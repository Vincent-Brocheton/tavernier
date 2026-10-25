import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/main.dart';

void main() {
  testWidgets("l'accueil affiche le nom et le sous-titre", (tester) async {
    await tester.pumpWidget(const GameTableApp());
    await tester.pumpAndSettle();

    expect(find.text('Tavernier'), findsOneWidget);
    expect(find.text('Gestion de personnage compatible 5e'), findsOneWidget);
  });
}
