// Spec character-creation : règles de l'acquisition par points (SRD p. 22) et
// des langues de départ (SRD p. 20), partagées par le moteur et l'interface.
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

void main() {
  test('coût des valeurs (SRD p. 22)', () {
    expect(pointBuyCosts, {
      8: 0,
      9: 1,
      10: 2,
      11: 3,
      12: 4,
      13: 5,
      14: 7,
      15: 9,
    });
    expect(pointBuyBudget, 27);
  });

  test('points dépensés : [D1] Aldric, 15 13 14 8 12 10', () {
    expect(
      pointBuySpent(const {
        'str': 15,
        'dex': 13,
        'con': 14,
        'int': 8,
        'wis': 12,
        'cha': 10,
      }),
      27,
    );
  });

  test('modificateur, valeurs impaires et sous 10 comprises', () {
    expect(abilityModifier(10), 0);
    expect(abilityModifier(11), 0);
    expect(abilityModifier(17), 3);
    expect(abilityModifier(8), -1);
    expect(abilityModifier(9), -1);
  });

  test('langues de départ (SRD p. 20) : le Commun et deux au choix', () {
    expect(startingLanguageId, 'srd:language:common');
    expect(startingLanguageChoices, 2);
  });
}
