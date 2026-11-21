// Spec local-database : « Migrations versionnées ». Le schéma qu'une base
// neuve reçoit du code doit être identique à l'instantané de sa version :
// changer une table sans nouvelle version fait échouer ce test.
import 'package:dnd_data/dnd_data.dart';
import 'package:drift_dev/api/migrations_native.dart';
import 'package:test/test.dart';

import 'generated_migrations/schema.dart';
import 'support.dart';

/// Structure d'une base : pour chaque table, ses colonnes (nom, type, non
/// nul, défaut, clé primaire), ses clés étrangères et ses index uniques.
/// Indépendante de la mise en forme du SQL.
const _structureQuery = """
SELECT m.name AS tbl, 'col' AS kind,
  c.name || ' ' || c.type || ' ' || c."notnull" || ' ' ||
  ifnull(c.dflt_value, '') || ' ' || c.pk AS detail
FROM sqlite_master m, pragma_table_info(m.name) c
WHERE m.type = 'table' AND m.name NOT LIKE 'sqlite_%'
UNION ALL
SELECT m.name, 'fk', f."table" || '.' || f."to" || ' ' || f."from" || ' ' ||
  f.on_delete
FROM sqlite_master m, pragma_foreign_key_list(m.name) f
WHERE m.type = 'table'
UNION ALL
SELECT m.name, 'index', i."unique" || ' ' || group_concat(ii.name, ',')
FROM sqlite_master m, pragma_index_list(m.name) i, pragma_index_info(i.name) ii
WHERE m.type = 'table'
GROUP BY m.name, i.name
ORDER BY 1, 2, 3
""";

List<String> _structure(Iterable<Map<String, Object?>> rows) => [
  for (final row in rows) '${row['tbl']} ${row['kind']} ${row['detail']}',
];

void main() {
  test("le schéma du code est celui de l'instantané v10", () async {
    final snapshot = await SchemaVerifier(GeneratedHelper()).schemaAt(10);
    addTearDown(snapshot.rawDatabase.close);
    final expected = _structure(snapshot.rawDatabase.select(_structureQuery));

    final db = memoryDatabase();
    addTearDown(db.close);
    final actual = _structure([
      for (final row in await db.customSelect(_structureQuery).get()) row.data,
    ]);

    expect(db.schemaVersion, 10);
    expect(actual, expected);
  });

  // v2 (US-24) : `rule_term.data`, les tables d'une règle ; v3 (US-36) :
  // `combat_view` et `combat_request` ; v4 (US-38) : `group_rest` et
  // `group_rest_done` ; v5 (US-26) : `note.title`, `updated_at`, `conflict` ;
  // v6 (US-27) : `homebrew_draft` ; v7 (US-27) : rareté et harmonisation
  // des armes et armures, `spell.classes` ; v8 (US-27) :
  // `player_class.subclass_feature_levels` ; v9 (US-29) : `author_key`,
  // `content_pack.description` et `author_public_key` ; v10 (US-30) :
  // `pack_file`.
  for (final (from, to) in [
    (1, 2),
    (1, 3),
    (2, 3),
    (1, 4),
    (3, 4),
    (1, 5),
    (4, 5),
    (1, 6),
    (5, 6),
    (1, 7),
    (6, 7),
    (1, 8),
    (7, 8),
    (1, 9),
    (8, 9),
    (1, 10),
    (9, 10),
  ]) {
    test('une base v$from monte en v$to', () async {
      final verifier = SchemaVerifier(GeneratedHelper());
      final schema = await verifier.schemaAt(from);
      final db = TavernierDatabase(schema.newConnection());
      addTearDown(db.close);
      await verifier.migrateAndValidate(db, to);
    });
  }
}
