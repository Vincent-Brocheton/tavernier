// Spec local-database : « Import et export d'un pack » et « Recherche plein
// texte ».
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

import 'support.dart';

Map<String, Object?> _byId(ContentPack pack) => {
  for (final e in pack.entities) '${e.id}': e.toJson(),
};

void main() {
  late TavernierDatabase db;
  late PackStore store;
  setUp(() {
    db = memoryDatabase();
    store = PackStore(db);
  });
  tearDown(() => db.close());

  group('import et export', () {
    test('pack SRD aller-retour : 188 entités identiques', () async {
      await store.importPack(srdPack);
      final exported = await store.exportPack(srdPack.manifest.id);
      expect(exported, isNotNull);
      expect(exported!.manifest.toJson(), srdPack.manifest.toJson());
      expect(exported.entities, hasLength(188));
      expect(_byId(exported), _byId(srdPack));
    });

    test('réimport : aucune entité en double', () async {
      await store.importPack(srdPack);
      await store.importPack(srdPack);
      final count = await db
          .customSelect('SELECT count(*) AS n FROM weapon')
          .getSingle();
      expect(count.read<int>('n'), 38);
      expect(
        (await store.exportPack(srdPack.manifest.id))!.entities,
        hasLength(188),
      );
    });

    test("un pack lu d'une archive garde tout son manifeste", () async {
      final archived = readDndpack(writeDndpack(srdPack));
      await store.importPack(archived);
      final exported = await store.exportPack(archived.manifest.id);
      expect(exported!.manifest.toJson(), archived.manifest.toJson());
    });

    test('un pack absent donne null', () async {
      expect(
        await store.exportPack('00000000-0000-0000-0000-000000000000'),
        isNull,
      );
    });
  });

  group('recherche plein texte', () {
    setUp(() => store.importPack(srdPack));

    Future<List<String>> ids(String query) async => [
      for (final hit in await store.search(query)) hit.id,
    ];

    test('avec ou sans accent', () async {
      expect(await ids('défense'), contains('srd:feat:defense'));
      expect(await ids('defense'), contains('srd:feat:defense'));
    });

    test('début de mot', () async {
      expect(
        await ids('épé'),
        containsAll(['srd:weapon:longsword', 'srd:weapon:shortsword']),
      );
    });

    test('texte de règles', () async {
      expect(await ids("Classe d'armure"), contains('srd:feat:defense'));
    });

    test('le résultat donne le type et le nom', () async {
      final hit = (await store.search('Vigilant')).first;
      expect(
        (hit.id, hit.type, hit.name),
        ('srd:feat:alert', 'feat', 'Vigilant'),
      );
    });

    test('une requête vide ou faite de ponctuation ne renvoie rien', () async {
      expect(await store.search('  '), isEmpty);
      expect(await store.search('"*'), isEmpty);
    });
  });
}
