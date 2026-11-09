// Spec account : « Connexion », « Première connexion sans réseau », « Mot de
// passe oublié », « Nouveau mot de passe ».
import 'dart:async';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_gateway.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/forgot_password_page.dart';
import 'package:game_table/account/new_password_page.dart';
import 'package:game_table/account/password_policy.dart';
import 'package:game_table/account/sign_in_page.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthState, User;

final class _FakeGateway implements AccountGateway {
  _FakeGateway({this.signedIn = true});

  /// Faux : page ouverte sans le lien de réinitialisation.
  final bool signedIn;
  SignInOutcome outcome = SignInOutcome.signedIn;
  final signIns = <(String, String)>[];
  final resets = <String>[];
  final updates = <(String, bool)>[];

  @override
  User? get user => !signedIn
      ? null
      : const User(
          id: 'u1',
          appMetadata: {},
          userMetadata: {},
          aud: 'authenticated',
          createdAt: '2026-11-09T10:00:00Z',
          email: 'hugo@exemple.fr',
        );

  @override
  Stream<AuthState> get changes => const Stream.empty();

  @override
  DateTime? get resetLinkExpiry =>
      DateTime.now().add(const Duration(minutes: 48, seconds: 30));

  @override
  Future<SignInOutcome> signIn(String email, String password) async {
    signIns.add((email, password));
    return outcome;
  }

  @override
  Future<void> requestPasswordReset(String email, {String? redirectTo}) async =>
      resets.add(email);

  @override
  Future<void> updatePassword(
    String password, {
    required bool signOutOthers,
  }) async => updates.add((password, signOutOthers));
}

late AppLocalizations l10n;

/// Mot de passe divulgué selon le double de Have I Been Pwned.
const _leaked = 'motdepasse123';

