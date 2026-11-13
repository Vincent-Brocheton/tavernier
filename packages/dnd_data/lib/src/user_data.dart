// Export des données de l'utilisateur (US-17, ENF-10, ENF-12) : tout ce qui
// n'est pas du contenu de règles, ligne par ligne, pour être relu ou réimporté.
import 'package:drift/drift.dart' show Table, TableInfo, Variable;

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

/// Résultat d'un import : lignes ajoutées, lignes déjà présentes gardées.
typedef UserDataImport = ({int added, int kept});

/// Importe un export : ajoute les lignes absentes, garde celles déjà
/// présentes (même `id`). Le fichier est contrôlé en entier avant toute
/// écriture ; un fichier refusé lève une [FormatException]. Les tables et
/// colonnes inconnues sont ignorées ; leurs noms viennent de la base, jamais
/// du fichier.
Future<UserDataImport> importUserData(
  TavernierDatabase db,
  Map<String, Object?> file,
) async {
  if (file['format'] != userDataFormat) {
    throw const FormatException('pas un export Tavernier');
  }
  final version = file['version'];
  if (version is! int || version < 1 || version > userDataVersion) {
    throw FormatException('version non prise en charge : $version');
  }
  final tables = file['tables'];
  if (tables is! Map<String, Object?>) {
    throw const FormatException('tables absentes');
  }
  final known = {
    for (final t in db.allTables)
      t.actualTableName: (t, {for (final c in t.$columns) c.name}),
  };
  // Ordre de l'export : les parents avant les enfants.
  final plan = <(TableInfo<Table, Object?>, List<Map<String, Object?>>)>[];
  for (final name in userDataTables(db)) {
    final rows = tables[name];
    if (rows == null) continue;
    final (table, columns) = known[name]!;
    if (rows is! List<Object?>) throw FormatException('$name : pas une liste');
    plan.add((
      table,
      [
        for (final row in rows)
          if (row is Map<String, Object?> && row['id'] is String)
            {
              for (final MapEntry(:key, :value) in row.entries)
                if (columns.contains(key))
                  key: switch (value) {
                    null || String() || num() => value,
                    bool() => value ? 1 : 0,
                    _ => throw FormatException('$name.$key : valeur invalide'),
                  },
            }
          else
            throw FormatException('$name : ligne sans identifiant'),
      ],
    ));
  }
  var added = 0;
  var kept = 0;
  await db.transaction(() async {
    for (final (table, rows) in plan) {
      final name = table.actualTableName;
      for (final row in rows) {
        final id = row['id']! as String;
        final exists = await db
            .customSelect(
              'SELECT 1 FROM $name WHERE id = ?',
              variables: [Variable.withString(id)],
            )
            .getSingleOrNull();
        if (exists != null) {
          kept++;
          continue;
        }
        await db.customStatement(
          'INSERT INTO $name (${row.keys.join(', ')}) '
          'VALUES (${List.filled(row.length, '?').join(', ')})',
          row.values.toList(),
        );
        added++;
      }
    }
  });
  db.markTablesUpdated({for (final (table, _) in plan) table});
  return (added: added, kept: kept);
}
