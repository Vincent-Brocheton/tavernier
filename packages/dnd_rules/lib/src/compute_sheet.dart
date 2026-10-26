import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';
import 'computed_sheet.dart';

const abilityCodes = ['str', 'dex', 'con', 'int', 'wis', 'cha'];

/// SRD p. 22, « Coût des valeurs de caractéristique ».
const _pointBuyCost = {8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9};

/// SRD p. 22, « Valeurs standard ».
const _standardArray = [15, 14, 13, 12, 10, 8];

/// Calcule la fiche d'un personnage (cahier §10.3) : fonction pure, sans
/// base, réseau ni Flutter. Les règles enfreintes sont listées dans
/// [ComputedSheet.integrityErrors], jamais levées.
ComputedSheet computeSheet(CharacterInput character, ActiveContent content) {
  final errors = <IntegrityError>[];
  final level = character.classLevels.fold(0, (sum, c) => sum + c.level);

  final background = content.entity(character.backgroundId);
  final abilities = {
    for (final code in abilityCodes)
      code: AbilityScore([
        Contribution('base', character.baseScores.of(code)),
        if (character.backgroundChoice.bonuses[code] case final bonus?
            when bonus != 0)
          Contribution(character.backgroundId, bonus),
      ]),
  };

  errors
    ..addAll(_checkGeneration(character.baseScores))
    ..addAll(_checkBackgroundBonus(character, background, abilities));

  return ComputedSheet(
    level: level,
    proficiencyBonus: _proficiencyBonus(level),
    abilities: abilities,
    pointBuyCost: character.baseScores.method == ScoreMethod.pointBuy
        ? _cost(character.baseScores)
        : null,
    integrityErrors: errors,
  );
}

/// SRD p. 24, « Progression des personnages ».
int _proficiencyBonus(int level) => 2 + (level - 1) ~/ 4;

int _cost(BaseScores scores) =>
    abilityCodes.fold(0, (sum, c) => sum + (_pointBuyCost[scores.of(c)] ?? 99));

List<IntegrityError> _checkGeneration(BaseScores scores) {
  final values = [for (final c in abilityCodes) scores.of(c)]..sort();
  String? problem;
  switch (scores.method) {
    case ScoreMethod.pointBuy:
      if (values.any((v) => v < 8 || v > 15)) {
        problem = 'acquisition par points : valeurs de 8 à 15';
      } else if (_cost(scores) != 27) {
        problem =
            'acquisition par points : ${_cost(scores)} points au lieu de 27';
      }
    case ScoreMethod.standardArray:
      if ('$values' != '${[..._standardArray]..sort()}') {
        problem = 'valeurs standard : 15, 14, 13, 12, 10 et 8 attendues';
      }
    case ScoreMethod.random:
      final rolls = [...?scores.rolls]..sort();
      if (rolls.any((r) => r < 3 || r > 18) || '$rolls' != '$values') {
        problem = 'génération aléatoire : les valeurs doivent être les jets';
      }
  }
  return [
    if (problem != null)
      IntegrityError(IntegrityRule.abilityGeneration, 'base_scores', problem),
  ];
}

/// Cahier §11.3 : bonus sur les 3 caractéristiques de l'Historique, en 2-1
/// ou 1-1-1, sans dépasser 20 (SRD p. 87).
List<IntegrityError> _checkBackgroundBonus(
  CharacterInput character,
  ContentEntity? background,
  Map<String, AbilityScore> abilities,
) {
  final choice = character.backgroundChoice;
  final eligible = background?.data is BackgroundData
      ? {
          for (final id in (background!.data as BackgroundData).abilities)
            for (final MapEntry(:key, :value) in abilityIdByCode.entries)
              if (value == '$id') key,
        }
      : const <String>{};
  final bonuses = choice.bonuses.entries.where((e) => e.value != 0);
  final values = [for (final e in bonuses) e.value]..sort();
  final expected = switch (choice.distribution) {
    '2-1' => [1, 2],
    '1-1-1' => [1, 1, 1],
    _ => null,
  };
  return [
    if (expected == null || '$values' != '$expected')
      const IntegrityError(
        IntegrityRule.backgroundBonus,
        'background_choice.bonuses',
        'répartition +2/+1 ou +1/+1/+1 attendue',
      ),
    for (final e in bonuses)
      if (!eligible.contains(e.key))
        IntegrityError(
          IntegrityRule.backgroundBonus,
          'background_choice.bonuses.${e.key}',
          'caractéristique non proposée par l\'Historique',
        ),
    for (final e in bonuses)
      if (abilities[e.key]!.value > 20)
        IntegrityError(
          IntegrityRule.backgroundBonus,
          'background_choice.bonuses.${e.key}',
          'le bonus d\'Historique ne peut pas dépasser 20',
        ),
  ];
}
