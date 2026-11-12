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

  /// Fiche du personnage.
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

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'Tout'**
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

  /// Montée de niveau.
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
  /// **'Fixez vos six valeurs selon la méthode choisie, puis appliquez les bonus de votre Historique.'**
  String get introAbilities;

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

  /// Règle sous une section de sorts.
  ///
  /// In fr, this message translates to:
  /// **'{names} : déjà connu, un sort ne se prend pas deux fois.'**
  String spellKnownRule(String names);

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Un lot de votre classe et un de votre Historique, ou leur valeur en or.'**
  String get introEquipment;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Qui est votre personnage ? Seul le nom est obligatoire.'**
  String get introDetails;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Votre personnage tel que les règles le calculent.'**
  String get introSummary;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveCharacter;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'L’enregistrement a échoué. Votre brouillon est conservé, réessayez.'**
  String get saveFailed;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Lot {letter}'**
  String lotName(String letter);

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'un outil au choix'**
  String get lotTool;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Outil du lot'**
  String get lotToolChoice;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'{count} po'**
  String goldPieces(int count);

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'CA avec cet équipement'**
  String get armorClassWithEquipment;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Or de départ'**
  String get startingGold;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un lot de classe.'**
  String get missingClassEquipment;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez le lot de l’Historique ou son or.'**
  String get missingBackgroundEquipment;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez l’outil du lot.'**
  String get missingEquipmentTool;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Donnez un nom à votre personnage.'**
  String get missingName;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Corrigez les erreurs de règle avant d’enregistrer.'**
  String get missingRules;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Nom *'**
  String get detailName;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Alignement'**
  String get detailAlignment;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Apparence'**
  String get detailAppearance;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Personnalité'**
  String get detailPersonality;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Histoire'**
  String get detailBackstory;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Loyal Bon'**
  String get alignmentLB;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Neutre Bon'**
  String get alignmentNB;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Chaotique Bon'**
  String get alignmentCB;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Loyal Neutre'**
  String get alignmentLN;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Neutre'**
  String get alignmentN;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Chaotique Neutre'**
  String get alignmentCN;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Loyal Mauvais'**
  String get alignmentLM;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Neutre Mauvais'**
  String get alignmentNM;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Chaotique Mauvais'**
  String get alignmentCM;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'{cls} {level}'**
  String classLevel(String cls, int level);

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'JS {value}'**
  String savingThrow(String value);

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'PV max'**
  String get statHitPoints;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'CA'**
  String get statArmorClass;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Initiative'**
  String get statInitiative;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Vitesse'**
  String get statSpeed;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrise'**
  String get statProficiency;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Percep. passive'**
  String get statPassivePerception;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Maîtrises'**
  String get summaryProficiencies;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Outils'**
  String get summaryTools;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Langues'**
  String get summaryLanguages;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Attaques'**
  String get summaryAttacks;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Aptitudes et dons'**
  String get summaryFeatures;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Sorts'**
  String get summarySpells;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Vérification des règles'**
  String get summaryChecks;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Erreur de règle'**
  String get ruleError;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Botte sur une arme absente'**
  String get masteryWithoutWeaponTitle;

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Votre équipement ne contient pas : {names}. Cela ne bloque pas l’enregistrement.'**
  String masteryWithoutWeapon(String names);

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Acquisition par points : {spent} / {budget}'**
  String checkPoints(int spent, int budget);

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Bonus d’Historique : {bonuses}'**
  String checkBonus(String bonuses);

  /// Étapes 7 à 9 de la création.
  ///
  /// In fr, this message translates to:
  /// **'Packs : {packs}'**
  String checkPacks(String packs);

  /// Attaque sans arme, au Récapitulatif.
  ///
  /// In fr, this message translates to:
  /// **'Mains nues'**
  String get unarmedStrike;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Principal'**
  String get tabMain;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Compétences'**
  String get tabSkills;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Combat'**
  String get tabCombat;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Sorts'**
  String get tabSpells;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Inventaire'**
  String get tabInventory;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Aptitudes'**
  String get tabFeatures;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Notes'**
  String get tabNotes;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Retour'**
  String get back;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Ce personnage est introuvable.'**
  String get characterNotFound;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques'**
  String get abilitiesTitle;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Touchez une valeur : décomposition'**
  String get tapForBreakdown;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'FOR'**
  String get abbrStr;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'DEX'**
  String get abbrDex;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'CON'**
  String get abbrCon;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'INT'**
  String get abbrInt;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'SAG'**
  String get abbrWis;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'CHA'**
  String get abbrCha;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Expertise'**
  String get expertise;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Utilisée par'**
  String get usedBy;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristique'**
  String get categoryAbility;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Compétence'**
  String get categorySkill;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Statistique'**
  String get categoryStat;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Valeur de base'**
  String get breakdownBase;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Bonus de maîtrise'**
  String get breakdownProficiency;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Création'**
  String get sourceCreation;

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Modificateur de {ability}'**
  String breakdownModifier(String ability);

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'JS {ability}'**
  String savingThrowOf(String ability);

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Modificateur {modifier} = ({score} − 10) ÷ 2, arrondi à l’inférieur'**
  String modifierRule(String modifier, int score);

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'Niveau de personnage {level}'**
  String proficiencyByLevel(int level);

  /// Fiche du personnage.
  ///
  /// In fr, this message translates to:
  /// **'{ability} {score}, modificateur {modifier}, jet de sauvegarde {save}'**
  String abilitySemantics(
    String ability,
    int score,
    String modifier,
    String save,
  );

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'Ressources'**
  String get resourcesTitle;

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'toucher'**
  String get toHit;

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'dégâts'**
  String get damageLabel;

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'Attaque'**
  String get categoryAttack;

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'repos court'**
  String get rechargeShortRest;

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'repos long'**
  String get rechargeLongRest;

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'Avec utilisations'**
  String get filterWithUses;

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'Dons'**
  String get filterFeats;

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'{available} utilisations sur {total}'**
  String usesOf(int available, int total);

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'Bottes d’arme {chosen} / {slots}'**
  String masteriesCount(int chosen, int slots);

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'Botte : {name}'**
  String masteryOn(String name);

  /// Fiche : onglets Combat et Aptitudes.
  ///
  /// In fr, this message translates to:
  /// **'{count} en réserve'**
  String inReserve(int count);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Monter au niveau {level}'**
  String levelUpTo(int level);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Montée de niveau'**
  String get levelUpTitle;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'{cls} {from} → {to}'**
  String levelFromTo(String cls, int from, int to);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'+{count} PV'**
  String hitPointsGain(int count);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Moyenne du dé de vie et modificateur de Constitution.'**
  String get hitPointsAverage;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Aptitudes gagnées'**
  String get featuresGained;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Sous-classe'**
  String get subclassTitle;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Nouvelle botte} other{{count} nouvelles bottes}}'**
  String masteriesGained(int count);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Amélioration de caractéristique ou autre don'**
  String get featChoiceTitle;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Seuls les dons dont vous remplissez les conditions sont sélectionnables.'**
  String get featChoiceHint;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'+2 à une'**
  String get improvementTwo;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'+1 à deux'**
  String get improvementOneAndOne;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Ce qui change'**
  String get whatChanges;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Dés de vie'**
  String get hitDiceLabel;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une sous-classe.'**
  String get missingSubclass;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Faites les choix de ce niveau.'**
  String get missingLevelChoice;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez votre nouvelle botte.'**
  String get missingMastery;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez un don.'**
  String get missingFeat;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez où porter le bonus.'**
  String get missingFeatBonus;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Niveau insuffisant'**
  String get featBlockLevel;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristique insuffisante'**
  String get featBlockAbility;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Aptitude requise manquante'**
  String get featBlockFeature;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Déjà obtenu · non répétable'**
  String get featBlockNotRepeatable;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Prêt à enregistrer'**
  String get levelUpReady;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Don accordé par ce niveau'**
  String get featChoiceOther;

  /// Montée de niveau : sorts.
  ///
  /// In fr, this message translates to:
  /// **'Choisissez vos sorts.'**
  String get missingSpells;

  /// Montée de niveau : sorts.
  ///
  /// In fr, this message translates to:
  /// **'{title} {chosen} / {count}'**
  String spellSectionCount(String title, int chosen, int count);

  /// Montée de niveau : sorts.
  ///
  /// In fr, this message translates to:
  /// **'Un sort déjà connu ne se prend pas deux fois.'**
  String get spellKnownShort;

  /// Montée de niveau : sorts.
  ///
  /// In fr, this message translates to:
  /// **'Liste de sorts'**
  String get initiateListChoice;

  /// Montée de niveau : sorts.
  ///
  /// In fr, this message translates to:
  /// **'Caractéristique d’incantation'**
  String get initiateAbilityChoice;

  /// Montée de niveau : sorts.
  ///
  /// In fr, this message translates to:
  /// **'Sorts mineurs'**
  String get initiateCantripChoice;

  /// Montée de niveau : sorts.
  ///
  /// In fr, this message translates to:
  /// **'Sort du 1er niveau'**
  String get initiateSpellChoice;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Quelle classe pour le niveau {level} ?'**
  String classForLevel(int level);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get continueClass;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Multiclasser · niveau 1 dans une autre classe'**
  String get multiclassHeading;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{{names} {minimum} requise} other{{names} {minimum} requis}}'**
  String multiclassNeeds(int count, String names, int minimum);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **' et '**
  String get abilityAnd;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **' ou '**
  String get abilityOr;

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'{ability} {score} ✓'**
  String abilityReached(String ability, int score);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'{ability} {score} : il manque {missing}'**
  String abilityMissing(String ability, int score, int missing);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Multiclasser demande {minimum} dans la caractéristique principale de la nouvelle classe et de la classe actuelle.'**
  String multiclassRule(int minimum);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Compétence de {cls}'**
  String multiclassSkill(String cls);

  /// Montée de niveau.
  ///
  /// In fr, this message translates to:
  /// **'Instrument de {cls}'**
  String multiclassTool(String cls);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Abjuration'**
  String get schoolAbjuration;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Invocation'**
  String get schoolConjuration;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Divination'**
  String get schoolDivination;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Enchantement'**
  String get schoolEnchantment;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Évocation'**
  String get schoolEvocation;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Illusion'**
  String get schoolIllusion;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Nécromancie'**
  String get schoolNecromancy;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Transmutation'**
  String get schoolTransmutation;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Personnelle'**
  String get rangeSelf;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Contact'**
  String get rangeTouch;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'À vue'**
  String get rangeSight;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Illimitée'**
  String get rangeUnlimited;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Spéciale'**
  String get rangeSpecial;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'DD des sorts'**
  String get spellSaveDcTitle;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Attaque de sort'**
  String get spellAttack;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Emplacements'**
  String get spellSlotsTitle;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Emplacements combinés'**
  String get spellSlotsCombined;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Magie de pacte'**
  String get pactMagicTitle;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Récupérés au repos court.'**
  String get pactRecharge;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Toujours préparé'**
  String get alwaysPrepared;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Au grimoire'**
  String get inSpellbook;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Concentration'**
  String get concentration;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Rituel'**
  String get ritual;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'C'**
  String get badgeConcentration;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'R'**
  String get badgeRitual;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Aucun sort'**
  String get noSpells;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Ce personnage ne lance pas de sorts. Le don Initié à la magie, pris à une prochaine Amélioration de caractéristique, lui en donnerait.'**
  String get noSpellsHint;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Préparés'**
  String get filterPrepared;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Rituels'**
  String get filterRituals;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Aucun sort pour ce filtre.'**
  String get noSpellMatches;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Sorts mineurs'**
  String get cantripsHeading;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'V'**
  String get componentVerbal;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'S'**
  String get componentSomatic;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Incantation'**
  String get spellCasting;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Portée'**
  String get spellRange;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Composantes'**
  String get spellComponents;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Durée'**
  String get spellDuration;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Composante matérielle'**
  String get spellMaterial;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Consommée par le sort'**
  String get materialConsumed;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{label} ÷ 2'**
  String casterHalf(String label);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{sum} (arrondi supérieur)'**
  String casterRounded(String sum);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{sum} = {level}'**
  String casterSum(String sum, int level);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'DD ({ability})'**
  String spellSaveDc(String ability);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Préparés : {count} / {max}'**
  String preparedOfMax(int count, int max);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{level, plural, =1{1er} other{{level}e}}'**
  String slotLevel(int level);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{available} emplacements sur {total} du niveau {level}'**
  String slotsOf(int level, int available, int total);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{slots} emplacements du {level}e niveau'**
  String pactSlots(int slots, int level);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Plus 1 sort toujours préparé} other{Plus {count} sorts toujours préparés}}'**
  String alwaysPreparedCount(int count);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{level, plural, =1{1er niveau} other{{level}e niveau}}'**
  String spellLevelName(int level);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'M ({material})'**
  String componentMaterial(String material);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Sort mineur · {school}'**
  String cantripOf(String school);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{school} du {level}'**
  String spellOfLevel(String school, String level);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Concentration, {duration}'**
  String durationConcentration(String duration);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Tous'**
  String get filterAllSpells;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Lancer'**
  String get castSpell;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Emplacement'**
  String get castSlotTitle;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'En rituel, sans emplacement'**
  String get castRitual;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{level} ({left, plural, =1{1 restant} other{{left} restants}})'**
  String castSlot(String level, int left);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{level}, pacte ({left, plural, =1{1 restant} other{{left} restants}})'**
  String castPactSlot(String level, int left);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Concentration en cours'**
  String get concentrationActive;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Mettre fin'**
  String get endConcentration;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Le lancer met fin à {spell} : un seul sort de concentration à la fois.'**
  String replacesConcentration(String spell);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Mettre fin à {spell} ?'**
  String replaceConcentrationTitle(String spell);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Un seul sort de concentration à la fois.'**
  String get replaceConcentrationHint;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Lancer quand même'**
  String get confirmCast;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancelCast;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Modifier mes sorts'**
  String get changeSpells;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get saveSpells;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Après un Repos long, vous pouvez changer votre liste de sorts préparés. Un sort mineur se remplace quand vous gagnez un niveau, ou après un Repos long pour le Magicien.'**
  String get changeRuleLongRestAll;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Après un Repos long, vous pouvez remplacer un sort préparé.'**
  String get changeRuleLongRestOne;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Quand vous gagnez un niveau, vous pouvez remplacer un sort préparé et un sort mineur.'**
  String get changeRuleLevelUp;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Grimoire : {count, plural, =1{1 sort} other{{count} sorts}}'**
  String spellbookCount(int count);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Copier un sort'**
  String get copySpellAction;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Copier'**
  String get copySpellConfirm;

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{hours} heures et {gold} po par niveau de sort.'**
  String copySpellRule(int hours, int gold);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'{level} · {gold} po'**
  String copySpellLevel(String level, int gold);

  /// Onglet Sorts.
  ///
  /// In fr, this message translates to:
  /// **'Sans emplacement ({left, plural, =1{1 restant} other{{left} restants}})'**
  String castFree(int left);

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'pp'**
  String get coinPlatinum;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'po'**
  String get coinGold;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'pe'**
  String get coinElectrum;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'pa'**
  String get coinSilver;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'pc'**
  String get coinCopper;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Harmonisation requise'**
  String get attunementRequired;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Tous vos emplacements d’harmonisation sont pris.'**
  String get attunementFull;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'S’harmoniser'**
  String get attune;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Mettre fin à l’harmonisation'**
  String get endAttunement;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Équiper'**
  String get equip;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Ranger au sac'**
  String get unequip;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Équipé'**
  String get itemsWorn;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Sac'**
  String get itemsBag;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un objet'**
  String get addItem;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Rechercher un objet'**
  String get searchItem;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Aucun objet trouvé.'**
  String get noItemMatches;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Votre sac est vide.'**
  String get emptyInventory;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'En ajouter un'**
  String get addOne;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'En retirer un'**
  String get removeOne;

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'× {count}'**
  String itemQuantity(int count);

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'Harmonisation {count} / {max}'**
  String attunementCount(int count, int max);

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'CA {value}'**
  String armorClassValue(int value);

  /// Onglet Inventaire.
  ///
  /// In fr, this message translates to:
  /// **'+{value} à la CA'**
  String armorShieldBonus(int value);

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Repos court'**
  String get shortRest;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Repos long'**
  String get longRest;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 1 heure · il faut au moins 1 PV'**
  String get shortRestHint;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Au moins 8 heures, dont 6 de sommeil. Prochain repos long possible 16 h après celui-ci.'**
  String get longRestHint;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Il faut au moins 1 PV pour se reposer.'**
  String get restNeedsHitPoint;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Dés de vie dépensés'**
  String get hitDiceSpent;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Saisir mon jet'**
  String get enterRoll;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Utiliser'**
  String get useResource;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Perdre 1 PV'**
  String get loseHitPoint;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Regagner 1 PV'**
  String get gainHitPoint;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Récupéré à la fin du repos'**
  String get recoveredTitle;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Rien à récupérer de plus.'**
  String get nothingToRecover;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Récupérés'**
  String get slotsRecovered;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Épuisement'**
  String get exhaustion;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Concentration terminée'**
  String get concentrationEnds;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Terminer le repos court'**
  String get finishShortRest;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'Terminer le repos'**
  String get finishLongRest;

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'PV {current} / {max}'**
  String hitPointsOf(int current, int max);

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'{before} → {after} / {max}'**
  String hitPointsChange(int before, int after, int max);

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'restants : {left} / {total} {die}'**
  String hitDiceLeft(int left, int total, String die);

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'{before} → {total} {die}'**
  String hitDiceChange(int before, int total, String die);

  /// Repos et suivi de jeu.
  ///
  /// In fr, this message translates to:
  /// **'{before} → {after} / {max}'**
  String recoveredUses(int before, int after, int max);

  /// Consommables et Inspiration.
  ///
  /// In fr, this message translates to:
  /// **'Inspiration héroïque'**
  String get inspirationHeld;

  /// Consommables et Inspiration.
  ///
  /// In fr, this message translates to:
  /// **'Pas d’Inspiration héroïque'**
  String get inspirationNone;

  /// Consommables et Inspiration.
  ///
  /// In fr, this message translates to:
  /// **'Obtenue'**
  String get inspirationGained;

  /// Consommables et Inspiration.
  ///
  /// In fr, this message translates to:
  /// **'Recevoir'**
  String get receiveInspiration;

  /// Consommables et Inspiration.
  ///
  /// In fr, this message translates to:
  /// **'Action Bonus'**
  String get actionBonus;

  /// Consommables et Inspiration.
  ///
  /// In fr, this message translates to:
  /// **'Action'**
  String get actionPlain;

  /// Consommables et Inspiration.
  ///
  /// In fr, this message translates to:
  /// **'{action} · {dice} + {bonus} PV · ×{count} dans le sac'**
  String consumableLine(String action, String dice, int bonus, int count);

  /// Consommables et Inspiration.
  ///
  /// In fr, this message translates to:
  /// **'PV {before} → {after} / {max} · quantité {from} → {to}'**
  String consumableResult(int before, int after, int max, int from, int to);

  /// Suggestions.
  ///
  /// In fr, this message translates to:
  /// **'Suggérer'**
  String get suggest;

  /// Suggestions.
  ///
  /// In fr, this message translates to:
  /// **'Suggestion appliquée, modifiable'**
  String get suggestionApplied;

  /// Suggestions.
  ///
  /// In fr, this message translates to:
  /// **'{first} en tête, puis {second}, selon les valeurs standard de votre classe.'**
  String suggestScoresReason(String first, String second);

  /// Suggestions.
  ///
  /// In fr, this message translates to:
  /// **'Les compétences de votre caractéristique principale, celles où vous brillez d’emblée.'**
  String get suggestSkillsReason;

  /// Suggestions.
  ///
  /// In fr, this message translates to:
  /// **'Les armes de votre équipement de départ d’abord.'**
  String get suggestMasteriesReason;

  /// Suggestions.
  ///
  /// In fr, this message translates to:
  /// **'Augmenter {abilities} renforce ce que fait votre classe.'**
  String suggestImprovementReason(String abilities);

  /// Termes cliquables.
  ///
  /// In fr, this message translates to:
  /// **'{term}, définition'**
  String ruleTermLabel(String term);

  /// Termes cliquables.
  ///
  /// In fr, this message translates to:
  /// **'Glossaire · SRD 5.2.1'**
  String get ruleTermSource;

  /// Jet simple.
  ///
  /// In fr, this message translates to:
  /// **'Relancer'**
  String get reroll;

  /// Jet simple.
  ///
  /// In fr, this message translates to:
  /// **'Résultat du {dice} (modifiable avant validation)'**
  String rollResultOf(String dice);

  /// Jet simple.
  ///
  /// In fr, this message translates to:
  /// **'Résultat impossible pour {dice}.'**
  String rollImpossible(String dice);

  /// Jet simple.
  ///
  /// In fr, this message translates to:
  /// **'Dépenser le {die}'**
  String spendHitDie(String die);

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Bienvenue'**
  String get signInWelcome;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Un compte sert à rejoindre des tables et à synchroniser vos fiches.'**
  String get signInPurpose;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get signInTitle;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get emailLabel;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordLabel;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Afficher le mot de passe'**
  String get showPassword;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Masquer le mot de passe'**
  String get hidePassword;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié ?'**
  String get forgotPasswordLink;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Se connecter'**
  String get signInAction;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'E-mail ou mot de passe incorrect. Vérifiez la saisie, ou réinitialisez votre mot de passe.'**
  String get signInInvalid;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Le serveur ne répond pas. Vérifiez votre connexion et réessayez.'**
  String get signInNetworkError;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Connexion impossible pour le moment. Réessayez dans quelques minutes.'**
  String get signInFailed;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Pas de connexion internet'**
  String get offlineTitle;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'La première connexion sur cet appareil demande le réseau. Le bouton se réactive dès que la connexion revient ; rien n’est enregistré en attendant.'**
  String get offlineFirstSignIn;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'La première connexion demande le réseau, ensuite tout fonctionne hors-ligne.'**
  String get signInFooter;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Votre table, même sans réseau'**
  String get signInTagline;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Fiches de personnage, combats et notes de séance, compatibles avec la cinquième édition. Une fois connecté, tout fonctionne hors-ligne.'**
  String get signInPitch;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Déjà connecté sur cet appareil ? Vos données s’ouvrent sans réseau.'**
  String get signInDesktopFooter;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe oublié'**
  String get forgotTitle;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Indiquez l’e-mail de votre compte : vous recevrez un lien pour choisir un nouveau mot de passe.'**
  String get forgotIntro;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Envoyer le lien'**
  String get forgotSend;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre boîte mail'**
  String get forgotSentTitle;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Si un compte existe pour {email}, un lien vient d’y être envoyé. Il est valable 1 heure. Pensez à regarder dans les courriers indésirables.'**
  String forgotSentBody(String email);

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le lien dans {time}'**
  String forgotResendIn(String time);

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer le lien'**
  String get forgotResend;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Revenir à la connexion'**
  String get backToSignIn;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Compte créé avec Google ou Apple : pas de mot de passe à réinitialiser, utilisez le même bouton qu’à l’inscription.'**
  String get forgotSocialNote;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordTitle;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Compte {email} · lien valable encore {minutes} min.'**
  String newPasswordAccount(String email, int minutes);

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Compte {email}'**
  String newPasswordAccountOnly(String email);

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Nouveau mot de passe'**
  String get newPasswordLabel;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Confirmer le mot de passe'**
  String get confirmPasswordLabel;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Les deux mots de passe diffèrent.'**
  String get passwordMismatch;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Robustesse : {level}'**
  String passwordStrength(String level);

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'très faible'**
  String get passwordStrength0;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'faible'**
  String get passwordStrength1;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'moyenne'**
  String get passwordStrength2;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'correcte'**
  String get passwordStrength3;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'forte'**
  String get passwordStrength4;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'10 caractères au moins'**
  String get ruleLength;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Différent de votre e-mail et de votre pseudo'**
  String get ruleIdentity;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Absent des listes de mots de passe divulgués'**
  String get ruleBreached;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Respecté'**
  String get ruleMet;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Non respecté'**
  String get ruleUnmet;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Vérification…'**
  String get rulePending;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Déconnecter mes autres appareils'**
  String get signOutOthers;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Leurs données locales sont conservées ; il faudra se reconnecter pour synchroniser.'**
  String get signOutOthersHint;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer et se connecter'**
  String get savePasswordAndSignIn;

  /// Connexion et mot de passe (US-39, écrans A1 à A4).
  ///
  /// In fr, this message translates to:
  /// **'Enregistrement impossible sans réseau. Réessayez une fois connecté.'**
  String get savePasswordNetworkError;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Connexion'**
  String get signInTab;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Inscription'**
  String get signUpTab;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Pseudonyme affiché'**
  String get pseudonymLabel;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get birthDateLabel;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'JJ/MM/AAAA'**
  String get birthDateHint;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Date invalide : utilisez le format JJ/MM/AAAA.'**
  String get birthDateInvalid;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Il faut avoir au moins 15 ans pour créer un compte.'**
  String get tooYoung;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Créer le compte'**
  String get signUpAction;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Vérifiez votre boîte mail'**
  String get signUpConfirmTitle;

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Si l’adresse {email} peut recevoir un compte, un lien de confirmation vient d’y être envoyé. Pensez à regarder dans les courriers indésirables.'**
  String signUpConfirmBody(String email);

  /// Inscription (US-12, écran T2).
  ///
  /// In fr, this message translates to:
  /// **'Inscription impossible pour le moment. Réessayez dans quelques minutes.'**
  String get signUpFailed;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Envoyer les rapports de plantage ?'**
  String get consentTitle;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Si l’application plante, un rapport technique nous aide à corriger le problème.'**
  String get consentBody;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Aucune donnée de jeu, aucune fiche, aucun contenu personnel.'**
  String get consentNoGameData;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Aucune mesure d’usage.'**
  String get consentNoUsage;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Modifiable à tout moment dans Réglages.'**
  String get consentChangeable;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Refuser'**
  String get consentRefuse;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Accepter'**
  String get consentAccept;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Profil et réglages'**
  String get profileTitle;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Non connecté'**
  String get profileSignedOut;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Affichage'**
  String get displaySection;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Langue'**
  String get languageLabel;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Français'**
  String get languageFrench;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Taille du texte'**
  String get textSizeLabel;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'{percent} %'**
  String textSizeValue(int percent);

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Thème'**
  String get themeLabel;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Sombre'**
  String get themeDark;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Clair'**
  String get themeLight;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Système'**
  String get themeSystem;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Le thème clair arrive dans une prochaine version.'**
  String get themeLightSoon;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Confidentialité'**
  String get privacySection;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Rapports de plantage'**
  String get crashReportsLabel;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Sans données de jeu ni contenu personnel'**
  String get crashReportsHint;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter'**
  String get signOut;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Modifications non envoyées'**
  String get signOutPendingTitle;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{1 modification n’a pas encore été envoyée. Elle sera perdue si vous vous déconnectez maintenant.} other{{count} modifications n’ont pas encore été envoyées. Elles seront perdues si vous vous déconnectez maintenant.}}'**
  String signOutPendingBody(int count);

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Se déconnecter quand même'**
  String get signOutAnyway;

  /// Profil, réglages et consentement (US-12, écrans T1, T5, A7).
  ///
  /// In fr, this message translates to:
  /// **'Annuler'**
  String get cancel;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Appareils connectés'**
  String get devicesSection;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'{browser} sur {platform}'**
  String deviceBrowserOn(String browser, String platform);

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Windows'**
  String get platformWindows;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'macOS'**
  String get platformMacos;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Linux'**
  String get platformLinux;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Android'**
  String get platformAndroid;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'iPhone'**
  String get platformIphone;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'iPad'**
  String get platformIpad;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Téléphone Android'**
  String get deviceAndroidPhone;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Tablette Android'**
  String get deviceAndroidTablet;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Appareil inconnu'**
  String get deviceUnknown;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Cet appareil · actif maintenant'**
  String get thisDeviceNow;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Actif maintenant'**
  String get activeNow;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Il y a {count} min'**
  String activeMinutes(int count);

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Il y a 1 heure} other{Il y a {count} heures}}'**
  String activeHours(int count);

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Il y a 1 jour} other{Il y a {count} jours}}'**
  String activeDays(int count);

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'{count, plural, =1{Il y a 1 semaine} other{Il y a {count} semaines}}'**
  String activeWeeks(int count);

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Il y a {count} mois'**
  String activeMonths(int count);

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'Déconnecter'**
  String get revokeDevice;

  /// Appareils connectés (US-12, EF-CPT-05, écrans T5 et A7).
  ///
  /// In fr, this message translates to:
  /// **'La liste des appareils demande le réseau.'**
  String get devicesOffline;

  /// Lien de confirmation ou de réinitialisation expiré (US-12, US-39).
  ///
  /// In fr, this message translates to:
  /// **'Ce lien a expiré ou a déjà servi. Si votre adresse est confirmée, connectez-vous ; sinon, demandez un nouveau lien avec « Mot de passe oublié ? ».'**
  String get authLinkInvalid;

  /// Renvoi de l’e-mail de confirmation d’inscription (US-12).
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer l’e-mail de confirmation'**
  String get resendConfirmation;

  /// Renvoi de l’e-mail de confirmation d’inscription (US-12).
  ///
  /// In fr, this message translates to:
  /// **'Renvoyer l’e-mail dans {time}'**
  String resendConfirmationIn(String time);

  /// Renvoi de l’e-mail de confirmation d’inscription (US-12).
  ///
  /// In fr, this message translates to:
  /// **'Si un compte attend une confirmation pour {email}, un nouveau lien vient d’y être envoyé.'**
  String confirmationResent(String email);

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Modifier le compte'**
  String get editAccountTitle;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Modifier'**
  String get editAccountAction;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Enregistrer'**
  String get accountSave;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Profil'**
  String get profileSection;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Avatar'**
  String get avatarLabel;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Image carrée, compressée à 200 Ko. Visible des membres de vos tables.'**
  String get avatarHint;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Visible des autres membres. Modifiable hors-ligne : la modification part à la synchronisation.'**
  String get pseudonymHint;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'E-mail'**
  String get emailSection;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Un lien de confirmation sera envoyé à la nouvelle adresse. {email} reste active jusqu’à la confirmation, et sera prévenue du changement.'**
  String emailChangeHint(String email);

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Changer le mot de passe'**
  String get changePasswordSection;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe actuel'**
  String get currentPasswordLabel;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'L’e-mail et le mot de passe demandent le réseau : ils sont vérifiés par le serveur.'**
  String get networkFieldsNote;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe actuel incorrect.'**
  String get wrongCurrentPassword;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Un lien de confirmation a été envoyé à {email}. Votre adresse actuelle reste active jusqu’à la confirmation.'**
  String emailChangeSent(String email);

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Modifications enregistrées.'**
  String get accountSaved;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'L’e-mail et le mot de passe demandent le réseau. Réessayez une fois connecté.'**
  String get accountNetworkError;

  /// Modifier le compte (US-40, écran A5).
  ///
  /// In fr, this message translates to:
  /// **'Le pseudonyme ne peut pas être vide.'**
  String get pseudonymRequired;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Continuer avec Google'**
  String get continueWithGoogle;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'ou'**
  String get orSeparator;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Date de naissance'**
  String get ageTitle;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Avant de continuer, indiquez votre date de naissance : il faut avoir au moins 15 ans pour utiliser un compte. Elle sert à la vérification et n’est pas conservée.'**
  String get ageIntro;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Continuer'**
  String get ageContinue;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Il faut avoir au moins 15 ans pour créer un compte. Votre compte Google n’a pas été conservé.'**
  String get ageRefused;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Méthodes de connexion'**
  String get methodsSection;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Active'**
  String get methodActive;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Non liée'**
  String get methodNotLinked;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Aucun pour l’instant'**
  String get methodNone;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Lier'**
  String get methodLink;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get methodRemove;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Ajouter'**
  String get methodAdd;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Google'**
  String get googleLabel;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Mot de passe'**
  String get passwordMethodLabel;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Il faut garder au moins une méthode : Google ne peut pas être retiré tant que c’est la seule.'**
  String get googleOnlyNote;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Fourni par Google. Pour en changer, ajoutez d’abord un mot de passe.'**
  String get emailFromGoogle;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Ajouter un mot de passe'**
  String get addPasswordTitle;

  /// Google et méthodes de connexion (US-40, écrans A1, T2, A6).
  ///
  /// In fr, this message translates to:
  /// **'Opération impossible pour le moment. Réessayez dans quelques minutes.'**
  String get methodFailed;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Nouvelle table'**
  String get newTable;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Créer la table'**
  String get createTable;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Nom de la table *'**
  String get tableNameLabel;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Description'**
  String get tableDescriptionLabel;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Niveau de départ des personnages'**
  String get startingLevelLabel;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Niveau de départ'**
  String get startingLevelShort;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Baisser le niveau de départ'**
  String get levelDecrease;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Monter le niveau de départ'**
  String get levelIncrease;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Méthode de caractéristiques'**
  String get statMethodTitle;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Imposée à toutes les créations de personnage de la table.'**
  String get statMethodHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Valeurs standard'**
  String get methodStandard;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'15, 14, 13, 12, 10, 8 à répartir'**
  String get methodStandardHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'27 points, valeurs de 8 à 15'**
  String get methodPointBuyHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Génération aléatoire'**
  String get methodRandom;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'4d6, on retire le plus faible, six fois'**
  String get methodRandomHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Repos long'**
  String get longRestTitle;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Récupération totale des PV'**
  String get longRestFull;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Règle de base du SRD'**
  String get longRestFullHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Récupération par dés de vie'**
  String get longRestHitDice;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Les PV ne remontent qu’en dépensant des dés de vie'**
  String get longRestHitDiceHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Récupération totale'**
  String get longRestFullShort;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Par dés de vie'**
  String get longRestHitDiceShort;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'PV à la montée de niveau'**
  String get hpOnLevelTitle;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Moyenne fixe'**
  String get hpAverage;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Jet de dé'**
  String get hpRoll;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'La moyenne du dé de vie, plus le modificateur de Constitution, à chaque niveau.'**
  String get hpAverageHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Le joueur lance son dé de vie à chaque niveau.'**
  String get hpRollHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Progression des personnages'**
  String get progressionTitle;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Points d’expérience'**
  String get progressionXp;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Jalons'**
  String get progressionMilestones;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Les PX des rencontres s’ajoutent aux fiches à la clôture de chaque séance ; le niveau suit les seuils du SRD.'**
  String get progressionXpHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Aucun PX n’apparaît aux joueurs : vous accordez les niveaux vous-même.'**
  String get progressionMilestonesHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Packs actifs'**
  String get packsTitle;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'La version est figée pour la table ; les joueurs reçoivent les packs par la synchronisation.'**
  String get packsHint;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'SRD 5.2.1'**
  String get srdPackName;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Toujours actif'**
  String get srdPackAlways;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Aperçu de la carte'**
  String get previewTitle;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Caractéristiques'**
  String get previewCharacteristics;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Repos long'**
  String get previewLongRest;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'PV par niveau'**
  String get previewHpPerLevel;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Progression'**
  String get previewProgression;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Packs'**
  String get previewPacks;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Tout reste modifiable dans Configuration. Étape suivante : inviter les joueurs.'**
  String get previewNext;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes MJ'**
  String get youAreGm;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Vous êtes joueur'**
  String get youArePlayer;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Aucune table pour l’instant. Créez la vôtre, ou rejoignez celle d’un MJ avec son invitation.'**
  String get tablesEmpty;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'MJ'**
  String get roleGm;

  /// Créer une table (US-13, écran T8).
  ///
  /// In fr, this message translates to:
  /// **'Joueur'**
  String get rolePlayer;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Vue d’ensemble'**
  String get tabOverview;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Configuration'**
  String get tabConfiguration;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Création des personnages'**
  String get characterCreationSection;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Règles de jeu'**
  String get gameRulesSection;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Visibilité entre joueurs'**
  String get visibilitySection;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Ouvrir les fiches complètes des autres PJ'**
  String get fullSheetsLabel;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'En lecture seule. Désactivé : chaque joueur voit nom, portrait, espèce, classe, niveau et état de santé qualitatif, sans PV chiffrés.'**
  String get fullSheetsHint;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Ouvertes'**
  String get fullSheetsOpen;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Fermées'**
  String get fullSheetsClosed;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Ce changement ne touche pas les fiches existantes'**
  String get methodChangeTitle;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'{method} s’appliquera aux prochaines créations. Les fiches de la table gardent leurs caractéristiques ; un personnage libre rattaché plus tard sera comparé à la nouvelle méthode.'**
  String methodChangeBody(String method);

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Passer aux jalons garde les PX déjà acquis sur les fiches, mais ils n’évoluent plus ; vous accordez ensuite les niveaux vous-même.'**
  String get milestonesNote;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Zone sensible'**
  String get sensitiveZone;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Archiver la table'**
  String get archiveTable;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Tout passe en lecture seule pour tous les membres. Restaurable à tout moment.'**
  String get archiveHint;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Archiver'**
  String get archiveAction;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Restaurer la table'**
  String get restoreTable;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'La table redevient modifiable pour tous les membres.'**
  String get restoreHint;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Restaurer'**
  String get restoreAction;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Table archivée : lecture seule pour tous les membres.'**
  String get archivedBanner;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Modifications non enregistrées'**
  String get unsavedTitle;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'{label} : {from} → {to}'**
  String changeLine(String label, String from, String to);

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Qui est prévenu'**
  String get whoIsNotifiedTitle;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Les joueurs voient la nouvelle règle dans la vue de la table à leur prochaine synchronisation. Chaque changement est daté dans l’activité de la table.'**
  String get whoIsNotifiedBody;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Méthode'**
  String get fieldMethod;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Activité'**
  String get activityTitle;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Aucun changement pour l’instant.'**
  String get activityEmpty;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Table archivée'**
  String get activityArchived;

  /// Configuration et activité d’une table (US-13, écran F6).
  ///
  /// In fr, this message translates to:
  /// **'Table restaurée'**
  String get activityRestored;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Membres'**
  String get tabMembers;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Inviter des joueurs'**
  String get inviteTitle;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Faites scanner le QR à la table, ou envoyez le lien. Le joueur a besoin du réseau pour rejoindre.'**
  String get inviteHint;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Créer une invitation'**
  String get inviteCreate;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Aucune invitation en cours. Une invitation vaut 7 jours.'**
  String get inviteNone;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Code'**
  String get inviteCodeLabel;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Copier le code'**
  String get inviteCopyCode;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Copier le lien'**
  String get inviteCopyLink;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Partager…'**
  String get inviteShare;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Rejoignez « {table} » sur Tavernier : {link} (code {code})'**
  String inviteShareText(String table, String link, String code);

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Copié'**
  String get inviteCopied;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'{days, plural, =0{Expire aujourd’hui} =1{Expire dans 1 jour} other{Expire dans {days} jours}}'**
  String inviteExpires(int days);

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Révoquer'**
  String get inviteRevoke;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Membres {count}'**
  String membersCount(int count);

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'{role} · vous'**
  String memberYou(String role);

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Membre'**
  String get memberUnknown;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Retirer de la table'**
  String get removeMember;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Retirer {name} ?'**
  String removeMemberTitle(String name);

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Sa fiche dans cette table est archivée, sans être supprimée. Une nouvelle invitation lui permettra de revenir.'**
  String get removeMemberBody;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Retirer'**
  String get removeAction;

  /// Membres et invitations d’une table (US-14, écrans T10 et T11).
  ///
  /// In fr, this message translates to:
  /// **'Retirer un joueur archive sa fiche, sans la supprimer.'**
  String get removeNote;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre une table'**
  String get joinTitle;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre'**
  String get joinTable;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Saisissez le code à 6 caractères donné par votre MJ.'**
  String get joinCodeHint;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Code de la table'**
  String get joinCodeLabel;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Pas de réseau.'**
  String get joinOfflineTitle;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Rejoindre une table demande une connexion, une seule fois. Le code est gardé : la demande partira dès que le réseau revient.'**
  String get joinOfflineBody;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'En attente du réseau…'**
  String get joinWaiting;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'En attendant, vous pouvez créer un personnage libre.'**
  String get joinWaitingHint;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Un compte est nécessaire pour rejoindre une table. Le code est gardé : la demande partira une fois connecté.'**
  String get joinNeedsAccount;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Ce code ne correspond à aucune invitation. Vérifiez-le auprès de votre MJ.'**
  String get joinErrorInvalid;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Cette invitation a expiré ou a été révoquée. Demandez un nouveau code à votre MJ.'**
  String get joinErrorExpired;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Cette table est archivée : elle n’accepte plus de joueurs.'**
  String get joinErrorArchived;

  /// Rejoindre une table (US-14, écrans T4 et T12).
  ///
  /// In fr, this message translates to:
  /// **'Trop d’essais. Réessayez dans une heure.'**
  String get joinErrorTooMany;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Méthode'**
  String get scoreMethodTitle;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Lancez les dés ou saisissez vos jets pour obtenir vos six valeurs.'**
  String get missingRolls;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Lancer'**
  String get rollDice;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Saisir mes jets'**
  String get enterRolls;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Vos six jets'**
  String get enterRollsTitle;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Pour chaque jet : 4d6, on retire le plus faible. Valeurs de 3 à 18.'**
  String get enterRollsHint;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Jet {number}'**
  String rollLabel(int number);

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Valider'**
  String get rollsValidate;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Jets : {values}'**
  String rollsSummary(String values);

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Choisissez une valeur pour chaque caractéristique ; une valeur déjà prise passe à l’autre.'**
  String get assignHint;

  /// Méthodes de caractéristiques à la création (US-15, SRD p. 21-22).
  ///
  /// In fr, this message translates to:
  /// **'Valeur de {ability}'**
  String assignValueLabel(String ability);
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
