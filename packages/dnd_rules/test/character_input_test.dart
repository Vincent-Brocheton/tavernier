import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  test("l'entrée d'Aldric niveau 1 se lit", () {
    final aldric = CharacterInput.fromJson(fixtureInput('aldric_n1'));
    expect(aldric.speciesId, 'srd:species:human');
    expect(aldric.baseScores.method, ScoreMethod.pointBuy);
    expect(aldric.baseScores.of('str'), 15);
    expect(aldric.backgroundChoice.bonuses, {'str': 2, 'con': 1});
    expect(aldric.classLevels.single.level, 1);
    expect(aldric.feats.map((f) => f.featId), contains('srd:feat:alert'));
    expect(aldric.choices, {
      'skillful': ['srd:skill:insight'],
    });
    expect(aldric.items.first.equipped, isTrue);
  });

  test('un champ inconnu est refusé', () {
    final json = {...fixtureInput('aldric_n1'), 'alignment': 'LB'};
    expect(() => CharacterInput.fromJson(json), throwsA(anything));
  });
}
