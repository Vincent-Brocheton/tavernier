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
    ),
]);

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
    final db = PowerSyncDatabase(schema: powerSyncSchema, path: p);
    await db.initialize();
    return db;
  });
  return TavernierDatabase(
    DatabaseConnection.delayed(powerSync.then(SqliteAsyncDriftConnection.new)),
    syncedTablesByPowerSync: true,
    powerSync: powerSync,
  );
}
