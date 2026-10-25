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
  'traits': {'feature'},
  'features': {'feature'},
  'parent_class': {'class'},
  'item': {'weapon', 'armor', 'tool', 'item'},
  'source': {'class', 'subclass', 'species', 'feat'},
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
