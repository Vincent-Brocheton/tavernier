// Critère de sortie de M3 (cahier §3) : une rencontre de 30 combattants
// menée sur téléphone, hors-ligne, avec la vraie base de la plateforme.
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/database.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:integration_test/integration_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import 'support/m3_flow.dart';

void main() {
  final binding = IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('M3 : 30 combattants sur téléphone, hors ligne', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = openTavernierDatabase(name: 'tavernier-m3');
    final ids = await seedM3(db);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          onlineProvider.overrideWith((ref) => Stream.value(false)),
          currentUserProvider.overrideWith(
            (ref) => Stream.value(
              const User(
                id: m3Gm,
                appMetadata: {},
                userMetadata: {},
                aud: 'authenticated',
                createdAt: '2026-11-20T10:00:00Z',
              ),
            ),
          ),
        ],
        child: MaterialApp.router(
          routerConfig: m3Router(ids.table),
          theme: AppTheme.dark,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    final watch = Stopwatch()..start();
    try {
      await playM3(tester);
      binding.reportData = {
        'm3': {'duree_ms': watch.elapsedMilliseconds},
      };
    } catch (error) {
      // flutter drive n'affiche pas le message : le rapport le garde.
      binding.reportData = {
        'm3': {
          'derniere_action': m3LastAction,
          'erreur': '$error',
          'textes': [
            for (final w in tester.widgetList<Text>(find.byType(Text))) ?w.data,
          ],
        },
      };
      rethrow;
    }
  });
}
