// Spec ui-kit : « Tuiles de valeur et décomposition ».
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

Widget _app(Widget child) => MaterialApp(
  theme: AppTheme.dark,
  home: Scaffold(body: Center(child: child)),
);

Widget _ability({required bool proficient, VoidCallback? onTap}) => SizedBox(
  width: 120,
  height: 140,
  child: AbilityTile(
    label: 'FOR',
    modifier: '+3',
    score: 17,
    save: '+5',
    saveProficient: proficient,
    semanticLabel: 'Force 17, modificateur +3, jet de sauvegarde +5',
    onTap: onTap ?? () {},
  ),
);

const _breakdown = ValueBreakdown(
  category: 'Caractéristique',
  title: 'Force',
  value: '17',
  modifier: '+3',
  lines: [
    BreakdownLine(amount: '15', label: 'Valeur de base', badge: 'Création'),
    BreakdownLine(amount: '+2', label: 'Soldat', badge: 'SRD 5.2.1'),
  ],
  rule: 'Modificateur +3',
  usesLabel: 'Utilisée par',
  uses: [BreakdownUse('Athlétisme', '+5')],
  closeLabel: 'Fermer',
);

void main() {
  group('AbilityTile', () {
    testWidgets('touchable, annoncée, 48 dp au moins', (tester) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await tester.pumpWidget(
        _app(_ability(proficient: true, onTap: () => taps++)),
      );
      await tester.tap(find.byType(AbilityTile));
      expect(taps, 1);
      expect(
        tester.getSize(find.byType(AbilityTile)).height,
        greaterThanOrEqualTo(48),
      );
      expect(
        find.bySemanticsLabel(
          'Force 17, modificateur +3, jet de sauvegarde +5',
        ),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('la maîtrise se lit à une icône', (tester) async {
      await tester.pumpWidget(_app(_ability(proficient: true)));
      expect(find.byIcon(Icons.radio_button_checked), findsOneWidget);
      await tester.pumpWidget(_app(_ability(proficient: false)));
      expect(find.byIcon(Icons.radio_button_unchecked), findsOneWidget);
    });
  });

  testWidgets('StatTile : valeur, libellé, toucher', (tester) async {
    var taps = 0;
    await tester.pumpWidget(
      _app(StatTile(value: '17', label: 'CA', onTap: () => taps++)),
    );
    expect(find.text('17'), findsOneWidget);
    await tester.tap(find.text('CA'));
    expect(taps, 1);
  });

  group('showAdaptiveSheet', () {
    Future<void> open(WidgetTester tester, double width) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        _app(
          Builder(
            builder: (context) => TextButton(
              onPressed: () => showAdaptiveSheet(context, _breakdown),
              child: const Text('Ouvrir'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Ouvrir'));
      await tester.pumpAndSettle();
    }

    testWidgets('téléphone : feuille modale', (tester) async {
      await open(tester, 390);
      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('grand écran : dialogue, Fermer le quitte', (tester) async {
      await open(tester, 1440);
      expect(find.byType(Dialog), findsOneWidget);
      expect(find.text('Athlétisme +5'), findsOneWidget);
      await tester.tap(find.text('Fermer'));
      await tester.pumpAndSettle();
      expect(find.byType(Dialog), findsNothing);
    });
  });
}
