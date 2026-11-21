// Brouillons homebrew (US-27, EF-HB-01, EF-HB-11) : un pack en cours
// d'édition, en JSON brut, et ses problèmes, qui bloquent la publication
// sans bloquer l'enregistrement.
import 'dart:convert';

import '../content_issue.dart';
import '../entities/content_entity.dart';
import '../entities/entity_data.dart';
import 'content_pack.dart';
import 'manifest.dart';

/// Manifeste d'un nouveau pack homebrew : version 0.1.0, dépendant du pack
/// [srd] (le SRD 5.2.1 de l'appareil).
Map<String, Object?> newHomebrewManifest({
  required String id,
  required String name,
  required String namespace,
  required String author,
  required PackManifest srd,
  String licence = 'CC-BY-4.0',
}) => {
  'format': PackManifest.format,
  'format_version': PackManifest.formatVersion,
  'id': id,
  'namespace': namespace,
  'name': name,
  'version': '0.1.0',
  'origin': PackOrigin.local.name,
  'author': author,
  'licence': licence,
  'dsl_version': 1,
  'locale': 'fr',
  'dependencies': [
    {'id': srd.id, 'version_range': '^${srd.version}'},
  ],
};

/// Espace de noms tiré d'un nom de pack : « Gardiens des Marches » →
/// `gardiens-des-marches`.
String slugOf(String text) {
  const accents = {
    'à': 'a', 'â': 'a', 'ä': 'a', 'ç': 'c', 'é': 'e', 'è': 'e', 'ê': 'e', //
    'ë': 'e', 'î': 'i', 'ï': 'i', 'ô': 'o', 'ö': 'o', 'ù': 'u', 'û': 'u', //
    'ü': 'u', 'ÿ': 'y', 'œ': 'oe', 'æ': 'ae', '’': '-', "'": '-',
  };
  final folded = text
      .toLowerCase()
      .split('')
      .map((c) => accents[c] ?? c)
      .join();
  return folded
      .replaceAll(RegExp('[^a-z0-9]+'), '-')
      .replaceAll(RegExp(r'^-+|-+$'), '');
}

/// Identifiant d'une nouvelle entité `{namespace}:{type}:{slug}`, unique
/// parmi [taken].
String homebrewEntityId(
  String namespace,
  String type,
  String name,
  Iterable<String> taken,
) {
  final base = '$namespace:$type:${slugOf(name).isEmpty ? type : slugOf(name)}';
  final used = taken.toSet();
  var id = base;
  for (var n = 2; used.contains(id); n++) {
    id = '$base-$n';
  }
  return id;
}

/// Problèmes d'un brouillon : manifeste, lecture de chaque entité, puis
/// les mêmes contrôles que le SRD (`validatePack`), avec [dependencies]
/// pour résoudre les références.
List<ContentIssue> checkDraft(
  Map<String, Object?> manifest,
  List<Map<String, Object?>> entities, {
  Iterable<ContentEntity> dependencies = const [],
}) {
  final parsedManifest = PackManifest.parse(manifest);
  final issues = [...parsedManifest.issues];
  final parsed = <ContentEntity>[];
  final ids = <String>{};
  for (final (i, json) in entities.indexed) {
    issues.addAll(_editorRules(json, 'entities[$i]'));
    final result = parseEntity(json, 'entities[$i]');
    issues.addAll(result.issues);
    if (result.entity case final entity?) {
      if (!ids.add('${entity.id}')) {
        issues.add(
          ContentIssue(
            'entities[$i].id',
            'identifiant en double : ${entity.id}',
          ),
        );
      }
      parsed.add(entity);
    }
  }
  issues.addAll(_subclassRules(parsed, dependencies, entities));
  if (parsedManifest.manifest case final m?) {
    issues.addAll(
      validatePack(
        ContentPack(manifest: m, entities: parsed),
        dependencies: dependencies,
      ),
    );
  }
  // Une règle peut venir à la fois de l'éditeur et de validatePack.
  final seen = <String>{};
  return [
    for (final i in issues)
      if (seen.add('${i.path}|${i.message}')) i,
  ];
}

/// Contraintes 2024 de l'éditeur (cahier §7.1), lues sur le JSON brut : un
/// brouillon incomplet, qui ne se lit pas encore, les montre déjà.
List<ContentIssue> _editorRules(Map<String, Object?> json, String path) {
  final data = json['data'];
  if (data is! Map<String, Object?>) return const [];
  return switch (json['type']) {
    'background' => [
      if (((data['abilities'] as List?) ?? const []).length != 3)
        ContentIssue(
          '$path.data.abilities',
          'un Historique cite exactement 3 caractéristiques',
        ),
      if (((data['skill_proficiencies'] as List?) ?? const []).length != 2)
        ContentIssue(
          '$path.data.skill_proficiencies',
          'un Historique accorde exactement 2 compétences',
        ),
    ],
    'weapon' => [
      if (data['mastery'] == null)
        ContentIssue(
          '$path.data.mastery',
          'une arme a toujours une botte d’arme',
        ),
    ],
    'species' => [
      if (((data['sizes'] as List?) ?? const []).isEmpty)
        ContentIssue('$path.data.sizes', 'une espèce a au moins une taille'),
    ],
    'class' => _classRules(data, path),
    // Le DD d'Influence se lit sur l'Intelligence (cahier §7.1).
    'monster' => [
      if ((data['abilities'] as Map?)?['int'] is! int)
        ContentIssue(
          '$path.data.abilities.int',
          'un monstre a une valeur d’Intelligence (DD d’Influence)',
        ),
    ],
    _ => const [],
  };
}

