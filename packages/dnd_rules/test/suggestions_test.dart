// Spec character-sheet : « Suggestions ». Table « Valeurs standard par classe »
// du SRD, et [J11], [P10].
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final content = srdContent();

  ClassData data(String slug) =>
      content.entity('srd:class:$slug')!.data as ClassData;

  group('valeurs', () {
    test('Guerrier : 15, 14, 13, 8, 10, 12 (SRD)', () {
      expect(suggestedScores('srd:class:fighter', data('fighter')), {
        'str': 15,
        'dex': 14,
        'con': 13,
        'int': 8,
        'wis': 10,
        'cha': 12,
      });
    });

    test('Magicien : Intelligence en tête', () {
      final scores = suggestedScores('srd:class:wizard', data('wizard'));
      expect(scores['int'], 15);
      expect(scores['str'], 8);
    });

    test('toutes les classes coûtent 27 points', () {
      for (final entity in content.entities) {
        if (entity.data case final ClassData cls) {
          final scores = suggestedScores('${entity.id}', cls);
          expect(pointBuySpent(scores), pointBuyBudget, reason: entity.name);
        }
      }
    });

    test('classe de pack : principales puis Constitution', () {
      final scores = suggestedScores('test:class:other', data('wizard'));
      expect(scores['int'], 15);
      expect(scores['con'], 14);
      expect(pointBuySpent(scores), pointBuyBudget);
    });
  });

  group('bonus d\'Historique', () {
    test('+2 et +1 sur les plus hautes valeurs éligibles', () {
      expect(
        suggestedBonuses(
          const {'str': 15, 'dex': 14, 'con': 13},
          const {'str', 'dex', 'con'},
        ),
        {'str': 2, 'dex': 1},
      );
    });

    test('une valeur non éligible est ignorée', () {
      expect(
        suggestedBonuses(
          const {'str': 15, 'dex': 14, 'con': 13, 'int': 8},
          const {'con', 'int', 'dex'},
        ),
        {'dex': 2, 'con': 1},
      );
    });
  });

  test('Roublard : compétences de Dextérité d\'abord', () {
    final picks = suggestedSkills(content, data('rogue'), const [
      'srd:skill:athletics',
      'srd:skill:persuasion',
      'srd:skill:stealth',
      'srd:skill:acrobatics',
    ], 2);
    expect(picks, ['srd:skill:stealth', 'srd:skill:acrobatics']);
  });

  test('compétences insuffisantes : complétées par les autres', () {
    final picks = suggestedSkills(content, data('rogue'), const [
      'srd:skill:athletics',
      'srd:skill:stealth',
    ], 2);
    expect(picks, ['srd:skill:stealth', 'srd:skill:athletics']);
  });

  test('Guerrier : bottes des armes de départ d\'abord', () {
    final picks = suggestedMasteries(data('fighter'), const [
      'srd:weapon:club',
      'srd:weapon:greatsword',
      'srd:weapon:flail',
    ], 2);
    expect(picks, ['srd:weapon:greatsword', 'srd:weapon:flail']);
  });

  group('Amélioration [P10]', () {
    final aldric = CharacterInput.fromJson(fixtureInput('aldric_n5'));

    test('FOR 18 : +2 en Force', () {
      final sheet = computeSheet(aldric, content);
      expect(suggestedImprovement(sheet, data('fighter')), ['str']);
    });

    test('Force et Dextérité au-delà du possible : +1 et +1', () {
      final high = aldric.copyWith(
        feats: [
          ...aldric.feats,
          const FeatInput(
            featId: abilityScoreImprovementFeat,
            sourceType: 'class_level',
            sourceRef: 'srd:class:fighter:6',
            choices: {'str': 1, 'con': 1},
          ),
        ],
      );
      final sheet = computeSheet(high, content);
      expect(sheet.abilities['str']!.value, 19);
      expect(suggestedImprovement(sheet, data('fighter')), ['dex']);
    });

    test('toutes les principales au plafond : les suivantes', () {
      final capped = aldric.copyWith(
        feats: [
          ...aldric.feats,
          const FeatInput(
            featId: abilityScoreImprovementFeat,
            sourceType: 'class_level',
            sourceRef: 'srd:class:fighter:6',
            choices: {'str': 2},
          ),
        ],
      );
      final sheet = computeSheet(capped, content);
      expect(sheet.abilities['str']!.value, 20);
      final monk = suggestedImprovement(sheet, data('barbarian'));
      expect(monk, hasLength(2));
      expect(monk, isNot(contains('str')));
    });
  });
}
