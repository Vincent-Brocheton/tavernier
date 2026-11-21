// Brouillons homebrew (US-27, EF-HB-01, EF-HB-11) : un pack en cours
// d'édition, en JSON brut, et ses problèmes, qui bloquent la publication
// sans bloquer l'enregistrement.
import '../content_issue.dart';
import '../entities/content_entity.dart';
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
    _ => const [],
  };
}
