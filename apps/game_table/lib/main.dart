import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'creation/creation_page.dart';
import 'creation/creation_providers.dart';
import 'creation/step_layout.dart';
import 'l10n/app_localizations.dart';

void main() {
  registerFontLicenses();
  runApp(const ProviderScope(child: GameTableApp()));
}

/// Racine de l'application : thème sombre du kit, taille de texte bornée,
/// navigation principale à cinq destinations.
class GameTableApp extends StatefulWidget {
  const GameTableApp({super.key});

  @override
  State<GameTableApp> createState() => _GameTableAppState();
}

class _GameTableAppState extends State<GameTableApp> {
  final _router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (_, _) => const _Shell()),
      GoRoute(path: '/characters/new', builder: (_, _) => const CreationPage()),
    ],
  );

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      builder: (context, child) => AppTextScale.clamp(child: child!),
    );
  }
}

class _Shell extends StatefulWidget {
  const _Shell();

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  var _selected = 0;

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
    return AdaptiveNavigationScaffold(
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
                        title: Text(character.name),
                        subtitle: Text(
                          [
                            namesOf(content, [character.speciesId]),
                            l10n.classLevel(
                              namesOf(content, [
                                character.classLevels.first.classId,
                              ]),
                              character.classLevels.first.level,
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