Future<void> _pump(
  WidgetTester tester,
  String location,
  _FakeGateway gateway, {
  Stream<bool>? online,
}) async {
  final router = GoRouter(
    initialLocation: location,
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Text('accueil')),
      GoRoute(path: '/connexion', builder: (_, _) => const SignInPage()),
      GoRoute(
        path: '/connexion/mot-de-passe-oublie',
        builder: (_, _) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/nouveau-mot-de-passe',
        builder: (_, _) => const NewPasswordPage(),
      ),
    ],
  );
  addTearDown(router.dispose);
  final leakedSuffix = sha1Hex(_leaked).substring(5);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        accountGatewayProvider.overrideWithValue(gateway),
        onlineProvider.overrideWith((ref) => online ?? Stream.value(true)),
        pseudonymProvider.overrideWith((ref) async => 'Grimoire42'),
        breachedPasswordsProvider.overrideWithValue(
          BreachedPasswords(
            MockClient((_) async => http.Response('$leakedSuffix:12\r\n', 200)),
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
  await tester.pumpAndSettle();
  l10n = AppLocalizations.of(tester.element(find.byType(Scaffold).first));
}

/// Écran haut : tout le formulaire [A3] est construit.
Future<void> _pumpTall(
  WidgetTester tester,
  String location,
  _FakeGateway gateway,
) async {
  tester.view.physicalSize = const Size(800, 1600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await _pump(tester, location, gateway);
}

Future<void> _type(WidgetTester tester, String label, String value) async {
  await tester.enterText(find.widgetWithText(TextField, label), value);
  await tester.pump();
}

Finder _button(String label) => find.ancestor(
  of: find.text(label),
  matching: find.byWidgetPredicate((w) => w is ButtonStyleButton),
);

bool _enabled(WidgetTester tester, String label) =>
    tester.widget<ButtonStyleButton>(_button(label)).onPressed != null;

void main() {
  group('connexion', () {
    testWidgets('identifiants refusés : le message unique', (tester) async {
      final gateway = _FakeGateway()
        ..outcome = SignInOutcome.invalidCredentials;
      await _pump(tester, '/connexion', gateway);
      await _type(tester, l10n.emailLabel, ' hugo@exemple.fr ');
      await _type(tester, l10n.passwordLabel, 'faux');
      await tester.tap(_button(l10n.signInAction));
      await tester.pumpAndSettle();
      expect(find.text(l10n.signInInvalid), findsOneWidget);
      expect(gateway.signIns, [(' hugo@exemple.fr ', 'faux')]);
    });

    testWidgets('serveur muet : un autre message', (tester) async {
      final gateway = _FakeGateway()..outcome = SignInOutcome.network;
      await _pump(tester, '/connexion', gateway);
      await tester.tap(_button(l10n.signInAction));
      await tester.pumpAndSettle();
      expect(find.text(l10n.signInNetworkError), findsOneWidget);
      expect(find.text(l10n.signInInvalid), findsNothing);
    });

    testWidgets('réussie : retour à l\'accueil', (tester) async {
      await _pump(tester, '/connexion', _FakeGateway());
      await tester.tap(_button(l10n.signInAction));
      await tester.pumpAndSettle();
      expect(find.text('accueil'), findsOneWidget);
    });

    testWidgets('sans réseau : désactivé et expliqué, puis réactivé', (
      tester,
    ) async {
      final online = StreamController<bool>();
      addTearDown(online.close);
      final gateway = _FakeGateway();
      await _pump(tester, '/connexion', gateway, online: online.stream);
      online.add(false);
      await tester.pumpAndSettle();
      expect(find.text(l10n.offlineTitle), findsOneWidget);
      expect(_enabled(tester, l10n.signInAction), isFalse);
      await _type(tester, l10n.emailLabel, 'hugo@exemple.fr');

      online.add(true);
      await tester.pumpAndSettle();
      expect(find.text(l10n.offlineTitle), findsNothing);
      expect(_enabled(tester, l10n.signInAction), isTrue);
      expect(find.text('hugo@exemple.fr'), findsOneWidget);
      expect(gateway.signIns, isEmpty);
    });

    testWidgets('desktop : deux colonnes [A4]', (tester) async {
      tester.view.physicalSize = const Size(1440, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await _pump(tester, '/connexion', _FakeGateway());
      expect(find.text(l10n.signInTagline), findsOneWidget);
      expect(find.text(l10n.signInTitle), findsOneWidget);
      expect(find.text(l10n.signInWelcome), findsNothing);
    });
  });

  group('mot de passe oublié', () {
    testWidgets('confirmation neutre, renvoi après 60 s', (tester) async {
      final gateway = _FakeGateway();
      await _pump(tester, '/connexion/mot-de-passe-oublie', gateway);
      await _type(tester, l10n.emailLabel, 'hugo@exemple.fr');
      await tester.tap(_button(l10n.forgotSend));
      await tester.pump();
      expect(gateway.resets, ['hugo@exemple.fr']);
      expect(find.text(l10n.forgotSentBody('hugo@exemple.fr')), findsOneWidget);
      expect(find.text(l10n.forgotResendIn('1:00')), findsOneWidget);
      expect(_enabled(tester, l10n.forgotResendIn('1:00')), isFalse);

      await tester.pump(const Duration(seconds: 18));
      expect(find.text(l10n.forgotResendIn('0:42')), findsOneWidget);
      await tester.pump(const Duration(seconds: 42));
      expect(_enabled(tester, l10n.forgotResend), isTrue);
      await tester.tap(_button(l10n.forgotResend));
      await tester.pump();
      expect(gateway.resets, hasLength(2));
      await tester.pump(resendDelay);
    });
  });

  group('nouveau mot de passe', () {
    String ruleLabel(String rule, String state) => '$rule, $state';

    testWidgets('8 caractères : règle non respectée, enregistrement bloqué', (
      tester,
    ) async {
      await _pumpTall(tester, '/nouveau-mot-de-passe', _FakeGateway());
      expect(
        find.text(l10n.newPasswordAccount('hugo@exemple.fr', 48)),
        findsOneWidget,
      );
      await _type(tester, l10n.newPasswordLabel, 'abcdefgh');
      expect(
        tester.getSemantics(find.text(l10n.ruleLength)).label,
        ruleLabel(l10n.ruleLength, l10n.ruleUnmet),
      );
      expect(_enabled(tester, l10n.savePasswordAndSignIn), isFalse);
    });

    testWidgets('mot de passe divulgué : règle non respectée', (tester) async {
      await _pumpTall(tester, '/nouveau-mot-de-passe', _FakeGateway());
      await _type(tester, l10n.newPasswordLabel, _leaked);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.text(l10n.ruleBreached)).label,
        ruleLabel(l10n.ruleBreached, l10n.ruleUnmet),
      );
    });

    testWidgets('pseudo : règle d\'identité non respectée', (tester) async {
      await _pumpTall(tester, '/nouveau-mot-de-passe', _FakeGateway());
      await _type(tester, l10n.newPasswordLabel, 'grimoire42');
      expect(
        tester.getSemantics(find.text(l10n.ruleIdentity)).label,
        ruleLabel(l10n.ruleIdentity, l10n.ruleUnmet),
      );
    });

    testWidgets('sans session de récupération : rien à enregistrer', (
      tester,
    ) async {
      await _pumpTall(
        tester,
        '/nouveau-mot-de-passe',
        _FakeGateway(signedIn: false),
      );
      const password = 'Correct-Cheval-Pile-42';
      await _type(tester, l10n.newPasswordLabel, password);
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pumpAndSettle();
      await _type(tester, l10n.confirmPasswordLabel, password);
      expect(_enabled(tester, l10n.savePasswordAndSignIn), isFalse);
    });

    testWidgets(
      'toutes les règles : enregistré, autres appareils déconnectés',
      (tester) async {
        final gateway = _FakeGateway();
        await _pumpTall(tester, '/nouveau-mot-de-passe', gateway);
        const password = 'Correct-Cheval-Pile-42';
        await _type(tester, l10n.newPasswordLabel, password);
        await tester.pump(const Duration(milliseconds: 400));
        await tester.pumpAndSettle();
        expect(_enabled(tester, l10n.savePasswordAndSignIn), isFalse);
        await _type(tester, l10n.confirmPasswordLabel, password);
        expect(
          find.text(l10n.passwordStrength(l10n.passwordStrength4)),
          findsOneWidget,
        );
        expect(
          tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
          isTrue,
        );
        await tester.tap(_button(l10n.savePasswordAndSignIn));
        await tester.pumpAndSettle();
        expect(gateway.updates, [(password, true)]);
        expect(find.text('accueil'), findsOneWidget);
      },
    );
  });
}
