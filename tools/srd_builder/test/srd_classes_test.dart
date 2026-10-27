// Classes du lot 2 de T-04 (change t-04b-classes-1). Valeurs relues dans
// docs/srd/FR_SRD_CC_v5.2.1.pdf, page imprimée citée.
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/src/class_extractor.dart';
import 'package:srd_builder/srd_builder.dart';
import 'package:test/test.dart';

final _root = p.normalize(
  p.join(
    p.fromUri(
      Isolate.resolvePackageUriSync(Uri.parse('package:srd_builder/'))!,
    ),
    '..',
  ),
);

/// Sorts cités par l'en-tête du sort mais absents de la « Liste des sorts »
/// de la classe dans le SRD français : écart signalé, l'en-tête fait foi.
const _knownListGaps = {
  'bard': {'phantasmal-force'},
  'sorcerer': {'phantasmal-force', 'mind-spike'},
  'wizard': {'phantasmal-force', 'conjure-minor-elementals'},
};

void main() {
  late Map<String, ContentEntity> byId;

  setUpAll(() {
    final loaded = loadSources(Directory(p.join(_root, 'sources')));
    expect(loaded.issues, isEmpty);
    byId = {for (final e in loaded.pack!.entities) '${e.id}': e};
  });

  ClassData cls(String slug) => byId['srd:class:$slug']!.data as ClassData;
  Map<String, Object?> effect(String feature, [int i = 0]) =>
      byId['srd:feature:$feature']!.effects[i].toJson();
  String ability(String code) => 'srd:ability:$code';

  test('Barbare (p. 30) : d12, FOR et CON, Rages 2 → 6', () {
    final c = cls('barbarian');
    expect(c.hitDie, 12);
    expect(c.savingThrows.map((e) => '$e'), [
      ability('strength'),
      ability('constitution'),
    ]);
    expect(c.levels, hasLength(20));
    expect(c.levels.first.columns, {
      'rages': 2,
      'rage_damage': 2,
      'weapon_mastery': 2,
    });
    expect(c.levels.last.columns['rages'], 6);
    expect(c.spellList, isEmpty);
  });

  test('seule une aptitude qui accorde un don se répète dans la table', () {
    List<String> at(String slug, int level) =>
        cls(slug).levels[level - 1].features.map((e) => '$e').toList();
    expect(at('bard', 9), isNot(contains('srd:feature:bard-expertise')));
    expect(at('bard', 8), ['srd:feature:bard-ability-score-improvement']);
    expect(at('sorcerer', 10), isEmpty);
  });

  test('Défense sans armure du Barbare (p. 30)', () {
    expect(effect('barbarian-unarmored-defense'), {
      'op': 'ac_formula',
      'base': 10,
      'abilities': ['dex', 'con'],
      'allows_shield': true,
      'when': {'armor': 'none'},
    });
  });

  test('Bond instinctif : « Bond agressif » dans la table du SRD', () {
    final level7 = cls('barbarian').levels[6].features.map((e) => '$e');
    expect(level7, contains('srd:feature:barbarian-instinctive-pounce'));
    expect(
      byId['srd:feature:barbarian-instinctive-pounce']!.name,
      'Bond instinctif',
    );
  });

  test('Barde (p. 33) : d8, dé bardique d6 → d12, 3 instruments', () {
    final c = cls('bard');
    expect(
      (c.hitDie, c.toolChoiceCount, c.toolChoiceCategory),
      (8, 3, ToolCategory.musicalInstrument),
    );
    expect('${c.spellcastingAbility}', ability('charisma'));
    expect(c.levels.first.columns['bardic_die'], 6);
    expect(c.levels.last.columns['bardic_die'], 12);
  });

  test('Clerc (p. 38) : Conduit divin à partir du niveau 2', () {
    final c = cls('cleric');
    expect(c.levels.first.columns.containsKey('channel_divinity'), isFalse);
    expect(c.levels[1].columns['channel_divinity'], 2);
    expect(c.levels.last.columns['channel_divinity'], 4);
  });

  test('Druide (p. 43) : matériel d’herboriste, langue druidique', () {
    final c = cls('druid');
    expect(c.toolProficiencies.map((e) => '$e'), ['srd:tool:herbalism-kit']);
    expect(effect('druid-druidic')['ref'], 'srd:language:druidic');
  });

  test('Ensorceleur (p. 49) : points de sorcellerie = niveau', () {
    final c = cls('sorcerer');
    expect(c.levels.first.columns.containsKey('sorcery_points'), isFalse);
    expect(c.levels[19].columns['sorcery_points'], 20);
    expect(effect('draconic-draconic-resilience'), {
      'op': 'modify_hp_max',
      'flat': 3,
      'per_level': 1,
    });
  });

  test('Magicien (p. 58) : table complète d’un lanceur complet', () {
    final c = cls('wizard');
    expect('${c.spellcastingAbility}', ability('intelligence'));
    List<int> slots(int level) => [
      for (var s = 1; s <= 9; s++) c.levels[level - 1].columns['slot_$s'] ?? 0,
    ];
    expect(slots(1), [2, 0, 0, 0, 0, 0, 0, 0, 0]);
    expect(slots(5), [4, 3, 2, 0, 0, 0, 0, 0, 0]);
    expect(slots(20), [4, 3, 3, 3, 3, 2, 2, 1, 1]);
    expect(c.levels.last.columns['prepared_spells'], 25);
    expect(c.levels.first.columns['cantrips'], 3);
  });

  test(
    'les cinq lanceurs complets ont les mêmes emplacements au niveau 20',
    () {
      for (final slug in ['bard', 'cleric', 'druid', 'sorcerer', 'wizard']) {
        final last = cls(slug).levels.last.columns;
        expect(
          [for (var s = 1; s <= 9; s++) last['slot_$s']],
          [4, 3, 3, 3, 3, 2, 2, 1, 1],
          reason: slug,
        );
      }
    },
  );

  test('listes de sorts = classes citées par l’en-tête de chaque sort', () {
    final headers = readSpellClasses(
      File(p.join(_root, 'extract', 'spell_classes.tsv')),
    );
    for (final (fr, slug) in [
      ('Barde', 'bard'),
      ('Clerc', 'cleric'),
      ('Druide', 'druid'),
      ('Ensorceleur', 'sorcerer'),
      ('Magicien', 'wizard'),
    ]) {
      expect(
        cls(slug).spellList.map((e) => e.slug).toSet(),
        headers[fr]!.toSet(),
        reason: slug,
      );
    }
    for (final MapEntry(key: slug, value: gaps) in _knownListGaps.entries) {
      expect(cls(slug).spellList.map((e) => e.slug), containsAll(gaps));
    }
  });

  test('aptitudes : sous-classes rattachées, textes non vides', () {
    for (final slug in [
      'path-of-the-berserker',
      'college-of-lore',
      'life-domain',
      'circle-of-the-land',
      'draconic-sorcery',
      'evoker',
    ]) {
      final sub = byId['srd:subclass:$slug']!.data as SubclassData;
      expect(sub.features, isNotEmpty, reason: slug);
      for (final f in sub.features) {
        expect(byId['$f']!.textFr, isNotEmpty, reason: '$f');
      }
    }
  });
}
