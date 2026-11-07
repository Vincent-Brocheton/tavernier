// Spec character-sheet : « Premier niveau d'une nouvelle classe », « Dés de vie
// par type », « Une seule formule de classe d'armure ». Valeurs du SRD p. 26-27
// et des encadrés « En tant que personnage multiclassé ».
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

const _rogue = 'srd:class:rogue';
const _bard = 'srd:class:bard';
const _wizard = 'srd:class:wizard';

void main() {
  final content = srdContent();

  /// FOR 17, DEX 13, CON 15, INT 8, SAG 12, CHA 10, sans objet.
  final aldric = CharacterInput.fromJson(fixtureInput('aldric_n1'))
      .copyWith(items: const []);

  CharacterInput withClasses(List<ClassLevelInput> levels) =>
      aldric.copyWith(classLevels: levels, weaponMasteries: const []);

  ClassLevelInput level(String slug, int level) =>
      ClassLevelInput(classId: 'srd:class:$slug', level: level);

  ClassData classData(String id) => content.entity(id)!.data as ClassData;

  group('encadrés du SRD', () {
    test('armes, armures et choix de chaque classe', () {
      Object? traits(String slug) {
        final t = classData('srd:class:$slug').multiclass;
        return [
          t.weaponProficiencies,
          t.armorTraining,
          t.skillChoiceCount,
          t.toolChoiceCount,
        ];
      }

      const martial = ['martial'];
      const none = <String>[];
      const armored = ['light', 'medium', 'shield'];
      expect(traits('barbarian'), [
        martial,
        ['shield'],
        0,
        0,
      ]);
      expect(traits('bard'), [
        none,
        ['light'],
        1,
        1,
      ]);
      expect(traits('cleric'), [none, armored, 0, 0]);
      expect(traits('druid'), [
        none,
        ['light', 'shield'],
        0,
        0,
      ]);
      expect(traits('fighter'), [martial, armored, 0, 0]);
      expect(traits('monk'), [none, none, 0, 0]);
      expect(traits('paladin'), [martial, armored, 0, 0]);
      expect(traits('ranger'), [martial, armored, 1, 0]);
      expect(traits('rogue'), [
        none,
        ['light'],
        1,
        0,
      ]);
      expect(traits('sorcerer'), [none, none, 0, 0]);
      expect(traits('warlock'), [
        none,
        ['light'],
        0,
        0,
      ]);
      expect(traits('wizard'), [none, none, 0, 0]);
    });

    test('le Roublard apporte ses outils de voleur', () {
      expect(classData(_rogue).multiclass.toolProficiencies.map((e) => '$e'), [
        'srd:tool:thieves-tools',
      ]);
    });
  });

  group('accès à une classe', () {
    final abilities = computeSheet(aldric, content).abilities;

    test('prérequis rempli : la valeur retenue', () {
      final access = classAccess(classData(_rogue), abilities);
      expect(access.open, isTrue);
      expect(access.scores, [(ability: 'srd:ability:dexterity', score: 13)]);
    });

    test('prérequis manquant : la valeur qui manque', () {
      final access = classAccess(classData('srd:class:paladin'), abilities);
      expect(access.open, isFalse);
      expect(access.scores, [(ability: 'srd:ability:charisma', score: 10)]);
    });
  });

  group('valeurs du SRD', () {
    test('Guerrier 3 / Roublard 2 : bonus de maîtrise +3', () {
      final sheet = computeSheet(
        withClasses([level('fighter', 3), level('rogue', 2)]),
        content,
      );
      expect(sheet.proficiencyBonus, 3);
    });

    test('Clerc 5 / Paladin 5 : cinq d8 et cinq d10', () {
      final sheet = computeSheet(
        withClasses([level('cleric', 5), level('paladin', 5)]),
        content,
      );
      expect(sheet.hitDice, [(die: 'd8', total: 5), (die: 'd10', total: 5)]);
    });

    test('Paladin 5 / Guerrier 5 : dix d10', () {
      final sheet = computeSheet(
        withClasses([level('paladin', 5), level('fighter', 5)]),
        content,
      );
      expect(sheet.hitDice, [(die: 'd10', total: 10)]);
    });

    test('Clerc 3 / Paladin 4 : 8 + 5 × 2 + 6 × 4 PV, plus CON +2 × 7', () {
      final sheet = computeSheet(
        withClasses([level('cleric', 3), level('paladin', 4)]),
        content,
      );
      expect(sheet.hitPointsMax.value, 56);
    });
  });

  group('armes', () {
    test('Roublard de départ : rapière maîtrisée', () {
      final sheet = computeSheet(withClasses([level('rogue', 1)]), content);
      expect(sheet.proficientWeapons, contains('srd:weapon:rapier'));
    });

    test('Magicien puis Roublard : rapière non maîtrisée', () {
      final sheet = computeSheet(
        withClasses([level('wizard', 1), level('rogue', 1)]),
        content,
      );
      expect(sheet.proficientWeapons, contains('srd:weapon:dagger'));
      expect(sheet.proficientWeapons, isNot(contains('srd:weapon:rapier')));
    });

    test('Magicien puis Guerrier : armes de guerre', () {
      final sheet = computeSheet(
        withClasses([level('wizard', 1), level('fighter', 1)]),
        content,
      );
      expect(sheet.proficientWeapons, contains('srd:weapon:rapier'));
    });
  });

  group('classe d\'armure', () {
    int armorClass(List<ClassLevelInput> levels) => computeSheet(
      withClasses(levels).copyWith(feats: const []),
      content,
    ).armorClass.value;

    test('Barbare : 10 + DEX +1 + CON +2', () {
      expect(armorClass([level('barbarian', 1)]), 13);
    });

    test('Moine : 10 + DEX +1 + SAG +1', () {
      expect(armorClass([level('monk', 1)]), 12);
    });

    test('Barbare / Moine : une seule formule', () {
      expect(armorClass([level('monk', 1), level('barbarian', 1)]), 13);
    });

    test('formule moins bonne que 10 + DEX : ignorée', () {
      final weak = aldric.copyWith(
        baseScores: aldric.baseScores.copyWith(constitution: 8),
        backgroundChoice: const BackgroundChoice(
          distribution: '2-1',
          bonuses: {'str': 2, 'dex': 1},
        ),
        classLevels: [level('barbarian', 1)],
        weaponMasteries: const [],
        feats: const [],
      );
      expect(computeSheet(weak, content).armorClass.value, 12);
    });
  });

  group('nouvelle classe', () {
    test('Aldric prend Roublard : niveau 1, aptitudes et compétence', () {
      final gain = levelGain(aldric, content, _rogue);
      expect(gain.classLevel, 1);
      expect(
        gain.features.map((f) => '${f.id}'),
        contains('srd:feature:rogue-sneak-attack'),
      );
      final skill = gain.choices.singleWhere(
        (c) => c.id == multiclassSkillChoice(_rogue),
      );
      expect(skill.count, 1);
      final offered = skill.options.map((o) => o.pick);
      expect(offered, contains('srd:skill:stealth'));
      // Athlétisme vient du Soldat, Perception du Guerrier.
      expect(offered, isNot(contains('srd:skill:athletics')));
      expect(offered, isNot(contains('srd:skill:perception')));
    });

    test('Barde : une compétence et un instrument', () {
      final gain = levelGain(aldric, content, _bard);
      final tool = gain.choices.singleWhere(
        (c) => c.id == multiclassToolChoice(_bard),
      );
      expect(tool.count, 1);
      expect(tool.options.map((o) => o.pick), contains('srd:tool:lute'));
      expect(
        gain.choices.map((c) => c.id),
        contains(multiclassSkillChoice(_bard)),
      );
    });

    test('Moine : rien à choisir de plus', () {
      final gain = levelGain(aldric, content, 'srd:class:monk');
      expect(
        gain.choices.map((c) => c.id),
        isNot(contains(multiclassToolChoice('srd:class:monk'))),
      );
    });

    test('une classe déjà prise n\'ouvre pas ces choix', () {
      final gain = levelGain(aldric, content, 'srd:class:fighter');
      expect(
        gain.choices.map((c) => c.id),
        isNot(contains(multiclassSkillChoice('srd:class:fighter'))),
      );
    });

    test('la compétence va sur la classe, l\'instrument dans les choix', () {
      final after = applyLevelUp(
        aldric,
        _bard,
        LevelChoices(
          choices: {
            multiclassSkillChoice(_bard): const ['srd:skill:stealth'],
            multiclassToolChoice(_bard): const ['srd:tool:lute'],
          },
        ),
      );
      expect(after.classLevels.last.classId, _bard);
      expect(after.classLevels.last.level, 1);
      expect(after.classLevels.last.skillChoices, ['srd:skill:stealth']);
      expect(after.choices.keys, isNot(contains(multiclassSkillChoice(_bard))));
      expect(after.choices[multiclassToolChoice(_bard)], ['srd:tool:lute']);
      expect(
        computeSheet(after, content).skillProficiencies,
        contains('stealth'),
      );
    });

    test('PV de la nouvelle classe : valeur fixe, pas le maximum', () {
      final before = computeSheet(aldric, content).hitPointsMax.value;
      final after = computeSheet(
        applyLevelUp(aldric, _rogue, const LevelChoices()),
        content,
      ).hitPointsMax.value;
      expect(after - before, 5 + 2);
    });

    test('Magicien : 6 sorts au grimoire, puis 2 par niveau', () {
      expect(spellGain(content, _wizard, 1).spellbook, 6);
      expect(spellGain(content, _wizard, 2).spellbook, 2);
      expect(spellGain(content, 'srd:class:cleric', 1).spellbook, 0);
    });

    test('le niveau 1 d\'une classe de lanceur apporte ses sorts', () {
      final spells = spellGain(content, 'srd:class:cleric', 1);
      expect(spells.cantrips, 3);
      expect(spells.prepared, 4);
      expect(spells.maxLevel, 1);
    });

    test('rester dans sa classe ne change pas son entrée', () {
      final after = applyLevelUp(
        aldric,
        'srd:class:fighter',
        const LevelChoices(),
      );
      expect(after.classLevels.single.level, 2);
      expect(
        after.classLevels.single.skillChoices,
        aldric.classLevels.single.skillChoices,
      );
    });
  });
}
