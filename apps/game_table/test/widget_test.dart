import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/main.dart';
import 'package:material_ui/material_ui.dart';

const _destinations = [
  'Accueil',
  'Tables',
  'Personnages',
  'Compendium',
  'Homebrew',
];

void main() {
  testWidgets("l'accueil affiche le nom et le sous-titre", (tester) async {
    await tester.pumpWidget(const GameTableApp());
    await tester.pumpAndSettle();

    expect(find.text('Tavernier'), findsOneWidget);
    expect(find.text('Gestion de personnage compatible 5e'), findsOneWidget);
  });

  testWidgets('thème sombre du kit', (tester) async {
    await tester.pumpWidget(const GameTableApp());
    final app = tester.widget<MaterialApp>(find.byType(MaterialApp));
    expect(app.themeMode, ThemeMode.dark);
    expect(app.darkTheme, AppTheme.dark);
  });

  for (final width in [390.0, 1440.0]) {
    testWidgets('$width dp : cinq destinations, changement de page', (
      tester,
    ) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(const GameTableApp());
      await tester.pumpAndSettle();
      for (final label in _destinations) {
        expect(find.text(label), findsWidgets);
      }
      await tester.tap(find.text('Personnages').last);
      await tester.pumpAndSettle();
      expect(
        find.descendant(
          of: find.byType(AdaptiveNavigationScaffold),
          matching: find.text('Personnages'),
        ),
        findsNWidgets(2),
        reason: 'libellé de navigation et titre de la page',
      );
    });
  }
}
