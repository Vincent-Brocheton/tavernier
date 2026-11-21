// Spec content-pack : « Pack signé », « Versions d'un pack » (US-29,
// EF-HB-04, EF-HB-05, EF-HB-11).
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

void main() {
  final pack = ContentPack(
    manifest: PackManifest.parse(
      newHomebrewManifest(
        id: '0193a000-0000-7000-8000-000000000029',
        name: 'Gardiens des Marches',
        namespace: 'gardiens',
        author: 'Inès',
        srd: srdManifest(),
      ),
    ).manifest!.copyWith(description: 'Les veilleurs des Marches.'),
    entities: [feat('veilleur', 'origin')],
  );

  group('signature', () {
    test('signé, écrit, relu : valide pour la clé de l’auteur', () async {
      final keys = await authorKeyPair(List.filled(32, 7));
      final signed = await signPack(pack, keys);
      final read = readDndpack(writeDndpack(signed));
      expect(read.manifest.description, 'Les veilleurs des Marches.');
      expect(read.manifest.authorPublicKey, signed.manifest.authorPublicKey);
      expect(read.manifest.signature, isNotNull);
      expect(await verifyPackSignature(read.manifest), isTrue);
      // Même graine, même clé : l'auteur se reconnaît.
      final again = await signPack(
        pack,
        await authorKeyPair(List.filled(32, 7)),
      );
      expect(again.manifest.authorPublicKey, signed.manifest.authorPublicKey);
    });

    test('version changée, pas de signature, autre clé : refusé', () async {
      final signed = await signPack(
        pack,
        await authorKeyPair(List.filled(32, 7)),
      );
      expect(
        await verifyPackSignature(signed.manifest.copyWith(version: '9.9.9')),
        isFalse,
      );
      expect(
        await verifyPackSignature(
          signed.manifest.copyWith(clearSignature: true),
        ),
        isFalse,
      );
      final other = await signPack(
        pack,
        await authorKeyPair(List.filled(32, 8)),
      );
      expect(
        await verifyPackSignature(
          signed.manifest.copyWith(
            authorPublicKey: other.manifest.authorPublicKey,
          ),
        ),
        isFalse,
      );
    });

    test(
      'graine neuve : 32 octets, une clé différente à chaque fois',
      () async {
        final a = await newAuthorSeed();
        final b = await newAuthorSeed();
        expect(a, hasLength(32));
        expect(a, isNot(b));
      },
    );

    test('champs de signature mal formés : manifeste refusé', () {
      final json = {...pack.manifest.toJson(), 'signature': 'abc'};
      expect(
        PackManifest.parse(json).issues.map((i) => i.path),
        contains('manifest.signature'),
      );
    });
  });

  group('versions', () {
    test('correctif, mineure, majeure depuis 2.1.0', () {
      expect(nextVersion('2.1.0', VersionBump.patch), '2.1.1');
      expect(nextVersion('2.1.0', VersionBump.minor), '2.2.0');
      expect(nextVersion('2.1.3', VersionBump.major), '3.0.0');
    });

    test('changements : ajouté, modifié, retiré', () {
      final alert = feat('alert', 'origin');
      final grappler = feat('grappler', 'general');
      final changed = entity({...grappler.toJson(), 'name': 'Lutteur aguerri'});
      final watcher = feat('veilleur', 'origin');
      final changes = packChanges([alert, grappler], [changed, watcher]);
      expect(changes.added.map((e) => '${e.id}'), ['${watcher.id}']);
      expect(changes.modified.map((e) => e.name), ['Lutteur aguerri']);
      expect(changes.removed.map((e) => '${e.id}'), ['${alert.id}']);
    });
  });
}
