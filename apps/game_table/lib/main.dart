import 'dart:async';

import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart' show AuthChangeEvent;

import 'account/account_providers.dart';
import 'account/age_page.dart';
import 'account/auth_links.dart';
import 'account/edit_account_page.dart';
import 'account/forgot_password_page.dart';
import 'account/new_password_page.dart';
import 'account/profile_page.dart';
import 'account/sign_in_page.dart';
import 'creation/creation_page.dart';
import 'creation/creation_providers.dart';
import 'creation/step_layout.dart';
import 'l10n/app_localizations.dart';
import 'settings/crash_consent_dialog.dart';
import 'settings/device_settings.dart';
import 'sheet/history_page.dart';
import 'sheet/level_up_page.dart';
import 'sheet/sheet_page.dart';
import 'tables/create_table_page.dart';
import 'tables/join_page.dart';
import 'tables/pending_join.dart';
import 'tables/summary_publisher.dart';
import 'tables/table_page.dart';
import 'tables/tables_tab.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  registerFontLicenses();
  await initAccounts();
  final preferences = await SharedPreferences.getInstance();
  runApp(
    ProviderScope(
      overrides: [sharedPreferencesProvider.overrideWithValue(preferences)],
      child: const GameTableApp(),
    ),
  );
}

/// Racine de l'application : thème sombre du kit, taille de texte bornée,
/// navigation principale à cinq destinations.
class GameTableApp extends ConsumerStatefulWidget {
  const GameTableApp({super.key});

  @override
  ConsumerState<GameTableApp> createState() => _GameTableAppState();
}

class _GameTableAppState extends ConsumerState<GameTableApp> {
  StreamSubscription<Object?>? _recovery;
  late final _router = GoRouter(
    // Retours de Supabase Auth (« #error=… », « #access_token=… ») : vers un
    // écran connu ; toute autre adresse inconnue ramène à l'accueil.
    redirect: (_, state) =>
        authCallbackRedirect(state.uri) ?? _ageRedirect(state.uri),
    errorBuilder: (_, _) => const _Shell(),
    routes: [
      GoRoute(path: '/', builder: (_, _) => const _Shell()),
      GoRoute(
        path: '/connexion',
        builder: (_, state) => SignInPage(
          invalidLink: state.uri.queryParameters['lien'] == 'invalide',
        ),
      ),
      GoRoute(path: '/profil', builder: (_, _) => const ProfilePage()),
      GoRoute(path: '/age', builder: (_, _) => const AgePage()),
      // Lien d'invitation (EF-TAB-05) et saisie du code.
      GoRoute(path: '/rejoindre', builder: (_, _) => const JoinPage()),
      GoRoute(
        path: '/rejoindre/:code',
        builder: (_, state) => JoinPage(code: state.pathParameters['code']),
      ),
      GoRoute(
        path: '/tables/nouvelle',
        builder: (_, _) => const CreateTablePage(),
      ),
      GoRoute(
        path: '/tables/:id',
        builder: (_, state) => TablePage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/profil/compte',
        builder: (_, _) => const EditAccountPage(),
      ),
      GoRoute(
        path: '/connexion/mot-de-passe-oublie',
        builder: (_, _) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/nouveau-mot-de-passe',
        builder: (_, _) => const NewPasswordPage(),
      ),
      GoRoute(
        path: '/characters/new',
        // Depuis un emplacement de PJ : ?table=…&slot=… (US-15).
        builder: (_, state) => CreationPage(
          tableId: state.uri.queryParameters['table'],
          slotId: state.uri.queryParameters['slot'],
        ),
      ),
      GoRoute(
        path: '/characters/:id/historique',
        builder: (_, state) => HistoryPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/characters/:id',
        builder: (_, state) => SheetPage(id: state.pathParameters['id']!),
      ),
      GoRoute(
        path: '/characters/:id/level-up',
        builder: (_, state) => LevelUpPage(id: state.pathParameters['id']!),
      ),
    ],
  );

  /// Un compte connecté sans âge vérifié (Google) passe d'abord par la date
  /// de naissance (EF-CPT-01).
  String? _ageRedirect(Uri location) {
    final gateway = ref.read(accountGatewayProvider);
    final needsAge =
        gateway?.user != null &&
        !gateway!.ageChecked &&
        gateway.googleIdentity != null;
    if (!needsAge || location.path == '/age') return null;
    return '/age';
  }

