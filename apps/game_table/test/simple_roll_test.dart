// Spec character-sheet : « Jet simple ».
import 'dart:math';

import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/sheet/simple_roll.dart';
import 'package:material_ui/material_ui.dart';

/// Hasard qui rend les valeurs voulues.
final class _Fixed implements Random {
  _Fixed(this.values);

  final List<int> values;
  var _next = 0;

  @override
  int nextInt(int max) => values[_next++ % values.length] - 1;

  @override
  bool nextBool() => throw UnimplementedError();

  @override
  double nextDouble() => throw UnimplementedError();
}

int? _value = -1;

Future<void> _open(
  WidgetTester tester,
  DiceFormula formula, {
  List<int> rolls = const [7],
  String? bonusLabel,
}) async {
  _value = -1;
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.dark,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(
        body: SimpleRoll(
          formula: formula,
          bonusLabel: bonusLabel,
          random: _Fixed(rolls),
          onChanged: (value) => _value = value,
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

Finder _rich(String text) => find.text(text, findRichText: true);

void main() {
  testWidgets('deux chemins côte à côte', (tester) async {
    await _open(tester, const DiceFormula(1, 10, bonus: 3));
    expect(find.text('Saisir mon jet'), findsOneWidget);
    expect(find.text('Lancer'), findsOneWidget);
  });

  testWidgets('lancer : détail et résultat', (tester) async {
    await _open(tester, const DiceFormula(1, 10, bonus: 3), bonusLabel: 'CON');
    await tester.tap(find.text('Lancer'));
    await tester.pumpAndSettle();
    expect(_rich('d10 7 + 3 CON = 10'), findsOneWidget);
    expect(_value, 7);
    expect(find.text('Relancer'), findsOneWidget);
  });

  testWidgets('plusieurs dés : chacun affiché', (tester) async {
    await _open(tester, const DiceFormula(2, 4, bonus: 2), rolls: [3, 2]);
    await tester.tap(find.text('Lancer'));
    await tester.pumpAndSettle();
    expect(_rich('2d4 (3, 2) + 2 = 7'), findsOneWidget);
  });

  testWidgets('Avantage : dé écarté barré', (tester) async {
    await _open(
      tester,
      const DiceFormula(1, 20, mode: RollMode.advantage),
      rolls: [4, 15],
    );
    await tester.tap(find.text('Lancer'));
    await tester.pumpAndSettle();
    expect(_rich('d20 15 (4) = 15'), findsOneWidget);
  });

  testWidgets('saisie : résultat des dés physiques', (tester) async {
    await _open(tester, const DiceFormula(1, 10, bonus: 3));
    await tester.tap(find.text('Saisir mon jet'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '9');
    await tester.pumpAndSettle();
    expect(_value, 9);
    expect(_rich('d10 9 + 3 = 12'), findsOneWidget);
  });

  testWidgets('jet impossible : refusé', (tester) async {
    await _open(tester, const DiceFormula(1, 10));
    await tester.enterText(find.byType(TextField), '11');
    await tester.pumpAndSettle();
    expect(_value, isNull);
    expect(find.text('Résultat impossible pour d10.'), findsOneWidget);
  });

  testWidgets('modifiable après un lancer', (tester) async {
    await _open(tester, const DiceFormula(1, 10));
    await tester.tap(find.text('Lancer'));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '2');
    await tester.pumpAndSettle();
    expect(_value, 2);
    expect(_rich('d10 2 = 2'), findsOneWidget);
  });
}
