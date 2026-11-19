// Assistant Étude, Influence, Observation (US-24, EF-ACT-01 à 05) : tables
// de règles du contenu actif, paliers d'information atteints.
import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';

/// Données des entités `rule` du contenu actif, dans l'ordre des packs.
Iterable<RuleData> _rules(ActiveContent content) => [
  for (final e in content.entities)
    if (e.data case final RuleData data) data,
];

/// Table « Domaines de savoir » : celle du dernier pack qui en porte une,
/// pour qu'un pack remplace celle du SRD (EF-ACT-05).
Map<CreatureType, ContentId> studySkills(ActiveContent content) =>
    _rules(content)
        .lastWhere((r) => r.studySkills.isNotEmpty, orElse: RuleData.new)
        .studySkills;

/// Table « Tests d'Influence » du contenu actif, comme [studySkills].
List<InfluenceCheck> influenceChecks(ActiveContent content) =>
    _rules(content)
        .lastWhere((r) => r.influenceChecks.isNotEmpty, orElse: RuleData.new)
        .influenceChecks;

/// Compétence suggérée pour étudier une créature de [type] ; `null` sans
/// type ou hors de la table.
ContentId? suggestedStudySkill(ActiveContent content, CreatureType? type) =>
    type == null ? null : studySkills(content)[type];

/// Indices des paliers de [dcs] qu'atteint [total] : DD inférieur ou égal.
List<int> reachedTiers(List<int> dcs, int total) => [
  for (final (i, dc) in dcs.indexed)
    if (dc <= total) i,
];
