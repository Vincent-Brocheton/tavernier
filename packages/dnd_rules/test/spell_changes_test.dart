// Spec character-sheet : « Modifier ses sorts », « Recopier un sort »,
// « Savoir rituel », « Lancers gratuits ». SRD, chaque classe.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

const _cleric = 'srd:class:cleric';
const _paladin = 'srd:class:paladin';
const _wizard = 'srd:class:wizard';

void main() {
  final content = srdContent();
  final mira = CharacterInput.fromJson(fixtureInput('mira_n5'));
  final brannoc = CharacterInput.fromJson(fixtureInput('brannoc_n5'));
  final thalia = CharacterInput.fromJson(fixtureInput('thalia_n5'));

  ClassData data(String id) => content.entity(id)!.data as ClassData;
  SpellData spell(String slug) =>
      content.entity('srd:spell:$slug')!.data as SpellData;

  group('façon de changer ses sorts', () {
    test('liste complète après un repos long', () {
      for (final slug in ['cleric', 'druid', 'wizard']) {
        final cls = data('srd:class:$slug');
        expect(cls.preparedChange, PreparedChange.longRestAll);
        expect(changeLimit(cls), isNull);
      }
    });

    test('un sort après un repos long', () {
      for (final slug in ['paladin', 'ranger']) {
        final cls = data('srd:class:$slug');
        expect(cls.preparedChange, PreparedChange.longRestOne);
        expect(changeLimit(cls), 1);
      }
    });

    test('un sort par niveau gagné', () {
      for (final slug in ['bard', 'sorcerer', 'warlock']) {
        final cls = data('srd:class:$slug');
        expect(cls.preparedChange, PreparedChange.levelUpOne);
        expect(changeLimit(cls), 1);
      }
    });

    test('pas de sorts : pas de façon de les changer', () {
      expect(data('srd:class:fighter').preparedChange, isNull);
    });
  });

  group('sorts d\'une classe', () {
    test('remplace les sorts préparés et mineurs', () {
      final after = withClassSpells(
        mira,
        content,
        _cleric,
        prepared: const ['srd:spell:bless'],
        cantrips: const ['srd:spell:guidance'],
      );
      expect(after.spells.prepared, ['srd:spell:bless']);
      expect(after.spells.cantrips, ['srd:spell:guidance']);
    });

    test('laisse ceux d\'une autre classe', () {
      final multi = mira.copyWith(
        classLevels: const [
          ClassLevelInput(classId: _cleric, level: 3),
          ClassLevelInput(classId: _paladin, level: 2),
        ],
        spells: const SpellsInput(
          prepared: ['srd:spell:bless', 'srd:spell:divine-favor'],
          classes: {'srd:spell:divine-favor': _paladin},
        ),
      );
      final after = withClassSpells(
        multi,
        content,
        _cleric,
        prepared: const ['srd:spell:command'],
        cantrips: const [],
      );
      expect(
        after.spells.prepared,
        unorderedEquals(['srd:spell:divine-favor', 'srd:spell:command']),
      );
      expect(after.spells.classes['srd:spell:command'], _cleric);
    });

    test('un sort du grimoire y reste', () {
      final prepared = brannoc.spells.spellbook.take(9).toList();
      final after = withClassSpells(
        brannoc,
        content,
        _wizard,
        prepared: prepared,
        cantrips: const [],
      );
      expect(after.spells.spellbook, hasLength(14));
      expect(after.spells.prepared, prepared);
    });
  });

  group('recopie', () {
    test('rejoint le grimoire, 50 po par niveau', () {
      final rich = brannoc.copyWith(coins: const {'gp': 120, 'sp': 3});
      final after = copySpell(rich, 'srd:spell:knock', 2, _wizard);
      expect(after.spells.spellbook, contains('srd:spell:knock'));
      expect(after.spells.classes['srd:spell:knock'], _wizard);
      expect(after.coins['gp'], 20);
      expect(after.coins['sp'], 3);
    });
  });

  group('lancers gratuits', () {
    test('Thalia, haute-elfe : un lancer de Détection de la magie', () {
      final sheet = computeSheet(thalia, content);
      expect(sheet.freeCasts['srd:spell:detect-magic'], 1);
      expect(sheet.freeCasts['srd:spell:misty-step'], 1);
      final options = castOptions(
        spell('detect-magic'),
        sheet,
        const PlayState(),
        spellId: 'srd:spell:detect-magic',
      );
      expect(options.first.free, isTrue);
      expect(options.first.level, 1);
    });

    test('lancer dépensé : retiré', () {
      final sheet = computeSheet(thalia, content);
      final options = castOptions(
        spell('misty-step'),
        sheet,
        PlayState(used: {freeCastResource('srd:spell:misty-step'): 1}),
        spellId: 'srd:spell:misty-step',
      );
      expect(options, isEmpty);
    });

    test('un palier non atteint ne donne rien', () {
      final low = thalia.copyWith(
        classLevels: [thalia.classLevels.single.copyWith(level: 3)],
        feats: const [],
      );
      expect(
        computeSheet(low, content).freeCasts,
        isNot(contains('srd:spell:misty-step')),
      );
    });

    test('Initié à la magie : un lancer de son sort du 1er niveau', () {
      expect(
        computeSheet(
          mira,
          content,
        ).freeCasts['srd:spell:protection-from-evil-and-good'],
        1,
      );
    });

    test('Rôdeur : Ennemi juré selon la table', () {
      final ranger = mira.copyWith(
        classLevels: const [
          ClassLevelInput(classId: 'srd:class:ranger', level: 1),
        ],
        feats: const [],
      );
      expect(
        computeSheet(ranger, content).freeCasts['srd:spell:hunters-mark'],
        2,
      );
    });
  });
}
