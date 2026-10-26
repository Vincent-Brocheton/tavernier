import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import 'l10n/app_localizations.dart';

void main() {
  registerFontLicenses();
  runApp(const GameTableApp());
}

/// Racine de l'application : thème sombre du kit, taille de texte bornée,
/// navigation principale à cinq destinations.
class GameTableApp extends StatelessWidget {
  const GameTableApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      home: const _Shell(),
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
        child: _selected == 0
            ? const _HomePage()
            : _PlaceholderPage(destinations[_selected].$2),
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
