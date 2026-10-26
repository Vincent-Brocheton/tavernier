// Spec ui-kit : « Navigation adaptative ».
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';

const _labels = ['Accueil', 'Tables', 'Personnages', 'Compendium', 'Homebrew'];

Widget _app(int selected, ValueChanged<int> onSelected) => MaterialApp(
  theme: AppTheme.dark,
  home: AdaptiveNavigationScaffold(
    selectedIndex: selected,
    onDestinationSelected: onSelected,
    destinations: [
      for (final label in _labels)
        AdaptiveDestination(
          icon: const Icon(Icons.circle_outlined),
          selectedIcon: const Icon(Icons.circle),
          label: label,
        ),
    ],
    body: Text('page $selected'),
  ),
);

Future<void> _setWidth(WidgetTester tester, double width) async {
  tester.view.physicalSize = Size(width, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
}

void main() {
  testWidgets('téléphone : barre de navigation de 80 dp', (tester) async {
    await _setWidth(tester, 390);
    await tester.pumpWidget(_app(0, (_) {}));
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(NavigationRail), findsNothing);
    expect(tester.getSize(find.byType(NavigationBar)).height, 80);
    for (final label in _labels) {
      expect(find.text(label), findsOneWidget);
    }
  });

  for (final width in [960.0, 1440.0]) {
    testWidgets('$width dp : rail de navigation de 80 dp', (tester) async {
      await _setWidth(tester, width);
      await tester.pumpWidget(_app(0, (_) {}));
      expect(find.byType(NavigationRail), findsOneWidget);
      expect(find.byType(NavigationBar), findsNothing);
      expect(tester.getSize(find.byType(NavigationRail)).width, 80);
      for (final label in _labels) {
        expect(find.text(label), findsOneWidget);
      }
    });
  }

  for (final width in [390.0, 960.0]) {
    testWidgets('$width dp : le toucher choisit la destination', (
      tester,
    ) async {
      await _setWidth(tester, width);
      int? chosen;
      await tester.pumpWidget(_app(0, (i) => chosen = i));
      await tester.tap(find.text('Personnages'));
      expect(chosen, 2);
    });
  }

  for (final width in [375.0, 960.0]) {
    testWidgets('$width dp : chaque libellé tient sur une ligne', (
      tester,
    ) async {
      await _setWidth(tester, width);
      await tester.pumpWidget(_app(2, (_) {}));
      for (final label in _labels) {
        expect(
          tester.getSize(find.text(label)).height,
          lessThanOrEqualTo(16),
          reason: label,
        );
      }
    });
  }

  testWidgets('destinations : cibles d’au moins 48 dp', (tester) async {
    await _setWidth(tester, 960);
    await tester.pumpWidget(_app(1, (_) {}));
    await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
    expect(find.text('page 1'), findsOneWidget);
  });
}