  @override
  void initState() {
    super.initState();
    // Toute connexion ou déconnexion revoit la redirection d'âge.
    ref.listenManual(currentUserProvider, (_, _) => _router.refresh());
    // Le lien de réinitialisation suivi ouvre une session de récupération :
    // on mène au choix du nouveau mot de passe [A3].
    _recovery = ref
        .read(accountGatewayProvider)
        ?.changes
        .where((c) => c.event == AuthChangeEvent.passwordRecovery)
        .listen((_) => _router.go('/nouveau-mot-de-passe'));
  }

  @override
  void dispose() {
    _recovery?.cancel();
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Synchronisation tant qu'un utilisateur est connecté (T-05).
    ref.watch(syncProvider);
    // Demande pour rejoindre une table, gardée jusqu'au réseau (EF-TAB-08).
    ref.listen(pendingJoinProvider, (_, _) {});
    // Résumés des fiches de table, pour le groupe (EF-TAB-09).
    ref.listen(summaryPublisherProvider, (_, _) {});
    final textScale = ref.watch(deviceSettingsProvider).textScale;
    return MaterialApp.router(
      routerConfig: _router,
      onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      // Taille du texte du système, multipliée par le réglage (EF-CPT-03),
      // puis bornée de 85 % à 200 %.
      builder: (context, child) {
        final media = MediaQuery.of(context);
        return MediaQuery(
          data: media.copyWith(
            textScaler: TextScaler.linear(
              media.textScaler.scale(1) * textScale,
            ),
          ),
          child: AppTextScale.clamp(child: child!),
        );
      },
    );
  }
}

class _Shell extends ConsumerStatefulWidget {
  const _Shell();

  @override
  ConsumerState<_Shell> createState() => _ShellState();
}

class _ShellState extends ConsumerState<_Shell> {
  var _selected = 0;

  @override
  void initState() {
    super.initState();
    // Premier lancement : consentement aux rapports de plantage [T1].
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => mounted ? askCrashConsentIfNeeded(context, ref) : null,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final destinations = [
      (GameIcons.navigation['home']!, l10n.navHome),
      (GameIcons.navigation['tables']!, l10n.navTables),
      (GameIcons.navigation['characters']!, l10n.navCharacters),
      (GameIcons.navigation['compendium']!, l10n.navCompendium),
      (GameIcons.navigation['homebrew']!, l10n.navHomebrew),
    ];
    final pseudonym = ref.watch(pseudonymProvider).value;
    return AdaptiveNavigationScaffold(
      account: IconButton(
        tooltip: l10n.profileTitle,
        onPressed: () => context.push('/profil'),
        icon: CircleAvatar(
          radius: 18,
          child: pseudonym == null || pseudonym.isEmpty
              ? const Icon(Icons.person_outline)
              : Text(pseudonym.characters.first.toUpperCase()),
        ),
      ),
      selectedIndex: _selected,
      onDestinationSelected: (i) => setState(() => _selected = i),
      destinations: [
        for (final (icon, label) in destinations)
          AdaptiveDestination(
            icon: GameIcon(icon),
            selectedIcon: GameIcon(icon),
            label: label,
          ),
      ],
      body: SafeArea(
        child: switch (_selected) {
          0 => const _HomePage(),
          1 => const TablesTab(),
          2 => const _CharactersPage(),
          _ => _PlaceholderPage(destinations[_selected].$2),
        },
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.appTitle,
            style: text.displaySmall!.copyWith(
              color: Theme.of(context).colorScheme.tertiary,
            ),
          ),
          Text(l10n.appTagline, style: text.bodyLarge),
        ],
      ),
    );
  }
}

/// Personnages : ceux qui sont enregistrés et l'entrée de la création.
class _CharactersPage extends ConsumerWidget {
  const _CharactersPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final characters = ref.watch(charactersProvider).asData?.value ?? const [];
    final content = ref.watch(contentProvider).asData?.value;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.navCharacters,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          SizedBox(height: AppSpacing.sm),
          if (characters.isEmpty || content == null)
            Text(l10n.noCharacterYet)
          else
            Flexible(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 480),
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    for (final (:id, :character) in characters)
                      ListTile(
                        key: ValueKey(id),
                        onTap: () => context.push('/characters/$id'),
                        title: Text(character.name),
                        subtitle: Text(
                          [
                            namesOf(content, [character.speciesId]),
                            for (final level in character.classLevels)
                              l10n.classLevel(
                                namesOf(content, [level.classId]),
                                level.level,
                              ),
                            namesOf(content, [character.backgroundId]),
                          ].join(' · '),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: () => context.push('/characters/new'),
            child: Text(l10n.newCharacter),
          ),
        ],
      ),
    );
  }
}

/// Page provisoire d'une destination, remplacée par les cartes de M1 à M4.
class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.headlineMedium),
    );
  }
}
