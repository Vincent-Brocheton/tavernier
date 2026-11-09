// Spec account : « Connexion par Google », « Méthodes de connexion »
// (EF-CPT-01, EF-CPT-10, écrans A1, A6).
import 'dart:async';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/age_page.dart';
import 'package:game_table/account/edit_account_page.dart';
import 'package:game_table/account/password_policy.dart';
import 'package:game_table/account/sign_in_page.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';

import 'fakes.dart';

late AppLocalizations l10n;

Future<void> _pump(
  WidgetTester tester,
  String location,
  FakeGateway gateway,
) async {
  tester.view.physicalSize = const Size(390, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Text('accueil')),
      GoRoute(path: '/connexion', builder: (_, _) => const SignInPage()),
      GoRoute(path: '/age', builder: (_, _) => const AgePage()),
      GoRoute(path: '/compte', builder: (_, _) => const EditAccountPage()),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountGatewayProvider.overrideWithValue(gateway),
        sessionActionsProvider.overrideWithValue(FakeSession(0)),
        pseudonymProvider.overrideWith((ref) async => 'Inès'),
        onlineProvider.overrideWith((ref) => Stream.value(true)),
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
  unawaited(router.push(location));
  await tester.pumpAndSettle();
  l10n = AppLocalizations.of(tester.element(find.byType(Scaffold).last));
}

Finder _button(String label) => find.ancestor(
  of: find.text(label),
  matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
);

bool _enabled(WidgetTester tester, String label) =>
    tester.widget<ButtonStyleButton>(_button(label)).onPressed != null;

void main() {
  testWidgets('connexion : « Continuer avec Google »', (tester) async {
    final gateway = FakeGateway();
    await _pump(tester, '/connexion', gateway);
    await tester.tap(find.text(l10n.continueWithGoogle));
    await tester.pumpAndSettle();
    expect(gateway.calls, ['google']);
  });

  group('date de naissance d’un compte Google', () {
    testWidgets('15 ans révolus : on continue', (tester) async {
      final gateway = FakeGateway();
      await _pump(tester, '/age', gateway);
      await tester.enterText(find.byType(TextField), '01/01/2000');
      await tester.pump();
      await tester.tap(_button(l10n.ageContinue));
      await tester.pumpAndSettle();
      expect(gateway.calls, ['age 2000']);
      expect(find.text('accueil'), findsOneWidget);
    });

    testWidgets('moins de 15 ans : compte refusé, expliqué', (tester) async {
      final gateway = FakeGateway()..ageAccepted = false;
      await _pump(tester, '/age', gateway);
      await tester.enterText(find.byType(TextField), '12/03/2013');
      await tester.pump();
      await tester.tap(_button(l10n.ageContinue));
      await tester.pumpAndSettle();
      expect(find.text(l10n.ageRefused), findsOneWidget);
    });
  });

  group('méthodes de connexion [A6]', () {
    testWidgets('Google seule : e-mail verrouillé, « Retirer » désactivé', (
      tester,
    ) async {
      final gateway = FakeGateway()
        ..google = true
        ..hasPasswordValue = false;
      await _pump(tester, '/compte', gateway);
      expect(find.text(l10n.emailFromGoogle), findsOneWidget);
      expect(
        tester
            .widget<TextField>(find.widgetWithText(TextField, l10n.emailLabel))
            .readOnly,
        isTrue,
      );
      expect(find.text(l10n.changePasswordSection), findsNothing);
      expect(find.text('ines.l@gmail.com'), findsOneWidget);
      expect(_enabled(tester, l10n.methodRemove), isFalse);
      expect(find.text(l10n.googleOnlyNote), findsOneWidget);
      expect(find.text(l10n.methodNone), findsOneWidget);
    });

    testWidgets('ajouter un mot de passe', (tester) async {
      final gateway = FakeGateway()
        ..google = true
        ..hasPasswordValue = false;
      await _pump(tester, '/compte', gateway);
      await tester.tap(_button(l10n.methodAdd));
      await tester.pumpAndSettle();
      await tester.enterText(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.byType(TextField),
        ),
        'Correct-Cheval-Pile-42',
      );
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await tester.tap(
        find.descendant(
          of: find.byType(AlertDialog),
          matching: find.text(l10n.accountSave),
        ),
      );
      await tester.pumpAndSettle();
      expect(gateway.calls, ['add Correct-Cheval-Pile-42']);
    });

    testWidgets('Google et mot de passe : Google se retire', (tester) async {
      final gateway = FakeGateway()..google = true;
      await _pump(tester, '/compte', gateway);
      expect(find.text(l10n.googleOnlyNote), findsNothing);
      await tester.tap(_button(l10n.methodRemove));
      await tester.pumpAndSettle();
      expect(gateway.calls, ['unlink']);
    });

    testWidgets('sans Google : « Lier »', (tester) async {
      final gateway = FakeGateway();
      await _pump(tester, '/compte', gateway);
      expect(find.text(l10n.methodNotLinked), findsOneWidget);
      await tester.tap(_button(l10n.methodLink));
      await tester.pumpAndSettle();
      expect(gateway.calls, ['link']);
    });
  });
}
