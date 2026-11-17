import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// État d'une rencontre préparée.
enum EncounterStatus {
  draft,
  ready,
  running,
  finished;

  static EncounterStatus parse(String? code) =>
      values.asNameMap()[code] ?? draft;
}

/// PV des monstres (EF-REN-04) : moyenne, ou jet au lancement.
enum HpMode {
  average,
  roll;

  static HpMode parse(String? code) => values.asNameMap()[code] ?? average;
}

/// Groupe d'adversaires préparé : un monstre (`monster`) ou un PNJ (`npc`).
final class EncounterGroup {
  const EncounterGroup({
    required this.id,
    required this.kind,
    required this.refId,
    required this.quantity,
    required this.sharedInitiative,
  });

  final String id;
  final String kind;
  final String refId;
  final int quantity;
  final bool sharedInitiative;
}

/// Rencontre préparée et ses groupes, dans l'ordre d'ajout.
final class Encounter {
  const Encounter({
    required this.id,
    required this.tableId,
    required this.title,
    required this.status,
    required this.hpMode,
    required this.groups,
    this.sessionId,
  });

  final String id;
  final String tableId;
  final String? sessionId;
  final String title;
  final EncounterStatus status;
  final HpMode hpMode;
  final List<EncounterGroup> groups;
}

/// Quantité maximale d'un groupe (contrainte du serveur).
const maxGroupQuantity = 30;

/// Rencontres préparées d'une table (US-19, EF-REN-01, 02, 05).
final class EncounterStore {
  EncounterStore(this._db);

  final TavernierDatabase _db;

  Future<void> _write(
    String sql,
    List<Object?> args,
    TableInfo<Table, Object?> table,
  ) => _db.customUpdate(
    sql,
    variables: [
      for (final arg in args)
        Variable<Object>(arg is bool ? (arg ? 1 : 0) : arg),
    ],
    updates: {table},
  );

  static String _now() => DateTime.now().toUtc().toIso8601String();

  /// Crée une rencontre en brouillon ; rend son identifiant.
  Future<String> create({
    required String tableId,
    required String title,
    String? sessionId,
  }) async {
    final id = uuidV7();
    await _write(
      'INSERT INTO encounter (id, table_id, session_id, title, status, '
      "hp_mode, position, created_at) VALUES (?, ?, ?, ?, 'draft', "
      "'average', 0, ?)",
      [id, tableId, sessionId, title, _now()],
      _db.encounters,
    );
    return id;
  }

  /// Modifie les champs donnés ; [clearSession] met la rencontre en réserve.
  Future<void> update(
    String id, {
    String? title,
    String? sessionId,
    bool clearSession = false,
    EncounterStatus? status,
    HpMode? hpMode,
    int? position,
  }) async {
    final columns = <String, Object?>{
      'title': ?title,
      if (clearSession) 'session_id': null else 'session_id': ?sessionId,
      'status': ?status?.name,
      'hp_mode': ?hpMode?.name,
      'position': ?position,
    };
    if (columns.isEmpty) return;
    await _write(
      'UPDATE encounter SET '
      '${columns.keys.map((c) => '$c = ?').join(', ')} WHERE id = ?',
      [...columns.values, id],
      _db.encounters,
    );
  }

  /// Copie [id] sous « titre (copie) », en brouillon, dans la même séance,
  /// avec ses groupes ; rend l'identifiant de la copie.
  Future<String> duplicate(String id) => _db.transaction(() async {
    final copy = uuidV7();
    await _write(
      'INSERT INTO encounter (id, table_id, session_id, title, status, '
      'hp_mode, position, created_at) '
      "SELECT ?, table_id, session_id, title || ' (copie)', 'draft', "
      'hp_mode, position, ? FROM encounter WHERE id = ?',
      [copy, _now(), id],
      _db.encounters,
    );
    final groups = await _db
        .customSelect(
          'SELECT id FROM encounter_group WHERE encounter_id = ? '
          'ORDER BY position, id',
          variables: [Variable.withString(id)],
        )
        .get();
    for (final group in groups) {
      await _write(
        'INSERT INTO encounter_group (id, encounter_id, table_id, kind, '
        'ref_id, quantity, shared_initiative, position) '
        'SELECT ?, ?, table_id, kind, ref_id, quantity, shared_initiative, '
        'position FROM encounter_group WHERE id = ?',
        [uuidV7(), copy, group.read<String>('id')],
        _db.encounterGroups,
      );
    }
    return copy;
  });

