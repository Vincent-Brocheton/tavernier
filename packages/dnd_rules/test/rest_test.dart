// Spec character-sheet : « Repos court », « Repos long », « Suivi des PV et des
// ressources ». SRD, Glossaire, et [P12], [P13].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

const _secondWind = 'srd:resource:second-wind';
const _actionSurge = 'srd:resource:action-surge';

void main() {
  final content = srdContent();
  final aldric = computeSheet(
    CharacterInput.fromJson(fixtureInput('aldric_n5')),
    content,
  );
  final mira = computeSheet(
    CharacterInput.fromJson(fixtureInput('mira_n5')),
    content,
  );
  final warlock = computeSheet(
    CharacterInput.fromJson(fixtureInput('mira_n5')).copyWith(
      classLevels: const [
        ClassLevelInput(classId: 'srd:class:warlock', level: 5),
      ],
      feats: const [],
    ),
    content,
  );

  group('PV', () {
    test('sans valeur : le maximum', () {
      expect(hitPoints(const PlayState(), aldric), 49);
    });

    test('perdre 3 PV', () {
      expect(
        hitPoints(changeHitPoints(const PlayState(), aldric, -3), aldric),
        46,
      );
    });

    test('jamais sous 0', () {
      final state = changeHitPoints(const PlayState(), aldric, -100);
      expect(state.hpCurrent, 0);
    });

    test('revenu au maximum : valeur vide', () {
      final state = changeHitPoints(const PlayState(hpCurrent: 48), aldric, 5);
      expect(state.hpCurrent, isNull);
    });

    test('un repos demande 1 PV', () {
      expect(canRest(const PlayState(hpCurrent: 0), aldric), isFalse);
      expect(canRest(const PlayState(hpCurrent: 1), aldric), isTrue);
    });
  });

  group('dés de vie [P12]', () {
    test('7 + 3 CON = 10 : 31 → 41', () {
      final state = spendHitDie(
        const PlayState(hpCurrent: 31),
        aldric,
        'd10',
        7,
      );
      expect(state.hpCurrent, 41);
      expect(hitDiceLeft(state, aldric.hitDice.single), 4);
    });

    test('minimum 1 PV', () {
      final frail = computeSheet(
        CharacterInput.fromJson(fixtureInput('aldric_n1')).copyWith(
          baseScores: const BaseScores(
            method: ScoreMethod.pointBuy,
            strength: 15,
            dexterity: 13,
            constitution: 8,
            intelligence: 8,
            wisdom: 12,
            charisma: 10,
          ),
          backgroundChoice: const BackgroundChoice(
            distribution: '2-1',
            bonuses: {'str': 2, 'dex': 1},
          ),
        ),
        content,
      );
      final state = spendHitDie(const PlayState(hpCurrent: 2), frail, 'd10', 1);
      expect(state.hpCurrent, 3);
    });

    test('plafonné au maximum', () {
      final state = spendHitDie(
        const PlayState(hpCurrent: 48),
        aldric,
        'd10',
        9,
      );
      expect(hitPoints(state, aldric), 49);
    });
  });

  group('repos court', () {
    test('Second souffle : une utilisation', () {
      final state = finishRest(
        const PlayState(used: {_secondWind: 2}),
        aldric,
        RestKind.short,
      );
      expect(state.usedOf(_secondWind), 1);
    });

    test('Fougue : tout revient', () {
      final state = finishRest(
        const PlayState(used: {_actionSurge: 1}),
        aldric,
        RestKind.short,
      );
      expect(state.usedOf(_actionSurge), 0);
    });

    test('emplacements de pacte rendus', () {
      final state = finishRest(
        const PlayState(used: {pactSlotResource: 2}),
        warlock,
        RestKind.short,
      );
      expect(state.usedOf(pactSlotResource), 0);
    });

    test('emplacements ordinaires gardés', () {
      final state = finishRest(
        PlayState(used: {slotResource(1): 2}),
        mira,
        RestKind.short,
      );
      expect(state.usedOf(slotResource(1)), 2);
    });

    test('dés de vie, PV, Épuisement gardés', () {
      final state = finishRest(
        PlayState(
          used: {hitDieResource('d10'): 2},
          hpCurrent: 30,
          exhaustion: 1,
        ),
        aldric,
        RestKind.short,
      );
      expect(state.usedOf(hitDieResource('d10')), 2);
      expect(state.hpCurrent, 30);
      expect(state.exhaustion, 1);
    });

    test('concentration gardée', () {
      final state = finishRest(
        const PlayState(concentrationSpellId: 'srd:spell:bless'),
        mira,
        RestKind.short,
      );
      expect(state.concentrationSpellId, 'srd:spell:bless');
    });
  });

  group('repos long [P13]', () {
    final tired = PlayState(
      used: {
        hitDieResource('d10'): 3,
        slotResource(1): 2,
        pactSlotResource: 1,
        _secondWind: 3,
      },
      hpCurrent: 41,
      exhaustion: 1,
      concentrationSpellId: 'srd:spell:bless',
    );

    test('41 → 49, dés et ressources rendus, Épuisement 1 → 0', () {
      final state = finishRest(tired, aldric, RestKind.long);
      expect(hitPoints(state, aldric), 49);
      expect(state.usedOf(hitDieResource('d10')), 0);
      expect(state.usedOf(slotResource(1)), 0);
      expect(state.usedOf(pactSlotResource), 0);
      expect(state.usedOf(_secondWind), 0);
      expect(state.exhaustion, 0);
    });

    test('un seul niveau d\'Épuisement retiré', () {
      expect(
        finishRest(
          const PlayState(exhaustion: 2),
          aldric,
          RestKind.long,
        ).exhaustion,
        1,
      );
    });

    test('la concentration prend fin', () {
      expect(
        finishRest(tired, aldric, RestKind.long).concentrationSpellId,
        isNull,
      );
    });

    test('règle par dés de vie : dés rendus, PV gardés', () {
      final state = finishRest(
        tired,
        aldric,
        RestKind.long,
        rule: LongRestRule.hitDice,
      );
      expect(state.hpCurrent, 41);
      expect(state.usedOf(hitDieResource('d10')), 0);
    });

    test('lancer gratuit d\'Initié à la magie rendu', () {
      final state = finishRest(
        PlayState(
          used: {
            freeCastResource('srd:spell:protection-from-evil-and-good'): 1,
          },
        ),
        mira,
        RestKind.long,
      );
      expect(state.used.values.every((v) => v == 0), isTrue);
    });
  });

  test('table des récupérations : Second souffle', () {
    expect(aldric.recharges[_secondWind], [
      (on: 'short_rest', amount: 1),
      (on: 'long_rest', amount: null),
    ]);
  });
}
