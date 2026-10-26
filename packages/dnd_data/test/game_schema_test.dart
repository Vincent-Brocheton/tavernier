// Spec local-database : « Schéma version 1 » (données de jeu, cahier
// §11.2), « Identifiant unique des données synchronisables », « Intégrité
// référentielle ».
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

import 'support.dart';

const gameTables = [
  'profile', 'game_table', 'table_member', 'table_invite', 'table_pack', //
  'table_banned_entity', 'character', 'character_base_scores',
  'character_background_choice', 'character_class_level', 'character_feat',
  'character_weapon_mastery', 'character_spell', 'character_item',
  'character_state', 'character_content_ref', 'character_change_log',
  'character_language', 'character_choice', 'npc_statblock', 'session',
  'encounter', 'combatant', 'encounter_event', 'note', 'author_identity',
];

const _characterChildren = [
  'character_base_scores',
  'character_background_choice',
  'character_class_level',
  'character_feat',
  'character_weapon_mastery',
  'character_item',
  'character_language',
  'character_choice',
];

void main() {
  late TavernierDatabase db;
  setUp(() => db = memoryDatabase());
  tearDown(() => db.close());

  Future<void> insertCharacter() => db.customStatement(
    'INSERT INTO character (id, kind, name, species_id, background_id, '
    "status, xp) VALUES ('c1', 'pc', 'Aldric', 'srd:species:human', "
    "'srd:background:soldier', 'draft', 0)",
  );

  test('base neuve : tables des données de jeu', () async {
    expect(await tableNames(db), containsAll(gameTables));
  });

  test('chaque table de données de jeu a la clé primaire id', () async {
    for (final table in gameTables) {
      expect(await primaryKey(db, table), ['id'], reason: table);
    }
  });

  test('un niveau de classe orphelin est refusé', () async {
    expect(
      () => db.customStatement(
        'INSERT INTO character_class_level (id, character_id, class_id, '
        "level, position) VALUES ('x', 'absent', 'srd:class:fighter', 1, 0)",
      ),
      throwsA(anything),
    );
  });

  test('supprimer un personnage supprime ses données', () async {
    await insertCharacter();
    await db.customStatement(
      'INSERT INTO character_base_scores (id, character_id, ability_id, base, '
      "method) VALUES ('b1', 'c1', 'str', 15, 'point_buy')",
    );
    await db.customStatement(
      'INSERT INTO character_background_choice (id, character_id, '
      "distribution, bonuses) VALUES ('bg', 'c1', '2-1', '{}')",
    );
    await db.customStatement(
      'INSERT INTO character_class_level (id, character_id, class_id, level, '
      "position) VALUES ('cl', 'c1', 'srd:class:fighter', 1, 0)",
    );
    await db.customStatement(
      'INSERT INTO character_feat (id, character_id, feat_id, source_type, '
      "source_ref, position) VALUES ('f', 'c1', 'srd:feat:alert', 'species', "
      "'srd:species:human', 0)",
    );
    await db.customStatement(
      'INSERT INTO character_weapon_mastery (id, character_id, weapon_id, '
      "slot_index) VALUES ('w', 'c1', 'srd:weapon:longsword', 0)",
    );
    await db.customStatement(
      'INSERT INTO character_item (id, character_id, item_id, quantity, '
      "equipped, attuned, position) VALUES ('i', 'c1', 'srd:armor:shield', 1, "
      '1, 0, 0)',
    );
    await db.customStatement(
      'INSERT INTO character_language (id, character_id, language_id, '
      "position) VALUES ('l', 'c1', 'srd:language:common', 0)",
    );
    await db.customStatement(
      'INSERT INTO character_choice (id, character_id, choice_key, '
      "selections) VALUES ('ch', 'c1', 'skillful', '[]')",
    );
    await db.customStatement("DELETE FROM character WHERE id = 'c1'");
    for (final table in _characterChildren) {
      final count = await db
          .customSelect('SELECT count(*) AS n FROM $table')
          .getSingle();
      expect(count.read<int>('n'), 0, reason: table);
    }
  });
}
