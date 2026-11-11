import 'dart:convert';

import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// PV à la montée de niveau (EF-TAB-03).
enum HpOnLevel { average, roll }

/// Progression des personnages (EF-TAB-10).
enum Progression { xp, milestones }

/// Rôle d'un utilisateur dans une table.
enum TableRole { gm, player }

/// Réglages d'une table (EF-TAB-01 à 03, EF-TAB-10).
final class TableSettings {
  const TableSettings({
    required this.name,
    this.description,
    this.startingLevel = 1,
    this.statMethod = ScoreMethod.pointBuy,
    this.longRest = LongRestRule.fullHitPoints,
    this.hpOnLevel = HpOnLevel.average,
    this.progression = Progression.xp,
  });

  final String name;
  final String? description;
  final int startingLevel;
  final ScoreMethod statMethod;
  final LongRestRule longRest;
  final HpOnLevel hpOnLevel;
  final Progression progression;

  TableSettings copyWith({
    String? name,
    String? description,
    int? startingLevel,
    ScoreMethod? statMethod,
    LongRestRule? longRest,
    HpOnLevel? hpOnLevel,
    Progression? progression,
  }) => TableSettings(
    name: name ?? this.name,
    description: description ?? this.description,
    startingLevel: startingLevel ?? this.startingLevel,
    statMethod: statMethod ?? this.statMethod,
    longRest: longRest ?? this.longRest,
    hpOnLevel: hpOnLevel ?? this.hpOnLevel,
    progression: progression ?? this.progression,
  );

  @override
  bool operator ==(Object other) =>
      other is TableSettings &&
      other.name == name &&
      other.description == description &&
      other.startingLevel == startingLevel &&
      other.statMethod == statMethod &&
      other.longRest == longRest &&
      other.hpOnLevel == hpOnLevel &&
      other.progression == progression;

  @override
  int get hashCode => Object.hash(
    name,
    description,
    startingLevel,
    statMethod,
    longRest,
    hpOnLevel,
    progression,
  );
}

/// Une table vue par un utilisateur.
final class TableSummary {
  const TableSummary({
    required this.id,
    required this.settings,
    required this.role,
    required this.archived,
    required this.fullSheetsVisible,
  });

  final String id;
  final TableSettings settings;
  final TableRole role;
  final bool archived;
  final bool fullSheetsVisible;
}

/// Entrée de l'activité d'une table (EF-TAB-11) : `config` porte
/// `{field, from, to}` ; `archived` et `restored` n'ont pas de détail.
final class TableActivity {
  const TableActivity({
    required this.at,
    required this.authorUserId,
    required this.kind,
    required this.detail,
  });

  final DateTime at;
  final String? authorUserId;
  final String kind;
  final Map<String, Object?> detail;
}

/// Pack activé dans une table, à sa version figée (EF-TAB-04).
typedef TablePackRef = ({String packId, String version});

/// Seule voie d'écriture des tables de jeu (cahier §10). Les valeurs sont
/// stockées par le nom de leur énumération.
final class TableStore {
  TableStore(this._db);

  final TavernierDatabase _db;

  /// Crée une table, inscrit son MJ et active ses packs, en une seule
  /// transaction ; rend son identifiant.
  Future<String> create({
    required String gmUserId,
    required TableSettings settings,
    required List<TablePackRef> packs,
  }) async {
    final id = uuidV7();
    await _db.transaction(() async {
      await _db.customStatement(
        'INSERT INTO game_table (id, gm_user_id, name, description, '
        'stat_method, long_rest_rule, hp_on_level_rule, starting_level, '
        'progression_mode, full_sheets_visible, archived) '
        'VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, 0, 0)',
        [
          id,
          gmUserId,
          settings.name.trim(),
          _orNull(settings.description),
          settings.statMethod.name,
          settings.longRest.name,
          settings.hpOnLevel.name,
          settings.startingLevel,
          settings.progression.name,
        ],
      );
      await _db.customStatement(
        'INSERT INTO table_member (id, table_id, user_id, role, joined_at) '
        "VALUES (?, ?, ?, 'gm', ?)",
        [uuidV7(), id, gmUserId, DateTime.now().toUtc().toIso8601String()],
      );
      for (final pack in packs) {
        await _db.customStatement(
          'INSERT INTO table_pack (id, table_id, pack_id, pinned_version) '
          'VALUES (?, ?, ?, ?)',
          [uuidV7(), id, pack.packId, pack.version],
        );
      }
    });
    return id;
  }

