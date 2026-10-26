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
Map<String, Object?> fixtureInput(String name) =>
    fixture(name)['input']! as Map<String, Object?>;

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
