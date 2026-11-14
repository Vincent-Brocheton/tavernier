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
  String get filterAll => 'Tout';

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
  String get introAbilities =>
      'Fixez vos six valeurs selon la méthode choisie, puis appliquez les bonus de votre Historique.';

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

  @override
  String get resourcesTitle => 'Ressources';

  @override
  String get toHit => 'toucher';

  @override
  String get damageLabel => 'dégâts';

  @override
  String get categoryAttack => 'Attaque';

  @override
  String get rechargeShortRest => 'repos court';

  @override
  String get rechargeLongRest => 'repos long';

  @override
  String get filterWithUses => 'Avec utilisations';

  @override
  String get filterFeats => 'Dons';

  @override
  String usesOf(int available, int total) {
    return '$available utilisations sur $total';
  }

  @override
  String masteriesCount(int chosen, int slots) {
    return 'Bottes d’arme $chosen / $slots';
  }

  @override
  String masteryOn(String name) {
    return 'Botte : $name';
  }

  @override
  String inReserve(int count) {
    return '$count en réserve';
  }

  @override
  String levelUpTo(int level) {
    return 'Monter au niveau $level';
  }

  @override
  String get levelUpTitle => 'Montée de niveau';

  @override
  String levelFromTo(String cls, int from, int to) {
    return '$cls $from → $to';
  }

  @override
  String hitPointsGain(int count) {
    return '+$count PV';
  }

  @override
  String get hitPointsAverage =>
      'Moyenne du dé de vie et modificateur de Constitution.';

  @override
  String get featuresGained => 'Aptitudes gagnées';

  @override
  String get subclassTitle => 'Sous-classe';

  @override
  String masteriesGained(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count nouvelles bottes',
      one: 'Nouvelle botte',
    );
    return '$_temp0';
  }

  @override
  String get featChoiceTitle => 'Amélioration de caractéristique ou autre don';

  @override
  String get featChoiceHint =>
      'Seuls les dons dont vous remplissez les conditions sont sélectionnables.';

  @override
  String get improvementTwo => '+2 à une';

  @override
  String get improvementOneAndOne => '+1 à deux';

  @override
  String get whatChanges => 'Ce qui change';

  @override
  String get hitDiceLabel => 'Dés de vie';

  @override
  String get missingSubclass => 'Choisissez une sous-classe.';

  @override
  String get missingLevelChoice => 'Faites les choix de ce niveau.';

  @override
  String get missingMastery => 'Choisissez votre nouvelle botte.';

  @override
  String get missingFeat => 'Choisissez un don.';

  @override
  String get missingFeatBonus => 'Choisissez où porter le bonus.';

  @override
  String get featBlockLevel => 'Niveau insuffisant';

  @override
  String get featBlockAbility => 'Caractéristique insuffisante';

  @override
  String get featBlockFeature => 'Aptitude requise manquante';

  @override
  String get featBlockNotRepeatable => 'Déjà obtenu · non répétable';

  @override
  String get levelUpReady => 'Prêt à enregistrer';

  @override
  String get featChoiceOther => 'Don accordé par ce niveau';

  @override
  String get missingSpells => 'Choisissez vos sorts.';

  @override
  String spellSectionCount(String title, int chosen, int count) {
    return '$title $chosen / $count';
  }

  @override
  String get spellKnownShort => 'Un sort déjà connu ne se prend pas deux fois.';

  @override
  String get initiateListChoice => 'Liste de sorts';

  @override
  String get initiateAbilityChoice => 'Caractéristique d’incantation';

  @override
  String get initiateCantripChoice => 'Sorts mineurs';

  @override
  String get initiateSpellChoice => 'Sort du 1er niveau';

  @override
  String classForLevel(int level) {
    return 'Quelle classe pour le niveau $level ?';
  }

  @override
  String get continueClass => 'Continuer';

  @override
  String get multiclassHeading =>
      'Multiclasser · niveau 1 dans une autre classe';

  @override
  String multiclassNeeds(int count, String names, int minimum) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$names $minimum requis',
      one: '$names $minimum requise',
    );
    return '$_temp0';
  }

  @override
  String get abilityAnd => ' et ';

  @override
  String get abilityOr => ' ou ';

  @override
  String abilityReached(String ability, int score) {
    return '$ability $score ✓';
  }

  @override
  String abilityMissing(String ability, int score, int missing) {
    return '$ability $score : il manque $missing';
  }

  @override
  String multiclassRule(int minimum) {
    return 'Multiclasser demande $minimum dans la caractéristique principale de la nouvelle classe et de la classe actuelle.';
  }

  @override
  String multiclassSkill(String cls) {
    return 'Compétence de $cls';
  }

  @override
  String multiclassTool(String cls) {
    return 'Instrument de $cls';
  }

  @override
  String get schoolAbjuration => 'Abjuration';

  @override
  String get schoolConjuration => 'Invocation';

  @override
  String get schoolDivination => 'Divination';

  @override
  String get schoolEnchantment => 'Enchantement';

  @override
  String get schoolEvocation => 'Évocation';

  @override
  String get schoolIllusion => 'Illusion';

  @override
  String get schoolNecromancy => 'Nécromancie';

  @override
  String get schoolTransmutation => 'Transmutation';

  @override
  String get rangeSelf => 'Personnelle';

  @override
  String get rangeTouch => 'Contact';

  @override
  String get rangeSight => 'À vue';

  @override
  String get rangeUnlimited => 'Illimitée';

  @override
  String get rangeSpecial => 'Spéciale';

  @override
  String get spellSaveDcTitle => 'DD des sorts';

  @override
  String get spellAttack => 'Attaque de sort';

  @override
  String get spellSlotsTitle => 'Emplacements';

  @override
  String get spellSlotsCombined => 'Emplacements combinés';

  @override
  String get pactMagicTitle => 'Magie de pacte';

  @override
  String get pactRecharge => 'Récupérés au repos court.';

  @override
  String get alwaysPrepared => 'Toujours préparé';

  @override
  String get inSpellbook => 'Au grimoire';

  @override
  String get concentration => 'Concentration';

  @override
  String get ritual => 'Rituel';

  @override
  String get badgeConcentration => 'C';

  @override
  String get badgeRitual => 'R';

  @override
  String get noSpells => 'Aucun sort';

  @override
  String get noSpellsHint =>
      'Ce personnage ne lance pas de sorts. Le don Initié à la magie, pris à une prochaine Amélioration de caractéristique, lui en donnerait.';

  @override
  String get filterPrepared => 'Préparés';

  @override
  String get filterRituals => 'Rituels';

  @override
  String get noSpellMatches => 'Aucun sort pour ce filtre.';

  @override
  String get cantripsHeading => 'Sorts mineurs';

  @override
  String get componentVerbal => 'V';

  @override
  String get componentSomatic => 'S';

  @override
  String get spellCasting => 'Incantation';

  @override
  String get spellRange => 'Portée';

  @override
  String get spellComponents => 'Composantes';

  @override
  String get spellDuration => 'Durée';

  @override
  String get spellMaterial => 'Composante matérielle';

  @override
  String get materialConsumed => 'Consommée par le sort';

  @override
  String casterHalf(String label) {
    return '$label ÷ 2';
  }

  @override
  String casterRounded(String sum) {
    return '$sum (arrondi supérieur)';
  }

  @override
  String casterSum(String sum, int level) {
    return '$sum = $level';
  }

  @override
  String spellSaveDc(String ability) {
    return 'DD ($ability)';
  }

  @override
  String preparedOfMax(int count, int max) {
    return 'Préparés : $count / $max';
  }

  @override
  String slotLevel(int level) {
    String _temp0 = intl.Intl.pluralLogic(
      level,
      locale: localeName,
      other: '${level}e',
      one: '1er',
    );
    return '$_temp0';
  }

  @override
  String slotsOf(int level, int available, int total) {
    return '$available emplacements sur $total du niveau $level';
  }

  @override
  String pactSlots(int slots, int level) {
    return '$slots emplacements du ${level}e niveau';
  }

  @override
  String alwaysPreparedCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Plus $count sorts toujours préparés',
      one: 'Plus 1 sort toujours préparé',
    );
    return '$_temp0';
  }

  @override
  String spellLevelName(int level) {
    String _temp0 = intl.Intl.pluralLogic(
      level,
      locale: localeName,
      other: '${level}e niveau',
      one: '1er niveau',
    );
    return '$_temp0';
  }

  @override
  String componentMaterial(String material) {
    return 'M ($material)';
  }

  @override
  String cantripOf(String school) {
    return 'Sort mineur · $school';
  }

  @override
  String spellOfLevel(String school, String level) {
    return '$school du $level';
  }

  @override
  String durationConcentration(String duration) {
    return 'Concentration, $duration';
  }

  @override
  String get filterAllSpells => 'Tous';

  @override
  String get castSpell => 'Lancer';

  @override
  String get castSlotTitle => 'Emplacement';

  @override
  String get castRitual => 'En rituel, sans emplacement';

  @override
  String castSlot(String level, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: '$left restants',
      one: '1 restant',
    );
    return '$level ($_temp0)';
  }

  @override
  String castPactSlot(String level, int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: '$left restants',
      one: '1 restant',
    );
    return '$level, pacte ($_temp0)';
  }

  @override
  String get concentrationActive => 'Concentration en cours';

  @override
  String get endConcentration => 'Mettre fin';

  @override
  String replacesConcentration(String spell) {
    return 'Le lancer met fin à $spell : un seul sort de concentration à la fois.';
  }

  @override
  String replaceConcentrationTitle(String spell) {
    return 'Mettre fin à $spell ?';
  }

  @override
  String get replaceConcentrationHint =>
      'Un seul sort de concentration à la fois.';

  @override
  String get confirmCast => 'Lancer quand même';

  @override
  String get cancelCast => 'Annuler';

  @override
  String get changeSpells => 'Modifier mes sorts';

  @override
  String get saveSpells => 'Enregistrer';

  @override
  String get changeRuleLongRestAll =>
      'Après un Repos long, vous pouvez changer votre liste de sorts préparés. Un sort mineur se remplace quand vous gagnez un niveau, ou après un Repos long pour le Magicien.';

  @override
  String get changeRuleLongRestOne =>
      'Après un Repos long, vous pouvez remplacer un sort préparé.';

  @override
  String get changeRuleLevelUp =>
      'Quand vous gagnez un niveau, vous pouvez remplacer un sort préparé et un sort mineur.';

  @override
  String spellbookCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count sorts',
      one: '1 sort',
    );
    return 'Grimoire : $_temp0';
  }

  @override
  String get copySpellAction => 'Copier un sort';

  @override
  String get copySpellConfirm => 'Copier';

  @override
  String copySpellRule(int hours, int gold) {
    return '$hours heures et $gold po par niveau de sort.';
  }

  @override
  String copySpellLevel(String level, int gold) {
    return '$level · $gold po';
  }

  @override
  String castFree(int left) {
    String _temp0 = intl.Intl.pluralLogic(
      left,
      locale: localeName,
      other: '$left restants',
      one: '1 restant',
    );
    return 'Sans emplacement ($_temp0)';
  }

  @override
  String get coinPlatinum => 'pp';

  @override
  String get coinGold => 'po';

  @override
  String get coinElectrum => 'pe';

  @override
  String get coinSilver => 'pa';

  @override
  String get coinCopper => 'pc';

  @override
  String get attunementRequired => 'Harmonisation requise';

  @override
  String get attunementFull =>
      'Tous vos emplacements d’harmonisation sont pris.';

  @override
  String get attune => 'S’harmoniser';

  @override
  String get endAttunement => 'Mettre fin à l’harmonisation';

  @override
  String get equip => 'Équiper';

  @override
  String get unequip => 'Ranger au sac';

  @override
  String get itemsWorn => 'Équipé';

  @override
  String get itemsBag => 'Sac';

  @override
  String get addItem => 'Ajouter un objet';

  @override
  String get searchItem => 'Rechercher un objet';

  @override
  String get noItemMatches => 'Aucun objet trouvé.';

  @override
  String get emptyInventory => 'Votre sac est vide.';

  @override
  String get addOne => 'En ajouter un';

  @override
  String get removeOne => 'En retirer un';

  @override
  String itemQuantity(int count) {
    return '× $count';
  }

  @override
  String attunementCount(int count, int max) {
    return 'Harmonisation $count / $max';
  }

  @override
  String armorClassValue(int value) {
    return 'CA $value';
  }

  @override
  String armorShieldBonus(int value) {
    return '+$value à la CA';
  }

  @override
  String get shortRest => 'Repos court';

  @override
  String get longRest => 'Repos long';

  @override
  String get shortRestHint => 'Au moins 1 heure · il faut au moins 1 PV';

  @override
  String get longRestHint =>
      'Au moins 8 heures, dont 6 de sommeil. Prochain repos long possible 16 h après celui-ci.';

  @override
  String get restNeedsHitPoint => 'Il faut au moins 1 PV pour se reposer.';

  @override
  String get hitDiceSpent => 'Dés de vie dépensés';

  @override
  String get enterRoll => 'Saisir mon jet';

  @override
  String get useResource => 'Utiliser';

  @override
  String get loseHitPoint => 'Perdre 1 PV';

  @override
  String get gainHitPoint => 'Regagner 1 PV';

  @override
  String get recoveredTitle => 'Récupéré à la fin du repos';

  @override
  String get nothingToRecover => 'Rien à récupérer de plus.';

  @override
  String get slotsRecovered => 'Récupérés';

  @override
  String get exhaustion => 'Épuisement';

  @override
  String get concentrationEnds => 'Concentration terminée';

  @override
  String get finishShortRest => 'Terminer le repos court';

  @override
  String get finishLongRest => 'Terminer le repos';

  @override
  String hitPointsOf(int current, int max) {
    return 'PV $current / $max';
  }

  @override
  String hitPointsChange(int before, int after, int max) {
    return '$before → $after / $max';
  }

  @override
  String hitDiceLeft(int left, int total, String die) {
    return 'restants : $left / $total $die';
  }

  @override
  String hitDiceChange(int before, int total, String die) {
    return '$before → $total $die';
  }

  @override
  String recoveredUses(int before, int after, int max) {
    return '$before → $after / $max';
  }

  @override
  String get inspirationHeld => 'Inspiration héroïque';

  @override
  String get inspirationNone => 'Pas d’Inspiration héroïque';

  @override
  String get inspirationGained => 'Obtenue';

  @override
  String get receiveInspiration => 'Recevoir';

  @override
  String get actionBonus => 'Action Bonus';

  @override
  String get actionPlain => 'Action';

  @override
  String consumableLine(String action, String dice, int bonus, int count) {
    return '$action · $dice + $bonus PV · ×$count dans le sac';
  }

  @override
  String consumableResult(int before, int after, int max, int from, int to) {
    return 'PV $before → $after / $max · quantité $from → $to';
  }

  @override
  String get suggest => 'Suggérer';

  @override
  String get suggestionApplied => 'Suggestion appliquée, modifiable';

  @override
  String suggestScoresReason(String first, String second) {
    return '$first en tête, puis $second, selon les valeurs standard de votre classe.';
  }

  @override
  String get suggestSkillsReason =>
      'Les compétences de votre caractéristique principale, celles où vous brillez d’emblée.';

  @override
  String get suggestMasteriesReason =>
      'Les armes de votre équipement de départ d’abord.';

  @override
  String suggestImprovementReason(String abilities) {
    return 'Augmenter $abilities renforce ce que fait votre classe.';
  }

  @override
  String ruleTermLabel(String term) {
    return '$term, définition';
  }

  @override
  String get ruleTermSource => 'Glossaire · SRD 5.2.1';

  @override
  String get reroll => 'Relancer';

  @override
  String rollResultOf(String dice) {
    return 'Résultat du $dice (modifiable avant validation)';
  }

  @override
  String rollImpossible(String dice) {
    return 'Résultat impossible pour $dice.';
  }

  @override
  String spendHitDie(String die) {
    return 'Dépenser le $die';
  }

  @override
  String get signInWelcome => 'Bienvenue';

  @override
  String get signInPurpose =>
      'Un compte sert à rejoindre des tables et à synchroniser vos fiches.';

  @override
  String get signInTitle => 'Connexion';

  @override
  String get emailLabel => 'E-mail';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get showPassword => 'Afficher le mot de passe';

  @override
  String get hidePassword => 'Masquer le mot de passe';

  @override
  String get forgotPasswordLink => 'Mot de passe oublié ?';

  @override
  String get signInAction => 'Se connecter';

  @override
  String get signInInvalid =>
      'E-mail ou mot de passe incorrect. Vérifiez la saisie, ou réinitialisez votre mot de passe.';

  @override
  String get signInNetworkError =>
      'Le serveur ne répond pas. Vérifiez votre connexion et réessayez.';

  @override
  String get signInFailed =>
      'Connexion impossible pour le moment. Réessayez dans quelques minutes.';

  @override
  String get offlineTitle => 'Pas de connexion internet';

  @override
  String get offlineFirstSignIn =>
      'La première connexion sur cet appareil demande le réseau. Le bouton se réactive dès que la connexion revient ; rien n’est enregistré en attendant.';

  @override
  String get signInFooter =>
      'La première connexion demande le réseau, ensuite tout fonctionne hors-ligne.';

  @override
  String get signInTagline => 'Votre table, même sans réseau';

  @override
  String get signInPitch =>
      'Fiches de personnage, combats et notes de séance, compatibles avec la cinquième édition. Une fois connecté, tout fonctionne hors-ligne.';

  @override
  String get signInDesktopFooter =>
      'Déjà connecté sur cet appareil ? Vos données s’ouvrent sans réseau.';

  @override
  String get forgotTitle => 'Mot de passe oublié';

  @override
  String get forgotIntro =>
      'Indiquez l’e-mail de votre compte : vous recevrez un lien pour choisir un nouveau mot de passe.';

  @override
  String get forgotSend => 'Envoyer le lien';

  @override
  String get forgotSentTitle => 'Vérifiez votre boîte mail';

  @override
  String forgotSentBody(String email) {
    return 'Si un compte existe pour $email, un lien vient d’y être envoyé. Il est valable 1 heure. Pensez à regarder dans les courriers indésirables.';
  }

  @override
  String forgotResendIn(String time) {
    return 'Renvoyer le lien dans $time';
  }

  @override
  String get forgotResend => 'Renvoyer le lien';

  @override
  String get backToSignIn => 'Revenir à la connexion';

  @override
  String get forgotSocialNote =>
      'Compte créé avec Google ou Apple : pas de mot de passe à réinitialiser, utilisez le même bouton qu’à l’inscription.';

  @override
  String get newPasswordTitle => 'Nouveau mot de passe';

  @override
  String newPasswordAccount(String email, int minutes) {
    return 'Compte $email · lien valable encore $minutes min.';
  }

  @override
  String newPasswordAccountOnly(String email) {
    return 'Compte $email';
  }

  @override
  String get newPasswordLabel => 'Nouveau mot de passe';

  @override
  String get confirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get passwordMismatch => 'Les deux mots de passe diffèrent.';

  @override
  String passwordStrength(String level) {
    return 'Robustesse : $level';
  }

  @override
  String get passwordStrength0 => 'très faible';

  @override
  String get passwordStrength1 => 'faible';

  @override
  String get passwordStrength2 => 'moyenne';

  @override
  String get passwordStrength3 => 'correcte';

  @override
  String get passwordStrength4 => 'forte';

  @override
  String get ruleLength => '10 caractères au moins';

  @override
  String get ruleIdentity => 'Différent de votre e-mail et de votre pseudo';

  @override
  String get ruleBreached => 'Absent des listes de mots de passe divulgués';

  @override
  String get ruleMet => 'Respecté';

  @override
  String get ruleUnmet => 'Non respecté';

  @override
  String get rulePending => 'Vérification…';

  @override
  String get signOutOthers => 'Déconnecter mes autres appareils';

  @override
  String get signOutOthersHint =>
      'Leurs données locales sont conservées ; il faudra se reconnecter pour synchroniser.';

  @override
  String get savePasswordAndSignIn => 'Enregistrer et se connecter';

  @override
  String get savePasswordNetworkError =>
      'Enregistrement impossible sans réseau. Réessayez une fois connecté.';

  @override
  String get signInTab => 'Connexion';

  @override
  String get signUpTab => 'Inscription';

  @override
  String get pseudonymLabel => 'Pseudonyme affiché';

  @override
  String get birthDateLabel => 'Date de naissance';

  @override
  String get birthDateHint => 'JJ/MM/AAAA';

  @override
  String get birthDateInvalid =>
      'Date invalide : utilisez le format JJ/MM/AAAA.';

  @override
  String get tooYoung => 'Il faut avoir au moins 15 ans pour créer un compte.';

  @override
  String get signUpAction => 'Créer le compte';

  @override
  String get signUpConfirmTitle => 'Vérifiez votre boîte mail';

  @override
  String signUpConfirmBody(String email) {
    return 'Si l’adresse $email peut recevoir un compte, un lien de confirmation vient d’y être envoyé. Pensez à regarder dans les courriers indésirables.';
  }

  @override
  String get signUpFailed =>
      'Inscription impossible pour le moment. Réessayez dans quelques minutes.';

  @override
  String get consentTitle => 'Envoyer les rapports de plantage ?';

  @override
  String get consentBody =>
      'Si l’application plante, un rapport technique nous aide à corriger le problème.';

  @override
  String get consentNoGameData =>
      'Aucune donnée de jeu, aucune fiche, aucun contenu personnel.';

  @override
  String get consentNoUsage => 'Aucune mesure d’usage.';

  @override
  String get consentChangeable => 'Modifiable à tout moment dans Réglages.';

  @override
  String get consentRefuse => 'Refuser';

  @override
  String get consentAccept => 'Accepter';

  @override
  String get profileTitle => 'Profil et réglages';

  @override
  String get profileSignedOut => 'Non connecté';

  @override
  String get displaySection => 'Affichage';

  @override
  String get languageLabel => 'Langue';

  @override
  String get languageFrench => 'Français';

  @override
  String get textSizeLabel => 'Taille du texte';

  @override
  String textSizeValue(int percent) {
    return '$percent %';
  }

  @override
  String get themeLabel => 'Thème';

  @override
  String get themeDark => 'Sombre';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLightSoon =>
      'Le thème clair arrive dans une prochaine version.';

  @override
  String get privacySection => 'Confidentialité';

  @override
  String get crashReportsLabel => 'Rapports de plantage';

  @override
  String get crashReportsHint => 'Sans données de jeu ni contenu personnel';

  @override
  String get signOut => 'Se déconnecter';

  @override
  String get signOutPendingTitle => 'Modifications non envoyées';

  @override
  String signOutPendingBody(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count modifications n’ont pas encore été envoyées. Elles seront perdues si vous vous déconnectez maintenant.',
      one: '1 modification n’a pas encore été envoyée. Elle sera perdue si vous vous déconnectez maintenant.',
    );
    return '$_temp0';
  }

  @override
  String get signOutAnyway => 'Se déconnecter quand même';

  @override
  String get cancel => 'Annuler';

  @override
  String get devicesSection => 'Appareils connectés';

  @override
  String deviceBrowserOn(String browser, String platform) {
    return '$browser sur $platform';
  }

  @override
  String get platformWindows => 'Windows';

  @override
  String get platformMacos => 'macOS';

  @override
  String get platformLinux => 'Linux';

  @override
  String get platformAndroid => 'Android';

  @override
  String get platformIphone => 'iPhone';

  @override
  String get platformIpad => 'iPad';

  @override
  String get deviceAndroidPhone => 'Téléphone Android';

  @override
  String get deviceAndroidTablet => 'Tablette Android';

  @override
  String get deviceUnknown => 'Appareil inconnu';

  @override
  String get thisDeviceNow => 'Cet appareil · actif maintenant';

  @override
  String get activeNow => 'Actif maintenant';

  @override
  String activeMinutes(int count) {
    return 'Il y a $count min';
  }

  @override
  String activeHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count heures',
      one: 'Il y a 1 heure',
    );
    return '$_temp0';
  }

  @override
  String activeDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count jours',
      one: 'Il y a 1 jour',
    );
    return '$_temp0';
  }

  @override
  String activeWeeks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Il y a $count semaines',
      one: 'Il y a 1 semaine',
    );
    return '$_temp0';
  }

  @override
  String activeMonths(int count) {
    return 'Il y a $count mois';
  }

  @override
  String get revokeDevice => 'Déconnecter';

  @override
  String get devicesOffline => 'La liste des appareils demande le réseau.';

  @override
  String get authLinkInvalid =>
      'Ce lien a expiré ou a déjà servi. Si votre adresse est confirmée, connectez-vous ; sinon, demandez un nouveau lien avec « Mot de passe oublié ? ».';

  @override
  String get resendConfirmation => 'Renvoyer l’e-mail de confirmation';

  @override
  String resendConfirmationIn(String time) {
    return 'Renvoyer l’e-mail dans $time';
  }

  @override
  String confirmationResent(String email) {
    return 'Si un compte attend une confirmation pour $email, un nouveau lien vient d’y être envoyé.';
  }

  @override
  String get editAccountTitle => 'Modifier le compte';

  @override
  String get editAccountAction => 'Modifier';

  @override
  String get accountSave => 'Enregistrer';

  @override
  String get profileSection => 'Profil';

  @override
  String get avatarLabel => 'Avatar';

  @override
  String get avatarHint =>
      'Image carrée, compressée à 200 Ko. Visible des membres de vos tables.';

  @override
  String get avatarRemove => 'Retirer';

  @override
  String get avatarUnreadable =>
      'Cette image ne peut pas être lue. Choisissez une image JPEG, PNG ou WebP.';

  @override
  String get pseudonymHint =>
      'Visible des autres membres. Modifiable hors-ligne : la modification part à la synchronisation.';

  @override
  String get emailSection => 'E-mail';

  @override
  String emailChangeHint(String email) {
    return 'Un lien de confirmation sera envoyé à la nouvelle adresse. $email reste active jusqu’à la confirmation, et sera prévenue du changement.';
  }

  @override
  String get changePasswordSection => 'Changer le mot de passe';

  @override
  String get currentPasswordLabel => 'Mot de passe actuel';

  @override
  String get networkFieldsNote =>
      'L’e-mail et le mot de passe demandent le réseau : ils sont vérifiés par le serveur.';

  @override
  String get wrongCurrentPassword => 'Mot de passe actuel incorrect.';

  @override
  String emailChangeSent(String email) {
    return 'Un lien de confirmation a été envoyé à $email. Votre adresse actuelle reste active jusqu’à la confirmation.';
  }

  @override
  String get accountSaved => 'Modifications enregistrées.';

  @override
  String get accountNetworkError =>
      'L’e-mail et le mot de passe demandent le réseau. Réessayez une fois connecté.';

  @override
  String get pseudonymRequired => 'Le pseudonyme ne peut pas être vide.';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get orSeparator => 'ou';

  @override
  String get ageTitle => 'Date de naissance';

  @override
  String get ageIntro =>
      'Avant de continuer, indiquez votre date de naissance : il faut avoir au moins 15 ans pour utiliser un compte. Elle sert à la vérification et n’est pas conservée.';

  @override
  String get ageContinue => 'Continuer';

  @override
  String get ageRefused =>
      'Il faut avoir au moins 15 ans pour créer un compte. Votre compte Google n’a pas été conservé.';

  @override
  String get methodsSection => 'Méthodes de connexion';

  @override
  String get methodActive => 'Active';

  @override
  String get methodNotLinked => 'Non liée';

  @override
  String get methodNone => 'Aucun pour l’instant';

  @override
  String get methodLink => 'Lier';

  @override
  String get methodRemove => 'Retirer';

  @override
  String get methodAdd => 'Ajouter';

  @override
  String get googleLabel => 'Google';

  @override
  String get passwordMethodLabel => 'Mot de passe';

  @override
  String get googleOnlyNote =>
      'Il faut garder au moins une méthode : Google ne peut pas être retiré tant que c’est la seule.';

  @override
  String get emailFromGoogle =>
      'Fourni par Google. Pour en changer, ajoutez d’abord un mot de passe.';

  @override
  String get addPasswordTitle => 'Ajouter un mot de passe';

  @override
  String get methodFailed =>
      'Opération impossible pour le moment. Réessayez dans quelques minutes.';

  @override
  String get newTable => 'Nouvelle table';

  @override
  String get createTable => 'Créer la table';

  @override
  String get tableNameLabel => 'Nom de la table *';

  @override
  String get tableDescriptionLabel => 'Description';

  @override
  String get startingLevelLabel => 'Niveau de départ des personnages';

  @override
  String get startingLevelShort => 'Niveau de départ';

  @override
  String get levelDecrease => 'Baisser le niveau de départ';

  @override
  String get levelIncrease => 'Monter le niveau de départ';

  @override
  String get statMethodTitle => 'Méthode de caractéristiques';

  @override
  String get statMethodHint =>
      'Imposée à toutes les créations de personnage de la table.';

  @override
  String get methodStandard => 'Valeurs standard';

  @override
  String get methodStandardHint => '15, 14, 13, 12, 10, 8 à répartir';

  @override
  String get methodPointBuyHint => '27 points, valeurs de 8 à 15';

  @override
  String get methodRandom => 'Génération aléatoire';

  @override
  String get methodRandomHint => '4d6, on retire le plus faible, six fois';

  @override
  String get longRestTitle => 'Repos long';

  @override
  String get longRestFull => 'Récupération totale des PV';

  @override
  String get longRestFullHint => 'Règle de base du SRD';

  @override
  String get longRestHitDice => 'Récupération par dés de vie';

  @override
  String get longRestHitDiceHint =>
      'Les PV ne remontent qu’en dépensant des dés de vie';

  @override
  String get longRestFullShort => 'Récupération totale';

  @override
  String get longRestHitDiceShort => 'Par dés de vie';

  @override
  String get hpOnLevelTitle => 'PV à la montée de niveau';

  @override
  String get hpAverage => 'Moyenne fixe';

  @override
  String get hpRoll => 'Jet de dé';

  @override
  String get hpAverageHint =>
      'La moyenne du dé de vie, plus le modificateur de Constitution, à chaque niveau.';

  @override
  String get hpRollHint => 'Le joueur lance son dé de vie à chaque niveau.';

  @override
  String get progressionTitle => 'Progression des personnages';

  @override
  String get progressionXp => 'Points d’expérience';

  @override
  String get progressionMilestones => 'Jalons';

  @override
  String get progressionXpHint =>
      'Les PX des rencontres s’ajoutent aux fiches à la clôture de chaque séance ; le niveau suit les seuils du SRD.';

  @override
  String get progressionMilestonesHint =>
      'Aucun PX n’apparaît aux joueurs : vous accordez les niveaux vous-même.';

  @override
  String get packsTitle => 'Packs actifs';

  @override
  String get packsHint =>
      'La version est figée pour la table ; les joueurs reçoivent les packs par la synchronisation.';

  @override
  String get srdPackName => 'SRD 5.2.1';

  @override
  String get srdPackAlways => 'Toujours actif';

  @override
  String get previewTitle => 'Aperçu de la carte';

  @override
  String get previewCharacteristics => 'Caractéristiques';

  @override
  String get previewLongRest => 'Repos long';

  @override
  String get previewHpPerLevel => 'PV par niveau';

  @override
  String get previewProgression => 'Progression';

  @override
  String get previewPacks => 'Packs';

  @override
  String get previewNext =>
      'Tout reste modifiable dans Configuration. Étape suivante : inviter les joueurs.';

  @override
  String get youAreGm => 'Vous êtes MJ';

  @override
  String get youArePlayer => 'Vous êtes joueur';

  @override
  String get tablesEmpty =>
      'Aucune table pour l’instant. Créez la vôtre, ou rejoignez celle d’un MJ avec son invitation.';

  @override
  String get roleGm => 'MJ';

  @override
  String get rolePlayer => 'Joueur';

  @override
  String get tabOverview => 'Vue d’ensemble';

  @override
  String get tabConfiguration => 'Configuration';

  @override
  String get characterCreationSection => 'Création des personnages';

  @override
  String get gameRulesSection => 'Règles de jeu';

  @override
  String get visibilitySection => 'Visibilité entre joueurs';

  @override
  String get fullSheetsLabel => 'Ouvrir les fiches complètes des autres PJ';

  @override
  String get fullSheetsHint =>
      'En lecture seule. Désactivé : chaque joueur voit nom, portrait, espèce, classe, niveau et état de santé qualitatif, sans PV chiffrés.';

  @override
  String get fullSheetsOpen => 'Ouvertes';

  @override
  String get fullSheetsClosed => 'Fermées';

  @override
  String get methodChangeTitle =>
      'Ce changement ne touche pas les fiches existantes';

  @override
  String methodChangeBody(String method) {
    return '$method s’appliquera aux prochaines créations. Les fiches de la table gardent leurs caractéristiques ; un personnage libre rattaché plus tard sera comparé à la nouvelle méthode.';
  }

  @override
  String get milestonesNote =>
      'Passer aux jalons garde les PX déjà acquis sur les fiches, mais ils n’évoluent plus ; vous accordez ensuite les niveaux vous-même.';

  @override
  String get sensitiveZone => 'Zone sensible';

  @override
  String get archiveTable => 'Archiver la table';

  @override
  String get archiveHint =>
      'Tout passe en lecture seule pour tous les membres. Restaurable à tout moment.';

  @override
  String get archiveAction => 'Archiver';

  @override
  String get restoreTable => 'Restaurer la table';

  @override
  String get restoreHint =>
      'La table redevient modifiable pour tous les membres.';

  @override
  String get restoreAction => 'Restaurer';

  @override
  String get archivedBanner =>
      'Table archivée : lecture seule pour tous les membres.';

  @override
  String get unsavedTitle => 'Modifications non enregistrées';

  @override
  String changeLine(String label, String from, String to) {
    return '$label : $from → $to';
  }

  @override
  String get whoIsNotifiedTitle => 'Qui est prévenu';

  @override
  String get whoIsNotifiedBody =>
      'Les joueurs voient la nouvelle règle dans la vue de la table à leur prochaine synchronisation. Chaque changement est daté dans l’activité de la table.';

  @override
  String get fieldMethod => 'Méthode';

  @override
  String get activityTitle => 'Activité';

  @override
  String get activityEmpty => 'Aucun changement pour l’instant.';

  @override
  String get activityArchived => 'Table archivée';

  @override
  String get activityRestored => 'Table restaurée';

  @override
  String get tabMembers => 'Membres';

  @override
  String get inviteTitle => 'Inviter des joueurs';

  @override
  String get inviteHint =>
      'Faites scanner le QR à la table, ou envoyez le lien. Le joueur a besoin du réseau pour rejoindre.';

  @override
  String get inviteCreate => 'Créer une invitation';

  @override
  String get inviteNone =>
      'Aucune invitation en cours. Une invitation vaut 7 jours.';

  @override
  String get inviteCodeLabel => 'Code';

  @override
  String get inviteCopyCode => 'Copier le code';

  @override
  String get inviteCopyLink => 'Copier le lien';

  @override
  String get inviteShare => 'Partager…';

  @override
  String inviteShareText(String table, String link, String code) {
    return 'Rejoignez « $table » sur Tavernier : $link (code $code)';
  }

  @override
  String get inviteCopied => 'Copié';

  @override
  String inviteExpires(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: 'Expire dans $days jours',
      one: 'Expire dans 1 jour',
      zero: 'Expire aujourd’hui',
    );
    return '$_temp0';
  }

  @override
  String get inviteRevoke => 'Révoquer';

  @override
  String membersCount(int count) {
    return 'Membres $count';
  }

  @override
  String memberYou(String role) {
    return '$role · vous';
  }

  @override
  String get memberUnknown => 'Membre';

  @override
  String get removeMember => 'Retirer de la table';

  @override
  String removeMemberTitle(String name) {
    return 'Retirer $name ?';
  }

  @override
  String get removeMemberBody =>
      'Sa fiche dans cette table est archivée, sans être supprimée. Une nouvelle invitation lui permettra de revenir.';

  @override
  String get removeAction => 'Retirer';

  @override
  String get removeNote =>
      'Retirer un joueur archive sa fiche, sans la supprimer.';

  @override
  String get joinTitle => 'Rejoindre une table';

  @override
  String get joinTable => 'Rejoindre';

  @override
  String get joinCodeHint =>
      'Saisissez le code à 6 caractères donné par votre MJ.';

  @override
  String get joinCodeLabel => 'Code de la table';

  @override
  String get joinOfflineTitle => 'Pas de réseau.';

  @override
  String get joinOfflineBody =>
      'Rejoindre une table demande une connexion, une seule fois. Le code est gardé : la demande partira dès que le réseau revient.';

  @override
  String get joinWaiting => 'En attente du réseau…';

  @override
  String get joinWaitingHint =>
      'En attendant, vous pouvez créer un personnage libre.';

  @override
  String get joinNeedsAccount =>
      'Un compte est nécessaire pour rejoindre une table. Le code est gardé : la demande partira une fois connecté.';

  @override
  String get joinErrorInvalid =>
      'Ce code ne correspond à aucune invitation. Vérifiez-le auprès de votre MJ.';

  @override
  String get joinErrorExpired =>
      'Cette invitation a expiré ou a été révoquée. Demandez un nouveau code à votre MJ.';

  @override
  String get joinErrorArchived =>
      'Cette table est archivée : elle n’accepte plus de joueurs.';

  @override
  String get joinErrorTooMany => 'Trop d’essais. Réessayez dans une heure.';

  @override
  String get scoreMethodTitle => 'Méthode';

  @override
  String get missingRolls =>
      'Lancez les dés ou saisissez vos jets pour obtenir vos six valeurs.';

  @override
  String get rollDice => 'Lancer';

  @override
  String get enterRolls => 'Saisir mes jets';

  @override
  String get enterRollsTitle => 'Vos six jets';

  @override
  String get enterRollsHint =>
      'Pour chaque jet : 4d6, on retire le plus faible. Valeurs de 3 à 18.';

  @override
  String rollLabel(int number) {
    return 'Jet $number';
  }

  @override
  String get rollsValidate => 'Valider';

  @override
  String rollsSummary(String values) {
    return 'Jets : $values';
  }

  @override
  String get assignHint =>
      'Choisissez une valeur pour chaque caractéristique ; une valeur déjà prise passe à l’autre.';

  @override
  String assignValueLabel(String ability) {
    return 'Valeur de $ability';
  }

  @override
  String methodImposed(String method) {
    return 'Méthode imposée par la table : $method';
  }

  @override
  String get myCharacterTitle => 'Mon personnage';

  @override
  String get createMySheet => 'Créer ma fiche';

  @override
  String get submitToGm => 'Envoyer au MJ';

  @override
  String get withdrawSheet => 'Reprendre';

  @override
  String reachStartingLevel(int level) {
    return 'Montez la fiche au niveau $level avant de l’envoyer.';
  }

  @override
  String sheetLevelStatus(int level, String status) {
    return 'Niveau $level · $status';
  }

  @override
  String get assignSlot => 'Attribuer un emplacement';

  @override
  String get removeSlot => 'Retirer l’emplacement';

  @override
  String get slotEmpty => 'Emplacement libre';

  @override
  String get statusDraft => 'en création';

  @override
  String get statusSubmitted => 'à valider';

  @override
  String get statusValidated => 'validée';

  @override
  String get statusChangesRequested => 'corrections demandées';

  @override
  String get statusArchived => 'archivée';

  @override
  String slotLineOf(String name, String status) {
    return '$name ($status)';
  }

  @override
  String get submitMessageLabel => 'Message pour le MJ (facultatif)';

  @override
  String get submitAction => 'Envoyer';

  @override
  String get correctionsTitle => 'Corrections demandées par le MJ';

  @override
  String get reviewTitle => 'Fiche à valider';

  @override
  String reviewBy(String classes, String background, String player) {
    return '$classes · $background · par $player';
  }

  @override
  String checkMethod(String method) {
    return 'Méthode de la table respectée : $method';
  }

  @override
  String checkMethodWrong(String actual, String expected) {
    return '$actual au lieu de $expected';
  }

  @override
  String checkLevel(int level) {
    return 'Niveau de départ : $level';
  }

  @override
  String checkLevelWrong(int actual, int expected) {
    return 'Niveau $actual au lieu du niveau de départ $expected';
  }

  @override
  String get checkRules => 'Règles respectées';

  @override
  String playerMessage(String player, String message) {
    return 'Message de $player : « $message »';
  }

  @override
  String get reviewCommentLabel => 'Commentaire (requis pour des corrections)';

  @override
  String get requestChanges => 'Demander des corrections';

  @override
  String get validateSheet => 'Valider';

  @override
  String get openFullSheet => 'Ouvrir la fiche complète';

  @override
  String get transferSlot => 'Transférer à…';

  @override
  String transferTitle(String name) {
    return 'Transférer $name à';
  }

  @override
  String get attachFree => 'Rattacher un personnage libre';

  @override
  String get attachTitle => 'Personnage à rattacher';

  @override
  String get attachNone =>
      'Aucun personnage libre : créez-en un depuis Personnages.';

  @override
  String get derogation => 'Dérogation';

  @override
  String get correction => 'Correction';

  @override
  String requestChangesCount(int count) {
    return 'Demander des corrections ($count)';
  }

  @override
  String derogationsNote(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count dérogations seront inscrites dans l’historique de la fiche.',
      one: '1 dérogation sera inscrite dans l’historique de la fiche.',
      zero: 'Aucune dérogation.',
    );
    return '$_temp0 Un personnage n’est rattaché qu’à une table à la fois.';
  }

  @override
  String get historyTitle => 'Historique';

  @override
  String get historyEmpty => 'Aucune entrée pour l’instant.';

  @override
  String historyDerogationLevel(String level) {
    return 'Dérogation : niveau $level accepté';
  }

  @override
  String historyDerogationMethod(String method) {
    return 'Dérogation : $method acceptée';
  }

  @override
  String historyDerogationRule(String rule) {
    return 'Dérogation : $rule';
  }

  @override
  String historyValues(String table, String sheet) {
    return 'Table : $table · Fiche : $sheet';
  }

  @override
  String historyMessage(String message) {
    return 'Message du MJ : « $message »';
  }

  @override
  String get historyNoNotification =>
      'Aucune notification envoyée ; trace conservée ici.';

  @override
  String historyAuthor(String date, String author) {
    return '$date · $author';
  }

  @override
  String get groupTitle => 'Le groupe';

  @override
  String get healthUnhurt => 'Indemne';

  @override
  String get healthWounded => 'Blessé';

  @override
  String get healthBadly => 'Gravement blessé';

  @override
  String get groupHpNote =>
      'Les PV exacts des autres joueurs restent visibles du MJ seulement.';

  @override
  String get syncSynced => 'Synchronisé';

  @override
  String syncPending(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count modifications en attente',
      one: '1 modification en attente',
    );
    return '$_temp0';
  }

  @override
  String get syncOffline => 'Hors-ligne';

  @override
  String syncOfflinePending(String pending) {
    return 'Hors-ligne · $pending';
  }

  @override
  String get syncConflict => 'Conflit résolu';

  @override
  String get conflictBannerTitle => 'Conflit résolu à la synchronisation.';

  @override
  String conflictBannerBody(
    String author,
    String field,
    String kept,
    String replaced,
  ) {
    return '$author a réglé $field à $kept ; votre valeur ($replaced) a été remplacée.';
  }

  @override
  String get conflictGmPriority => 'En combat, la version du MJ prime.';

  @override
  String get conflictSeeHistory => 'Voir l’historique';

  @override
  String get conflictOk => 'OK';

  @override
  String get conflictSomeone => 'Un autre appareil';

  @override
  String historyConflict(String field) {
    return 'Conflit résolu : $field';
  }

  @override
  String historyConflictAuthors(String kept, String replaced) {
    return 'Gardé : $kept · Remplacé : $replaced';
  }

  @override
  String get fieldHp => 'PV';

  @override
  String get fieldExhaustion => 'Épuisement';

  @override
  String get fieldInspiration => 'Inspiration héroïque';

  @override
  String get fieldConcentration => 'Concentration';

  @override
  String get fieldResources => 'Ressources';

  @override
  String get fieldName => 'Nom';

  @override
  String get fieldXp => 'PX';

  @override
  String get fieldCoins => 'Monnaie';

  @override
  String get fieldAlignment => 'Alignement';

  @override
  String get fieldAppearance => 'Apparence';

  @override
  String get fieldPersonality => 'Personnalité';

  @override
  String get fieldBackstory => 'Histoire';

  @override
  String get valueYes => 'Oui';

  @override
  String get valueNo => 'Non';

  @override
  String get valueNone => 'aucune';

  @override
  String get myDataSection => 'Mes données';

  @override
  String get exportDataHint =>
      'Fiches, tables et notes, dans un fichier JSON que vous pourrez réimporter.';

  @override
  String get exportDataAction => 'Exporter mes données';

  @override
  String get exportNever => 'Aucun export sur cet appareil.';

  @override
  String exportLast(String date) {
    return 'Dernier export : $date.';
  }

  @override
  String get exportFailed => 'L’export a échoué. Réessayez.';

  @override
  String get importDataAction => 'Importer une sauvegarde';

  @override
  String get importConfirmTitle => 'Importer cette sauvegarde ?';

  @override
  String get importConfirmBody =>
      'Les éléments absents de cet appareil seront ajoutés. Ceux qui y sont déjà restent tels quels.';

  @override
  String get importConfirm => 'Importer';

  @override
  String importDone(int added, int kept) {
    String _temp0 = intl.Intl.pluralLogic(
      added,
      locale: localeName,
      other: '$added éléments ajoutés',
      one: '1 élément ajouté',
      zero: 'Aucun élément ajouté',
    );
    String _temp1 = intl.Intl.pluralLogic(
      kept,
      locale: localeName,
      other: '$kept déjà présents',
      one: '1 déjà présent',
      zero: 'aucun déjà présent',
    );
    return '$_temp0, $_temp1.';
  }

  @override
  String get importRefused =>
      'Ce fichier n’est pas une sauvegarde de Tavernier.';

  @override
  String get importFailed => 'L’import a échoué. Réessayez.';

  @override
  String backupReminderTitle(int days) {
    return 'Aucune sauvegarde depuis $days jours';
  }

  @override
  String get backupReminderBody =>
      'Ni synchronisation ni export sur cet appareil. Exportez vos données pour ne rien perdre.';

  @override
  String get backupLater => 'Plus tard';

  @override
  String get backupExportNow => 'Exporter maintenant';

  @override
  String get deleteAccountTitle => 'Supprimer le compte';

  @override
  String get deleteAccountHint =>
      'Un export de vos données vous sera proposé avant la suppression.';

  @override
  String deleteAccountGmTables(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'Vous êtes MJ de $count tables.',
      one: 'Vous êtes MJ de 1 table.',
    );
    return '$_temp0';
  }

  @override
  String get deleteAccountAction => 'Supprimer mon compte…';

  @override
  String get deleteAccountBackupTitle => 'D’abord, gardez une copie';

  @override
  String get deleteAccountBackupBody =>
      'Fiches, tables, packs et notes, dans un fichier JSON que vous pourrez réimporter.';

  @override
  String get deleteAccountWhatHappens => 'Ce qui va se passer';

  @override
  String get deleteAccountCharacters =>
      'Vos personnages sont retirés des tables où ils jouent.';

  @override
  String get deleteAccountTables =>
      'Les tables dont vous êtes MJ restent en place pour leurs joueurs, mais sans MJ.';

  @override
  String get deleteAccountPacks =>
      'Les packs que vous avez publiés restent disponibles, attribués à « auteur supprimé ».';

  @override
  String get deleteAccountServers =>
      'Le compte et ses données sont effacés des serveurs sous 30 jours.';

  @override
  String get deleteAccountConfirmLabel => 'Tapez SUPPRIMER pour confirmer';

  @override
  String get deleteAccountConfirmWord => 'SUPPRIMER';

  @override
  String get deleteAccountFinal => 'La suppression est définitive.';

  @override
  String get deleteAccountConfirm => 'Supprimer définitivement';

  @override
  String get deleteAccountOffline =>
      'Le serveur ne répond pas : rien n’a été supprimé. Réessayez une fois connecté.';

  @override
  String pendingValidationTitle(String gm) {
    return 'En attente de validation par $gm · utilisable en jeu';
  }

  @override
  String get pendingValidationGm => 'le MJ';

  @override
  String get pendingValidationBody =>
      'Les corrections demandées s’appliqueront après la séance, sans perdre vos PV ni vos emplacements utilisés.';

  @override
  String proposalTitle(String gm, String summary) {
    return '$gm propose : $summary';
  }

  @override
  String get proposalSomeone => 'Le MJ';

  @override
  String proposalReplaceFeat(String from, String to) {
    return 'remplacer le don $from par $to';
  }

  @override
  String get proposalChangeSheet => 'modifier la fiche';

  @override
  String proposalReason(String reason) {
    return 'Motif : « $reason »';
  }

  @override
  String get proposalValue => 'Valeur';

  @override
  String get proposalBefore => 'Avant';

  @override
  String get proposalAfter => 'Après';

  @override
  String get proposalFeatRow => 'Don';

  @override
  String get proposalSkillsRow => 'Maîtrises';

  @override
  String proposalSkillsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count compétences',
      one: '1 compétence',
    );
    return '$_temp0';
  }

  @override
  String proposalSkillsAdded(String skills) {
    return '+ $skills';
  }

  @override
  String proposalSkillsRemoved(String skills) {
    return '− $skills';
  }

  @override
  String get proposalRefuseMessage => 'Message si vous refusez';

  @override
  String get proposalRefuse => 'Refuser';

  @override
  String get proposalAccept => 'Accepter';

  @override
  String get proposalAcceptNote =>
      'L’acceptation applique la modification et l’inscrit dans l’historique de la fiche.';

  @override
  String historyProposal(String summary) {
    return 'Proposition acceptée : $summary';
  }

  @override
  String historyProposalBy(String gm, String reason) {
    return 'Proposée par $gm · Motif : « $reason »';
  }

  @override
  String get proposalAction => 'Proposer une modification';

  @override
  String proposalPageTitle(String player) {
    return 'Proposer une modification à $player';
  }

  @override
  String get proposalPlayer => 'le joueur';

  @override
  String proposalPageIntro(String name) {
    return '$name · hors combat, une modification structurelle passe par l’accord du joueur.';
  }

  @override
  String get proposalNoFeat =>
      'Cette fiche n’a pas de don d’origine ni de style de combat à remplacer.';

  @override
  String get proposalTypeFeat => 'Type : don';

  @override
  String get proposalReplace => 'Remplacer';

  @override
  String get proposalBy => 'Par';

  @override
  String get proposalEligibleHint =>
      'Seuls les dons éligibles sont proposés : même catégorie, pas déjà pris.';

  @override
  String proposalChoose(int count, int picked) {
    return 'Choisir $count ($picked/$count)';
  }

  @override
  String get proposalReasonLabel => 'Motif (obligatoire, visible du joueur)';

  @override
  String get proposalSend => 'Envoyer la proposition';

  @override
  String proposalSent(String player) {
    return 'Proposition envoyée à $player.';
  }

  @override
  String proposalPending(String player) {
    return 'Proposition envoyée à $player : en attente de sa réponse.';
  }

  @override
  String proposalRefused(String player) {
    return '$player a refusé votre proposition';
  }

  @override
  String get proposalRefusedNoReply => 'Sans message.';

  @override
  String levelUnlockXp(String xp) {
    return 'Seuil de $xp PX atteint';
  }

  @override
  String levelUnlockMilestone(int level, String name) {
    return 'Niveau $level accordé par $name';
  }

  @override
  String levelUnlockOverride(int level, String name) {
    return 'Niveau $level débloqué par $name (dérogation)';
  }

  @override
  String levelUnlockReason(String reason) {
    return 'Jalon : « $reason »';
  }

  @override
  String get levelUnlockGm => 'le MJ';

  @override
  String get levelUnlockLater => 'Plus tard';

  @override
  String levelUnlockChip(int level) {
    return 'Niveau $level';
  }

  @override
  String xpProgress(String xp, String next) {
    return '$xp / $next PX';
  }

  @override
  String xpProgressLabel(int level, String xp, String next) {
    return 'Progression : $xp PX sur $next, niveau $level';
  }

  @override
  String levelOverrideAction(int level) {
    return 'Débloquer le niveau $level';
  }

  @override
  String levelOverrideBody(int level, String name) {
    return '$name pourra monter au niveau $level sans attendre le seuil de PX ni un jalon. La dérogation est inscrite dans l\'historique de la fiche.';
  }

  @override
  String get levelOverrideReason => 'Motif (facultatif)';

  @override
  String get levelOverrideConfirm => 'Débloquer';

  @override
  String levelOverrideDone(int level) {
    return 'Niveau $level débloqué.';
  }

  @override
  String historyLevelGrant(int level) {
    return 'Niveau $level accordé';
  }

  @override
  String historyLevelOverride(int level) {
    return 'Niveau $level débloqué (dérogation)';
  }

  @override
  String historyLevelUp(int level) {
    return 'Montée au niveau $level';
  }
}
