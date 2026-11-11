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
        startingLevel: row.read<int>('starting_level'),
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
      archived: row.read<bool>('archived'),
      fullSheetsVisible: row.read<bool>('full_sheets_visible'),
    );
  }
}

String? _orNull(String? text) =>
    text == null || text.trim().isEmpty ? null : text.trim();
