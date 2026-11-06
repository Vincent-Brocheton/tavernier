// Spec ui-kit : « Composants des caractéristiques ».
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.dark,
  home: Scaffold(body: Center(child: child)),
);

void main() {
  group('PointBuyTile', () {
    testWidgets('valeur, détail, boutons actifs', (tester) async {
      var raised = 0;
      var lowered = 0;
      await tester.pumpWidget(
        _app(
          PointBuyTile(
            label: 'Force',
            detail: 'coût 9',
            value: 15,
            raiseLabel: 'Augmenter Force',
            lowerLabel: 'Diminuer Force',
            onRaise: () => raised++,
            onLower: () => lowered++,
          ),
        ),
      );
      expect(find.text('15'), findsOneWidget);
      expect(find.text('coût 9'), findsOneWidget);
      await tester.tap(find.byTooltip('Augmenter Force'));
      await tester.tap(find.byTooltip('Diminuer Force'));
      expect((raised, lowered), (1, 1));
    });

    testWidgets('bouton sans action : désactivé, 48 dp', (tester) async {
      await tester.pumpWidget(
        _app(
          const PointBuyTile(
            label: 'Force',
            detail: 'coût 0',
            value: 8,
            raiseLabel: 'Augmenter Force',
            lowerLabel: 'Diminuer Force',
          ),
        ),
      );
      final button = find.byType(IconButton).first;
      expect(tester.widget<IconButton>(button).onPressed, isNull);
      expect(tester.getSize(button).height, greaterThanOrEqualTo(48));
    });
  });

  group('BonusToggle', () {
    Future<int> pump(
      WidgetTester tester,
      BonusToggleState state,
      String label,
    ) async {
      var taps = 0;
      await tester.pumpWidget(
        _app(
          BonusToggle(
            label: label,
            semanticLabel: 'Bonus sur Force',
            state: state,
            onTap: () => taps++,
          ),
        ),
      );
      await tester.tap(find.byType(BonusToggle), warnIfMissed: false);
      return taps;
    }

    testWidgets('disponible : touchable, 48 dp', (tester) async {
      expect(await pump(tester, BonusToggleState.available, '+2'), 1);
      expect(tester.getSize(find.byType(BonusToggle)).height, 48);
    });

    testWidgets('sélectionnée : état annoncé', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, BonusToggleState.selected, '+2');
      expect(
        tester.getSemantics(find.byType(InkWell)),
        isSemantics(isSelected: true, isButton: true),
      );
      handle.dispose();
    });

    testWidgets('disponible : activable au lecteur d’écran', (tester) async {
      final handle = tester.ensureSemantics();
      await pump(tester, BonusToggleState.available, '+2');
      expect(
        tester.getSemantics(find.byType(InkWell)),
        isSemantics(isButton: true, hasTapAction: true),
      );
      handle.dispose();
    });

    testWidgets('bloquée : ne réagit pas', (tester) async {
      expect(await pump(tester, BonusToggleState.blocked, '—'), 0);
    });

    testWidgets('invalide : barrée, reste touchable', (tester) async {
      expect(await pump(tester, BonusToggleState.invalid, '+2'), 1);
      expect(
        tester.widget<Text>(find.text('+2')).style?.decoration,
        TextDecoration.lineThrough,
      );
    });
  });

  testWidgets('StatusBanner : icône, titre, message, annonce', (tester) async {
    await tester.pumpWidget(
      _app(const StatusBanner(title: 'Bonus à refaire', message: 'Le +2…')),
    );
    expect(find.byIcon(Icons.error_outline), findsOneWidget);
    expect(find.text('Bonus à refaire'), findsOneWidget);
    expect(find.text('Le +2…'), findsOneWidget);
    expect(
      tester
          .widget<Semantics>(
            find
                .descendant(
                  of: find.byType(StatusBanner),
                  matching: find.byType(Semantics),
                )
                .first,
          )
          .properties
          .liveRegion,
      isTrue,
    );
  });
}
