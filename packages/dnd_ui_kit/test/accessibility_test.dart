// Spec ui-kit : « Accessibilité du texte et du mouvement » (ENF-14).
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Future<double> _scaleFor(WidgetTester tester, double requested) async {
  late double applied;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(textScaler: TextScaler.linear(requested)),
      child: AppTextScale.clamp(
        child: Builder(
          builder: (context) {
            applied = MediaQuery.textScalerOf(context).scale(10) / 10;
            return const SizedBox();
          },
        ),
      ),
    ),
  );
  return applied;
}

Future<(Duration, Duration)> _motion(WidgetTester tester, bool reduced) async {
  late (Duration, Duration) durations;
  await tester.pumpWidget(
    MediaQuery(
      data: MediaQueryData(disableAnimations: reduced),
      child: Builder(
        builder: (context) {
          durations = (
            AppMotion.standard(context),
            AppMotion.emphasized(context),
          );
          return const SizedBox();
        },
      ),
    ),
  );
  return durations;
}

void main() {
  testWidgets('taille de texte bornée de 85 à 200 %', (tester) async {
    expect(await _scaleFor(tester, 3), 2);
    expect(await _scaleFor(tester, 0.5), 0.85);
    expect(await _scaleFor(tester, 1.3), 1.3);
  });

  testWidgets('durées des tokens, nulles si animations réduites', (
    tester,
  ) async {
    expect(await _motion(tester, false), (
      const Duration(milliseconds: 300),
      const Duration(milliseconds: 500),
    ));
    expect(await _motion(tester, true), (Duration.zero, Duration.zero));
  });

  test('courbe des tokens', () {
    expect(AppMotion.curve.transform(0), 0);
    expect(AppMotion.curve.transform(1), 1);
    final c = AppMotion.curve;
    expect((c.a, c.b, c.c, c.d), (0.2, 0.0, 0.0, 1.0));
  });
}