/// EF-HB-11 : une progression de classe incomplète bloque la publication.
List<ContentIssue> _classRules(Map<String, Object?> data, String path) {
  final levels = [
    for (final l in (data['levels'] as List?) ?? const <Object?>[])
      if (l case {'level': final int level}) level,
  ];
  final subclassLevels = [
    for (final l
        in (data['subclass_feature_levels'] as List?) ?? const <Object?>[])
      if (l is int) l,
  ];
  return [
    if (levels.length != 20 ||
        levels.toSet().length != 20 ||
        levels.any((l) => l < 1 || l > 20))
      ContentIssue(
        '$path.data.levels',
        'progression incomplète : une classe a ses 20 niveaux',
      ),
    if (subclassLevels.firstOrNull != data['subclass_level'])
      ContentIssue(
        '$path.data.subclass_feature_levels',
        'les aptitudes de sous-classe commencent au niveau où on la choisit',
      )
    else if ([
          for (var i = 1; i < subclassLevels.length; i++)
            subclassLevels[i] <= subclassLevels[i - 1],
        ].contains(true) ||
        (subclassLevels.lastOrNull ?? 0) > 20)
      ContentIssue(
        '$path.data.subclass_feature_levels',
        'les niveaux de sous-classe vont croissant, jusqu’au niveau 20',
      ),
  ];
}

/// [H02] : les aptitudes d'une sous-classe tombent aux niveaux que sa
/// classe parente leur réserve, et chacun de ces niveaux en a au moins une.
List<ContentIssue> _subclassRules(
  List<ContentEntity> parsed,
  Iterable<ContentEntity> dependencies,
  List<Map<String, Object?>> entities,
) {
  final byId = {
    for (final e in dependencies) '${e.id}': e,
    for (final e in parsed) '${e.id}': e,
  };
  final index = {for (final (i, json) in entities.indexed) '${json['id']}': i};
  final issues = <ContentIssue>[];
  for (final sub in parsed) {
    if (sub.data case SubclassData(:final parentClass, :final features)) {
      final parent = byId['$parentClass']?.data;
      if (parent is! ClassData || parent.subclassFeatureLevels.isEmpty) {
        continue;
      }
      final allowed = parent.subclassFeatureLevels;
      final reached = <int>{};
      for (final f in features) {
        final level = switch (byId['$f']?.data) {
          FeatureData(:final level?) => level,
          _ => null,
        };
        if (level == null) continue;
        reached.add(level);
        if (!allowed.contains(level)) {
          issues.add(
            ContentIssue(
              index['$f'] == null
                  ? 'entities[${index['${sub.id}']}].data.features'
                  : 'entities[${index['$f']}].data.level',
              'la classe parente n’accorde pas d’aptitude de sous-classe '
              'au niveau $level',
            ),
          );
        }
      }
      final missing = allowed.where((l) => !reached.contains(l)).toList();
      if (missing.isNotEmpty) {
        issues.add(
          ContentIssue(
            'entities[${index['${sub.id}']}].data.features',
            'progression incomplète : aucune aptitude aux niveaux '
                '${missing.join(', ')}',
          ),
        );
      }
    }
  }
  return issues;
}

/// Type d'une nouvelle version (EF-HB-11).
enum VersionBump {
  /// Texte seulement : 2.1.0 → 2.1.1.
  patch,

  /// Ajouts compatibles : 2.1.0 → 2.2.0.
  minor,

  /// Peut invalider des fiches : 2.1.0 → 3.0.0.
  major,
}

/// Version qui suit [version] pour un changement [bump].
String nextVersion(String version, VersionBump bump) {
  final [major, minor, patch] = [
    for (final n in version.split('.')) int.parse(n),
  ];
  return switch (bump) {
    VersionBump.patch => '$major.$minor.${patch + 1}',
    VersionBump.minor => '$major.${minor + 1}.0',
    VersionBump.major => '${major + 1}.0.0',
  };
}

/// Entités ajoutées, modifiées et retirées de [previous] à [next], dans
/// l'ordre de [next] puis de [previous].
({
  List<ContentEntity> added,
  List<ContentEntity> modified,
  List<ContentEntity> removed,
})
packChanges(List<ContentEntity> previous, List<ContentEntity> next) {
  final before = {for (final e in previous) '${e.id}': e};
  final after = {for (final e in next) '${e.id}': e};
  String json(ContentEntity e) => jsonEncode(e.toJson());
  return (
    added: [
      for (final e in next)
        if (!before.containsKey('${e.id}')) e,
    ],
    modified: [
      for (final e in next)
        if (before['${e.id}'] case final old? when json(old) != json(e)) e,
    ],
    removed: [
      for (final e in previous)
        if (!after.containsKey('${e.id}')) e,
    ],
  );
}
