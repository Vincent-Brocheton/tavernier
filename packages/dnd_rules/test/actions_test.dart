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

  group('Influence', () {
    test('DD : 15, ou l\'Intelligence de la cible si elle est plus élevée', () {
      // [C10] : Varga, INT 14.
      expect(influenceDc(14), 15);
      expect(influenceDc(18), 18);
      expect(influenceDc(null), 15);
    });

    test('Avantage si Amicale, Désavantage si Hostile (SRD)', () {
      expect(influenceMode('friendly'), RollMode.advantage);
      expect(influenceMode('indifferent'), RollMode.normal);
      expect(influenceMode('hostile'), RollMode.disadvantage);
    });

    test('Amadouer seulement pour une Bête ou une Monstruosité', () {
      List<String> ids(CreatureType? type) => [
        for (final c in influenceChecksFor(content, type)) c.id,
      ];
      expect(ids(CreatureType.humanoid), [
        'intimidate',
        'persuade',
        'perform',
        'deceive',
      ]);
      expect(ids(CreatureType.beast), contains('handle'));
      expect(ids(null), isNot(contains('handle')));
    });

    group('échec mémorisé (SRD : attendre 24 heures)', () {
      final at = DateTime.utc(2026, 11, 19, 20);
      InfluenceAttempt attempt({
        String actor = 'aldric',
        String approach = 'persuade',
        bool success = false,
        int hours = 24,
      }) => (
        at: at,
        actor: actor,
        target: 'varga',
        approach: approach,
        success: success,
        retryHours: hours,
      );

      DateTime? blocked(List<InfluenceAttempt> attempts, DateTime now) =>
          influenceBlockedUntil(
            attempts,
            actor: 'aldric',
            target: 'varga',
            approach: 'persuade',
            now: now,
          );

      test('[C10] : échec d\'Aldric il y a 2 h', () {
        expect(
          blocked([attempt()], at.add(const Duration(hours: 2))),
          at.add(const Duration(hours: 24)),
        );
        expect(blocked([attempt()], at.add(const Duration(hours: 25))), isNull);
      });

      test('autre personnage, autre approche ou réussite : rien', () {
        final later = at.add(const Duration(hours: 1));
        expect(blocked([attempt(actor: 'thalia')], later), isNull);
        expect(blocked([attempt(approach: 'intimidate')], later), isNull);
        expect(blocked([attempt(success: true)], later), isNull);
      });

      test('délai modifié par le MJ', () {
        expect(
          blocked([attempt(hours: 1)], at.add(const Duration(hours: 2))),
          isNull,
        );
      });
    });

    test('l\'attitude d\'une cible suit sa dernière Influence', () {
      final state = projectCombat([
        const CombatEvent(
          id: 'e0',
          type: CombatEventType.combatantAdded,
          payload: {'id': 'loup', 'kind': 'monster', 'label': 'Loup'},
        ),
        const CombatEvent(
          id: 'e1',
          type: CombatEventType.influence,
          payload: {
            'actor': 'aldric',
            'target': 'loup',
            'attitude': 'friendly',
          },
        ),
      ]);
      expect(state.combatant('loup')!.attitude, 'friendly');
      expect(
        projectCombat([
          const CombatEvent(
            id: 'e0',
            type: CombatEventType.combatantAdded,
            payload: {'id': 'loup', 'kind': 'monster', 'label': 'Loup'},
          ),
        ]).combatant('loup')!.attitude,
        'indifferent',
      );
    });
  });
}
