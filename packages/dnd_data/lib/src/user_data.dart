// Export des données de l'utilisateur (US-17, ENF-10, ENF-12) : tout ce qui
// n'est pas du contenu de règles, ligne par ligne, pour être relu ou réimporté.
import 'package:drift/drift.dart' show Table, TableInfo;

import 'database.dart';
import 'powersync.dart';

/// Format et version du fichier d'export.
const userDataFormat = 'tavernier-export';
const userDataVersion = 1;

/// Tables des données de l'utilisateur : les synchronisées et les tables
/// locales de jeu (M3). Les clés de pack (`author_identity`) n'y sont pas.
List<String> userDataTables(TavernierDatabase db) => [
  ...syncedTables,
  for (final TableInfo<Table, Object?> table in [
    db.npcStatblocks,
    db.sessions,
    db.encounters,
    db.combatants,
    db.encounterEvents,
    db.notes,
  ])
    table.actualTableName,
];

/// Export JSON des données de l'utilisateur : chaque ligne telle qu'en base,
/// et les packs installés sans leur contenu.
Future<Map<String, Object?>> exportUserData(
  TavernierDatabase db, {
  DateTime? now,
}) async {
  final packs = await db
      .customSelect('SELECT id, version FROM content_pack ORDER BY id')
      .get();
  return {
    'format': userDataFormat,
    'version': userDataVersion,
    'exported_at': (now ?? DateTime.now()).toUtc().toIso8601String(),
    'packs': [for (final p in packs) p.data],
    'tables': {
      for (final table in userDataTables(db))
        table: [
          for (final row in await db.customSelect('SELECT * FROM $table').get())
            row.data,
        ],
    },
  };
}
