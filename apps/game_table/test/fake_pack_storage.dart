import 'dart:typed_data';

import 'package:dnd_content/dnd_content.dart';
import 'package:game_table/homebrew/pack_storage.dart';

/// Stockage de packs en mémoire, sous l'empreinte de chaque fichier.
final class FakePackStorage implements PackStorage {
  final files = <String, Uint8List>{};

  @override
  Future<void> upload(String sha256, Uint8List bytes) async =>
      files[sha256] = bytes;

  @override
  Future<Uint8List> download(String sha256) async =>
      files[sha256] ?? (throw StateError('absent : $sha256'));
}

/// Un `.dndpack` signé de « Gardiens des Marches » (graine 1 : Inès),
/// dépendant de [srd], avec une sous-classe du Guerrier et son aptitude.
Future<List<int>> gardiensFile(PackManifest srd, String version) async =>
    writeDndpack(
      await signPack(
        ContentPack(
          manifest: PackManifest(
            id: '0193a000-0000-7000-8000-000000000030',
            namespace: 'gardiens',
            name: 'Gardiens des Marches',
            version: version,
            origin: PackOrigin.local,
            author: 'Inès',
            licence: 'CC-BY-4.0',
            locale: 'fr',
            dependencies: [(id: srd.id, versionRange: '^${srd.version}')],
          ),
          entities: [
            parseEntity({
              'id': 'gardiens:subclass:rempart',
              'type': 'subclass',
              'name': 'Gardien du rempart',
              'data': {
                'parent_class': 'srd:class:fighter',
                'features': ['gardiens:feature:rempart-vivant'],
              },
            }, 'test').entity!,
            parseEntity({
              'id': 'gardiens:feature:rempart-vivant',
              'type': 'feature',
              'name': 'Rempart vivant',
              'data': {'source': 'gardiens:subclass:rempart', 'level': 3},
              'text': {'fr': 'Vous protégez vos alliés.'},
            }, 'test').entity!,
          ],
        ),
        await authorKeyPair(List.filled(32, 1)),
      ),
    );
