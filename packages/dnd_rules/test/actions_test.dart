// Spec encounters : « Compétence suggérée pour l'Étude », « Paliers révélés
// par l'Étude » (US-24, EF-ACT-01, 05). SRD 5.2.1, « Domaines de savoir » ;
// valeurs de [D1] et [C9].
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final content = srdContent();

  test('[C9] : Histoire pour Varga, Humanoïde', () {
    expect(
      '${suggestedStudySkill(content, CreatureType.humanoid)}',
      'srd:skill:history',
    );
    expect(
      '${suggestedStudySkill(content, CreatureType.ooze)}',
      'srd:skill:nature',
    );
    expect(suggestedStudySkill(content, null), isNull);
  });

  test('un pack homebrew remplace la table du SRD', () {
    final homebrew = parseEntity({
      'id': 'maison:rule:study',
      'type': 'rule',
      'name': 'Étude',
      'text': {'fr': 'Texte.'},
      'data': {
        'study_skills': {'humanoid': 'srd:skill:investigation'},
      },
    }, 'maison').entity!;
    final custom = srdContent([homebrew]);
    expect(
      '${suggestedStudySkill(custom, CreatureType.humanoid)}',
      'srd:skill:investigation',
    );
    expect(suggestedStudySkill(custom, CreatureType.ooze), isNull);
  });

  test('cinq façons d\'interagir, Amadouer pour une Bête', () {
    final checks = influenceChecks(content);
    expect(
      [for (final c in checks) c.id],
      ['intimidate', 'persuade', 'perform', 'deceive', 'handle'],
    );
    expect(checks.last.creatureTypes, contains(CreatureType.beast));
  });

  test('[D1] : Thalia, 16 contre DD 10, 15 et 20 de Varga', () {
    expect(reachedTiers([10, 15, 20], 16), [0, 1]);
    expect(reachedTiers([20, 10], 9), isEmpty);
    expect(reachedTiers([15], 15), [0]);
  });

  test('les assistants n\'agissent pas sur l\'état du combat', () {
    final state = projectCombat([
      for (final (i, type) in [
        CombatEventType.study,
        CombatEventType.influence,
        CombatEventType.observation,
      ].indexed)
        CombatEvent(id: 'e$i', type: type, payload: const {'actor': 'thalia'}),
    ]);
    expect(state.combatants, isEmpty);
    expect(CombatEventType.parse('study'), CombatEventType.study);
  });
}
