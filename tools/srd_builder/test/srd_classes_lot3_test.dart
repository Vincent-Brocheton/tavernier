// Classes du lot 3 de T-04 (change t-04c-classes-2). Valeurs relues dans
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

void main() {
  late Map<String, ContentEntity> byId;

  setUpAll(() {
    final loaded = loadSources(Directory(p.join(_root, 'sources')));
    expect(loaded.issues, isEmpty);
    byId = {for (final e in loaded.pack!.entities) '${e.id}': e};
  });

  ClassData cls(String slug) => byId['srd:class:$slug']!.data as ClassData;
  Map<String, int> at(String slug, int level) =>
      cls(slug).levels[level - 1].columns;

  test('Moine (p. 64) : Arts martiaux, Déplacement sans armure en pieds', () {
    expect(at('monk', 1)['martial_arts_die'], 6);
    expect(at('monk', 20)['martial_arts_die'], 12);
    expect(at('monk', 1).containsKey('unarmored_movement_feet'), isFalse);
    expect(at('monk', 2)['unarmored_movement_feet'], 10);
    expect(at('monk', 18)['unarmored_movement_feet'], 30);
    expect(
      byId['srd:feature:monk-unarmored-defense']!.effects.single.toJson(),
      {
        'op': 'ac_formula',
        'base': 10,
        'abilities': ['dex', 'wis'],
        'allows_shield': false,
        'when': {'armor': 'none', 'shield': false},
      },
    );
  });

  test('Occultiste (p. 68) : Magie de pacte', () {
    expect(
      (at('warlock', 1)['pact_slots'], at('warlock', 1)['pact_slot_level']),
      (1, 1),
    );
    expect(
      (at('warlock', 13)['pact_slots'], at('warlock', 13)['pact_slot_level']),
      (3, 5),
    );
    expect(
      (at('warlock', 17)['pact_slots'], at('warlock', 17)['pact_slot_level']),
      (4, 5),
    );
    expect('${cls('warlock').spellcastingAbility}', 'srd:ability:charisma');
  });

  test('Arcanum mystique listé une seule fois (niveau 11)', () {
    final levels = [
      for (final l in cls('warlock').levels)
        if (l.features.any((f) => f.slug == 'warlock-mystic-arcanum')) l.level,
    ];
    expect(levels, [11]);
  });

  test('Roublard (p. 84) : Attaque sournoise 1 → 10 dés, outils de voleur', () {
    expect(at('rogue', 1)['sneak_attack_dice'], 1);
    expect(at('rogue', 19)['sneak_attack_dice'], 10);
    expect(cls('rogue').toolProficiencies.map((e) => '$e'), [
      'srd:tool:thieves-tools',
    ]);
  });

  test('Imposition des mains (p. 75) : 5 × niveau de Paladin, Repos long', () {
    expect(byId['srd:feature:paladin-lay-on-hands']!.effects.single.toJson(), {
      'op': 'grant_resource',
      'id': 'srd:resource:lay-on-hands',
      'max': {'ref': 'class_level', 'class': 'srd:class:paladin', 'times': 5},
      'recharge': [
        {'on': 'long_rest', 'amount': 'all'},
      ],
    });
  });

  test('demi-lanceurs : emplacements au niveau 20', () {
    for (final slug in ['paladin', 'ranger']) {
      expect(
        [for (var s = 1; s <= 5; s++) at(slug, 20)['slot_$s']],
        [4, 3, 3, 3, 2],
        reason: slug,
      );
    }
  });

  test('listes de sorts = classes citées par l’en-tête de chaque sort', () {
    final headers = readSpellClasses(
      File(p.join(_root, 'extract', 'spell_classes.tsv')),
    );
    for (final (fr, slug) in [
      ('Occultiste', 'warlock'),
      ('Paladin', 'paladin'),
      ('Rôdeur', 'ranger'),
    ]) {
      expect(
        cls(slug).spellList.map((e) => e.slug).toSet(),
        headers[fr]!.toSet(),
        reason: slug,
      );
    }
    expect(cls('monk').spellList, isEmpty);
    expect(cls('rogue').spellList, isEmpty);
  });

  test('sous-classes rattachées, textes non vides', () {
    for (final slug in [
      'warrior-of-the-open-hand',
      'fiend-patron',
      'oath-of-devotion',
      'hunter',
      'thief',
    ]) {
      final sub = byId['srd:subclass:$slug']!.data as SubclassData;
      expect(sub.features, isNotEmpty, reason: slug);
      for (final f in sub.features) {
        expect(byId['$f']!.textFr, isNotEmpty, reason: '$f');
      }
    }
  });
}
