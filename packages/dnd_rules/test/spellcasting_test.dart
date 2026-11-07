// Spec character-sheet : « Valeurs d'incantation par classe », « Emplacements de
// sort », « Sorts de la fiche ». Valeurs de [D1] et du SRD p. 26-27.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

const _cleric = 'srd:class:cleric';
const _paladin = 'srd:class:paladin';

void main() {
  final content = srdContent();
  final mira = CharacterInput.fromJson(fixtureInput('mira_n5'));
  final brannoc = CharacterInput.fromJson(fixtureInput('brannoc_n5'));

  ClassLevelInput level(String slug, int level, [String? subclass]) =>
      ClassLevelInput(
        classId: 'srd:class:$slug',
        level: level,
        subclassId: subclass,
      );

  /// Scores d'Orin [D1] : FOR 15, DEX 10, CON 14, INT 8, SAG 14, CHA 14,
  /// sans bonus d'Historique.
  CharacterInput orin(List<ClassLevelInput> levels) => mira.copyWith(
    speciesId: 'srd:species:human',
    baseScores: const BaseScores(
      method: ScoreMethod.pointBuy,
      strength: 15,
      dexterity: 10,
      constitution: 14,
      intelligence: 8,
      wisdom: 14,
      charisma: 14,
    ),
    backgroundChoice: const BackgroundChoice(
      distribution: '1-1-1',
      bonuses: {},
    ),
    classLevels: levels,
    feats: const [],
    spells: const SpellsInput(),
    choices: const {},
    weaponMasteries: const [],
    items: const [],
  );

  group('valeurs par classe', () {
    test('Mira : DD 14, +6, 9 préparés, 4 mineurs', () {
      final casting = computeSheet(
        mira,
        content,
      ).spellcasting['srd:class:cleric']!;
      expect(casting.ability, 'wis');
      expect(casting.saveDc.value, 14);
      expect(casting.attackBonus.value, 6);
      expect(casting.preparedMax, 9);
      expect(casting.cantripsKnown, 4);
      expect(casting.saveDc.sources, const [
        Contribution('dc_base', 8),
        Contribution('proficiency', 3),
        Contribution('wis', 3),
      ]);
    });

    test('Orin : deux classes, chacune sa caractéristique', () {
      final sheet = computeSheet(
        orin([level('cleric', 3), level('paladin', 4)]),
        content,
      );
      final cleric = sheet.spellcasting[_cleric]!;
      final paladin = sheet.spellcasting[_paladin]!;
      expect(cleric.ability, 'wis');
      expect(cleric.saveDc.value, 13);
      expect(cleric.preparedMax, 6);
      expect(paladin.ability, 'cha');
      expect(paladin.saveDc.value, 13);
      expect(paladin.preparedMax, 5);
    });

    test('un Guerrier ne lance pas de sorts', () {
      final sheet = computeSheet(orin([level('fighter', 5)]), content);
      expect(sheet.spellcasting, isEmpty);
      expect(sheet.spellSlots, isEmpty);
      expect(sheet.pactMagic, isNull);
    });
  });

  group('emplacements', () {
    test('Mira : 4 / 3 / 2, sans niveau de lanceur', () {
      final sheet = computeSheet(mira, content);
      expect(sheet.spellSlots, [4, 3, 2]);
      expect(sheet.casterLevel, isNull);
    });

    test('Paladin 4 : 3 emplacements du 1er niveau', () {
      final sheet = computeSheet(orin([level('paladin', 4)]), content);
      expect(sheet.spellSlots, [3]);
    });

    test('Clerc 3 / Paladin 4 [F5b] : lanceur 5, 4 / 3 / 2', () {
      final sheet = computeSheet(
        orin([level('cleric', 3), level('paladin', 4)]),
        content,
      );
      expect(sheet.casterLevel, 5);
      expect(sheet.spellSlots, [4, 3, 2]);
    });

    test('Ensorceleur 3 / Rôdeur 4 (SRD) : 4 / 3 / 2', () {
      final sheet = computeSheet(
        orin([level('sorcerer', 3), level('ranger', 4)]),
        content,
      );
      expect(sheet.casterLevel, 5);
      expect(sheet.spellSlots, [4, 3, 2]);
    });

    test('Paladin 1 / Rôdeur 2 : moitié de la somme, arrondie', () {
      final sheet = computeSheet(
        orin([level('paladin', 1), level('ranger', 2)]),
        content,
      );
      expect(sheet.casterLevel, 2);
      expect(sheet.spellSlots, [3]);
    });

    test('Guerrier 5 / Clerc 3 : la table du Clerc seul', () {
      final sheet = computeSheet(
        orin([level('fighter', 5), level('cleric', 3)]),
        content,
      );
      expect(sheet.casterLevel, isNull);
      expect(sheet.spellSlots, [4, 2]);
    });

    test('la table du multiclassage vaut celle du Magicien', () {
      final wizard = content.entity('srd:class:wizard')!.data as ClassData;
      for (final row in wizard.levels) {
        expect(multiclassSlots[row.level - 1], [
          for (var n = 1; row.columns['slot_$n'] != null; n++)
            row.columns['slot_$n'],
        ], reason: 'niveau ${row.level}');
      }
    });

    test('Occultiste 5 : 2 emplacements du 3e niveau, à part', () {
      final sheet = computeSheet(orin([level('warlock', 5)]), content);
      expect(sheet.spellSlots, isEmpty);
      expect(sheet.pactMagic!.slots, 2);
      expect(sheet.pactMagic!.slotLevel, 3);
      expect(sheet.spellcasting['srd:class:warlock']!.preparedMax, 6);
      expect(sheet.spellcasting['srd:class:warlock']!.cantripsKnown, 3);
    });

    test('Clerc 3 / Occultiste 2 : pas de table du multiclassage', () {
      final sheet = computeSheet(
        orin([level('cleric', 3), level('warlock', 2)]),
        content,
      );
      expect(sheet.casterLevel, isNull);
      expect(sheet.spellSlots, [4, 2]);
      expect(sheet.pactMagic!.slots, 2);
      expect(sheet.pactMagic!.slotLevel, 1);
    });
  });

  group('sorts de la fiche', () {
    test('Mira : sorts de domaine toujours préparés', () {
      final spells = sheetSpells(mira, content);
      final aid = spells.singleWhere((s) => s.id == 'srd:spell:aid');
      expect(aid.alwaysPrepared, isTrue);
      expect(aid.classId, _cleric);
      expect(
        spells.where((s) => s.origin == SpellOrigin.granted),
        hasLength(6),
      );
    });

    test('Mira : neuf sorts préparés de sa classe', () {
      final spells = sheetSpells(mira, content);
      expect(
        spells.where((s) => s.prepared && s.classId == _cleric),
        hasLength(9),
      );
    });

    test('Mira : Initié à la magie, hors classe', () {
      final spell = sheetSpells(
        mira,
        content,
      ).singleWhere((s) => s.id == 'srd:spell:mending');
      expect(spell.origin, SpellOrigin.feat);
      expect(spell.classId, isNull);
    });

    test('Brannoc : grimoire de 14 sorts', () {
      final spells = sheetSpells(brannoc, content);
      expect(spells.where((s) => s.inSpellbook), hasLength(14));
    });

    test('un palier se lit au niveau de la classe', () {
      final character = orin([
        level('fighter', 4),
        level('cleric', 3, 'srd:subclass:life-domain'),
      ]);
      final ids = sheetSpells(character, content).map((s) => s.id);
      expect(ids, contains('srd:spell:aid'));
      expect(ids, isNot(contains('srd:spell:revivify')));
    });

    test('la classe du sort suit la montée de niveau', () {
      final before = orin([level('cleric', 3), level('paladin', 3)]);
      final after = applyLevelUp(
        before,
        _paladin,
        const LevelChoices(
          spells: SpellsInput(prepared: ['srd:spell:divine-favor']),
        ),
      );
      expect(after.spells.classes['srd:spell:divine-favor'], _paladin);
      final spell = sheetSpells(
        after,
        content,
      ).singleWhere((s) => s.id == 'srd:spell:divine-favor');
      expect(spell.classId, _paladin);
    });

    test('sans association : la première classe de lanceur', () {
      final character = orin([level('fighter', 2), level('cleric', 1)])
          .copyWith(spells: const SpellsInput(prepared: ['srd:spell:bless']));
      expect(sheetSpells(character, content).single.classId, _cleric);
    });
  });
}
