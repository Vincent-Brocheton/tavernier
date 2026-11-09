// Spec account : « Modification du compte » (EF-CPT-09, écran A5).
import 'dart:async';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_gateway.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/edit_account_page.dart';
import 'package:game_table/account/password_policy.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import 'fakes.dart';

late AppLocalizations l10n;

Future<void> _pump(
  WidgetTester tester,
  FakeGateway gateway,
  FakeSession session,
) async {
  tester.view.physicalSize = const Size(390, 1400);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: '/profil',
    routes: [
      GoRoute(
        path: '/profil',
        builder: (_, _) => const Text('profil'),
        routes: [
          GoRoute(path: 'compte', builder: (_, _) => const EditAccountPage()),
        ],
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountGatewayProvider.overrideWithValue(gateway),
        sessionActionsProvider.overrideWithValue(session),
        pseudonymProvider.overrideWith((ref) async => 'Hugo'),
        breachedPasswordsProvider.overrideWithValue(
          BreachedPasswords(MockClient((_) async => http.Response('', 200))),
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
  await tester.pumpAndSettle();
  // Sans attendre : la page reste ouverte jusqu'à sa fermeture.
  unawaited(router.push('/profil/compte'));
  await tester.pumpAndSettle();
  l10n = AppLocalizations.of(tester.element(find.byType(EditAccountPage)));
}

Future<void> _type(WidgetTester tester, String label, String value) async {
  await tester.enterText(find.widgetWithText(TextField, label), value);
  await tester.pump();
}

bool _canSave(WidgetTester tester) =>
    tester
        .widget<FilledButton>(
          find.widgetWithText(FilledButton, l10n.accountSave),
        )
        .onPressed !=
    null;

Future<void> _save(WidgetTester tester) async {
  await tester.tap(find.widgetWithText(FilledButton, l10n.accountSave));
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('rien de changé : « Enregistrer » désactivé', (tester) async {
    await _pump(tester, FakeGateway(), FakeSession(0));
    expect(find.text('Hugo'), findsOneWidget);
    expect(find.text('hugo@exemple.fr'), findsOneWidget);
    expect(_canSave(tester), isFalse);
  });

  testWidgets('pseudonyme : enregistré, retour au profil', (tester) async {
    final session = FakeSession(0);
    await _pump(tester, FakeGateway(), session);
    await _type(tester, l10n.pseudonymLabel, 'Hugo le Brave');
    await _save(tester);
    expect(session.renames, ['Hugo le Brave']);
    expect(find.text('profil'), findsOneWidget);
  });

  testWidgets('pseudonyme vide : refusé', (tester) async {
    await _pump(tester, FakeGateway(), FakeSession(0));
    await _type(tester, l10n.pseudonymLabel, '  ');
    expect(find.text(l10n.pseudonymRequired), findsOneWidget);
    expect(_canSave(tester), isFalse);
  });

  testWidgets('nouvel e-mail : lien envoyé à la nouvelle adresse', (
    tester,
  ) async {
    final gateway = FakeGateway();
    await _pump(tester, gateway, FakeSession(0));
    await _type(tester, l10n.emailLabel, 'hugo.martin@exemple.fr');
    await _save(tester);
    expect(gateway.emailChanges, ['hugo.martin@exemple.fr']);
    expect(
      find.text(l10n.emailChangeSent('hugo.martin@exemple.fr')),
      findsOneWidget,
    );
  });

  testWidgets('mot de passe actuel faux : rien n’est changé', (tester) async {
    final gateway = FakeGateway()
      ..passwordOutcome = PasswordChangeOutcome.wrongCurrent;
    await _pump(tester, gateway, FakeSession(0));
    await _type(tester, l10n.currentPasswordLabel, 'faux');
    await _type(tester, l10n.newPasswordLabel, 'Correct-Cheval-Pile-42');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(_canSave(tester), isTrue);
    await _save(tester);
    expect(gateway.passwordChanges, [('faux', 'Correct-Cheval-Pile-42')]);
    expect(find.text(l10n.wrongCurrentPassword), findsOneWidget);
    expect(find.byType(EditAccountPage), findsOneWidget);
  });

  testWidgets('nouveau mot de passe sans l’actuel : désactivé', (tester) async {
    await _pump(tester, FakeGateway(), FakeSession(0));
    await _type(tester, l10n.newPasswordLabel, 'Correct-Cheval-Pile-42');
    await tester.pump(const Duration(milliseconds: 400));
    await tester.pumpAndSettle();
    expect(_canSave(tester), isFalse);
  });
}
