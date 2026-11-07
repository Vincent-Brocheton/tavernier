// Spec character-sheet : « Bonus de caractéristique », « Don accordé par une
// Amélioration de caractéristique », « Montée de niveau ».
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

const _fighter = 'srd:class:fighter';

/// Premières options des choix de niveau 1 de [data].
Map<String, List<String>> levelOneChoices(
  ActiveContent content,
  ClassData data,
) => {
  for (final choice in openChoices(content, levelOneFeatures(data)))
    choice.id: [
      for (final option in choice.options.take(choice.count)) option.pick,
    ],
};

void main() {
  final content = srdContent();
  final aldric = CharacterInput.fromJson(fixtureInput('aldric_n1'));

  /// Aldric niveau 5 : les choix de la planche [D1].
  CharacterInput aldricAt5() {
    var character = applyLevelUp(aldric, _fighter, const LevelChoices());
    character = applyLevelUp(
      character,
      _fighter,
      const LevelChoices(subclassId: 'srd:subclass:champion'),
    );
    character = applyLevelUp(
      character,
      _fighter,
      const LevelChoices(
        feat: abilityScoreImprovementFeat,
        featChoices: {'str': 1, 'con': 1},
        masteries: ['srd:weapon:greatsword'],
      ),
    );
    return applyLevelUp(character, _fighter, const LevelChoices());
  }

  group('Aldric niveau 5, valeurs de [D1]', () {
    late ComputedSheet sheet;
    setUp(() => sheet = computeSheet(aldricAt5(), content));

    test('aucune erreur', () => expect(sheet.integrityErrors, isEmpty));

    test('niveau, maîtrise, PV', () {
      expect(sheet.level, 5);
      expect(sheet.proficiencyBonus, 3);
      expect(sheet.hitPointsMax.value, 49);
      expect(sheet.hitDice, (die: 'd10', total: 5));
    });

    test('caractéristiques', () {
      expect(sheet.abilities['str']!.value, 18);
      expect(sheet.abilities['str']!.modifier, 4);
      expect(sheet.abilities['con']!.value, 16);
      expect(sheet.abilities['dex']!.value, 13);
    });

    test('sauvegardes, compétences, Initiative', () {
      expect(sheet.savingThrows['str'], 7);
      expect(sheet.savingThrows['con'], 6);
      expect(sheet.skills['athletics'], 7);
      expect(sheet.passivePerception, 14);
      expect(sheet.initiative.value, 4);
      // Athlète accompli (Champion, niveau 3).
      expect(sheet.initiative.advantage, isTrue);
    });

    test('bottes et ressources', () {
      expect(sheet.weaponMasterySlots, 4);
      expect(sheet.resources['srd:resource:second-wind'], 3);
      expect(sheet.resources['srd:resource:action-surge'], 1);
    });

    test('décomposition de la Force', () {
      expect(sheet.abilities['str']!.sources, const [
        Contribution('base', 15),
        Contribution('srd:background:soldier', 2),
        Contribution(abilityScoreImprovementFeat, 1),
      ]);
    });
  });

  group('bonus de caractéristique', () {
    CharacterInput withImprovement(Map<String, Object?> choices) =>
        aldric.copyWith(
          classLevels: [aldric.classLevels.single.copyWith(level: 4)],
          feats: [
            ...aldric.feats,
            FeatInput(
              featId: abilityScoreImprovementFeat,
              sourceType: 'class_level',
              sourceRef: '$_fighter:4',
              choices: choices,
            ),
          ],
        );

    test('plafonné à 20', () {
      final base = withImprovement(const {'str': 2});
      final high = base.copyWith(
        backgroundChoice: const BackgroundChoice(
          distribution: '2-1',
          bonuses: {'str': 2, 'con': 1},
        ),
        baseScores: base.baseScores.copyWith(
          strength: 15,
          dexterity: 14,
          constitution: 14,
          wisdom: 11,
        ),
      );
      expect(computeSheet(high, content).abilities['str']!.value, 19);
      final capped = high.copyWith(
        feats: [
          ...high.feats,
          const FeatInput(
            featId: abilityScoreImprovementFeat,
            sourceType: 'class_level',
            sourceRef: '$_fighter:6',
            choices: {'str': 2},
          ),
        ],
        classLevels: [high.classLevels.single.copyWith(level: 6)],
      );
      expect(computeSheet(capped, content).abilities['str']!.value, 20);
    });

    test('répartition inconnue : erreur', () {
      final sheet = computeSheet(withImprovement(const {'str': 3}), content);
      expect(
        sheet.integrityErrors.map((e) => e.rule),
        contains(IntegrityRule.choice),
      );
    });
  });

  test('un don d’origines remplace l’Amélioration de caractéristique', () {
    final fourth = aldric.copyWith(
      classLevels: [aldric.classLevels.single.copyWith(level: 4)],
      feats: [
        ...aldric.feats,
        const FeatInput(
          featId: 'srd:feat:skilled',
          sourceType: 'class_level',
          sourceRef: '$_fighter:4',
          choices: {
            'skilled': [
              'srd:skill:arcana',
              'srd:skill:history',
              'srd:skill:nature',
            ],
          },
        ),
      ],
    );
    expect(
      computeSheet(fourth, content).integrityErrors.map((e) => e.rule),
      isNot(contains(IntegrityRule.featGrant)),
    );
  });

  group('levelGain', () {
    CharacterInput atLevel(int level) => aldric.copyWith(
      classLevels: [aldric.classLevels.single.copyWith(level: level)],
    );

    test('niveau 2 : Fougue, ni don ni sous-classe', () {
      final gain = levelGain(aldric, content, _fighter);
      expect(gain.classLevel, 2);
      expect(
        gain.features.map((f) => '${f.id}'),
        contains('srd:feature:fighter-action-surge'),
      );
      expect(gain.subclasses, isEmpty);
      expect(gain.featCategories, isEmpty);
    });

    test('niveau 3 : sous-classe due, et ses aptitudes une fois choisie', () {
      final open = levelGain(atLevel(2), content, _fighter);
      expect(open.subclasses.map((s) => '${s.id}'), ['srd:subclass:champion']);
      final chosen = levelGain(
        atLevel(2),
        content,
        _fighter,
        subclassId: 'srd:subclass:champion',
      );
      expect(
        chosen.features.map((f) => '${f.id}'),
        contains('srd:feature:champion-improved-critical'),
      );
    });

    test('niveau 4 : un don général', () {
      expect(levelGain(atLevel(3), content, _fighter).featCategories, [
        'general',
      ]);
    });

    test('Roublard niveau 6 : seconde Expertise, pas la première', () {
      final rogue = aldric.copyWith(
        classLevels: [
          const ClassLevelInput(classId: 'srd:class:rogue', level: 5),
        ],
      );
      final gain = levelGain(rogue, content, 'srd:class:rogue');
      expect(gain.choices.map((c) => c.id), ['rogue-expertise-6']);
    });
  });

  test('Paladin niveau 2 : styles de combat, pas de dons généraux', () {
    final styles = featsForCategory(content, 'fighting_style');
    expect(styles.map((f) => '${f.id}'), contains('srd:feat:defense'));
    expect(
      styles.map((f) => '${f.id}'),
      isNot(contains(abilityScoreImprovementFeat)),
    );
  });

  group('toute classe du niveau 1 au niveau 20', () {
    /// Fait monter [start] avec les premiers choix valides.
    CharacterInput climb(CharacterInput start, String classId) {
      var character = start;
      for (var level = 2; level <= maxCharacterLevel; level++) {
        var gain = levelGain(character, content, classId);
        final subclass = gain.subclasses.firstOrNull;
        if (subclass != null) {
          gain = levelGain(
            character,
            content,
            classId,
            subclassId: '${subclass.id}',
          );
        }
        final before = computeSheet(character, content);
        final bare = raisedOneLevel(character, classId);
        final slots =
            computeSheet(bare, content).weaponMasterySlots -
            before.weaponMasterySlots;
        final cls = content.entity(classId)!.data as ClassData;
        final owned = {for (final m in character.weaponMasteries) m.weaponId};
        final picks = {
          for (final choice in gain.choices)
            choice.id: [
              for (final option in choice.options.take(choice.count))
                option.pick,
            ],
        };
        gain = levelGain(
          character,
          content,
          classId,
          subclassId: subclass == null ? null : '${subclass.id}',
          picks: picks,
        );
        final category = gain.featCategories.firstOrNull;
        final feat = category == null
            ? null
            : featsForCategory(content, category).firstWhere(
                (f) => featBlock(f, character, before, level, content) == null,
              );
        final featId = '${feat?.id}';
        final featChoices = <String, Object?>{
          if (featId == abilityScoreImprovementFeat)
            abilityCodes.firstWhere(
              (code) => before.abilities[code]!.value <= 18,
            ): 2,
          for (final choice in openChoices(content, [featId]))
            if (choice.options.isNotEmpty)
              choice.id: [
                for (final option in choice.options.take(choice.count))
                  option.pick,
              ],
          if (category == 'epic_boon') 'str': 1,
        };
        character = applyLevelUp(
          character,
          classId,
          LevelChoices(
            subclassId: subclass == null ? null : '${subclass.id}',
            feat: feat == null ? null : featId,
            featChoices: featChoices.isEmpty ? null : featChoices,
            choices: picks,
            masteries: [
              for (final weapon in masteryOptions(content, cls).weapons)
                if (!owned.contains('${weapon.id}')) '${weapon.id}',
            ].take(slots).toList(),
          ),
        );
      }
      return character;
    }

    for (final slug in [
      'barbarian',
      'bard',
      'cleric',
      'druid',
      'fighter',
      'monk',
      'paladin',
      'ranger',
      'rogue',
      'sorcerer',
      'warlock',
      'wizard',
    ]) {
      test(slug, () {
        final classId = 'srd:class:$slug';
        final data = content.entity(classId)!.data as ClassData;
        final first = levelOneChoices(content, data);
        final start = aldric.copyWith(
          classLevels: [ClassLevelInput(classId: classId, level: 1)],
          feats: [
            for (final feat in aldric.feats)
              if (feat.sourceType != 'class') feat,
            for (final category in grantedFeatCategories(
              content,
              levelOneFeatures(data),
            ))
              FeatInput(
                featId: '${featsForCategory(content, category).first.id}',
                sourceType: 'class',
                sourceRef: classId,
              ),
          ],
          weaponMasteries: const [],
          choices: {
            'skillful': const ['srd:skill:insight'],
            ...first,
          },
        );
        final sheet = computeSheet(climb(start, classId), content);
        expect(sheet.level, 20);
        expect(
          sheet.integrityErrors.map((e) => e.message),
          isEmpty,
          reason: slug,
        );
      });
    }
  });

  group('featBlock', () {
    final sheet = computeSheet(aldric, content);
    ContentEntity feat(String slug) => content.entity('srd:feat:$slug')!;

    test('non répétable déjà obtenu', () {
      expect(
        featBlock(feat('alert'), aldric, sheet, 4, content),
        FeatBlock.notRepeatable,
      );
    });

    test('répétable déjà obtenu : disponible', () {
      final twice = aldric.copyWith(
        feats: [
          ...aldric.feats,
          const FeatInput(
            featId: abilityScoreImprovementFeat,
            sourceType: 'class_level',
            sourceRef: '$_fighter:4',
          ),
        ],
      );
      expect(
        featBlock(
          content.entity(abilityScoreImprovementFeat)!,
          twice,
          sheet,
          6,
          content,
        ),
        isNull,
      );
    });

    test('niveau insuffisant', () {
      expect(
        featBlock(feat('grappler'), aldric, sheet, 3, content),
        FeatBlock.level,
      );
    });

    test('caractéristique insuffisante', () {
      final weak = aldric.copyWith(
        baseScores: aldric.baseScores.copyWith(strength: 8, dexterity: 8),
        backgroundChoice: const BackgroundChoice(
          distribution: '2-1',
          bonuses: {'con': 2, 'wis': 1},
        ),
      );
      expect(
        featBlock(
          feat('grappler'),
          weak,
          computeSheet(weak, content),
          4,
          content,
        ),
        FeatBlock.ability,
      );
    });

    test('sort requis : un Guerrier ne prend pas une faveur de lanceur', () {
      expect(
        featBlock(feat('boon-of-spell-recall'), aldric, sheet, 19, content),
        FeatBlock.feature,
      );
    });

    test('conditions remplies', () {
      expect(featBlock(feat('grappler'), aldric, sheet, 4, content), isNull);
    });
  });
}
