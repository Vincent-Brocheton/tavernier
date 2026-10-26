// Spec local-database : « Migrations versionnées ». Le schéma qu'une base
// neuve reçoit du code doit être identique à l'instantané de sa version :
// changer une table sans nouvelle version fait échouer ce test.
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
  test("le schéma du code est celui de l'instantané v1", () async {
    final snapshot = await SchemaVerifier(GeneratedHelper()).schemaAt(1);
    addTearDown(snapshot.rawDatabase.close);
    final expected = _structure(snapshot.rawDatabase.select(_structureQuery));

    final db = memoryDatabase();
    addTearDown(db.close);
    final actual = _structure([
      for (final row in await db.customSelect(_structureQuery).get()) row.data,
    ]);

    expect(db.schemaVersion, 1);
    expect(actual, expected);
  });
}
