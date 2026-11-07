// Critère de sortie de M1 (cahier §3) : un PJ complet créé puis monté au
// niveau 5, avec la vraie base de la plateforme et sans réseau.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/main.dart';
import 'package:integration_test/integration_test.dart';

import 'support/m1_flow.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('M1 : création puis niveau 5, hors ligne', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: GameTableApp()));
    await createAndReachLevel5(tester);
  });
}
