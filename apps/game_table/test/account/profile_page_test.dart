// Spec account : « Consentement aux rapports de crash », « Réglages
// d'affichage », « Déconnexion ».
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/profile_page.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/main.dart';
import 'package:game_table/settings/device_settings.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

final class _FakeSession implements SessionActions {
  _FakeSession(this.pending);

  final int pending;
  var signedOut = false;

  @override
  Future<int> pendingUploads() async => pending;

  @override
  Future<void> signOut() async => signedOut = true;
}

const _user = User(
  id: 'u1',
  appMetadata: {},
  userMetadata: {},
  aud: 'authenticated',
  createdAt: '2026-11-09T10:00:00Z',
  email: 'hugo@exemple.fr',
);

late AppLocalizations l10n;

Future<SharedPreferences> _prefs(Map<String, Object> values) async {
  SharedPreferences.setMockInitialValues(values);
  return SharedPreferences.getInstance();
}

Future<void> _pumpProfile(
  WidgetTester tester, {
  required SharedPreferences prefs,
  _FakeSession? session,
}) async {
  tester.view.physicalSize = const Size(390, 1100);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: '/profil',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Text('accueil')),
      GoRoute(path: '/profil', builder: (_, _) => const ProfilePage()),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        currentUserProvider.overrideWith((ref) => Stream.value(_user)),
        pseudonymProvider.overrideWith((ref) async => 'Hugo'),
        if (session != null) sessionActionsProvider.overrideWithValue(session),
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
  l10n = AppLocalizations.of(tester.element(find.byType(ProfilePage)));
}

void main() {
  group('consentement [T1]', () {
    Future<void> pumpApp(WidgetTester tester, SharedPreferences prefs) async {
      final database = TavernierDatabase(NativeDatabase.memory());
      addTearDown(database.close);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            sharedPreferencesProvider.overrideWithValue(prefs),
            databaseProvider.overrideWithValue(database),
          ],
          child: const GameTableApp(),
        ),
      );
      await tester.pumpAndSettle();
    }

    testWidgets('premier lancement : demandé, puis plus jamais', (
      tester,
    ) async {
      final prefs = await _prefs({});
      await pumpApp(tester, prefs);
      final l10n = AppLocalizations.of(
        tester.element(find.byType(AlertDialog)),
      );
      expect(find.text(l10n.consentTitle), findsOneWidget);
      // Le dialogue ne se ferme qu'avec une réponse.
      await tester.tapAt(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text(l10n.consentTitle), findsOneWidget);

      await tester.tap(find.text(l10n.consentAccept));
      await tester.pumpAndSettle();
      expect(find.text(l10n.consentTitle), findsNothing);
      expect(prefs.getBool('crash_reports'), isTrue);

      await tester.pumpWidget(const SizedBox());
      await pumpApp(tester, prefs);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('profil et réglages [T5]', () {
    testWidgets('en-tête : pseudonyme et e-mail', (tester) async {
      await _pumpProfile(tester, prefs: await _prefs({}));
      expect(find.text('Hugo'), findsOneWidget);
      expect(find.text('hugo@exemple.fr'), findsOneWidget);
      expect(find.text(l10n.themeLightSoon), findsOneWidget);
    });

    testWidgets('taille du texte : réglée et gardée', (tester) async {
      final prefs = await _prefs({});
      await _pumpProfile(tester, prefs: prefs);
      expect(find.text(l10n.textSizeValue(100)), findsWidgets);
      await tester.drag(find.byType(Slider), const Offset(400, 0));
      await tester.pumpAndSettle();
      expect(find.text(l10n.textSizeValue(200)), findsWidgets);
      expect(prefs.getDouble('text_scale'), 2);
    });

    testWidgets('rapports de plantage : révocables', (tester) async {
      final prefs = await _prefs({'crash_reports': true});
      await _pumpProfile(tester, prefs: prefs);
      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();
      expect(prefs.getBool('crash_reports'), isFalse);
    });

    testWidgets('déconnexion sans modification en attente', (tester) async {
      final session = _FakeSession(0);
      await _pumpProfile(tester, prefs: await _prefs({}), session: session);
      await tester.tap(find.text(l10n.signOut));
      await tester.pumpAndSettle();
      expect(session.signedOut, isTrue);
      expect(find.text('accueil'), findsOneWidget);
    });

    testWidgets('modifications en attente : confirmation qui les compte', (
      tester,
    ) async {
      final session = _FakeSession(3);
      await _pumpProfile(tester, prefs: await _prefs({}), session: session);
      await tester.tap(find.text(l10n.signOut));
      await tester.pumpAndSettle();
      expect(find.text(l10n.signOutPendingBody(3)), findsOneWidget);

      await tester.tap(find.text(l10n.cancel));
      await tester.pumpAndSettle();
      expect(session.signedOut, isFalse);

      await tester.tap(find.text(l10n.signOut));
      await tester.pumpAndSettle();
      await tester.tap(find.text(l10n.signOutAnyway));
      await tester.pumpAndSettle();
      expect(session.signedOut, isTrue);
    });
  });
}
