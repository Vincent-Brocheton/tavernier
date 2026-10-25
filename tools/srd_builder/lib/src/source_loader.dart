import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;

/// Sources chargées : le pack si tout est valide, sinon les problèmes,
/// chacun rattaché au fichier source concerné.
typedef LoadedSources = ({ContentPack? pack, List<ContentIssue> issues});

/// Lit `pack.json` et `<type>/<slug>.json` sous [dir]
/// (docs/packs/FORMAT_DNDPACK.md), sans s'arrêter au premier problème.
LoadedSources loadSources(Directory dir) {
  final issues = <ContentIssue>[];
  final fileById = <String, String>{};
  final entities = <ContentEntity>[];

  final packFile = File(p.join(dir.path, 'pack.json'));
  PackManifest? manifest;
  if (!packFile.existsSync()) {
    issues.add(const ContentIssue('pack.json', 'fichier absent'));
  } else if (_readJson(packFile, 'pack.json', issues) case final json?) {
    // `format` et `format_version` sont fixés par le format : facultatifs ici.
    final result = PackManifest.parse(
      json is Map<String, Object?>
          ? {
              'format': PackManifest.format,
              'format_version': PackManifest.formatVersion,
              ...json,
            }
          : json,
    );
    manifest = result.manifest;
    issues.addAll([
      for (final i in result.issues) ContentIssue('pack.json', '$i'),
    ]);
  }

  final files = dir.existsSync()
      ? (dir
            .listSync(recursive: true)
            .whereType<File>()
            .where(
              (f) =>
                  f.path.endsWith('.json') && p.basename(f.path) != 'pack.json',
            )
            .toList()
          ..sort((a, b) => a.path.compareTo(b.path)))
      : <File>[];

  for (final file in files) {
    final relative = p
        .relative(file.path, from: dir.path)
        .replaceAll(r'\', '/');
    final json = _readJson(file, relative, issues);
    if (json == null) continue;
    final result = parseEntity(json, relative);
    issues.addAll(result.issues);
    final entity = result.entity;
    if (entity == null) continue;

    final expected = '${entity.type}/${entity.id.slug}.json';
    if (relative != expected) {
      issues.add(
        ContentIssue(relative, '${entity.id} doit être rangé dans $expected'),
      );
      continue;
    }
    final id = '${entity.id}';
    if (fileById[id] case final other?) {
      issues.add(ContentIssue(relative, '$id déjà déclaré dans $other'));
      continue;
    }
    fileById[id] = relative;
    entities.add(entity);
  }

  final pack = manifest == null
      ? null
      : ContentPack(manifest: manifest, entities: entities);
  if (pack != null) {
    for (final issue in validatePack(pack)) {
      final id = issue.path.split('.').first;
      issues.add(ContentIssue(fileById[id] ?? issue.path, issue.message));
    }
  }
  return (pack: issues.isEmpty ? pack : null, issues: issues);
}

Object? _readJson(File file, String name, List<ContentIssue> issues) {
  try {
    return jsonDecode(file.readAsStringSync());
  } on FormatException catch (e) {
    issues.add(ContentIssue(name, 'JSON invalide (${e.message})'));
    return null;
  }
}
