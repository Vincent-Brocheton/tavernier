// Spec local-database : « Enregistrement d'un personnage ».

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart' show Variable;
import 'package:test/test.dart';

import 'support.dart';

void main() {
  // Mêmes tests sur des tables ordinaires et sur les vues de PowerSync, le
  // moteur de l'app (spec local-database : « Base locale PowerSync »).
  for (final (name, open) in [
    ('tables', () async => memoryDatabase()),
    ('PowerSync', powerSyncDatabase),
  ]) {
    group(name, () => _tests(open));
  }
}

void _tests(Future<TavernierDatabase> Function() open) {
  late TavernierDatabase db;
  late CharacterStore store;
  setUp(() async {
    db = await open();
    store = CharacterStore(db);
  });
  tearDown(() => db.close());

  group('état de jeu', () {
    late CharacterInput aldric;
    setUp(() async {
      aldric = CharacterInput.fromJson(aldricJson());
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
    final wizard = CharacterInput.fromJson(aldricJson()).copyWith(
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

  test('fiche de table : rattachée à la création, jamais effacée', () async {
    final aldric = CharacterInput.fromJson(aldricJson());
    await store.save('a', aldric, tableId: 't1');
    await store.save('a', aldric.copyWith(name: 'Aldric Varenne'));
    final row = await db
        .customSelect("SELECT table_id, status FROM character WHERE id = 'a'")
        .getSingle();
    expect(row.read<String>('table_id'), 't1');
    expect(row.read<String>('status'), 'draft');

    await store.setStatus('a', 'submitted');
    expect(await store.status('a'), 'submitted');
  });

  test('liste : les fiches de l\'utilisateur, pas celles des autres', () async {
    final aldric = CharacterInput.fromJson(aldricJson());
    await store.save('mienne', aldric);
    await store.save('envoyee', aldric);
    await store.save('autre', aldric);
    await db.customStatement(
      "UPDATE character SET owner_user_id = 'moi' WHERE id = 'envoyee'",
    );
    await db.customStatement(
      "UPDATE character SET owner_user_id = 'hugo' WHERE id = 'autre'",
    );
    expect((await store.list(ownerUserId: 'moi')).map((c) => c.id), [
      'envoyee',
      'mienne',
    ]);
  });

  test('personnages libres, rattachement, dérogations', () async {
    final aldric = CharacterInput.fromJson(aldricJson());
    await store.save('kael', aldric);
    await store.save('table', aldric, tableId: 't0');
    await store.save('autre', aldric);
    await db.customStatement(
      "UPDATE character SET owner_user_id = 'hugo' WHERE id = 'autre'",
    );
    expect((await store.freeCharacters('leo')).map((c) => c.id), ['kael']);

    await TableStore(db).attachToSlot('s1', 't1', 'kael', 'Je vous rejoins.');
    expect(await store.freeCharacters('leo'), isEmpty);
    expect(await store.status('kael'), 'submitted');

    await store.addDerogations('kael', 'mj', [
      {'check': 'level', 'table': '1', 'sheet': '3', 'message': 'Bienvenue'},
      {'check': 'method', 'table': 'pointBuy', 'sheet': 'random'},
    ]);
    final history = await store.history('kael');
    expect(history.map((e) => e.detail['check']), ['method', 'level']);
    expect(history.first.detail['kind'], 'derogation');
    expect(history.first.authorUserId, 'mj');
  });

  test('liste : du plus ancien au plus récent, par identifiant', () async {
    final aldric = CharacterInput.fromJson(aldricJson());
    final older = uuidV7(at: DateTime.utc(2026));
    final newer = uuidV7(at: DateTime.utc(2026, 2));
    await store.save(newer, aldric.copyWith(name: 'Autre'));
    await store.save(older, aldric);
    final list = await store.list();
    expect(list.map((c) => c.id), [older, newer]);
    expect(list.last.character.name, 'Autre');
  });

  test('suppression : la fiche et tout son contenu', () async {
    final aldric = CharacterInput.fromJson(aldricJson());
    await store.save('a', aldric);
    await store.saveState('a', const PlayState(hpCurrent: 3));
    await store.save('b', aldric);
    await store.delete('a');
    expect(await store.load('a'), isNull);
    for (final table in syncedTables.where((t) => t.startsWith('character_'))) {
      final rows = await db
          .customSelect(
            'SELECT count(*) AS n FROM $table WHERE character_id = ?',
            variables: [Variable.withString('a')],
          )
          .getSingle();
      expect(rows.read<int>('n'), 0, reason: table);
    }
    expect(await store.load('b'), aldric);
  });

  test('Aldric aller-retour', () async {
    final aldric = CharacterInput.fromJson(aldricJson());
    await store.save('c1', aldric);
    expect(await store.load('c1'), aldric);
  });

  test('modification : une botte de moins', () async {
    final aldric = CharacterInput.fromJson(aldricJson());
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
    final aldric = CharacterInput.fromJson(aldricJson());
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
    final json = aldricJson();
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
      final aldric = CharacterInput.fromJson(aldricJson());
      final draft = aldric.copyWith(
        languages: [...aldric.languages, aldric.languages.first],
      );
      await store.save('c1', draft);
      expect(await store.load('c1'), draft);
    },
  );
}
