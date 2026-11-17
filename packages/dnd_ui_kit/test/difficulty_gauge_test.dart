// Spec ui-kit : « Jauge de difficulté » (COMPOSANTS §2.12, [C1]).
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const _marks = <GaugeMark>[
  (label: 'Faible', value: '2 000', xp: 2000),
  (label: 'Modérée', value: '3 000', xp: 3000),
  (label: 'Élevée', value: '4 400', xp: 4400),
];

Widget _gauge(GaugeLevel level, int xp) => MaterialApp(
  theme: AppTheme.dark,
  home: Scaffold(
    body: DifficultyGauge(
      title: 'Difficulté',
      levelLabel: 'Modérée',
      level: level,
      xp: xp,
      xpLabel: '$xp PX',
      caption: '4 PJ de niveau 5',
      marks: _marks,
    ),
  ),
);

void main() {
  testWidgets('[C1] : libellé, repères, total, légende', (tester) async {
    tester.view.physicalSize = const Size(1440, 300);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(_gauge(GaugeLevel.moderate, 3000));
    for (final shown in [
      'Difficulté',
      'Modérée',
      'Faible',
      '2 000',
      'Élevée',
      '4 400',
      '3000 PX',
      '4 PJ de niveau 5',
    ]) {
      expect(find.text(shown), findsWidgets, reason: shown);
    }
    expect(
      find.bySemanticsLabel('Difficulté : Modérée, 3000 PX, 4 PJ de niveau 5'),
      findsOneWidget,
    );
  });

  for (final (level, icon) in [
    (GaugeLevel.belowLow, Icons.remove_circle_outline),
    (GaugeLevel.low, Icons.check_circle_outline),
    (GaugeLevel.moderate, Icons.warning_amber),
    (GaugeLevel.high, Icons.dangerous_outlined),
  ]) {
    testWidgets('${level.name} : icône et couleur de la barre', (tester) async {
      await tester.pumpWidget(_gauge(level, 1000));
      final context = tester.element(find.byType(DifficultyGauge));
      final colors = GameColors.of(context);
      final expected = switch (level) {
        GaugeLevel.belowLow => Theme.of(context).colorScheme.outline,
        GaugeLevel.low => colors.heal,
        GaugeLevel.moderate => colors.alert,
        GaugeLevel.high => colors.damage,
      };
      expect(tester.widget<Icon>(find.byIcon(icon)).color, expected);
      expect(
        tester
            .widget<LinearProgressIndicator>(
              find.byType(LinearProgressIndicator),
            )
            .color,
        expected,
      );
    });
  }

  testWidgets('remplissage : proportion des PX, bornée', (tester) async {
    await tester.pumpWidget(_gauge(GaugeLevel.high, 99999));
    expect(
      tester
          .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
          .value,
      1.0,
    );
  });
}
