// Outils partagés des tests de dnd_rules.
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:srd_builder/srd_builder.dart';

final _package = Isolate.resolvePackageUriSync(
  Uri.parse('package:dnd_rules/'),
)!;

/// Fixture [D1] complète.
Map<String, Object?> fixture(String name) => jsonDecode(
  File.fromUri(_package.resolve('../test/fixtures/d1/$name.json'))
      .readAsStringSync(),
) as Map<String, Object?>;

/// Entrée stockée d'une fixture [D1].
Map<String, Object?> fixtureInput(String name) {
  final data = fixture(name);
  final parent = data['extends'] as String?;
  if (parent == null) return data['input']! as Map<String, Object?>;
  final input = {...fixtureInput(parent)};
  // `<clé>_added` complète la liste du parent, toute autre clé la remplace.
  (data['input_changes']! as Map<String, Object?>).forEach((key, value) {
    if (key.endsWith('_added')) {
      final base = key.substring(0, key.length - '_added'.length);
      input[base] = [
        ...(input[base] as List<Object?>? ?? const []),
        ...value! as List<Object?>,
      ];
    } else {
      input[key] = value;
    }
  });
  return input;
}

/// Pack SRD de l'échantillon M0, chargé depuis ses sources.
final ContentPack srdPack = () {
  final loaded = loadSources(
    Directory.fromUri(_package.resolve('../../../tools/srd_builder/sources/')),
  );
  return loaded.pack ?? (throw StateError('${loaded.issues}'));
}();

/// Contenu actif : le pack SRD, plus des entités de test éventuelles.
ActiveContent srdContent([List<ContentEntity> extra = const []]) =>
    ActiveContent([
      srdPack,
      if (extra.isNotEmpty)
        ContentPack(manifest: srdPack.manifest, entities: extra),
    ]);

/// Aldric niveau 1, éventuellement modifié par [change].
CharacterInput aldric([void Function(Map<String, Object?> json)? change]) {
  final json =
      jsonDecode(jsonEncode(fixtureInput('aldric_n1'))) as Map<String, Object?>;
  change?.call(json);
  return CharacterInput.fromJson(json);
}
