// Spec account : « État de synchronisation affiché » (US-16, ENF-02).
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart' show Override;
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/sync_state.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations_fr.dart';
import 'package:game_table/main.dart';
import 'package:material_ui/material_ui.dart';

import 'fakes.dart';

final _l10n = AppLocalizationsFr();

List<Override> _overrides({
  bool signedIn = true,
  bool online = true,
  ({bool connected, bool connecting})? connection = (
    connected: true,
    connecting: false,
  ),
  int pending = 0,
}) {
  final gateway = FakeGateway(signedIn: signedIn);
  return [
    accountGatewayProvider.overrideWithValue(gateway),
    currentUserProvider.overrideWith((ref) => Stream.value(gateway.user)),
    onlineProvider.overrideWith((ref) => Stream.value(online)),
    powerSyncConnectionProvider.overrideWith((ref) => Stream.value(connection)),
    pendingUploadsCountProvider.overrideWith((ref) => Stream.value(pending)),
  ];
}

Future<({SyncIndicatorState state, int pending})?> _state(
  List<Override> overrides,
) async {
  final container = ProviderContainer(overrides: overrides);
  addTearDown(container.dispose);
  container.listen(syncIndicatorProvider, (_, _) {});
  await pumpEventQueue();
  return container.read(syncIndicatorProvider);
}

void main() {
  test('sans compte : pas d\'indicateur', () async {
    expect(await _state(_overrides(signedIn: false)), isNull);
  });

  test('connecté, rien en attente : synchronisé', () async {
    final sync = await _state(_overrides());
    expect(sync?.state, SyncIndicatorState.synced);
    expect(syncLabel(_l10n, sync!), 'Synchronisé');
  });

  test('connecté, écritures en attente : en attente', () async {
    final sync = await _state(_overrides(pending: 2));
    expect(sync?.state, SyncIndicatorState.pending);
    expect(syncLabel(_l10n, sync!), '2 modifications en attente');
  });

  test('sans réseau, trois modifications : hors ligne', () async {
    final sync = await _state(_overrides(online: false, pending: 3));
    expect(sync?.state, SyncIndicatorState.offline);
    expect(syncLabel(_l10n, sync!), 'Hors-ligne · 3 modifications en attente');
  });

  test('service injoignable : hors ligne', () async {
    final sync = await _state(
      _overrides(connection: (connected: false, connecting: false)),
    );
    expect(sync?.state, SyncIndicatorState.offline);
    expect(syncLabel(_l10n, sync!), 'Hors-ligne');
  });

  test('en connexion : pas encore hors ligne', () async {
    final sync = await _state(
      _overrides(connection: (connected: false, connecting: true)),
    );
    expect(sync?.state, SyncIndicatorState.synced);
  });

  for (final (width, compact) in [(1440.0, false), (390.0, true)]) {
    testWidgets('$width dp : indicateur à côté du compte', (tester) async {
      tester.view.physicalSize = Size(width, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      final database = TavernierDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            ..._overrides(online: false, pending: 3),
            databaseProvider.overrideWithValue(database),
            contentProvider.overrideWith(
              (ref) => ActiveContent([
                readDndpack(
                  File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync(),
                ),
              ]),
            ),
          ],
          child: const GameTableApp(),
        ),
      );
      await tester.pumpAndSettle();
      final indicator = tester.widget<SyncIndicator>(
        find.byType(SyncIndicator),
      );
      expect(indicator.state, SyncIndicatorState.offline);
      expect(indicator.compact, compact);
      expect(
        find.text('Hors-ligne · 3 modifications en attente'),
        compact ? findsNothing : findsOneWidget,
      );
      await tester.pumpWidget(const SizedBox());
      await tester.pump(Duration.zero);
    });
  }
}
