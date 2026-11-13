// Spec local-database : « Export des données de l'utilisateur » (US-17,
// ENF-10, ENF-12).

import 'dart:convert';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:test/test.dart';

import 'support.dart';

void main() {
  // L'import se vérifie entre deux bases ouvertes ensemble.
  driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
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

  group('import', () {
    late TavernierDatabase fresh;
    setUp(() async => fresh = await powerSyncDatabase());
    tearDown(() => fresh.close());

    Future<Map<String, Object?>> exported() async =>
        jsonDecode(jsonEncode(await exportUserData(db)))
            as Map<String, Object?>;

    Future<List<Map<String, Object?>>> rows(
      TavernierDatabase d,
      String table,
    ) async => [
      for (final r in await d.customSelect('SELECT * FROM $table').get())
        r.data,
    ];

    test('restauration sur une base vide', () async {
      final result = await importUserData(fresh, await exported());
      expect(await rows(fresh, 'character'), await rows(db, 'character'));
      expect(
        await rows(fresh, 'character_class_level'),
        await rows(db, 'character_class_level'),
      );
      expect(
        await rows(fresh, 'character_item'),
        await rows(db, 'character_item'),
      );
      expect(result.added, greaterThan(3));
      expect(result.kept, 0);
    });

    test('ligne déjà présente gardée', () async {
      final file = await exported();
      await db.customStatement("UPDATE character SET name = 'Aldric le Brave'");
      final before = await rows(db, 'character_item');
      final result = await importUserData(db, file);
      expect((await rows(db, 'character')).single['name'], 'Aldric le Brave');
      expect(await rows(db, 'character_item'), before);
      expect(result.added, 0);
      expect(result.kept, greaterThan(3));
    });

    test('colonne et table inconnues ignorées', () async {
      final file = await exported();
      final tables = file['tables']! as Map<String, Object?>;
      ((tables['character']! as List<Object?>).single!
              as Map<String, Object?>)['future_column'] =
          'x';
      tables['future_table'] = [
        {'id': 'f'},
      ];
      await importUserData(fresh, file);
      expect(await rows(fresh, 'character'), hasLength(1));
    });

    group('fichier refusé, base inchangée', () {
      Future<void> refused(Map<String, Object?> file) async {
        await expectLater(
          importUserData(fresh, file),
          throwsA(isA<FormatException>()),
        );
        expect(await rows(fresh, 'character'), isEmpty);
        expect(await rows(fresh, 'character_item'), isEmpty);
      }

      test('autre format', () async {
        await refused({...await exported(), 'format': 'autre'});
      });
      test('version plus récente', () async {
        await refused({...await exported(), 'version': userDataVersion + 1});
      });
      test('ligne sans identifiant', () async {
        final file = await exported();
        final tables = file['tables']! as Map<String, Object?>;
        (tables['character_language']! as List<Object?>).add(<String, Object?>{
          'character_id': 'a',
        });
        await refused(file);
      });
      test('valeur qui n’est pas simple', () async {
        final file = await exported();
        final tables = file['tables']! as Map<String, Object?>;
        ((tables['character']! as List<Object?>).single!
            as Map<String, Object?>)['name'] = [
          'liste',
        ];
        await refused(file);
      });
      test('pas de tables', () async {
        await refused({'format': userDataFormat, 'version': 1});
      });
    });
  });
}
