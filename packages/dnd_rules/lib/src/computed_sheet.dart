import 'creation_rules.dart';

/// Une contribution à une valeur calculée (EF-PJ-03) : `base`, un code de
/// caractéristique ou l'identifiant de l'entité qui contribue.
final class Contribution {
  const Contribution(this.label, this.value);

  final String label;
  final int value;

  Map<String, Object?> toJson() => {'label': label, 'value': value};

  @override
  bool operator ==(Object other) =>
      other is Contribution && other.label == label && other.value == value;

  @override
  int get hashCode => Object.hash(label, value);

  @override
  String toString() => '$label $value';
}

/// Valeur calculée et sa décomposition ; la somme des contributions égale
/// la valeur.
final class Computed {
  Computed(this.sources) : value = sources.fold(0, (sum, c) => sum + c.value);

  final List<Contribution> sources;
  final int value;
}

/// Initiative : valeur décomposée et Avantage éventuel.
final class Initiative extends Computed {
  Initiative(super.sources, {required this.advantage});

  final bool advantage;
}

/// Valeur de caractéristique et son modificateur (SRD p. 22).
final class AbilityScore extends Computed {
  AbilityScore(super.sources);

  int get modifier => abilityModifier(value);
}

/// Une attaque de la fiche (arme portée ou mains nues).
final class Attack {
  const Attack({
    required this.weaponId,
    required this.attackBonus,
    this.sources = const [],
    required this.damage,
    required this.damageType,
    this.rangeFeet,
    this.mastery,
  });

  /// Identifiant de l'arme, ou `unarmed`.
  final String weaponId;
  final int attackBonus;

  /// Décomposition du bonus d'attaque.
  final List<Contribution> sources;

  /// Dés et modificateur, ex. `1d8+3` ; un nombre pour les mains nues.
  final String damage;

  /// Slug du type de dégâts, ex. `slashing`.
  final String damageType;
  final List<int>? rangeFeet;

  /// Botte choisie pour cette arme.
  final String? mastery;

  Map<String, Object?> toJson() => {
    'weapon_id': weaponId,
    'attack_bonus': attackBonus,
    'damage': damage,
    'damage_type': damageType,
    if (rangeFeet != null) 'range_feet': rangeFeet,
    if (mastery != null) 'mastery': mastery,
  };
}

/// Règle d'intégrité enfreinte (cahier §11.3 et SRD).
enum IntegrityRule {
  abilityGeneration,
  backgroundBonus,
  featGrant,
  weaponMastery,
  multiclass,
  choice,
  reference,
}

final class IntegrityError {
  const IntegrityError(this.rule, this.path, this.message);

  final IntegrityRule rule;

  /// Chemin dans l'entrée du personnage, ex. `background_choice.bonuses`.
  final String path;
  final String message;

  Map<String, Object?> toJson() => {
    'rule': rule.name,
    'path': path,
    'message': message,
  };

  @override
  String toString() => '${rule.name} $path : $message';
}

/// Fiche calculée par `computeSheet`. [toJson] a la forme du bloc
/// `expected` des fixtures [D1].
/// Valeurs d'incantation d'une classe.
final class ClassCasting {
  const ClassCasting({
    required this.ability,
    required this.saveDc,
    required this.attackBonus,
    required this.cantripsKnown,
    required this.preparedMax,
  });

  /// Code de la caractéristique d'incantation.
  final String ability;
  final Computed saveDc;
  final Computed attackBonus;
  final int cantripsKnown;
  final int preparedMax;

  Map<String, Object?> toJson() => {
    'ability': ability,
    'save_dc': saveDc.value,
    'attack_bonus': attackBonus.value,
    'cantrips_known': cantripsKnown,
    'prepared_max': preparedMax,
  };
}

/// Magie de pacte de l'Occultiste, récupérée au repos court.
final class PactMagic {
  const PactMagic({required this.slots, required this.slotLevel});

  final int slots;

  /// Niveau auquel les sorts sont toujours lancés.
  final int slotLevel;

  Map<String, Object?> toJson() => {
    'slots': slots,
    'slot_level': slotLevel,
    'recharge': 'short_rest',
  };
}

