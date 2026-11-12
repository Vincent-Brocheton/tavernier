// Spec tables : « Rejoindre une table » (US-14, EF-TAB-08).
import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/settings/device_settings.dart';
import 'package:game_table/tables/pending_join.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../account/fakes.dart';

void main() {
  late FakeGateway gateway;
  late StreamController<bool> online;
  late SharedPreferences prefs;

  Future<ProviderContainer> start({
    bool signedIn = true,
    bool isOnline = true,
  }) async {
    final container = ProviderContainer(
      overrides: [
        accountGatewayProvider.overrideWithValue(gateway),
        currentUserProvider.overrideWith(
          (ref) => Stream.value(signedIn ? gateway.user : null),
        ),
        onlineProvider.overrideWith((ref) => online.stream),
        sharedPreferencesProvider.overrideWithValue(prefs),
      ],
    );
    addTearDown(container.dispose);
    container
      ..listen(pendingJoinProvider, (_, _) {})
      ..listen(onlineProvider, (_, _) {})
      ..listen(currentUserProvider, (_, _) {});
    online.add(isOnline);
    await pumpEventQueue();
    return container;
  }

  setUp(() async {
    gateway = FakeGateway();
    online = StreamController<bool>.broadcast();
    addTearDown(online.close);
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  JoinState stateOf(ProviderContainer c) => c.read(pendingJoinProvider);

  test('en ligne : table rejointe, code oublié', () async {
    final c = await start();
    await c.read(pendingJoinProvider.notifier).submit(' k7q4zp ');
    expect(gateway.joins, ['K7Q4ZP']);
    expect(stateOf(c).status, JoinStatus.joined);
    expect(stateOf(c).tableId, 't1');
    expect(prefs.getString('pending_join'), isNull);
  });

  test('hors ligne : en attente, part au retour du réseau', () async {
    final c = await start(isOnline: false);
    await c.read(pendingJoinProvider.notifier).submit('K7Q4ZP');
    expect(stateOf(c).status, JoinStatus.waiting);
    expect(gateway.joins, isEmpty);
    expect(prefs.getString('pending_join'), 'K7Q4ZP');

    online.add(true);
    await pumpEventQueue();
    expect(gateway.joins, ['K7Q4ZP']);
    expect(stateOf(c).status, JoinStatus.joined);
  });

  test('sans compte : code gardé, compte demandé', () async {
    final c = await start(signedIn: false);
    await c.read(pendingJoinProvider.notifier).submit('K7Q4ZP');
    expect(stateOf(c).status, JoinStatus.needsAccount);
    expect(prefs.getString('pending_join'), 'K7Q4ZP');
  });

  test('refus : motif affiché, code oublié', () async {
    gateway.joinReply = (_) => (tableId: null, error: 'expired_code');
    final c = await start();
    await c.read(pendingJoinProvider.notifier).submit('K7Q4ZP');
    expect(stateOf(c).status, JoinStatus.failed);
    expect(stateOf(c).error, 'expired_code');
    expect(prefs.getString('pending_join'), isNull);
  });

  test('réseau perdu en route : le code reste', () async {
    gateway.joinReply = (_) => throw Exception('réseau');
    final c = await start();
    await c.read(pendingJoinProvider.notifier).submit('K7Q4ZP');
    expect(stateOf(c).status, JoinStatus.waiting);
    expect(prefs.getString('pending_join'), 'K7Q4ZP');
  });

  test('code gardé d\'une session précédente : repart au lancement', () async {
    await prefs.setString('pending_join', 'K7Q4ZP');
    final c = await start();
    expect(gateway.joins, ['K7Q4ZP']);
    expect(stateOf(c).status, JoinStatus.joined);
  });
}
