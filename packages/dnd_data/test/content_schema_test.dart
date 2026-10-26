// Spec local-database : « Schéma version 1 » (contenu, cahier §11.1) et
// « Intégrité référentielle » (cascade depuis un pack).
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

import 'support.dart';

const contentTables = {
  'content_pack', 'pack_dependency', 'ability', 'skill', 'language', //
  'condition', 'damage_type', 'mastery_property', 'weapon', 'armor', 'tool',
  'item', 'background', 'background_ability', 'background_proficiency',
  'background_equipment_option', 'feat', 'species', 'species_trait',
  'player_class',
  'class_level',
  'subclass',
  'subclass_feature',
  'feature',
  'spell',
  'spell_class', 'monster', 'monster_action', 'study_reveal', 'effect',
  'entity_text', 'content_search',
};

void main() {
  late TavernierDatabase db;
  setUp(() => db = memoryDatabase());
  tearDown(() => db.close());

  test('base neuve : version 1 et tables du contenu', () async {
    expect(db.schemaVersion, 1);
    expect(await tableNames(db), containsAll(contentTables));
  });

  test('les clés étrangères sont actives', () async {
    final row = await db.customSelect('PRAGMA foreign_keys').getSingle();
    expect(row.data.values.single, 1);
  });

  test('supprimer un pack supprime ses entités, effets et textes', () async {
    await db.customStatement(
      'INSERT INTO content_pack (id, namespace, name, version, origin, author, '
      "licence, dsl_version, locale) VALUES ('p', 'srd', 'SRD', '1.0.0', 'srd', "
      "'a', 'CC-BY-4.0', 1, 'fr')",
    );
    await db.customStatement(
      'INSERT INTO feat (id, pack_id, name, category, repeatable) '
      "VALUES ('srd:feat:alert', 'p', 'Vigilant', 'origin', 0)",
    );
    await db.customStatement(
      'INSERT INTO effect (owner_id, owner_type, position, pack_id, payload) '
      "VALUES ('srd:feat:alert', 'feat', 0, 'p', '{}')",
    );
    await db.customStatement(
      'INSERT INTO entity_text (entity_id, locale, pack_id, description) '
      "VALUES ('srd:feat:alert', 'fr', 'p', 'Texte')",
    );
    await db.customStatement("DELETE FROM content_pack WHERE id = 'p'");
    for (final table in ['feat', 'effect', 'entity_text']) {
      final count = await db
          .customSelect('SELECT count(*) AS n FROM $table')
          .getSingle();
      expect(count.read<int>('n'), 0, reason: table);
    }
  });
}
