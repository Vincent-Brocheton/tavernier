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
final Schema powerSyncSchema = () {
  // Base jamais ouverte : on n'en lit que la description des tables.
  final metadata = TavernierDatabase(
    LazyDatabase(() => throw StateError('base de description seulement')),
  );
  return Schema([
    for (final table in metadata.allTables)
      if (syncedTables.contains(table.actualTableName))
        Table(table.actualTableName, [
          for (final column in table.$columns)
            if (column.name != 'id')
              switch (column.type) {
                DriftSqlType.bool ||
                DriftSqlType.int ||
                DriftSqlType.bigInt => Column.integer(column.name),
                DriftSqlType.double => Column.real(column.name),
                _ => Column.text(column.name),
              },
        ]),
  ]);
}();

/// Base PowerSync de l'appareil, à [path] (un nom de fichier sur le Web).
PowerSyncDatabase openPowerSyncDatabase(String path) =>
    PowerSyncDatabase(schema: powerSyncSchema, path: path);

/// Base Drift de l'app au-dessus de [powerSync].
TavernierDatabase openPowerSyncTavernierDatabase(PowerSyncDatabase powerSync) =>
    TavernierDatabase(
      DatabaseConnection.delayed(
        powerSync.initialize().then(
          (_) => SqliteAsyncDriftConnection(powerSync),
        ),
      ),
      syncedTablesByPowerSync: true,
    );
