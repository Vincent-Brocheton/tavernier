// Assistant Étude, Influence, Observation (US-24, EF-ACT-01 à 05) : tables
// de règles du contenu actif, paliers d'information atteints.
import 'dart:math';

import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'dice.dart';

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

/// DD d'une Influence (SRD) : 15, ou l'Intelligence de la cible si elle est
/// plus élevée.
int influenceDc(int? intelligence) => max(15, intelligence ?? 0);

/// L'attitude module le test (SRD) : Avantage contre une cible Amicale,
/// Désavantage contre une cible Hostile.
RollMode influenceMode(String attitude) => switch (attitude) {
  'friendly' => RollMode.advantage,
  'hostile' => RollMode.disadvantage,
  _ => RollMode.normal,
};

/// Façons d'interagir possibles avec une créature de [type] : celles sans
/// type requis, et celles qui le visent.
List<InfluenceCheck> influenceChecksFor(
  ActiveContent content,
  CreatureType? type,
) => [
  for (final c in influenceChecks(content))
    if (c.creatureTypes.isEmpty || c.creatureTypes.contains(type)) c,
];

/// Tentative d'Influence passée, lue au journal de la table.
typedef InfluenceAttempt = ({
  DateTime at,
  String actor,
  String target,
  String approach,
  bool success,
  int retryHours,
});

/// Fin de l'attente après le dernier échec de [actor] sur [target] avec
/// [approach] (SRD : 24 heures, ou une autre durée fixée par le MJ) ; `null`
/// si rien n'empêche une nouvelle tentative à [now] (EF-ACT-03).
DateTime? influenceBlockedUntil(
  Iterable<InfluenceAttempt> attempts, {
  required String actor,
  required String target,
  required String approach,
  required DateTime now,
}) {
  DateTime? until;
  for (final a in attempts) {
    if (a.success ||
        a.actor != actor ||
        a.target != target ||
        a.approach != approach) {
      continue;
    }
    final end = a.at.add(Duration(hours: a.retryHours));
    if (end.isAfter(now) && (until == null || end.isAfter(until))) until = end;
  }
  return until;
}