  /// Enregistre la configuration de la table [id] et date chaque réglage
  /// changé dans son activité, en une transaction (EF-TAB-11). Le nom et la
  /// description ne changent pas ici.
  Future<void> update(
    String id, {
    required String authorUserId,
    required TableSettings settings,
    required bool fullSheetsVisible,
  }) async {
    final before = await load(id, authorUserId);
    if (before == null) return;
    final old = before.settings;
    final changes = <String, (Object, Object)>{
      'statMethod': (old.statMethod.name, settings.statMethod.name),
      'startingLevel': (old.startingLevel, settings.startingLevel),
      'longRest': (old.longRest.name, settings.longRest.name),
      'hpOnLevel': (old.hpOnLevel.name, settings.hpOnLevel.name),
      'progression': (old.progression.name, settings.progression.name),
      'fullSheetsVisible': (before.fullSheetsVisible, fullSheetsVisible),
    }..removeWhere((_, change) => change.$1 == change.$2);
    if (changes.isEmpty) return;
    await _db.transaction(() async {
      await _db.customStatement(
        'UPDATE game_table SET stat_method = ?, starting_level = ?, '
        'long_rest_rule = ?, hp_on_level_rule = ?, progression_mode = ?, '
        'full_sheets_visible = ? WHERE id = ?',
        [
          settings.statMethod.name,
          settings.startingLevel,
          settings.longRest.name,
          settings.hpOnLevel.name,
          settings.progression.name,
          if (fullSheetsVisible) 1 else 0,
          id,
        ],
      );
      for (final MapEntry(key: field, value: (from, to)) in changes.entries) {
        await _addActivity(id, authorUserId, 'config', {
          'field': field,
          'from': from,
          'to': to,
        });
      }
    });
  }

  /// Archive la table (lecture seule pour tous) ou la restaure, et le date
  /// dans son activité (EF-TAB-07).
  Future<void> setArchived(
    String id, {
    required bool archived,
    required String authorUserId,
  }) => _db.transaction(() async {
    await _db.customStatement(
      'UPDATE game_table SET archived = ? WHERE id = ?',
      [if (archived) 1 else 0, id],
    );
    await _addActivity(
      id,
      authorUserId,
      archived ? 'archived' : 'restored',
      const {},
    );
  });

  /// Activité de la table, la plus récente d'abord.
  Future<List<TableActivity>> activity(
    String tableId, {
    int limit = 20,
  }) async => [
    for (final row
        in await _db
            .customSelect(
              'SELECT * FROM table_activity WHERE table_id = ? '
              // La date d'abord : deux UUID v7 de la même milliseconde ne sont pas
              // ordonnés.
              'ORDER BY at DESC, id DESC LIMIT ?',
              variables: [
                Variable.withString(tableId),
                Variable.withInt(limit),
              ],
            )
            .get())
      TableActivity(
        at: DateTime.parse(row.read<String>('at')),
        authorUserId: row.readNullable<String>('author_user_id'),
        kind: row.read<String>('kind'),
        detail: jsonDecode(
          row.readNullable<String>('detail') ?? '{}',
        ) as Map<String, Object?>,
      ),
  ];

  Future<void> _addActivity(
    String tableId,
    String authorUserId,
    String kind,
    Map<String, Object?> detail,
  ) => _db.customStatement(
    'INSERT INTO table_activity (id, table_id, author_user_id, at, kind, '
    'detail) VALUES (?, ?, ?, ?, ?, ?)',
    [
      uuidV7(),
      tableId,
      authorUserId,
      DateTime.now().toUtc().toIso8601String(),
      kind,
      jsonEncode(detail),
    ],
  );

  /// Tables dont [userId] est MJ ou membre, la plus récente d'abord
  /// (identifiants UUID v7).
  Future<List<TableSummary>> list(String userId) async => [
    for (final row
        in await _db
            .customSelect(
              '${_select}WHERE g.gm_user_id = ?1 OR m.user_id = ?1 '
              'ORDER BY g.id DESC',
              variables: [Variable.withString(userId)],
            )
            .get())
      _summary(row, userId),
  ];

  /// La table [id] vue par [userId], ou `null`.
  Future<TableSummary?> load(String id, String userId) async {
    final row = await _db
        .customSelect(
          '${_select}WHERE g.id = ?2',
          variables: [Variable.withString(userId), Variable.withString(id)],
        )
        .getSingleOrNull();
    return row == null ? null : _summary(row, userId);
  }

  static const _select =
      'SELECT DISTINCT g.*, m.role AS member_role FROM game_table g '
      'LEFT JOIN table_member m ON m.table_id = g.id AND m.user_id = ?1 ';

  TableSummary _summary(QueryRow row, String userId) {
    // Une valeur inconnue (écrite ailleurs, ou plus récente) prend la valeur
    // par défaut au lieu de faire échouer toute la liste.
    T byName<T extends Enum>(List<T> values, String column, T fallback) =>
        values.asNameMap()[row.read<String>(column)] ?? fallback;
    return TableSummary(
      id: row.read<String>('id'),
      settings: TableSettings(
        name: row.read<String>('name'),
        description: row.readNullable<String>('description'),
        startingLevel: row.readNullable<int>('starting_level') ?? 1,
        statMethod: byName(
          ScoreMethod.values,
          'stat_method',
          ScoreMethod.pointBuy,
        ),
        longRest: byName(
          LongRestRule.values,
          'long_rest_rule',
          LongRestRule.fullHitPoints,
        ),
        hpOnLevel: byName(
          HpOnLevel.values,
          'hp_on_level_rule',
          HpOnLevel.average,
        ),
        progression: byName(
          Progression.values,
          'progression_mode',
          Progression.xp,
        ),
      ),
      role: row.readNullable<String>('gm_user_id') == userId
          ? TableRole.gm
          : TableRole.player,
      archived: row.readNullable<bool>('archived') ?? false,
      fullSheetsVisible: row.readNullable<bool>('full_sheets_visible') ?? false,
    );
  }
}

String? _orNull(String? text) =>
    text == null || text.trim().isEmpty ? null : text.trim();
