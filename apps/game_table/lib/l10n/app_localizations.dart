import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('fr')];

  /// Nom de l'application.
  ///
  /// In fr, this message translates to:
  /// **'Tavernier'**
  String get appTitle;

  /// Sous-titre affiché sous le nom de l'application.
  ///
  /// In fr, this message translates to:
  /// **'Gestion de personnage compatible 5e'**
  String get appTagline;

  /// Destination de navigation : accueil.
  ///
  /// In fr, this message translates to:
  /// **'Accueil'**
  String get navHome;

  /// Destination de navigation : tables de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Tables'**
  String get navTables;

  /// Destination de navigation : personnages.
  ///
  /// In fr, this message translates to:
  /// **'Personnages'**
  String get navCharacters;

  /// Destination de navigation : compendium des règles.
  ///
  /// In fr, this message translates to:
  /// **'Compendium'**
  String get navCompendium;

  /// Destination de navigation : contenu homebrew.
  ///
  /// In fr, this message translates to:
  /// **'Homebrew'**
  String get navHomebrew;

  /// Bouton et titre de la création de personnage.
  ///
  /// In fr, this message translates to:
  /// **'Nouveau personnage'**
  String get newCharacter;

  /// Liste de personnages vide.
  ///
  /// In fr, this message translates to:
  /// **'Aucun personnage pour l’instant.'**
  String get noCharacterYet;

  /// Bouton de fermeture.
  ///
  /// In fr, this message translates to:
  /// **'Fermer'**
  String get close;

  /// Assistant : étape précédente.
  ///
  /// In fr, this message translates to:
  /// **'Précédent'**
  String get previous;

  /// Assistant : étape suivante, sur téléphone.
  ///
  /// In fr, this message translates to:
  /// **'Suivant'**
  String get next;

  /// Étape pas encore livrée.
  ///
  /// In fr, this message translates to:
  /// **'Bientôt disponible'**
  String get comingSoon;

  /// Échec de lecture du pack.
  ///
  /// In fr, this message translates to:
  /// **'Le contenu n’a pas pu être lu.'**
  String get contentError;

  /// Relance une lecture.
  ///
  /// In fr, this message translates to:
  /// **'Réessayer'**
  String get retry;

  /// Étape 1.
  ///
  /// In fr, this message translates to:
  /// **'Classe'**
  String get stepClass;

  /// Étape 2.
  ///
  /// In fr, this message translates to:
  /// **'Historique'**
  String get stepBackground;

  /// Étape 3.
  ///
  /// In fr, this message translates to:
  /// **'Espèce'**
  String get stepSpecies;

  /// Étape 4.
  ///
  /// In fr, this message translates to:
  /// **'Langues'**
  String get stepLanguages;

  /// Étape 5.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques'**
  String get stepAbilities;

  /// Étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Sous-choix'**
  String get stepSubchoices;

  /// Étape 7.
  ///
  /// In fr, this message translates to:
  /// **'Équipement'**
  String get stepEquipment;

  /// Étape 8.
  ///
  /// In fr, this message translates to:
  /// **'Détails'**
  String get stepDetails;

  /// Étape 9.
  ///
  /// In fr, this message translates to:
  /// **'Récapitulatif'**
  String get stepSummary;

  /// Étape sans choix fait.
  ///
  /// In fr, this message translates to:
  /// **'À choisir'**
  String get stepToChoose;

  /// Sous-libellé de l’étape 4.
  ///
  /// In fr, this message translates to:
  /// **'Commun + 2'**
  String get stepLanguagesHint;

  /// Sous-libellé de l’étape 5.
  ///
  /// In fr, this message translates to:
  /// **'Acquisition par points'**
  String get stepAbilitiesHint;

  /// Sous-libellé de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Compétences, bottes, don'**
  String get stepSubchoicesHint;

  /// Sous-libellé de l’étape 7.
  ///
  /// In fr, this message translates to:
  /// **'Pack ou or'**
  String get stepEquipmentHint;

  /// Sous-libellé de l’étape 8.
  ///
  /// In fr, this message translates to:
  /// **'Nom, apparence'**
  String get stepDetailsHint;

  /// Sous-libellé de l’étape 9.
  ///
  /// In fr, this message translates to:
  /// **'Envoi au MJ'**
  String get stepSummaryHint;

  /// Introduction de l’étape 1.
  ///
  /// In fr, this message translates to:
  /// **'Votre classe décide de vos talents au combat, de vos dés de vie et de vos maîtrises. Vous pourrez revenir sur ce choix.'**
  String get introClass;

  /// Introduction de l’étape 2.
  ///
  /// In fr, this message translates to:
  /// **'Ce que faisait votre personnage avant l’aventure. L’Historique donne trois caractéristiques à augmenter, un don d’origines, deux compétences et un outil.'**
  String get introBackground;

  /// Introduction de l’étape 3.
  ///
  /// In fr, this message translates to:
  /// **'Taille, Vitesse et traits. Aucun bonus de caractéristique : ils viennent de l’Historique.'**
  String get introSpecies;

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une classe pour continuer.'**
  String get missingClass;

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un Historique pour continuer.'**
  String get missingBackground;

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un outil pour continuer.'**
  String get missingTool;

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une espèce pour continuer.'**
  String get missingSpecies;

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une catégorie de taille pour continuer.'**
  String get missingSize;

  /// Champ de recherche.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher une classe'**
  String get searchClass;

  /// Filtre de classes.
  ///
  /// In fr, this message translates to:
  /// **'Toutes'**
  String get filterAll;

  /// Filtre de classes.
  ///
  /// In fr, this message translates to:
  /// **'Martiales'**
  String get filterMartial;

  /// Filtre de classes.
  ///
  /// In fr, this message translates to:
  /// **'Lanceurs de sorts'**
  String get filterCasters;

  /// Filtre de classes.
  ///
  /// In fr, this message translates to:
  /// **'Homebrew'**
  String get filterHomebrew;

  /// Recherche vide.
  ///
  /// In fr, this message translates to:
  /// **'Aucun résultat.'**
  String get noResult;

  /// Conjonction entre deux valeurs.
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get orWord;

  /// Conjonction entre deux valeurs.
  ///
  /// In fr, this message translates to:
  /// **'et'**
  String get andWord;

  /// Détail de classe.
  ///
  /// In fr, this message translates to:
  /// **'Principale'**
  String get labelPrimary;

  /// Détail de classe.
  ///
  /// In fr, this message translates to:
  /// **'Dé de vie'**
  String get labelHitDie;

  /// Détail de classe.
  ///
  /// In fr, this message translates to:
  /// **'Jets de sauvegarde'**
  String get labelSaves;

  /// Détail de classe et d’Historique.
  ///
  /// In fr, this message translates to:
  /// **'Compétences'**
  String get labelSkills;

  /// Détail de classe.
  ///
  /// In fr, this message translates to:
  /// **'Armes'**
  String get labelWeapons;

  /// Détail de classe.
  ///
  /// In fr, this message translates to:
  /// **'Armures'**
  String get labelArmor;

  /// Détail de classe.
  ///
  /// In fr, this message translates to:
  /// **'Au niveau 1'**
  String get labelAtLevel1;

  /// Détail d’Historique.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques éligibles'**
  String get labelEligibleAbilities;

  /// Détail d’Historique.
  ///
  /// In fr, this message translates to:
  /// **'+2 / +1 ou +1 / +1 / +1, répartis à l’étape 5.'**
  String get bonusSpread;

  /// Détail d’Historique.
  ///
  /// In fr, this message translates to:
  /// **'Don d’origines'**
  String get labelOriginFeat;

  /// Détail d’Historique.
  ///
  /// In fr, this message translates to:
  /// **'Outil'**
  String get labelTool;

  /// Choix d’un outil.
  ///
  /// In fr, this message translates to:
  /// **'Type'**
  String get labelToolChoice;

  /// Détail d’espèce.
  ///
  /// In fr, this message translates to:
  /// **'Catégorie de taille'**
  String get labelSizeCategory;

  /// Maîtrise d’armes.
  ///
  /// In fr, this message translates to:
  /// **'Courantes'**
  String get weaponSimple;

  /// Maîtrise d’armes.
  ///
  /// In fr, this message translates to:
  /// **'De guerre'**
  String get weaponMartial;

  /// Maîtrise d’armes.
  ///
  /// In fr, this message translates to:
  /// **'De guerre (propriété Légère)'**
  String get weaponMartialLight;

  /// Maîtrise d’armes.
  ///
  /// In fr, this message translates to:
  /// **'De guerre (Finesse ou Légère)'**
  String get weaponMartialFinesseOrLight;

  /// Formation aux armures.
  ///
  /// In fr, this message translates to:
  /// **'Légères'**
  String get armorLight;

  /// Formation aux armures.
  ///
  /// In fr, this message translates to:
  /// **'Intermédiaires'**
  String get armorMedium;

  /// Formation aux armures.
  ///
  /// In fr, this message translates to:
  /// **'Lourdes'**
  String get armorHeavy;

  /// Formation aux armures.
  ///
  /// In fr, this message translates to:
  /// **'Boucliers'**
  String get armorShield;

  /// Formation aux armures.
  ///
  /// In fr, this message translates to:
  /// **'Aucune'**
  String get armorNone;

  /// Catégorie d’outil.
  ///
  /// In fr, this message translates to:
  /// **'boîte de jeux'**
  String get toolGamingSet;

  /// Catégorie d’outil.
  ///
  /// In fr, this message translates to:
  /// **'instrument de musique'**
  String get toolMusicalInstrument;

  /// Catégorie d’outil.
  ///
  /// In fr, this message translates to:
  /// **'outils d’artisan'**
  String get toolArtisan;

  /// Badge de source du pack SRD.
  ///
  /// In fr, this message translates to:
  /// **'SRD 5.2.1'**
  String get sourceSrd;

  /// Progression de l’assistant.
  ///
  /// In fr, this message translates to:
  /// **'Étape {step} sur {total}'**
  String stepOf(int step, int total);

  /// Surtitre de l’assistant.
  ///
  /// In fr, this message translates to:
  /// **'ÉTAPE {step} SUR {total}'**
  String stepEyebrow(int step, int total);

  /// Assistant : étape suivante, grand écran.
  ///
  /// In fr, this message translates to:
  /// **'Suivant : {step}'**
  String nextTo(String step);

  /// Carte de classe.
  ///
  /// In fr, this message translates to:
  /// **'Principale : {abilities}'**
  String classPrimary(String abilities);

  /// Puce de classe.
  ///
  /// In fr, this message translates to:
  /// **'Dé de vie d{faces}'**
  String classHitDie(int faces);

  /// Détail de classe.
  ///
  /// In fr, this message translates to:
  /// **'d{faces} par niveau'**
  String hitDiePerLevel(int faces);

  /// Compétences à choisir.
  ///
  /// In fr, this message translates to:
  /// **'{count} parmi {skills}'**
  String skillsAmong(int count, String skills);

  /// Carte d’Historique.
  ///
  /// In fr, this message translates to:
  /// **'Don : {feat}'**
  String featLine(String feat);

  /// Outil au choix.
  ///
  /// In fr, this message translates to:
  /// **'{category} (au choix)'**
  String toolChoiceLine(String category);

  /// Trait d’espèce à niveau.
  ///
  /// In fr, this message translates to:
  /// **'(niv. {level})'**
  String traitFromLevel(int level);

  /// Introduction de l’étape 4.
  ///
  /// In fr, this message translates to:
  /// **'Le commun, plus deux langues courantes.'**
  String get introLanguages;

  /// Sous-titre du Commun.
  ///
  /// In fr, this message translates to:
  /// **'Connu de tous les personnages'**
  String get commonLanguageHint;

  /// Titre de liste.
  ///
  /// In fr, this message translates to:
  /// **'Langues courantes'**
  String get standardLanguages;

  /// Bouton : langues au hasard.
  ///
  /// In fr, this message translates to:
  /// **'Tirer au sort'**
  String get drawLanguages;

  /// Règle affichée sous la liste.
  ///
  /// In fr, this message translates to:
  /// **'Langues rares (abyssal, céleste, infernal…) : seulement via une aptitude qui les accorde.'**
  String get rareLanguagesRule;

  /// Titre de section.
  ///
  /// In fr, this message translates to:
  /// **'Acquisition par points'**
  String get pointBuy;

  /// Répartition des bonus.
  ///
  /// In fr, this message translates to:
  /// **'+2 et +1'**
  String get distributionTwoOne;

  /// Répartition des bonus.
  ///
  /// In fr, this message translates to:
  /// **'+1, +1 et +1'**
  String get distributionOnes;

  /// En-tête de colonne.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristique'**
  String get labelAbility;

  /// En-tête de colonne.
  ///
  /// In fr, this message translates to:
  /// **'Base'**
  String get labelBase;

  /// En-tête de colonne.
  ///
  /// In fr, this message translates to:
  /// **'Total'**
  String get labelTotal;

  /// Ligne de bonus.
  ///
  /// In fr, this message translates to:
  /// **'Éligible'**
  String get eligible;

  /// Ligne de bonus.
  ///
  /// In fr, this message translates to:
  /// **'Le +1 doit aller ailleurs'**
  String get plusOneElsewhere;

  /// Ligne de bonus.
  ///
  /// In fr, this message translates to:
  /// **'Le +2 doit aller ailleurs'**
  String get plusTwoElsewhere;

  /// Bandeau de choix devenu invalide.
  ///
  /// In fr, this message translates to:
  /// **'Bonus à refaire'**
  String get bonusInvalidTitle;

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'Placez vos bonus d’Historique pour continuer.'**
  String get missingBonus;

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'Placez vos bonus sur des caractéristiques éligibles pour continuer.'**
  String get missingBonusInvalid;

  /// Compteur de sélection.
  ///
  /// In fr, this message translates to:
  /// **'{count} / {total}'**
  String countOf(int count, int total);

  /// Budget de points.
  ///
  /// In fr, this message translates to:
  /// **'{spent} / {total} points'**
  String pointsOf(int spent, int total);

  /// Coût d’une valeur.
  ///
  /// In fr, this message translates to:
  /// **'coût {cost}'**
  String costOf(int cost);

  /// Rappel des coûts.
  ///
  /// In fr, this message translates to:
  /// **'Coûts : {costs}. Valeur entre {min} et {max} avant bonus.'**
  String pointBuyCosts(String costs, int min, int max);

  /// Bouton +.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter {ability}'**
  String raiseAbility(String ability);

  /// Bouton −.
  ///
  /// In fr, this message translates to:
  /// **'Diminuer {ability}'**
  String lowerAbility(String ability);

  /// Introduction de l’étape 5.
  ///
  /// In fr, this message translates to:
  /// **'Répartissez vos {points} points, puis appliquez les bonus de votre Historique.'**
  String introAbilities(int points);

  /// Titre de section.
  ///
  /// In fr, this message translates to:
  /// **'Bonus d’Historique · {background}'**
  String backgroundBonus(String background);

  /// Sous-titre des bonus.
  ///
  /// In fr, this message translates to:
  /// **'{abilities} · plafond {cap}'**
  String bonusCap(String abilities, int cap);

  /// Ligne de bonus.
  ///
  /// In fr, this message translates to:
  /// **'Non éligible pour {background}'**
  String notEligibleFor(String background);

  /// Nom lu d’une bascule.
  ///
  /// In fr, this message translates to:
  /// **'+{value} sur {ability}'**
  String bonusOn(int value, String ability);

  /// Bandeau de choix devenu invalide.
  ///
  /// In fr, this message translates to:
  /// **'Le bonus placé sur {abilities} n’est plus valide. {background} n’autorise les bonus que sur {allowed}.'**
  String bonusInvalidMessage(
    String abilities,
    String background,
    String allowed,
  );

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Choisissez encore 1 langue pour continuer.} other{Choisissez encore {count} langues pour continuer.}}'**
  String missingLanguages(int count);

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Il reste 1 point à dépenser.} other{Il reste {count} points à dépenser.}}'**
  String missingPoints(int count);

  /// Étape franchie devenue invalide.
  ///
  /// In fr, this message translates to:
  /// **'À refaire'**
  String get stepToRedo;

  /// Introduction de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Les choix laissés ouverts par votre classe, votre Historique et votre espèce. Les options impossibles sont grisées, avec la règle qui les bloque.'**
  String get introSubchoices;

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Outils à choisir'**
  String get classToolsTitle;

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Bottes d’arme'**
  String get weaponMasteryTitle;

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Style de combat'**
  String get fightingStyleTitle;

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Don d’origines'**
  String get originFeatTitle;

  /// Panneau de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'À compléter'**
  String get toComplete;

  /// Don indisponible.
  ///
  /// In fr, this message translates to:
  /// **'Déjà obtenu par l’Historique · non répétable'**
  String get featNotRepeatable;

  /// Règle affichée sous l’Expertise.
  ///
  /// In fr, this message translates to:
  /// **'L’Expertise ne porte que sur une compétence que vous maîtrisez déjà.'**
  String get expertiseRule;

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Compétences de {cls}'**
  String classSkillsOf(String cls);

  /// Règle sous une section.
  ///
  /// In fr, this message translates to:
  /// **'{names} : déjà maîtrisé, une maîtrise ne se prend pas deux fois.'**
  String alreadyKnownRule(String names);

  /// Choix devenu invalide.
  ///
  /// In fr, this message translates to:
  /// **'À refaire : {names}.'**
  String choiceToRedo(String names);

  /// Panneau À compléter.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Encore 1 choix} other{Encore {count} choix}}'**
  String choicesLeft(int count);

  /// Suivant bloqué.
  ///
  /// In fr, this message translates to:
  /// **'À compléter : {title}.'**
  String missingSubchoice(String title);

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'{name} : {title}'**
  String choiceTitle(String name, String title);

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Sorts mineurs de {cls}'**
  String cantripsOf(String cls);

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Sorts préparés de {cls}'**
  String preparedSpellsOf(String cls);

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'Grimoire'**
  String get spellbookTitle;

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'{feat} : liste de sorts'**
  String initiateListTitle(String feat);

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'{feat} : caractéristique d’incantation'**
  String initiateAbilityTitle(String feat);

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'{feat} : sorts mineurs'**
  String initiateCantripsTitle(String feat);

  /// Section de l’étape 6.
  ///
  /// In fr, this message translates to:
  /// **'{feat} : sort du 1er niveau'**
  String initiateSpellTitle(String feat);

  /// Règle sous la liste de sorts.
  ///
  /// In fr, this message translates to:
  /// **'Ce don se reprend avec une autre liste de sorts.'**
  String get sameListRule;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
