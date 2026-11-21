// Import d'un pack (US-30, EF-HB-06 à 08) : aperçu face aux versions
// installées, et changement d'identité d'un pack (pack distinct,
// duplication).
import 'dart:convert';

import '../content_issue.dart';
import '../entities/content_entity.dart';
import 'content_pack.dart';
import 'homebrew.dart';
import 'manifest.dart';

/// Version d'un pack gardée par l'appareil : identifiant local (celui de la
/// bibliothèque), identifiant source (celui du fichier), clé de l'auteur.
typedef InstalledVersion = ({
  String packId,
  String sourceId,
  String? authorKey,
  String version,
  ContentPack pack,
});

/// Nature d'un import (EF-HB-07).
enum ImportKind { newPack, update, distinct, alreadyInstalled }

/// Entité nouvelle qui porte le nom d'une entité d'un autre pack.
typedef NameConflict = ({
  ContentEntity incoming,
  ContentEntity existing,
  String packName,
});

/// Aperçu d'un import ([H08], [H09]).
final class ImportPreview {
  const ImportPreview({
    required this.kind,
    required this.signatureValid,
    required this.missingDependencies,
    required this.issues,
    required this.conflicts,
    this.target,
    this.previous,
    this.changes,
  });

  final ImportKind kind;
  final bool signatureValid;
  final List<PackDependency> missingDependencies;
  final List<ContentIssue> issues;
  final List<NameConflict> conflicts;

  /// Identifiant local du pack mis à jour.
  final String? target;

  /// Dernière version installée du même auteur.
  final InstalledVersion? previous;
  final ({
    List<ContentEntity> added,
    List<ContentEntity> modified,
    List<ContentEntity> removed,
  })?
  changes;

  /// Rien ne s'importe : signature, dépendances, contenu ou version.
  bool get blocked =>
      kind == ImportKind.alreadyInstalled ||
      !signatureValid ||
      missingDependencies.isNotEmpty ||
      issues.isNotEmpty;
}

/// Compare deux versions semver, nombre par nombre.
int compareVersions(String a, String b) {
  final x = [for (final n in a.split('.')) int.tryParse(n) ?? 0];
  final y = [for (final n in b.split('.')) int.tryParse(n) ?? 0];
  for (var i = 0; i < 3; i++) {
    final c = x.elementAtOrNull(i)?.compareTo(y.elementAtOrNull(i) ?? 0) ?? 0;
    if (c != 0) return c;
  }
  return 0;
}

String _fold(String name) => slugOf(name);

/// Aperçu de l'import de [incoming] : [installed] sont les versions gardées
/// par l'appareil, [available] les packs qui résolvent les dépendances et
/// les noms (SRD de l'appareil et packs installés).
ImportPreview inspectImport(
  ContentPack incoming, {
  required bool signatureValid,
  required List<InstalledVersion> installed,
  required List<ContentPack> available,
}) {
  final m = incoming.manifest;
  final sameSource = [
    for (final v in installed)
      if (v.sourceId == m.id) v,
  ];
  final sameAuthor = [
    for (final v in sameSource)
      if (v.authorKey != null && v.authorKey == m.authorPublicKey) v,
  ]..sort((a, b) => compareVersions(b.version, a.version));
  final kind = sameSource.isEmpty
      ? ImportKind.newPack
      : sameAuthor.isEmpty
      ? ImportKind.distinct
      : sameAuthor.any((v) => v.version == m.version)
      ? ImportKind.alreadyInstalled
      : ImportKind.update;
  final previous = sameAuthor.firstOrNull;

  final known = {for (final p in available) p.manifest.id};
  final own = {?previous?.packId, m.id};
  final others = [
    for (final p in available)
      if (!own.contains(p.manifest.id)) p,
  ];
  final previousIds = {
    for (final e in previous?.pack.entities ?? const <ContentEntity>[])
      '${e.id}',
  };
  final byName = <String, (ContentEntity, String)>{};
  for (final p in others) {
    for (final e in p.entities) {
      byName.putIfAbsent(_fold(e.name), () => (e, p.manifest.name));
    }
  }

  return ImportPreview(
    kind: kind,
    signatureValid: signatureValid,
    missingDependencies: [
      for (final d in m.dependencies)
        if (!known.contains(d.id)) d,
    ],
    issues: validatePack(
      incoming,
      dependencies: [for (final p in others) ...p.entities],
    ),
    conflicts: [
      for (final e in incoming.entities)
        if (!previousIds.contains('${e.id}'))
          if (byName[_fold(e.name)] case (final existing, final packName)
              when existing.id != e.id)
            (incoming: e, existing: existing, packName: packName),
    ],
    target: kind == ImportKind.update ? previous?.packId : null,
    previous: previous,
    changes: previous == null
        ? null
        : packChanges(previous.pack.entities, incoming.entities),
  );
}

/// Le même pack sous un autre identifiant, espace de noms et nom : chaque
/// identifiant et chaque référence `{ancien}:…` suit ; la signature et la
/// clé de l'auteur sont retirées.
ContentPack rebrandPack(
  ContentPack pack, {
  required String id,
  required String namespace,
  required String name,
  String? author,
  String? version,
  PackOrigin? origin,
}) {
  final old = '${pack.manifest.namespace}:';
  Object? rewrite(Object? value) => switch (value) {
    final String s when s.startsWith(old) =>
      '$namespace:${s.substring(old.length)}',
    final Map<String, Object?> map => {
      for (final MapEntry(:key, :value) in map.entries) key: rewrite(value),
    },
    final List<Object?> list => [for (final v in list) rewrite(v)],
    _ => value,
  };
  final m = pack.manifest;
  return ContentPack(
    manifest: PackManifest(
      id: id,
      namespace: namespace,
      name: name,
      version: version ?? m.version,
      origin: origin ?? m.origin,
      author: author ?? m.author,
      licence: m.licence,
      locale: m.locale,
      attribution: m.attribution,
      dslVersion: m.dslVersion,
      dependencies: m.dependencies,
      description: m.description,
    ),
    entities: [
      for (final e in pack.entities)
        parseEntity(
          rewrite(jsonDecode(jsonEncode(e.toJson()))),
          'rebrand',
        ).entity!,
    ],
  );
}
