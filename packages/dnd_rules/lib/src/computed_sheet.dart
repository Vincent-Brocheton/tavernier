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

/// Valeur de caractéristique et son modificateur (SRD p. 22).
final class AbilityScore extends Computed {
  AbilityScore(super.sources);

  int get modifier => ((value - 10) / 2).floor();
}

/// Règle d'intégrité enfreinte (cahier §11.3 et SRD).
enum IntegrityRule {
  abilityGeneration,
  backgroundBonus,
  featGrant,
  weaponMastery,
  multiclass,
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
final class ComputedSheet {
  const ComputedSheet({
    required this.level,
    required this.proficiencyBonus,
    required this.abilities,
    required this.pointBuyCost,
    required this.integrityErrors,
  });

  final int level;
  final int proficiencyBonus;

  /// Par code de caractéristique (`str`…`cha`).
  final Map<String, AbilityScore> abilities;

  /// Coût en points, pour la méthode « Acquisition par points ».
  final int? pointBuyCost;
  final List<IntegrityError> integrityErrors;

  Map<String, Object?> toJson() => {
    'level': level,
    'proficiency_bonus': proficiencyBonus,
    if (pointBuyCost != null) 'point_buy_cost': pointBuyCost,
    'abilities': {
      for (final MapEntry(:key, :value) in abilities.entries)
        key: {'score': value.value, 'modifier': value.modifier},
    },
    'integrity_errors': [for (final e in integrityErrors) e.toJson()],
    'sources': {
      for (final MapEntry(:key, :value) in abilities.entries)
        key: [for (final c in value.sources) c.toJson()],
    },
  };
}
