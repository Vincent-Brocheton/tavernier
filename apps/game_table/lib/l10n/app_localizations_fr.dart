// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Tavernier';

  @override
  String get appTagline => 'Gestion de personnage compatible 5e';

  @override
  String get navHome => 'Accueil';

  @override
  String get navTables => 'Tables';

  @override
  String get navCharacters => 'Personnages';

  @override
  String get navCompendium => 'Compendium';

  @override
  String get navHomebrew => 'Homebrew';
}
