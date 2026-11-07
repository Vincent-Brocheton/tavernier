// Spec character-sheet : « Jet simple ». EF-DES-01 à 03, SRD, Glossaire
// (Avantage et Désavantage).
import 'dart:math';

import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

/// Hasard qui rend les valeurs voulues, de 1 à [sides].
final class _Fixed implements Random {
  _Fixed(this.values);

  final List<int> values;
  var _next = 0;

  @override
  int nextInt(int max) => values[_next++] - 1;

  @override
  bool nextBool() => throw UnimplementedError();

  @override
  double nextDouble() => throw UnimplementedError();
}

void main() {
  group('formule', () {
    test('2d4+2', () {
      final f = DiceFormula.parse('2d4+2');
      expect((f.count, f.sides, f.bonus), (2, 4, 2));
      expect(f.dice, '2d4');
    });

    test('d20 : un dé', () {
      final f = DiceFormula.parse('d20');
      expect((f.count, f.sides, f.bonus), (1, 20, 0));
      expect(f.dice, 'd20');
    });

    test('bonus négatif', () {
      expect(DiceFormula.parse('1d10-1').bonus, -1);
    });

    test('formule invalide', () {
      expect(() => DiceFormula.parse('deux dés'), throwsFormatException);
    });

    test('résultats possibles des dés', () {
      const f = DiceFormula(2, 4, bonus: 2);
      expect(f.validDice(1), isFalse);
      expect(f.validDice(2), isTrue);
      expect(f.validDice(8), isTrue);
      expect(f.validDice(9), isFalse);
    });
  });

  group('lancer', () {
    test('1d10 + 3 : 7 donne 10', () {
      final roll = rollDice(const DiceFormula(1, 10, bonus: 3), _Fixed([7]));
      expect(roll.dice, [7]);
      expect(roll.total, 10);
      expect(roll.dropped, isNull);
    });

    test('2d4 + 2 : 3 et 2 donnent 7', () {
      final roll = rollDice(const DiceFormula(2, 4, bonus: 2), _Fixed([3, 2]));
      expect(roll.dice, [3, 2]);
      expect(roll.total, 7);
    });

    test('Avantage : 15 gardé, 4 écarté', () {
      final roll = rollDice(
        const DiceFormula(1, 20, mode: RollMode.advantage),
        _Fixed([4, 15]),
      );
      expect(roll.dice, [15]);
      expect(roll.dropped, 4);
    });

    test('Désavantage : 4 gardé, 15 écarté', () {
      final roll = rollDice(
        const DiceFormula(1, 20, mode: RollMode.disadvantage),
        _Fixed([4, 15]),
      );
      expect(roll.dice, [4]);
      expect(roll.dropped, 15);
    });

    test('vrai hasard : toujours dans les bornes', () {
      const f = DiceFormula(2, 6);
      final random = Random(1);
      for (var i = 0; i < 200; i++) {
        expect(f.validDice(rollDice(f, random).diceTotal), isTrue);
      }
    });
  });
}
