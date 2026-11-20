// Critère de sortie de M3 (cahier §3), sur une base en mémoire : une
// rencontre de 30 combattants menée sur téléphone, hors-ligne. Le même
// parcours tourne en intégration sur chaque plateforme.
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import '../integration_test/support/m3_flow.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

void main() {
  testWidgets('M3 : 30 combattants sur téléphone, hors ligne', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final db = TavernierDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    final ids = (await tester.runAsync(() => seedM3(db)))!;
    final router = m3Router(ids.table);
    addTearDown(router.dispose);
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          databaseProvider.overrideWithValue(db),
          contentProvider.overrideWith((ref) => _content),
          // Hors ligne : ni réseau, ni service de synchronisation.
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
          routerConfig: router,
          theme: AppTheme.dark,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            ...GlobalMaterialLocalizations.delegates,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
    try {
      await playM3(tester);
    } catch (_) {
      // ignore: avoid_print
      print('M3 : arrêt à « $m3LastAction »');
      // ignore: avoid_print
      print(
        [for (final w in tester.widgetList<Text>(find.byType(Text))) w.data]
            .join(' | '),
      );
      rethrow;
    }

    // La rencontre est terminée, ses PX vont aux 4 PJ, la séance est close.
    final encounter = (await tester.runAsync(
      () => EncounterStore(db).watchList(ids.table).first,
    ))!.single;
    expect(encounter.status, EncounterStatus.finished);
    final session = (await tester.runAsync(
      () => SessionStore(db).watchList(ids.table).first,
    ))!.single;
    expect(session.status, SessionStatus.closed);
    final events = (await tester.runAsync(
      () => CombatStore(db).watchEvents(ids.encounter).first,
    ))!;
    final state = projectCombat(events);
    expect(state.combatants, hasLength(30));
    final bandit = state.combatants.firstWhere((c) => c.label == 'Bandit 1');
    expect(bandit.hp, bandit.hpMax! - 5);
    final veteran = state.combatants.firstWhere((c) => c.label == 'Vétéran');
    expect(
      veteran.conditions.map((i) => i.condition),
      contains('srd:condition:prone'),
    );
    final xp = (await tester.runAsync(
      () => CharacterStore(db).watchSessionGains(ids.session).first,
    ))!;
    expect(xp, hasLength(4));
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 1));
  });
}
