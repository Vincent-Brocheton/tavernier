/// Seuils de difficulté d'une rencontre, en PX.
final class EncounterBudget {
  const EncounterBudget(this.low, this.moderate, this.high);

  final int low;
  final int moderate;
  final int high;

  EncounterBudget operator +(EncounterBudget other) => EncounterBudget(
    low + other.low,
    moderate + other.moderate,
    high + other.high,
  );

  @override
  bool operator ==(Object other) =>
      other is EncounterBudget &&
      other.low == low &&
      other.moderate == moderate &&
      other.high == high;

  @override
  int get hashCode => Object.hash(low, moderate, high);

  @override
  String toString() => 'EncounterBudget($low, $moderate, $high)';
}

/// Table « Budget de PX par personnage » du SRD 5.2.1 : seuils Faible,
/// Modérée et Élevée d'un personnage, du niveau 1 au niveau 20.
const xpBudgetByLevel = [
  EncounterBudget(50, 75, 100),
  EncounterBudget(100, 150, 200),
  EncounterBudget(150, 225, 400),
  EncounterBudget(250, 375, 500),
  EncounterBudget(500, 750, 1100),
  EncounterBudget(600, 1000, 1400),
  EncounterBudget(750, 1300, 1700),
  EncounterBudget(1000, 1700, 2100),
  EncounterBudget(1300, 2000, 2600),
  EncounterBudget(1600, 2300, 3100),
  EncounterBudget(1900, 2900, 4100),
  EncounterBudget(2200, 3700, 4700),
  EncounterBudget(2600, 4200, 5400),
  EncounterBudget(2900, 4900, 6200),
  EncounterBudget(3300, 5400, 7800),
  EncounterBudget(3800, 6100, 9800),
  EncounterBudget(4500, 7200, 11700),
  EncounterBudget(5000, 8700, 14200),
  EncounterBudget(5500, 10700, 17200),
  EncounterBudget(6400, 13200, 22000),
];

/// Budget d'une rencontre (EF-REN-03) : les seuils de chaque personnage
/// présent, selon son niveau, additionnés.
EncounterBudget encounterBudget(Iterable<int> levels) {
  var total = const EncounterBudget(0, 0, 0);
  for (final level in levels) {
    if (level < 1 || level > 20) {
      throw ArgumentError.value(level, 'level', 'de 1 à 20');
    }
    total += xpBudgetByLevel[level - 1];
  }
  return total;
}

/// Difficulté d'une rencontre : le plus haut seuil atteint.
enum EncounterDifficulty { belowLow, low, moderate, high }

/// Difficulté d'une rencontre de [xp] PX d'adversaires face à [budget].
EncounterDifficulty encounterDifficulty(int xp, EncounterBudget budget) =>
    xp >= budget.high && budget.high > 0
    ? EncounterDifficulty.high
    : xp >= budget.moderate && budget.moderate > 0
    ? EncounterDifficulty.moderate
    : xp >= budget.low && budget.low > 0
    ? EncounterDifficulty.low
    : EncounterDifficulty.belowLow;
