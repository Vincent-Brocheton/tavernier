import '../content_id.dart';
import '../content_issue.dart';
import '../dsl/effect.dart';
import '../entities/content_entity.dart';
import '../entities/entity_data.dart';
import 'manifest.dart';

/// Un pack : son manifeste et ses entités.
final class ContentPack {
  const ContentPack({required this.manifest, required this.entities});

  final PackManifest manifest;
  final List<ContentEntity> entities;
}

/// Type attendu des références portées par les champs de `data`.
const _referenceTypes = <String, Set<String>>{
  'ability': {'ability'},
  'abilities': {'ability'},
  'primary_abilities': {'ability'},
  'saving_throws': {'ability'},
  'damage_type': {'damage-type'},
  'mastery': {'mastery'},
  'origin_feat': {'feat'},
  'skill_proficiencies': {'skill'},
  'skill_choices': {'skill'},
  'tool_proficiency': {'tool'},
  'tool_proficiencies': {'tool'},
  'traits': {'feature'},
  'features': {'feature'},
  'parent_class': {'class'},
  'spell_list': {'spell'},
  'spellcasting_ability': {'ability'},
  'item': {'weapon', 'armor', 'tool', 'item'},
  'source': {'class', 'subclass', 'species', 'feat'},
  'vulnerabilities': {'damage-type'},
  'resistances': {'damage-type'},
  'immunities': {'damage-type'},
  'condition_immunities': {'condition'},
  'damage': {'damage-type'},
};

/// Références (id, types acceptés ou `null` pour tout type) d'une entité.
Iterable<(String, Set<String>?)> _references(ContentEntity entity) sync* {
  Iterable<(String, Set<String>?)> scan(
    Object? value,
    Set<String>? types,
  ) sync* {
    switch (value) {
      case String() when ContentId.tryParse(value)?.type != 'resource':
        if (ContentId.isValid(value)) yield (value, types);
      case Map<String, dynamic>():
        for (final MapEntry(:key, :value) in value.entries) {
          yield* scan(value, _referenceTypes[key] ?? types);
        }
      case List<dynamic>():
        for (final item in value) {
          yield* scan(item, types);
        }
    }
  }

  yield* scan(entity.data.toJson(), null);
  // Les compétences d'un monstre sont les clés de `skills`.
  if (entity.data case MonsterData(:final skills)) {
    for (final id in skills.keys) {
      yield (id, {'skill'});
    }
  }
  for (final effect in entity.effects) {
    for (final id in effectReferences(effect)) {
      yield (id, null);
    }
  }
  if (entity.extendsId case final parent?) yield ('$parent', {entity.type});
}

/// Contrôle d'un pack : identifiants uniques, références résolues et
/// typées, règles d'intégrité du contenu (cahier §11.3), licence.
List<ContentIssue> validatePack(
  ContentPack pack, {
  Iterable<ContentEntity> dependencies = const [],
}) {
  final issues = <ContentIssue>[];
  final manifest = pack.manifest;
  if (manifest.licence.trim().isEmpty) {
    issues.add(const ContentIssue('manifest.licence', 'licence obligatoire'));
  }
  if (manifest.origin == PackOrigin.srd &&
      manifest.attribution != srdAttributionFr) {
    issues.add(
      const ContentIssue(
        'manifest.attribution',
        'l\'attribution du SRD doit reprendre mot pour mot la déclaration du cahier §1.3',
      ),
    );
  }

  final known = {for (final e in dependencies) '${e.id}': e};
  final own = <String>{};
  for (final entity in pack.entities) {
    final key = '${entity.id}';
    if (!own.add(key)) issues.add(ContentIssue(key, 'identifiant en double'));
    known[key] = entity;
  }

  for (final entity in pack.entities) {
    final path = '${entity.id}';
    for (final (id, types) in _references(entity)) {
      final target = known[id];
      if (target == null) {
        issues.add(ContentIssue(path, 'référence introuvable : $id'));
      } else if (types != null && !types.contains(target.type)) {
        issues.add(
          ContentIssue(
            path,
            '$id : type « ${types.join(' ou ')} » attendu, reçu « ${target.type} »',
          ),
        );
      }
    }
    if (entity.data case final MonsterData monster) {
      issues.addAll(_monsterIssues(path, monster));
    }
    if (entity.data case final BackgroundData background) {
      if (background.abilities.length != 3) {
        issues.add(
          ContentIssue(
            '$path.data.abilities',
            'un Historique cite exactement 3 caractéristiques',
          ),
        );
      }
      final feat = known['${background.originFeat}']?.data;
      if (feat is FeatData && feat.category != FeatCategory.origin) {
        issues.add(
          ContentIssue(
            '$path.data.origin_feat',
            'le don d\'un Historique doit être un don d\'origines',
          ),
        );
      }
    }
  }
  return issues;
}

/// PX par FP, table « Points d'expérience par facteur de puissance » du SRD
/// (FP 0 : 0 ou 10 PX).
const _xpByCr = <String, List<int>>{
  '0': [0, 10], '1/8': [25], '1/4': [50], '1/2': [100], '1': [200], //
  '2': [450], '3': [700], '4': [1100], '5': [1800], '6': [2300], //
  '7': [2900], '8': [3900], '9': [5000], '10': [5900], '11': [7200], //
  '12': [8400], '13': [10000], '14': [11500], '15': [13000], //
  '16': [15000], '17': [18000], '18': [20000], '19': [22000], //
  '20': [25000], '21': [33000], '22': [41000], '23': [50000], //
  '24': [62000], '25': [75000], '26': [90000], '27': [105000], //
  '28': [120000], '29': [135000], '30': [155000],
};

/// BM par FP, table « Bonus de maîtrise par facteur de puissance » du SRD :
/// +2 jusqu'à FP 4, puis +1 tous les 4 FP.
int _proficiencyBonusOf(String cr) {
  final value = int.tryParse(cr) ?? 0;
  return value < 5 ? 2 : (value - 1) ~/ 4 + 2;
}

List<ContentIssue> _monsterIssues(String path, MonsterData m) {
  final xp = _xpByCr[m.cr];
  if (xp == null) {
    return [ContentIssue('$path.data.cr', 'FP inconnu : ${m.cr}')];
  }
  final pb = _proficiencyBonusOf(m.cr);
  return [
    if (!xp.contains(m.xp))
      ContentIssue(
        '$path.data.xp',
        'FP ${m.cr} : ${xp.join(' ou ')} PX attendus, reçu ${m.xp}',
      ),
    if (m.proficiencyBonus != pb)
      ContentIssue(
        '$path.data.proficiency_bonus',
        'FP ${m.cr} : BM +$pb attendu, reçu +${m.proficiencyBonus}',
      ),
    if (m.legendaryUses == null &&
        m.actions.any((a) => a.kind == MonsterActionKind.legendary))
      ContentIssue(
        '$path.data.legendary_uses',
        'nombre d’utilisations requis pour une action Légendaire',
      ),
  ];
}
