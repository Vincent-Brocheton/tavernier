// Spec character-sheet : « Lancer un sort », « Concentration ». EF-PJ-09, SRD
// p. 27 pour les emplacements de pacte, [P14] et [F5a].
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final content = srdContent();
  final mira = CharacterInput.fromJson(fixtureInput('mira_n5'));
  final sheet = computeSheet(mira, content);
  final warlock = computeSheet(
    mira.copyWith(
      classLevels: const [
        ClassLevelInput(classId: 'srd:class:warlock', level: 5),
      ],
      feats: const [],
    ),
    content,
  );

  SpellData spell(String slug) =>
      content.entity('srd:spell:$slug')!.data as SpellData;

  group('manières de lancer', () {
    test('sort mineur : rien à dépenser', () {
      final options = castOptions(
        spell('sacred-flame'),
        sheet,
        const PlayState(),
      );
      expect(options.single.resource, isNull);
      expect(options.single.ritual, isFalse);
    });

    test('un sort du 1er niveau accepte tous les emplacements', () {
      final options = castOptions(spell('bless'), sheet, const PlayState());
      expect(options.map((o) => o.level), [1, 2, 3]);
      expect(options.map((o) => o.left), [4, 3, 2]);
    });

    test('un sort du 3e niveau ne prend que le 3e', () {
      final options = castOptions(
        spell('spirit-guardians'),
        sheet,
        const PlayState(),
      );
      expect(options.map((o) => o.level), [3]);
    });

    test('emplacements épuisés : niveau retiré', () {
      final options = castOptions(
        spell('spirit-guardians'),
        sheet,
        PlayState(used: {slotResource(3): 2}),
      );
      expect(options, isEmpty);
    });

    test('rituel : possible sans emplacement', () {
      final options = castOptions(
        spell('detect-magic'),
        sheet,
        PlayState(
          used: {slotResource(1): 4, slotResource(2): 3, slotResource(3): 2},
        ),
      );
      expect(options.single.ritual, isTrue);
      expect(options.single.resource, isNull);
      expect(options.single.level, 1);
    });

    test('Occultiste 5 [F5a] : toujours au niveau de pacte', () {
      final options = castOptions(spell('hex'), warlock, const PlayState());
      expect(options.single.level, 3);
      expect(options.single.pact, isTrue);
      expect(options.single.left, 2);
    });

    test('Occultiste : un sort au-dessus du pacte ne se lance pas', () {
      expect(
        castOptions(spell('wall-of-fire'), warlock, const PlayState()),
        isEmpty,
      );
    });
  });

  group('lancer', () {
    test('décompte l\'emplacement choisi', () {
      final state = castSpell(
        const PlayState(),
        'srd:spell:sanctuary',
        spell('sanctuary'),
        CastOption(level: 2, left: 3, resource: slotResource(2)),
      );
      expect(state.usedOf(slotResource(2)), 1);
      expect(state.usedOf(slotResource(1)), 0);
    });

    test('sort mineur : rien n\'est dépensé', () {
      final state = castSpell(
        const PlayState(),
        'srd:spell:sacred-flame',
        spell('sacred-flame'),
        const CastOption(level: 0, left: 0),
      );
      expect(state.used, isEmpty);
    });

    test('sort sans concentration : celle en cours continue', () {
      final state = castSpell(
        const PlayState(concentrationSpellId: 'srd:spell:bless'),
        'srd:spell:sanctuary',
        spell('sanctuary'),
        CastOption(level: 1, left: 4, resource: slotResource(1)),
      );
      expect(state.concentrationSpellId, 'srd:spell:bless');
    });
  });

  group('concentration (EF-PJ-09)', () {
    const blessing = PlayState(concentrationSpellId: 'srd:spell:bless');

    test('un second sort à concentration remplace le premier', () {
      final guardians = spell('spirit-guardians');
      expect(
        replacedConcentration(
          'srd:spell:spirit-guardians',
          guardians,
          blessing,
        ),
        'srd:spell:bless',
      );
      final state = castSpell(
        blessing,
        'srd:spell:spirit-guardians',
        guardians,
        CastOption(level: 3, left: 2, resource: slotResource(3)),
      );
      expect(state.concentrationSpellId, 'srd:spell:spirit-guardians');
    });

    test('rien à remplacer sans concentration en cours', () {
      expect(
        replacedConcentration(
          'srd:spell:bless',
          spell('bless'),
          const PlayState(),
        ),
        isNull,
      );
    });

    test('un sort sans concentration ne remplace rien', () {
      expect(
        replacedConcentration(
          'srd:spell:sanctuary',
          spell('sanctuary'),
          blessing,
        ),
        isNull,
      );
    });

    test('le même sort ne demande pas de confirmation', () {
      expect(
        replacedConcentration('srd:spell:bless', spell('bless'), blessing),
        isNull,
      );
    });

    test('mettre fin garde les emplacements', () {
      final state = endConcentration(
        PlayState(
          used: {slotResource(1): 2},
          concentrationSpellId: 'srd:spell:bless',
        ),
      );
      expect(state.concentrationSpellId, isNull);
      expect(state.usedOf(slotResource(1)), 2);
    });
  });
}
