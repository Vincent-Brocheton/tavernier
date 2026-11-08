// Spec local-database : « Schéma version 1 » (données de jeu, cahier
// §11.2), « Identifiant unique des données synchronisables ».
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

void main() {
  late TavernierDatabase db;
  setUp(() => db = memoryDatabase());
  tearDown(() => db.close());

  test('base neuve : tables des données de jeu', () async {
    expect(await tableNames(db), containsAll(gameTables));
  });

  test('chaque table de données de jeu a la clé primaire id', () async {
    for (final table in gameTables) {
      expect(await primaryKey(db, table), ['id'], reason: table);
    }
  });
}
