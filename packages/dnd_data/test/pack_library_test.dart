// Spec local-database : « Fichiers de packs par version » (US-30,
// EF-HB-06 à 09).
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

import 'support.dart';

const _id = '0193a000-0000-7000-8000-000000000030';
const _karlId = '0193a000-0000-7000-8000-0000000000ff';

Future<List<int>> _file(
  String version,
  List<String> feats, {
  int seed = 1,
}) async => writeDndpack(
  await signPack(
    ContentPack(
      manifest: PackManifest(
        id: _id,
        namespace: 'gardiens',
        name: 'Gardiens des Marches',
        version: version,
        origin: PackOrigin.local,
        author: seed == 1 ? 'Inès' : 'Karl',
        licence: 'CC-BY-4.0',
        locale: 'fr',
      ),
      entities: [
        for (final f in feats)
          parseEntity({
            'id': 'gardiens:feat:${slugOf(f)}',
            'type': 'feat',
            'name': f,
            'data': {'category': 'origin'},
            'text': {'fr': '$f : texte.'},
          }, 'test').entity!,
      ],
    ),
    await authorKeyPair(List.filled(32, seed)),
  ),
);

void main() {
  late TavernierDatabase db;
  late PackLibrary library;
  setUp(() {
    db = memoryDatabase();
    library = PackLibrary(db);
  });
  tearDown(() => db.close());

  Future<List<String>> names(String packId) async => [
    for (final e in (await PackStore(db).exportPack(packId))!.entities) e.name,
  ];

  test('deux versions : le contenu porte la plus récente', () async {
    await library.install(await _file('0.1.0', ['Veilleur']));
    await library.install(await _file('0.2.0', ['Veilleur', 'Guetteur']));
    final content = (await PackStore(db).exportPack(_id))!;
    expect(content.manifest.version, '0.2.0');
    // Le manifeste du fichier, signature comprise, sans changement.
    expect(await verifyPackSignature(content.manifest), isTrue);
    expect(await names(_id), ['Guetteur', 'Veilleur']);
    final old = (await library.version(_id, '0.1.0'))!;
    expect([for (final e in old.entities) e.name], ['Veilleur']);
    expect(
      [for (final v in await library.installed()) v.version],
      ['0.1.0', '0.2.0'],
    );
    expect(await library.version(_id, '9.9.9'), isNull);
    expect(
      readDndpack((await library.file(_id, '0.1.0'))!).manifest.version,
      '0.1.0',
    );
    expect(await library.file(_id, '9.9.9'), isNull);

    // Une version plus ancienne importée après ne remplace pas le contenu.
    await library.install(await _file('0.0.9', ['Ancien']));
    expect((await PackStore(db).exportPack(_id))!.manifest.version, '0.2.0');
  });

  test('pack distinct : autre espace de noms, l’original intact', () async {
    await library.install(await _file('0.1.0', ['Veilleur']));
    final id = await library.install(
      await _file('0.3.0', ['Veilleur'], seed: 2),
      packId: _karlId,
      namespace: 'gardiens-karl',
      name: 'Gardiens des Marches (Karl)',
    );
    expect(id, _karlId);
    final karl = (await PackStore(db).exportPack(_karlId))!;
    expect(karl.manifest.name, 'Gardiens des Marches (Karl)');
    expect(
      [for (final e in karl.entities) '${e.id}'],
      ['gardiens-karl:feat:veilleur'],
    );
    expect((await PackStore(db).exportPack(_id))!.manifest.version, '0.1.0');
    final versions = await library.installed();
    expect(versions.last.sourceId, _id);
    expect(versions.last.packId, _karlId);
  });

  test('renommage : seulement dans la bibliothèque', () async {
    await library.install(
      await _file('0.1.0', ['Veilleur']),
      renames: {'gardiens:feat:veilleur': 'Veilleur des Marches'},
    );
    expect(await names(_id), ['Veilleur des Marches']);
    final row = await db
        .customSelect('SELECT bytes FROM pack_file')
        .getSingle();
    expect(
      readDndpack(row.read<List<int>>('bytes')).entities.single.name,
      'Veilleur',
    );
  });
}
