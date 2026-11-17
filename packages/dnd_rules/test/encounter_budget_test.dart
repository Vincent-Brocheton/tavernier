// Spec encounters : « Budget de PX d'une rencontre », « Difficulté d'une
// rencontre » (US-19, EF-REN-03). Seuils relus dans la table « Budget de PX
// par personnage » du SRD 5.2.1 ; rencontres de [D1].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

void main() {
  test('table du SRD : niveaux 1, 5, 13 et 20', () {
    expect(xpBudgetByLevel, hasLength(20));
    expect(xpBudgetByLevel[0], const EncounterBudget(50, 75, 100));
    expect(xpBudgetByLevel[4], const EncounterBudget(500, 750, 1100));
    expect(xpBudgetByLevel[12], const EncounterBudget(2600, 4200, 5400));
    expect(xpBudgetByLevel[19], const EncounterBudget(6400, 13200, 22000));
  });

  test('[D1] : quatre PJ de niveau 5, budget 2 000 / 3 000 / 4 400', () {
    expect(
      encounterBudget(const [5, 5, 5, 5]),
      const EncounterBudget(2000, 3000, 4400),
    );
  });

  test('niveaux mêlés : chaque PJ selon son niveau', () {
    expect(
      encounterBudget(const [5, 5, 5, 3]),
      const EncounterBudget(1650, 2475, 3700),
    );
    expect(encounterBudget(const []), const EncounterBudget(0, 0, 0));
  });

  test('niveau hors de 1 à 20 : refusé', () {
    expect(() => encounterBudget(const [0]), throwsArgumentError);
    expect(() => encounterBudget(const [21]), throwsArgumentError);
  });

  test('[D1] : le relais du Sel modéré, l\'embuscade sous le budget', () {
    final budget = encounterBudget(const [5, 5, 5, 5]);
    expect(encounterDifficulty(3000, budget), EncounterDifficulty.moderate);
    expect(encounterDifficulty(300, budget), EncounterDifficulty.belowLow);
    expect(encounterDifficulty(800, budget), EncounterDifficulty.belowLow);
    expect(encounterDifficulty(5000, budget), EncounterDifficulty.high);
  });

  test('[D1] : au niveau 1, 300 PX modérée, 200 PX faible', () {
    final budget = encounterBudget(const [1, 1, 1, 1]);
    expect(budget, const EncounterBudget(200, 300, 400));
    expect(encounterDifficulty(300, budget), EncounterDifficulty.moderate);
    expect(encounterDifficulty(200, budget), EncounterDifficulty.low);
    expect(encounterDifficulty(400, budget), EncounterDifficulty.high);
  });
}
