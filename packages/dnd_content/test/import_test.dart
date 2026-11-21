// Spec content-pack : « Aperçu d'un import », « Changer l'identité d'un
// pack » (US-30, EF-HB-06 à 08).
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

void main() {
  final srd = validPack();
  const id = '0193a000-0000-7000-8000-000000000030';

  ContentEntity gardiensFeat(String slug, String name) => entity({
    'id': 'gardiens:feat:$slug',
    'type': 'feat',
    'name': name,
    'data': {'category': 'origin'},
    'text': {'fr': '$name : texte.'},
  });

  Future<ContentPack> pack(
    String version,
    List<ContentEntity> entities, {
    int seed = 1,
    List<PackDependency>? dependencies,
  }) async => signPack(
    ContentPack(
      manifest: PackManifest(
        id: id,
        namespace: 'gardiens',
        name: 'Gardiens des Marches',
        version: version,
        origin: PackOrigin.local,
        author: seed == 1 ? 'Inès' : 'Karl',
        licence: 'CC-BY-4.0',
        locale: 'fr',
        dependencies:
            dependencies ?? [(id: srd.manifest.id, versionRange: '^1.0.0')],
      ),
      entities: entities,
    ),
    await authorKeyPair(List.filled(32, seed)),
  );

  InstalledVersion installed(ContentPack p, {String? packId}) => (
    packId: packId ?? p.manifest.id,
    sourceId: p.manifest.id,
    authorKey: p.manifest.authorPublicKey,
    version: p.manifest.version,
    pack: p,
  );

  test('nouveau pack : rien d’installé, rien de bloqué', () async {
    final incoming = await pack('0.1.0', [
      gardiensFeat('veilleur', 'Veilleur'),
    ]);
    final preview = inspectImport(
      incoming,
      signatureValid: true,
      installed: const [],
      available: [srd],
    );
    expect(preview.kind, ImportKind.newPack);
    expect(preview.changes, isNull);
    expect(preview.blocked, isFalse);
  });

  test('même auteur : mise à jour ; même version : déjà installée', () async {
    final v1 = await pack('0.1.0', [gardiensFeat('veilleur', 'Veilleur')]);
    final v2 = await pack('0.2.0', [
      gardiensFeat('veilleur', 'Veilleur'),
      gardiensFeat('guetteur', 'Guetteur'),
    ]);
    final preview = inspectImport(
      v2,
      signatureValid: true,
      installed: [installed(v1)],
      available: [srd, v1],
    );
    expect(preview.kind, ImportKind.update);
    expect(preview.target, id);
    expect(preview.previous!.version, '0.1.0');
    expect(preview.changes!.added.map((e) => e.name), ['Guetteur']);
    expect(preview.conflicts, isEmpty);
    expect(preview.blocked, isFalse);

    final again = inspectImport(
      v1,
      signatureValid: true,
      installed: [installed(v1)],
      available: [srd, v1],
    );
    expect(again.kind, ImportKind.alreadyInstalled);
    expect(again.blocked, isTrue);
  });

  test(
    'autre clé : pack distinct ; refus de signature ou de dépendance',
    () async {
      final ines = await pack('0.1.0', [gardiensFeat('veilleur', 'Veilleur')]);
      final karl = await pack('0.3.0', [
        gardiensFeat('veilleur', 'Veilleur'),
      ], seed: 2);
      final preview = inspectImport(
        karl,
        signatureValid: true,
        installed: [installed(ines)],
        available: [srd, ines],
      );
      expect(preview.kind, ImportKind.distinct);
      expect(preview.target, isNull);
      // Les entités d'Inès sont d'un autre pack : même nom, même id, pas de
      // conflit de nom (l'identifiant est le même).
      expect(preview.conflicts, isEmpty);

      expect(
        inspectImport(
          karl,
          signatureValid: false,
          installed: const [],
          available: [srd],
        ).blocked,
        isTrue,
      );
      final orphan = await pack(
        '0.1.0',
        [gardiensFeat('veilleur', 'Veilleur')],
        dependencies: [
          (id: '00000000-0000-0000-0000-00000000dead', versionRange: '^1.0.0'),
        ],
      );
      final missing = inspectImport(
        orphan,
        signatureValid: true,
        installed: const [],
        available: [srd],
      );
      expect(missing.missingDependencies.single.id, endsWith('dead'));
      expect(missing.blocked, isTrue);
    },
  );

  test('conflit de nom avec un autre pack', () async {
    final incoming = await pack('0.1.0', [
      gardiensFeat('attaquant-sauvage', 'savage-attacker'),
    ]);
    final preview = inspectImport(
      incoming,
      signatureValid: true,
      installed: const [],
      available: [srd],
    );
    final conflict = preview.conflicts.single;
    expect('${conflict.incoming.id}', 'gardiens:feat:attaquant-sauvage');
    expect('${conflict.existing.id}', 'srd:feat:savage-attacker');
    expect(conflict.packName, 'SRD 5.2.1 (FR)');
  });

  test('rebrandPack : références suivies, autres packs inchangés', () async {
    final original = await pack('0.2.0', [
      entity({
        'id': 'gardiens:subclass:rempart',
        'type': 'subclass',
        'name': 'Gardien du rempart',
        'data': {
          'parent_class': 'srd:class:fighter',
          'features': ['gardiens:feature:rempart'],
        },
      }),
    ]);
    final copy = rebrandPack(
      original,
      id: '0193a000-0000-7000-8000-0000000000ff',
      namespace: 'gardiens-karl',
      name: 'Gardiens des Marches (Karl)',
      version: '0.1.0',
      author: 'Camille',
      origin: PackOrigin.local,
    );
    expect(copy.manifest.namespace, 'gardiens-karl');
    expect(copy.manifest.name, 'Gardiens des Marches (Karl)');
    expect(copy.manifest.version, '0.1.0');
    expect(copy.manifest.author, 'Camille');
    expect(copy.manifest.signature, isNull);
    expect(copy.manifest.authorPublicKey, isNull);
    final sub = copy.entities.single;
    expect('${sub.id}', 'gardiens-karl:subclass:rempart');
    expect((sub.data as SubclassData).features.map((f) => '$f'), [
      'gardiens-karl:feature:rempart',
    ]);
    expect('${(sub.data as SubclassData).parentClass}', 'srd:class:fighter');
  });

  test('versions semver comparées nombre par nombre', () {
    expect(compareVersions('0.10.0', '0.9.3'), greaterThan(0));
    expect(compareVersions('1.0.0', '1.0.0'), 0);
    expect(compareVersions('1.2.3', '2.0.0'), lessThan(0));
  });
}
