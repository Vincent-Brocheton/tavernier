// Spec account : « Consentement aux rapports de crash », « Réglages
// d'affichage », « Déconnexion ».
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/account/account_providers.dart';
import 'package:game_table/account/delete_account_page.dart';
import 'package:game_table/account/profile_page.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/l10n/app_localizations.dart';
import 'package:game_table/main.dart';
import 'package:game_table/settings/device_settings.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show User;

import 'fakes.dart';

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
  FakeSession? session,
  int gmTables = 0,
  bool signedIn = true,
}) async {
  // Tout le profil construit, « Se déconnecter » compris.
  tester.view.physicalSize = const Size(390, 2000);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final router = GoRouter(
    initialLocation: '/profil',
    routes: [
      GoRoute(path: '/', builder: (_, _) => const Text('accueil')),
      GoRoute(path: '/profil', builder: (_, _) => const ProfilePage()),
      GoRoute(
        path: '/profil/supprimer',
        builder: (_, _) => const DeleteAccountPage(),
      ),
    ],
  );
  addTearDown(router.dispose);
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        currentUserProvider.overrideWith(
          (ref) => Stream.value(signedIn ? _user : null),
        ),
        pseudonymProvider.overrideWith((ref) async => 'Hugo'),
        gmTableCountProvider.overrideWith((ref) async => gmTables),
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
    testWidgets('supprimer le compte [A7] : tables de MJ, puis [T15]', (
      tester,
    ) async {
      await _pumpProfile(tester, prefs: await _prefs({}), gmTables: 1);
      expect(find.textContaining('Vous êtes MJ de 1 table.'), findsOneWidget);
      await tester.ensureVisible(find.text('Supprimer mon compte…'));
      await tester.tap(find.text('Supprimer mon compte…'));
      await tester.pumpAndSettle();
      expect(find.byType(DeleteAccountPage), findsOneWidget);
    });

    testWidgets('sans compte : pas de suppression proposée', (tester) async {
      await _pumpProfile(tester, prefs: await _prefs({}), signedIn: false);
      expect(find.text('Supprimer mon compte…'), findsNothing);
    });

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

    testWidgets('appareils : cet appareil, puis les autres', (tester) async {
      await _pumpProfile(
        tester,
        prefs: await _prefs({}),
        session: FakeSession(0),
      );
      expect(find.text(l10n.devicesSection), findsOneWidget);
      expect(find.text('Chrome sur Windows'), findsOneWidget);
      expect(find.text(l10n.thisDeviceNow), findsOneWidget);
      expect(find.text(l10n.deviceAndroidPhone), findsOneWidget);
      expect(find.text(l10n.activeDays(2)), findsOneWidget);
      // « Déconnecter » sur l'autre appareil seulement.
      expect(find.text(l10n.revokeDevice), findsOneWidget);
    });

    testWidgets("déconnexion à distance : l'appareil disparaît", (
      tester,
    ) async {
      final session = FakeSession(0);
      await _pumpProfile(tester, prefs: await _prefs({}), session: session);
      await tester.tap(find.text(l10n.revokeDevice));
      await tester.pumpAndSettle();
      expect(session.revoked, ['s2']);
      expect(find.text(l10n.deviceAndroidPhone), findsNothing);
    });

    testWidgets('déconnexion à distance sans réseau : expliquée', (
      tester,
    ) async {
      final session = FakeSession(0)..revokeFails = true;
      await _pumpProfile(tester, prefs: await _prefs({}), session: session);
      await tester.tap(find.text(l10n.revokeDevice));
      await tester.pumpAndSettle();
      expect(find.text(l10n.devicesOffline), findsOneWidget);
      expect(find.text(l10n.deviceAndroidPhone), findsOneWidget);
    });

    testWidgets('appareils sans réseau : expliqué', (tester) async {
      await _pumpProfile(
        tester,
        prefs: await _prefs({}),
        session: FakeSession(0, online: false),
      );
      expect(find.text(l10n.devicesOffline), findsOneWidget);
    });

    testWidgets('déconnexion sans modification en attente', (tester) async {
      final session = FakeSession(0);
      await _pumpProfile(tester, prefs: await _prefs({}), session: session);
      await tester.tap(find.text(l10n.signOut));
      await tester.pumpAndSettle();
      expect(session.signedOut, isTrue);
      expect(find.text('accueil'), findsOneWidget);
    });

    testWidgets('modifications en attente : confirmation qui les compte', (
      tester,
    ) async {
      final session = FakeSession(3);
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