  /// Supprime la rencontre et ses groupes : les vues PowerSync n'ont pas de
  /// clés étrangères.
  Future<void> delete(String id) => _db.transaction(() async {
    await _write('DELETE FROM encounter_group WHERE encounter_id = ?', [
      id,
    ], _db.encounterGroups);
    await _write('DELETE FROM encounter WHERE id = ?', [id], _db.encounters);
  });

  /// Ajoute [quantity] adversaires [refId] ; un groupe de même référence
  /// grossit (jusqu'à [maxGroupQuantity]). Rend l'identifiant du groupe.
  Future<String> addGroup(
    String encounterId, {
    required String kind,
    required String refId,
    int quantity = 1,
  }) => _db.transaction(() async {
    final existing = await _db
        .customSelect(
          'SELECT id, quantity FROM encounter_group '
          'WHERE encounter_id = ? AND kind = ? AND ref_id = ?',
          variables: [
            Variable.withString(encounterId),
            Variable.withString(kind),
            Variable.withString(refId),
          ],
        )
        .getSingleOrNull();
    if (existing != null) {
      final id = existing.read<String>('id');
      await updateGroup(
        id,
        quantity: existing.read<int>('quantity') + quantity,
      );
      return id;
    }
    final id = uuidV7();
    await _write(
      'INSERT INTO encounter_group (id, encounter_id, table_id, kind, ref_id, '
      'quantity, shared_initiative, position) '
      'SELECT ?, id, table_id, ?, ?, ?, 1, '
      '(SELECT coalesce(max(position), -1) + 1 FROM encounter_group '
      'WHERE encounter_id = ?) FROM encounter WHERE id = ?',
      [
        id,
        kind,
        refId,
        quantity.clamp(1, maxGroupQuantity),
        encounterId,
        encounterId,
      ],
      _db.encounterGroups,
    );
    return id;
  });

  Future<void> updateGroup(
    String id, {
    int? quantity,
    bool? sharedInitiative,
  }) async {
    final columns = <String, Object?>{
      if (quantity != null) 'quantity': quantity.clamp(1, maxGroupQuantity),
      'shared_initiative': ?sharedInitiative,
    };
    if (columns.isEmpty) return;
    await _write(
      'UPDATE encounter_group SET '
      '${columns.keys.map((c) => '$c = ?').join(', ')} WHERE id = ?',
      [...columns.values, id],
      _db.encounterGroups,
    );
  }

  Future<void> removeGroup(String id) => _write(
    'DELETE FROM encounter_group WHERE id = ?',
    [id],
    _db.encounterGroups,
  );

  /// Rencontres de [tableId] avec leurs groupes, par position puis par
  /// création.
  Stream<List<Encounter>> watchList(String tableId) {
    final encounters = _db.customSelect(
      'SELECT * FROM encounter WHERE table_id = ? '
      'ORDER BY position, created_at, id',
      variables: [Variable.withString(tableId)],
      // Les groupes aussi : changer un groupe rafraîchit la liste.
      readsFrom: {_db.encounters, _db.encounterGroups},
    );
    final groups = _db.customSelect(
      'SELECT * FROM encounter_group WHERE table_id = ? '
      'ORDER BY position, id',
      variables: [Variable.withString(tableId)],
      readsFrom: {_db.encounterGroups},
    );
    // ponytail: deux requêtes réunies à chaque changement ; une jointure si
    // une table compte des centaines de rencontres.
    return encounters.watch().asyncMap((rows) async {
      final byEncounter = <String, List<EncounterGroup>>{};
      for (final g in await groups.get()) {
        (byEncounter[g.read<String>('encounter_id')] ??= []).add(
          EncounterGroup(
            id: g.read<String>('id'),
            kind: g.read<String>('kind'),
            refId: g.read<String>('ref_id'),
            quantity: g.read<int>('quantity'),
            sharedInitiative: g.read<int>('shared_initiative') != 0,
          ),
        );
      }
      return [
        for (final row in rows)
          Encounter(
            id: row.read<String>('id'),
            tableId: row.read<String>('table_id'),
            sessionId: row.readNullable<String>('session_id'),
            title: row.read<String>('title'),
            status: EncounterStatus.parse(row.readNullable<String>('status')),
            hpMode: HpMode.parse(row.readNullable<String>('hp_mode')),
            groups: byEncounter[row.read<String>('id')] ?? const [],
          ),
      ];
    });
  }
}
