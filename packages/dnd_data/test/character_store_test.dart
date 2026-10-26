// Spec local-database : « Enregistrement d'un personnage ».
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

/// Entrée d'Aldric niveau 1, fixture [D1] de dnd_rules.
Map<String, Object?> _aldricJson() {
  final file = File.fromUri(
    Isolate.resolvePackageUriSync(Uri.parse('package:dnd_rules/'))!
        .resolve('../test/fixtures/d1/aldric_n1.json'),
  );
  final json = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
  return json['input']! as Map<String, Object?>;
}

void main() {
  late TavernierDatabase db;
  late CharacterStore store;
  setUp(() {
    db = memoryDatabase();
    store = CharacterStore(db);
  });
  tearDown(() => db.close());

  test('Aldric aller-retour', () async {
    final aldric = CharacterInput.fromJson(_aldricJson());
    await store.save('c1', aldric);
    expect(await store.load('c1'), aldric);
  });

  test('modification : une botte de moins', () async {
    final aldric = CharacterInput.fromJson(_aldricJson());
    await store.save('c1', aldric);
    final changed = aldric.copyWith(
      weaponMasteries: aldric.weaponMasteries.take(2).toList(),
    );
    await store.save('c1', changed);
    expect((await store.load('c1'))!.weaponMasteries, hasLength(2));
    final rows = await db
        .customSelect('SELECT count(*) AS n FROM character_weapon_mastery')
        .getSingle();
    expect(rows.read<int>('n'), 2);
  });

  test("réenregistrer garde l'état de jeu du personnage", () async {
    final aldric = CharacterInput.fromJson(_aldricJson());
    await store.save('c1', aldric);
    await db.customStatement(
      'INSERT INTO character_state (id, character_id, hp_current) '
      "VALUES ('s1', 'c1', 34)",
    );
    await store.save('c1', aldric.copyWith(xp: 300));
    final state = await db
        .customSelect('SELECT hp_current FROM character_state')
        .getSingle();
    expect(state.read<int>('hp_current'), 34);
    expect((await store.load('c1'))!.xp, 300);
  });

  test('un personnage absent donne null', () async {
    expect(await store.load('absent'), isNull);
  });

  test('génération aléatoire : les jets sont conservés', () async {
    final json = _aldricJson();
    (json['base_scores']! as Map<String, Object?>)
      ..['method'] = 'random'
      ..['rolls'] = [15, 13, 14, 8, 12, 10];
    final random = CharacterInput.fromJson(json);
    await store.save('c2', random);
    expect(await store.load('c2'), random);
  });
}
