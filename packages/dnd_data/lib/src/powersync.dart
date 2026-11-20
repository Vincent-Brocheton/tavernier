import 'package:drift/drift.dart' hide Column, Table;
import 'package:drift_sqlite_async/drift_sqlite_async.dart';
import 'package:powersync/powersync.dart';

import 'database.dart';

/// Tables synchronisées par PowerSync (T-05), celles de la publication
/// `powersync` du backend. PowerSync les tient en vues sur ses propres
/// tables ; Drift crée les autres.
const syncedTables = {
  'profile',
  'game_table',
  'table_member',
  'table_invite',
  'table_pack',
  'table_banned_entity',
  'table_activity',
  'pc_slot',
  'session',
  'session_attendance',
  'npc_statblock',
  'encounter',
  'encounter_group',
  'encounter_event',
  'combat_view',
  'combat_request',
  'group_rest',
  'group_rest_done',
  'note',
  'character_summary',
  'character',
  'character_base_scores',
  'character_background_choice',
  'character_class_level',
  'character_feat',
  'character_weapon_mastery',
  'character_spell',
  'character_item',
  'character_state',
  'character_content_ref',
  'character_change_log',
  'character_language',
  'character_choice',
  'character_proposal',
};

/// Schéma PowerSync des [syncedTables], dérivé des tables Drift : une
/// colonne ajoutée côté Drift y entre seule. `id` est implicite.
final Schema powerSyncSchema = Schema([
  for (final table in _syncedDriftTables)
    Table(
      table.actualTableName,
      [
        for (final column in table.$columns)
          if (column.name != 'id')
            switch (column.type) {
              DriftSqlType.bool ||
              DriftSqlType.int ||
              DriftSqlType.bigInt => Column.integer(column.name),
              DriftSqlType.double => Column.real(column.name),
              _ => Column.text(column.name),
            },
      ],
      // Une mise à jour sans changement n'est pas envoyée.
      ignoreEmptyUpdates: true,
      // Les valeurs remplacées partent avec la modification : le serveur y
      // reconnaît un conflit (US-16, ENF-03).
      trackPreviousValues: conflictTrackedTables.contains(table.actualTableName)
          ? const TrackPreviousValuesOptions(onlyWhenChanged: true)
          : null,
    ),
]);

Schema _schemaWithout(String table) => Schema([
  for (final t in powerSyncSchema.tables)
    if (t.name != table) t,
]);

/// Tables dont les conflits se détectent et se tracent : la fiche et son
/// état de jeu (US-16), les notes (US-26, EF-NOT-06). Les autres tables de la fiche sont des lignes qui
/// s'ajoutent ou se retirent, sans écrasement.
const conflictTrackedTables = {'character', 'character_state', 'note'};

/// Colonnes booléennes des [syncedTables] : 0/1 en local, `true`/`false`
/// pour Postgres.
final Map<String, Set<String>> syncedBooleanColumns = {
  for (final table in _syncedDriftTables)
    table.actualTableName: {
      for (final column in table.$columns)
        if (column.type == DriftSqlType.bool) column.name,
    },
};

/// Tables Drift synchronisées, lues sur une base jamais ouverte : on n'en
/// prend que la description.
final _syncedDriftTables = [
  for (final table in TavernierDatabase(
    LazyDatabase(() => throw StateError('base de description seulement')),
  ).allTables)
    if (syncedTables.contains(table.actualTableName)) table,
];

/// Base Drift de l'app, ouverte par PowerSync à [path] (un nom de fichier
/// sur le Web). La fermer ferme aussi la base PowerSync.
TavernierDatabase openPowerSyncTavernierDatabase(Future<String> path) {
  final powerSync = path.then((p) async {
    // Avant la v5, `note` était une table locale : PowerSync ne peut pas
    // poser sa vue sur elle. On ouvre sans elle, on la retire, puis on
    // passe au schéma complet.
    final db = PowerSyncDatabase(schema: _schemaWithout('note'), path: p);
    await db.initialize();
    final note = await db.getOptional(
      "SELECT type FROM sqlite_master WHERE name = 'note'",
    );
    if (note?['type'] == 'table') await db.execute('DROP TABLE note');
    await db.updateSchema(powerSyncSchema);
    return db;
  });
  return TavernierDatabase(
    DatabaseConnection.delayed(powerSync.then(SqliteAsyncDriftConnection.new)),
    syncedTablesByPowerSync: true,
    powerSync: powerSync,
  );
}
