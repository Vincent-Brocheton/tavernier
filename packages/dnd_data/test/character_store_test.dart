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

  group('état de jeu', () {
    late CharacterInput aldric;
    setUp(() async {
      aldric = CharacterInput.fromJson(_aldricJson());
      await store.save('a', aldric);
    });

    test('sans état : vide', () async {
      final state = await store.loadState('a');
      expect(state.used, isEmpty);
      expect(state.concentrationSpellId, isNull);
    });

    test('relecture à l\'identique', () async {
      await store.saveState(
        'a',
        PlayState(
          used: {slotResource(1): 2, pactSlotResource: 1},
          concentrationSpellId: 'srd:spell:bless',
        ),
      );
      final state = await store.loadState('a');
      expect(state.usedOf(slotResource(1)), 2);
      expect(state.usedOf(pactSlotResource), 1);
      expect(state.concentrationSpellId, 'srd:spell:bless');
    });

    test('PV et Épuisement relus', () async {
      await store.saveState('a', const PlayState(hpCurrent: 7, exhaustion: 2));
      final state = await store.loadState('a');
      expect(state.hpCurrent, 7);
      expect(state.exhaustion, 2);
    });

    test('Inspiration relue', () async {
      await store.saveState('a', const PlayState(heroicInspiration: true));
      expect((await store.loadState('a')).heroicInspiration, isTrue);
    });

    test('personnage indemne : PV vides', () async {
      await store.saveState('a', const PlayState());
      expect((await store.loadState('a')).hpCurrent, isNull);
    });

    test('un second enregistrement remplace le premier', () async {
      await store.saveState(
        'a',
        const PlayState(concentrationSpellId: 'srd:spell:bless'),
      );
      await store.saveState('a', const PlayState());
      expect((await store.loadState('a')).concentrationSpellId, isNull);
    });

    test('réenregistrer le personnage garde son état', () async {
      await store.saveState('a', PlayState(used: {slotResource(1): 1}));
      await store.save('a', aldric);
      expect((await store.loadState('a')).usedOf(slotResource(1)), 1);
    });
  });

  group('sorts, monnaie et détails', () {
    final wizard = CharacterInput.fromJson(_aldricJson()).copyWith(
      spells: const SpellsInput(
        cantrips: ['srd:spell:light', 'srd:spell:mage-hand'],
        prepared: ['srd:spell:sleep', 'srd:spell:burning-hands'],
        spellbook: [
          'srd:spell:thunderwave',
          'srd:spell:sleep',
          'srd:spell:burning-hands',
        ],
      ),
      coins: const {'gp': 18},
      alignment: 'LB',
      appearance: 'Grand et sec',
      personality: 'Calme',
      backstory: 'Ancien soldat',
    );

    test('aller-retour', () async {
      await store.save('c1', wizard);
      expect(await store.load('c1'), wizard);
    });

    test('un second enregistrement remplace les sorts', () async {
      await store.save('c1', wizard);
      final next = wizard.copyWith(spells: const SpellsInput());
      await store.save('c1', next);
      expect(await store.load('c1'), next);
    });
  });

  test('liste : du plus ancien au plus récent', () async {
    final aldric = CharacterInput.fromJson(_aldricJson());
    await store.save('b', aldric);
    await store.save('a', aldric.copyWith(name: 'Autre'));
    final list = await store.list();
    expect(list.map((c) => c.id), ['b', 'a']);
    expect(list.last.character.name, 'Autre');
  });

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

  test(
    'une entrée non validée (langue en double) est gardée telle quelle',
    () async {
      final aldric = CharacterInput.fromJson(_aldricJson());
      final draft = aldric.copyWith(
        languages: [...aldric.languages, aldric.languages.first],
      );
      await store.save('c1', draft);
      expect(await store.load('c1'), draft);
    },
  );
}