final class ComputedSheet {
  const ComputedSheet({
    required this.level,
    required this.proficiencyBonus,
    required this.abilities,
    required this.pointBuyCost,
    required this.savingThrows,
    required this.saveBreakdown,
    required this.savingThrowProficiencies,
    required this.skills,
    required this.skillBreakdown,
    required this.skillProficiencies,
    required this.passivePerception,
    required this.initiative,
    required this.armorClass,
    required this.speed,
    required this.hitPointsMax,
    required this.hitDice,
    required this.proficientWeapons,
    required this.spellcasting,
    required this.casterLevel,
    required this.spellSlots,
    required this.pactMagic,
    required this.resources,
    required this.weaponMasterySlots,
    required this.attacks,
    required this.integrityErrors,
  });

  final int level;
  final int proficiencyBonus;

  /// Par code de caractéristique (`str`…`cha`).
  final Map<String, AbilityScore> abilities;

  /// Coût en points, pour la méthode « Acquisition par points ».
  final int? pointBuyCost;

  /// Par code de caractéristique.
  final Map<String, int> savingThrows;
  final Map<String, Computed> saveBreakdown;
  final List<String> savingThrowProficiencies;

  /// Par compétence, clé en snake_case (`animal_handling`).
  final Map<String, int> skills;
  final Map<String, Computed> skillBreakdown;
  final List<String> skillProficiencies;
  final int passivePerception;
  final Initiative initiative;
  final Computed armorClass;

  /// Vitesse en pieds.
  final Computed speed;
  int get speedFeet => speed.value;
  final Computed hitPointsMax;

  /// Une entrée par type de dé, dans l'ordre des classes.
  final List<({String die, int total})> hitDice;

  /// Identifiants des armes maîtrisées.
  final Set<String> proficientWeapons;

  /// Valeurs d'incantation, par classe de lanceur.
  final Map<String, ClassCasting> spellcasting;

  /// Niveau de lanceur d'un multiclassé à deux classes à emplacements.
  final int? casterLevel;

  /// Emplacements par niveau de sort, du 1er au plus haut.
  final List<int> spellSlots;
  final PactMagic? pactMagic;

  /// Maximum de chaque ressource, par clé (`srd:resource:second-wind`).
  final Map<String, int> resources;
  final int weaponMasterySlots;
  final List<Attack> attacks;
  final List<IntegrityError> integrityErrors;

  Map<String, Object?> toJson() => {
    'level': level,
    'proficiency_bonus': proficiencyBonus,
    if (pointBuyCost != null) 'point_buy_cost': pointBuyCost,
    'abilities': {
      for (final MapEntry(:key, :value) in abilities.entries)
        key: {'score': value.value, 'modifier': value.modifier},
    },
    'saving_throws': savingThrows,
    'saving_throw_proficiencies': savingThrowProficiencies,
    'skills': skills,
    'skill_proficiencies': skillProficiencies,
    'passive_perception': passivePerception,
    'initiative': {
      'bonus': initiative.value,
      'advantage': initiative.advantage,
    },
    'armor_class': armorClass.value,
    'speed_feet': speedFeet,
    'hit_points_max': hitPointsMax.value,
    'hit_dice': [
      for (final dice in hitDice) {'die': dice.die, 'total': dice.total},
    ],
    'resources': [
      for (final MapEntry(:key, :value) in resources.entries)
        {'id': key, 'max': value},
    ],
    'weapon_mastery_slots': weaponMasterySlots,
    'spellcasting': {
      for (final MapEntry(:key, :value) in spellcasting.entries)
        key: value.toJson(),
    },
    'caster_level': casterLevel,
    'spell_slots': spellSlots,
    'pact_magic': pactMagic?.toJson(),
    'attacks': [for (final a in attacks) a.toJson()],
    'integrity_errors': [for (final e in integrityErrors) e.toJson()],
    'sources': {
      for (final MapEntry(:key, :value) in {
        ...abilities,
        'armor_class': armorClass,
        'initiative': initiative,
        'hit_points_max': hitPointsMax,
      }.entries)
        key: [for (final c in value.sources) c.toJson()],
    },
  };
}
