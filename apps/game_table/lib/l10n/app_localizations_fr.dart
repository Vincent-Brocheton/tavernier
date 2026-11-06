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

  @override
  String get newCharacter => 'Nouveau personnage';

  @override
  String get noCharacterYet => 'Aucun personnage pour l’instant.';

  @override
  String get close => 'Fermer';

  @override
  String get previous => 'Précédent';

  @override
  String get next => 'Suivant';

  @override
  String get comingSoon => 'Bientôt disponible';

  @override
  String get contentError => 'Le contenu n’a pas pu être lu.';

  @override
  String get retry => 'Réessayer';

  @override
  String get stepClass => 'Classe';

  @override
  String get stepBackground => 'Historique';

  @override
  String get stepSpecies => 'Espèce';

  @override
  String get stepLanguages => 'Langues';

  @override
  String get stepAbilities => 'Caractéristiques';

  @override
  String get stepSubchoices => 'Sous-choix';

  @override
  String get stepEquipment => 'Équipement';

  @override
  String get stepDetails => 'Détails';

  @override
  String get stepSummary => 'Récapitulatif';

  @override
  String get stepToChoose => 'À choisir';

  @override
  String get stepLanguagesHint => 'Commun + 2';

  @override
  String get stepAbilitiesHint => 'Acquisition par points';

  @override
  String get stepSubchoicesHint => 'Compétences, bottes, don';

  @override
  String get stepEquipmentHint => 'Pack ou or';

  @override
  String get stepDetailsHint => 'Nom, apparence';

  @override
  String get stepSummaryHint => 'Envoi au MJ';

  @override
  String get introClass =>
      'Votre classe décide de vos talents au combat, de vos dés de vie et de vos maîtrises. Vous pourrez revenir sur ce choix.';

  @override
  String get introBackground =>
      'Ce que faisait votre personnage avant l’aventure. L’Historique donne trois caractéristiques à augmenter, un don d’origines, deux compétences et un outil.';

  @override
  String get introSpecies =>
      'Taille, Vitesse et traits. Aucun bonus de caractéristique : ils viennent de l’Historique.';

  @override
  String get missingClass => 'Choisissez une classe pour continuer.';

  @override
  String get missingBackground => 'Choisissez un Historique pour continuer.';

  @override
  String get missingTool => 'Choisissez un outil pour continuer.';

  @override
  String get missingSpecies => 'Choisissez une espèce pour continuer.';

  @override
  String get missingSize =>
      'Choisissez une catégorie de taille pour continuer.';

  @override
  String get searchClass => 'Rechercher une classe';

  @override
  String get filterAll => 'Toutes';

  @override
  String get filterMartial => 'Martiales';

  @override
  String get filterCasters => 'Lanceurs de sorts';

  @override
  String get filterHomebrew => 'Homebrew';

  @override
  String get noResult => 'Aucun résultat.';

  @override
  String get orWord => 'ou';

  @override
  String get andWord => 'et';

  @override
  String get labelPrimary => 'Principale';

  @override
  String get labelHitDie => 'Dé de vie';

  @override
  String get labelSaves => 'Jets de sauvegarde';

  @override
  String get labelSkills => 'Compétences';

  @override
  String get labelWeapons => 'Armes';

  @override
  String get labelArmor => 'Armures';

  @override
  String get labelAtLevel1 => 'Au niveau 1';

  @override
  String get labelEligibleAbilities => 'Caractéristiques éligibles';

  @override
  String get bonusSpread => '+2 / +1 ou +1 / +1 / +1, répartis à l’étape 5.';

  @override
  String get labelOriginFeat => 'Don d’origines';

  @override
  String get labelTool => 'Outil';

  @override
  String get labelToolChoice => 'Type';

  @override
  String get labelSizeCategory => 'Catégorie de taille';

  @override
  String get weaponSimple => 'Courantes';

  @override
  String get weaponMartial => 'De guerre';

  @override
  String get weaponMartialLight => 'De guerre (propriété Légère)';

  @override
  String get weaponMartialFinesseOrLight => 'De guerre (Finesse ou Légère)';

  @override
  String get armorLight => 'Légères';

  @override
  String get armorMedium => 'Intermédiaires';

  @override
  String get armorHeavy => 'Lourdes';

  @override
  String get armorShield => 'Boucliers';

  @override
  String get armorNone => 'Aucune';

  @override
  String get toolGamingSet => 'boîte de jeux';

  @override
  String get toolMusicalInstrument => 'instrument de musique';

  @override
  String get toolArtisan => 'outils d’artisan';

  @override
  String get sourceSrd => 'SRD 5.2.1';

  @override
  String stepOf(int step, int total) {
    return 'Étape $step sur $total';
  }

  @override
  String stepEyebrow(int step, int total) {
    return 'ÉTAPE $step SUR $total';
  }

  @override
  String nextTo(String step) {
    return 'Suivant : $step';
  }

  @override
  String classPrimary(String abilities) {
    return 'Principale : $abilities';
  }

  @override
  String classHitDie(int faces) {
    return 'Dé de vie d$faces';
  }

  @override
  String hitDiePerLevel(int faces) {
    return 'd$faces par niveau';
  }

  @override
  String skillsAmong(int count, String skills) {
    return '$count parmi $skills';
  }

  @override
  String featLine(String feat) {
    return 'Don : $feat';
  }

  @override
  String toolChoiceLine(String category) {
    return '$category (au choix)';
  }

  @override
  String traitFromLevel(int level) {
    return '(niv. $level)';
  }

  @override
  String get introLanguages => 'Le commun, plus deux langues courantes.';

  @override
  String get commonLanguageHint => 'Connu de tous les personnages';

  @override
  String get standardLanguages => 'Langues courantes';

  @override
  String get drawLanguages => 'Tirer au sort';

  @override
  String get rareLanguagesRule =>
      'Langues rares (abyssal, céleste, infernal…) : seulement via une aptitude qui les accorde.';

  @override
  String get pointBuy => 'Acquisition par points';

  @override
  String get distributionTwoOne => '+2 et +1';

  @override
  String get distributionOnes => '+1, +1 et +1';

  @override
  String get labelAbility => 'Caractéristique';

  @override
  String get labelBase => 'Base';

  @override
  String get labelTotal => 'Total';

  @override
  String get eligible => 'Éligible';

  @override
  String get plusOneElsewhere => 'Le +1 doit aller ailleurs';

  @override
  String get plusTwoElsewhere => 'Le +2 doit aller ailleurs';

  @override
  String get bonusInvalidTitle => 'Bonus à refaire';

  @override
  String get missingBonus => 'Placez vos bonus d’Historique pour continuer.';

  @override
  String get missingBonusInvalid =>
      'Placez vos bonus sur des caractéristiques éligibles pour continuer.';

  @override
  String countOf(int count, int total) {
    return '$count / $total';
  }

  @override
  String pointsOf(int spent, int total) {
    return '$spent / $total points';
  }

  @override
  String costOf(int cost) {
    return 'coût $cost';
  }

  @override
  String pointBuyCosts(String costs, int min, int max) {
    return 'Coûts : $costs. Valeur entre $min et $max avant bonus.';
  }

  @override
  String raiseAbility(String ability) {
    return 'Augmenter $ability';
  }

  @override
  String lowerAbility(String ability) {
    return 'Diminuer $ability';
  }

  @override
  String introAbilities(int points) {
    return 'Répartissez vos $points points, puis appliquez les bonus de votre Historique.';
  }

  @override
  String backgroundBonus(String background) {
    return 'Bonus d’Historique · $background';
  }

  @override
  String bonusCap(String abilities, int cap) {
    return '$abilities · plafond $cap';
  }

  @override
  String notEligibleFor(String background) {
    return 'Non éligible pour $background';
  }

  @override
  String bonusOn(int value, String ability) {
    return '+$value sur $ability';
  }

  @override
  String bonusInvalidMessage(
    String abilities,
    String background,
    String allowed,
  ) {
    return 'Le bonus placé sur $abilities n’est plus valide. $background n’autorise les bonus que sur $allowed.';
  }

  @override
  String missingLanguages(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Choisissez encore $count langues pour continuer.',
      one: 'Choisissez encore 1 langue pour continuer.',
    );
    return '$_temp0';
  }

  @override
  String missingPoints(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il reste $count points à dépenser.',
      one: 'Il reste 1 point à dépenser.',
    );
    return '$_temp0';
  }

  @override
  String get stepToRedo => 'À refaire';

  @override
  String get introSubchoices =>
      'Les choix laissés ouverts par votre classe, votre Historique et votre espèce. Les options impossibles sont grisées, avec la règle qui les bloque.';

  @override
  String get classToolsTitle => 'Outils à choisir';

  @override
  String get weaponMasteryTitle => 'Bottes d’arme';

  @override
  String get fightingStyleTitle => 'Style de combat';

  @override
  String get originFeatTitle => 'Don d’origines';

  @override
  String get toComplete => 'À compléter';

  @override
  String get featNotRepeatable =>
      'Déjà obtenu par l’Historique · non répétable';

  @override
  String get expertiseRule =>
      'L’Expertise ne porte que sur une compétence que vous maîtrisez déjà.';

  @override
  String classSkillsOf(String cls) {
    return 'Compétences de $cls';
  }

  @override
  String alreadyKnownRule(String names) {
    return '$names : déjà maîtrisé, une maîtrise ne se prend pas deux fois.';
  }

  @override
  String choiceToRedo(String names) {
    return 'À refaire : $names.';
  }

  @override
  String choicesLeft(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Encore $count choix',
      one: 'Encore 1 choix',
    );
    return '$_temp0';
  }

  @override
  String missingSubchoice(String title) {
    return 'À compléter : $title.';
  }

  @override
  String choiceTitle(String name, String title) {
    return '$name : $title';
  }

  @override
  String cantripsOf(String cls) {
    return 'Sorts mineurs de $cls';
  }

  @override
  String preparedSpellsOf(String cls) {
    return 'Sorts préparés de $cls';
  }

  @override
  String get spellbookTitle => 'Grimoire';

  @override
  String initiateListTitle(String feat) {
    return '$feat : liste de sorts';
  }

  @override
  String initiateAbilityTitle(String feat) {
    return '$feat : caractéristique d’incantation';
  }

  @override
  String initiateCantripsTitle(String feat) {
    return '$feat : sorts mineurs';
  }

  @override
  String initiateSpellTitle(String feat) {
    return '$feat : sort du 1er niveau';
  }

  @override
  String get sameListRule => 'Ce don se reprend avec une autre liste de sorts.';

  @override
  String spellKnownRule(String names) {
    return '$names : déjà connu, un sort ne se prend pas deux fois.';
  }

  @override
  String get introEquipment =>
      'Un lot de votre classe et un de votre Historique, ou leur valeur en or.';

  @override
  String get introDetails =>
      'Qui est votre personnage ? Seul le nom est obligatoire.';

  @override
  String get introSummary =>
      'Votre personnage tel que les règles le calculent.';

  @override
  String get saveCharacter => 'Enregistrer';

  @override
  String get saveFailed =>
      'L’enregistrement a échoué. Votre brouillon est conservé, réessayez.';

  @override
  String lotName(String letter) {
    return 'Lot $letter';
  }

  @override
  String get lotTool => 'un outil au choix';

  @override
  String get lotToolChoice => 'Outil du lot';

  @override
  String goldPieces(int count) {
    return '$count po';
  }

  @override
  String get armorClassWithEquipment => 'CA avec cet équipement';

  @override
  String get startingGold => 'Or de départ';

  @override
  String get missingClassEquipment => 'Choisissez un lot de classe.';

  @override
  String get missingBackgroundEquipment =>
      'Choisissez le lot de l’Historique ou son or.';

  @override
  String get missingEquipmentTool => 'Choisissez l’outil du lot.';

  @override
  String get missingName => 'Donnez un nom à votre personnage.';

  @override
  String get missingRules =>
      'Corrigez les erreurs de règle avant d’enregistrer.';

  @override
  String get detailName => 'Nom *';

  @override
  String get detailAlignment => 'Alignement';

  @override
  String get detailAppearance => 'Apparence';

  @override
  String get detailPersonality => 'Personnalité';

  @override
  String get detailBackstory => 'Histoire';

  @override
  String get alignmentLB => 'Loyal Bon';

  @override
  String get alignmentNB => 'Neutre Bon';

  @override
  String get alignmentCB => 'Chaotique Bon';

  @override
  String get alignmentLN => 'Loyal Neutre';

  @override
  String get alignmentN => 'Neutre';

  @override
  String get alignmentCN => 'Chaotique Neutre';

  @override
  String get alignmentLM => 'Loyal Mauvais';

  @override
  String get alignmentNM => 'Neutre Mauvais';

  @override
  String get alignmentCM => 'Chaotique Mauvais';

  @override
  String classLevel(String cls, int level) {
    return '$cls $level';
  }

  @override
  String savingThrow(String value) {
    return 'JS $value';
  }

  @override
  String get statHitPoints => 'PV max';

  @override
  String get statArmorClass => 'CA';

  @override
  String get statInitiative => 'Initiative';

  @override
  String get statSpeed => 'Vitesse';

  @override
  String get statProficiency => 'Maîtrise';

  @override
  String get statPassivePerception => 'Percep. passive';

  @override
  String get summaryProficiencies => 'Maîtrises';

  @override
  String get summaryTools => 'Outils';

  @override
  String get summaryLanguages => 'Langues';

  @override
  String get summaryAttacks => 'Attaques';

  @override
  String get summaryFeatures => 'Aptitudes et dons';

  @override
  String get summarySpells => 'Sorts';

  @override
  String get summaryChecks => 'Vérification des règles';

  @override
  String get ruleError => 'Erreur de règle';

  @override
  String get masteryWithoutWeaponTitle => 'Botte sur une arme absente';

  @override
  String masteryWithoutWeapon(String names) {
    return 'Votre équipement ne contient pas : $names. Cela ne bloque pas l’enregistrement.';
  }

  @override
  String checkPoints(int spent, int budget) {
    return 'Acquisition par points : $spent / $budget';
  }

  @override
  String checkBonus(String bonuses) {
    return 'Bonus d’Historique : $bonuses';
  }

  @override
  String checkPacks(String packs) {
    return 'Packs : $packs';
  }

  @override
  String get unarmedStrike => 'Mains nues';

  @override
  String get tabMain => 'Principal';

  @override
  String get tabSkills => 'Compétences';

  @override
  String get tabCombat => 'Combat';

  @override
  String get tabSpells => 'Sorts';

  @override
  String get tabInventory => 'Inventaire';

  @override
  String get tabFeatures => 'Aptitudes';

  @override
  String get tabNotes => 'Notes';

  @override
  String get back => 'Retour';

  @override
  String get characterNotFound => 'Ce personnage est introuvable.';

  @override
  String get abilitiesTitle => 'Caractéristiques';

  @override
  String get tapForBreakdown => 'Touchez une valeur : décomposition';

  @override
  String get abbrStr => 'FOR';

  @override
  String get abbrDex => 'DEX';

  @override
  String get abbrCon => 'CON';

  @override
  String get abbrInt => 'INT';

  @override
  String get abbrWis => 'SAG';

  @override
  String get abbrCha => 'CHA';

  @override
  String get expertise => 'Expertise';

  @override
  String get usedBy => 'Utilisée par';

  @override
  String get categoryAbility => 'Caractéristique';

  @override
  String get categorySkill => 'Compétence';

  @override
  String get categoryStat => 'Statistique';

  @override
  String get breakdownBase => 'Valeur de base';

  @override
  String get breakdownProficiency => 'Bonus de maîtrise';

  @override
  String get sourceCreation => 'Création';

  @override
  String breakdownModifier(String ability) {
    return 'Modificateur de $ability';
  }

  @override
  String savingThrowOf(String ability) {
    return 'JS $ability';
  }

  @override
  String modifierRule(String modifier, int score) {
    return 'Modificateur $modifier = ($score − 10) ÷ 2, arrondi à l’inférieur';
  }

  @override
  String proficiencyByLevel(int level) {
    return 'Niveau de personnage $level';
  }

  @override
  String abilitySemantics(
    String ability,
    int score,
    String modifier,
    String save,
  ) {
    return '$ability $score, modificateur $modifier, jet de sauvegarde $save';
  }
}
