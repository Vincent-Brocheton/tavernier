import 'dart:math';

/// Avantage ou Désavantage sur un d20 (SRD, Glossaire).
enum RollMode { normal, advantage, disadvantage }

/// Formule d'un jet : `count`d`sides` + `bonus`.
final class DiceFormula {
  const DiceFormula(
    this.count,
    this.sides, {
    this.bonus = 0,
    this.mode = RollMode.normal,
  });

  /// `2d4+2`, `d20`, `1d10-1`.
  factory DiceFormula.parse(String text, {RollMode mode = RollMode.normal}) {
    final match = RegExp(r'^(\d*)d(\d+)\s*([+-]\s*\d+)?$')
        .firstMatch(text.replaceAll(' ', ''));
    if (match == null) throw FormatException('formule de dés : $text');
    return DiceFormula(
      int.parse(match.group(1)!.isEmpty ? '1' : match.group(1)!),
      int.parse(match.group(2)!),
      bonus: int.parse(match.group(3) ?? '0'),
      mode: mode,
    );
  }

  final int count;
  final int sides;
  final int bonus;
  final RollMode mode;

  /// Les dés peuvent-ils donner [value] ?
  bool validDice(int value) => value >= count && value <= count * sides;

  /// Notation des dés seuls : `d20`, `2d4`.
  String get dice => count == 1 ? 'd$sides' : '${count}d$sides';
}

/// Un jet de l'application.
final class DiceRoll {
  const DiceRoll(this.formula, this.dice, {this.dropped});

  final DiceFormula formula;

  /// Dés gardés.
  final List<int> dice;

  /// d20 écarté par l'Avantage ou le Désavantage.
  final int? dropped;

  int get diceTotal => dice.fold(0, (sum, die) => sum + die);
  int get total => diceTotal + formula.bonus;
}

/// Lance [formula] avec [random].
DiceRoll rollDice(DiceFormula formula, Random random) {
  int die() => random.nextInt(formula.sides) + 1;
  if (formula.mode != RollMode.normal) {
    final first = die();
    final second = die();
    final high = max(first, second);
    final low = min(first, second);
    final advantage = formula.mode == RollMode.advantage;
    return DiceRoll(formula, [
      if (advantage) high else low,
    ], dropped: advantage ? low : high);
  }
  return DiceRoll(formula, [for (var i = 0; i < formula.count; i++) die()]);
}
