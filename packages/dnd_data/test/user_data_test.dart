// Spec local-database : « Export des données de l'utilisateur » (US-17,
// ENF-10, ENF-12).

import 'dart:convert';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  late TavernierDatabase db;
  setUp(() async {
    db = await powerSyncDatabase();
    await PackStore(db).importPack(srdPack);
    await CharacterStore(db).save('a', CharacterInput.fromJson(aldricJson()));
  });
  tearDown(() => db.close());

  test('personnage exporté, avec son détail', () async {
    final export = await exportUserData(
      db,
      now: DateTime.utc(2026, 11, 13, 10),
    );
    // Passe par le JSON : le fichier écrit est relu tel quel.
    final json = jsonDecode(jsonEncode(export)) as Map<String, dynamic>;
    expect(json['format'], 'tavernier-export');
    expect(json['version'], 1);
    expect(json['exported_at'], '2026-11-13T10:00:00.000Z');
    final tables = json['tables'] as Map<String, dynamic>;
    final characters = tables['character'] as List<dynamic>;
    expect(characters, hasLength(1));
    expect((characters.single as Map)['name'], 'Aldric Varenne');
    final levels = tables['character_class_level'] as List<dynamic>;
    expect((levels.single as Map)['class_id'], 'srd:class:fighter');
    expect(tables['character_item'], isNotEmpty);
    expect(tables.keys, containsAll(['profile', 'game_table', 'note']));
  });

  test('contenu de règles exclu, packs cités', () async {
    final export = await exportUserData(db);
    expect(export['packs'], [
      {'id': srdPack.manifest.id, 'version': srdPack.manifest.version},
    ]);
    final tables = (export['tables']! as Map<String, Object?>).keys;
    for (final content in [
      'spell',
      'player_class',
      'monster',
      'author_identity',
    ]) {
      expect(tables, isNot(contains(content)), reason: content);
    }
  });
}
