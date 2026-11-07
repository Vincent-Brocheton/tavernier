import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'compute_sheet.dart';
import 'computed_sheet.dart';
import 'creation_rules.dart';

/// Table « Valeurs standard par classe » du SRD, dans l'ordre de
/// [abilityCodes].
const _standardByClass = {
  'srd:class:barbarian': [15, 13, 14, 10, 12, 8],
  'srd:class:bard': [8, 14, 12, 13, 10, 15],
  'srd:class:cleric': [14, 8, 13, 10, 15, 12],
  'srd:class:druid': [8, 12, 14, 13, 15, 10],
  'srd:class:sorcerer': [10, 13, 14, 8, 12, 15],
  'srd:class:fighter': [15, 14, 13, 8, 10, 12],
  'srd:class:wizard': [8, 12, 13, 15, 14, 10],
  'srd:class:monk': [12, 15, 13, 10, 14, 8],
  'srd:class:warlock': [8, 14, 13, 12, 10, 15],
  'srd:class:paladin': [15, 10, 13, 8, 12, 14],
  'srd:class:ranger': [12, 15, 13, 8, 14, 10],
  'srd:class:rogue': [12, 15, 13, 14, 10, 8],
};

/// Tableau standard, des plus hautes aux plus basses valeurs.
const _standardArray = [15, 14, 13, 12, 10, 8];

/// Codes des caractéristiques principales de [data].
List<String> _primaryCodes(ClassData data) => [
  for (final id in data.primaryAbilities)
    for (final MapEntry(:key, :value) in abilityIdByCode.entries)
      if (value == '$id') key,
];

/// Valeurs suggérées à [classId]. Une classe de pack, absente de la table du
/// SRD, reçoit le tableau standard : principales d'abord, puis Constitution.
Map<String, int> suggestedScores(String classId, ClassData data) {
  if (_standardByClass[classId] case final scores?) {
    return {for (final (i, code) in abilityCodes.indexed) code: scores[i]};
  }
  final order = {..._primaryCodes(data), 'con', ...abilityCodes};
  return {for (final (i, code) in order.indexed) code: _standardArray[i]};
}

/// Bonus d'Historique en 2-1 : +2 puis +1 sur les plus hautes valeurs de
/// [eligible].
Map<String, int> suggestedBonuses(
  Map<String, int> scores,
  Set<String> eligible,
) {
  final best = eligible.toList()
    ..sort((a, b) => (scores[b] ?? 0).compareTo(scores[a] ?? 0));
  return {for (final (i, code) in best.take(2).indexed) code: 2 - i};
}

/// [count] compétences de [options], celles des caractéristiques principales
/// d'abord.
List<String> suggestedSkills(
  ActiveContent content,
  ClassData data,
  List<String> options,
  int count,
) {
  final primary = {for (final id in data.primaryAbilities) '$id'};
  bool key(String id) {
    final skill = content.entity(id)?.data;
    return skill is SkillData && primary.contains('${skill.ability}');
  }

  return [
    ...options.where(key),
    ...options.where((id) => !key(id)),
  ].take(count).toList();
}

/// [count] armes de [options], celles de l'équipement de départ d'abord.
List<String> suggestedMasteries(
  ClassData data,
  List<String> options,
  int count,
) {
  final starting = {
    for (final option in data.startingEquipment)
      for (final item in option.items) '${item.item}',
  };
  return [
    ...options.where(starting.contains),
    ...options.where((id) => !starting.contains(id)),
  ].take(count).toList();
}

/// Amélioration suggérée : +2 sur une caractéristique principale qui le
/// permet, sinon +1 sur les deux meilleures qui le permettent.
List<String> suggestedImprovement(ComputedSheet sheet, ClassData data) {
  int score(String code) => sheet.abilities[code]!.value;
  for (final code in _primaryCodes(data)) {
    if (score(code) + 2 <= abilityScoreCap) return [code];
  }
  final order = {..._primaryCodes(data), ...abilityCodes}.toList()
    ..sort((a, b) => score(b).compareTo(score(a)));
  return order.where((c) => score(c) < abilityScoreCap).take(2).toList();
}
