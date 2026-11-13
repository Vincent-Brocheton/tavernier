// Spec account : « Supprimer le compte » (US-17, EF-CPT-04, écran T15).
import 'dart:async';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/delete_account_page.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'fakes.dart';

Future<void> _pump(WidgetTester tester, FakeSession session) async {
  tester.view.physicalSize = const Size(390, 1000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: '/profil',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Text('accueil')),
      GoRoute(path: '/profil', builder: (_, _) => const Text('profil')),
      GoRoute(
        path: '/profil/supprimer',
        builder: (_, _) => const DeleteAccountPage(),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [sessionActionsProvider.overrideWithValue(session)],
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
  await tester.pumpAndSettle();
  unawaited(router.push('/profil/supprimer'));
  await tester.pumpAndSettle();
}

bool _canDelete(WidgetTester tester) =>
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, 'Supprimer définitivement'),
        )
        .onPressed !=
    null;

Future<void> _type(WidgetTester tester, String text) async {
  await tester.dragUntilVisible(
    find.byType(TextField),
    find.byType(ListView),
    const Offset(0, -200),
  );
  await tester.enterText(find.byType(TextField), text);
  await tester.pump();
}

void main() {
  testWidgets('[T15] : export proposé, conséquences, confirmation tapée', (
    tester,
  ) async {
    final session = FakeSession(0);
    await _pump(tester, session);
    expect(find.text('D’abord, gardez une copie'), findsOneWidget);
    expect(find.text('Exporter mes données'), findsOneWidget);
    expect(
      find.text(
        'Les tables dont vous êtes MJ restent en place pour leurs joueurs, '
        'mais sans MJ.',
      ),
      findsOneWidget,
    );
    expect(_canDelete(tester), isFalse);
    await _type(tester, 'SUPPR');
    expect(_canDelete(tester), isFalse);
    await _type(tester, 'SUPPRIMER');
    expect(_canDelete(tester), isTrue);

    await tester.tap(find.text('Supprimer définitivement'));
    await tester.pumpAndSettle();
    expect(session.deleted, isTrue);
    expect(find.text('accueil'), findsOneWidget);
  });

  testWidgets('sans réseau : rien supprimé, et dit', (tester) async {
    final session = FakeSession(0)..deleteFails = true;
    await _pump(tester, session);
    await _type(tester, 'supprimer');
    await tester.tap(find.text('Supprimer définitivement'));
    await tester.pumpAndSettle();
    expect(session.deleted, isFalse);
    expect(session.signedOut, isFalse);
    expect(find.textContaining('rien n’a été supprimé'), findsOneWidget);
    expect(find.byType(DeleteAccountPage), findsOneWidget);
  });

  testWidgets('Annuler : retour au profil', (tester) async {
    await _pump(tester, FakeSession(0));
    await tester.tap(find.text('Annuler'));
    await tester.pumpAndSettle();
    expect(find.text('profil'), findsOneWidget);
  });

  group('SessionActions.deleteAccount', () {
    ProviderContainer container(FakeGateway gateway) {
      final database = TavernierDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      final c = ProviderContainer(
        overrides: [
          accountGatewayProvider.overrideWithValue(gateway),
          databaseProvider.overrideWithValue(database),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('serveur, puis déconnexion', () async {
      final gateway = FakeGateway();
      await container(gateway).read(sessionActionsProvider).deleteAccount();
      expect(gateway.calls, ['delete']);
      expect(gateway.signedOut, isTrue);
    });

    test('serveur injoignable : session gardée', () async {
      final gateway = FakeGateway()..deleteFails = true;
      await expectLater(
        container(gateway).read(sessionActionsProvider).deleteAccount(),
        throwsException,
      );
      expect(gateway.signedOut, isFalse);
    });
  });
}
