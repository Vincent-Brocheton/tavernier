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
    test('pack SRD aller-retour : toutes les entités identiques', () async {
      await store.importPack(srdPack);
      final exported = await store.exportPack(srdPack.manifest.id);
      expect(exported, isNotNull);
      expect(exported!.manifest.toJson(), srdPack.manifest.toJson());
      expect(exported.entities, hasLength(srdPack.entities.length));
      expect(_byId(exported), _byId(srdPack));
    });

    test(
      'pack homebrew aller-retour : arme magique, sort et ses classes',
      () async {
        ContentEntity entity(Map<String, Object?> json) =>
            parseEntity(json, 'test').entity!;
        final pack = ContentPack(
          manifest: const PackManifest(
            id: '00000000-0000-0000-0000-000000000027',
            namespace: 'hb',
            name: 'Gardiens',
            version: '0.1.0',
            origin: PackOrigin.local,
            author: 'Inès',
            licence: 'CC-BY-4.0',
            locale: 'fr',
          ),
          entities: [
            entity({
              'id': 'hb:weapon:warden-axe',
              'type': 'weapon',
              'name': 'Hache du veilleur',
              'extends_id': 'srd:weapon:battleaxe',
              'data': {
                'category': 'martial',
                'kind': 'melee',
                'damage': '1d8',
                'damage_type': 'srd:damage-type:slashing',
                'properties': ['versatile'],
                'versatile_damage': '1d10',
                'mastery': 'srd:mastery:topple',
                'weight_kg': 2.0,
                'cost_cp': 1000,
                'rarity': 'uncommon',
                'attunement': true,
              },
            }),
            entity({
              'id': 'hb:armor:warden-shield',
              'type': 'armor',
              'name': 'Bouclier du veilleur',
              'data': {
                'category': 'shield',
                'base_ac': 2,
                'weight_kg': 3.0,
                'cost_cp': 1000,
                'rarity': 'rare',
              },
              'effects': [
                {'op': 'modify_ac', 'value': 1},
              ],
            }),
            entity({
              'id': 'hb:spell:mist-lantern',
              'type': 'spell',
              'name': 'Lanterne de brume',
              'data': {
                'level': 1,
                'school': 'illusion',
                'casting_time': 'action',
                'ritual': false,
                'range': {'kind': 'feet', 'feet': 60},
                'components': {'verbal': true, 'somatic': true},
                'material_consumed': false,
                'duration': '1 heure',
                'concentration': false,
                'classes': ['srd:class:wizard'],
              },
              'text': {'fr': 'Une lueur pâle.'},
            }),
          ],
        );
        await store.importPack(srdPack);
        await store.importPack(pack);
        final exported = await store.exportPack(pack.manifest.id);
        expect(_byId(exported!), _byId(pack));
        // La liste du Magicien du SRD reste la sienne.
        final srd = await store.exportPack(srdPack.manifest.id);
        expect(_byId(srd!), _byId(srdPack));
      },
    );

    test('monstre homebrew : paliers d’Étude gardés et indexés', () async {
      final wolf = srdPack.entities.firstWhere(
        (e) => '${e.id}' == 'srd:monster:wolf',
      );
      final json = wolf.toJson();
      final monster = parseEntity({
        ...json,
        'id': 'hb:monster:mist-wolf',
        'data': {
          ...json['data']! as Map<String, Object?>,
          'study_reveals': [
            {'dc': 10, 'text': 'Il chasse en meute.'},
            {'dc': 15, 'text': 'La brume le cache.'},
          ],
        },
      }, 'test').entity!;
      final pack = ContentPack(
        manifest: const PackManifest(
          id: '00000000-0000-0000-0000-000000000028',
          namespace: 'hb',
          name: 'Bestiaire',
          version: '0.1.0',
          origin: PackOrigin.local,
          author: 'Inès',
          licence: 'CC-BY-4.0',
          locale: 'fr',
        ),
        entities: [monster],
      );
      await store.importPack(srdPack);
      await store.importPack(pack);
      expect(_byId((await store.exportPack(pack.manifest.id))!), _byId(pack));
      final rows = await db
          .customSelect(
            'SELECT dc, reveal_text FROM study_reveal '
            "WHERE monster_id = 'hb:monster:mist-wolf' ORDER BY dc",
          )
          .get();
      expect(
        [for (final r in rows) r.data],
        [
          {'dc': 10, 'reveal_text': 'Il chasse en meute.'},
          {'dc': 15, 'reveal_text': 'La brume le cache.'},
        ],
      );
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
        hasLength(srdPack.entities.length),
      );
    });

    test("un pack lu d'une archive garde tout son manifeste", () async {
      final archived = readDndpack(writeDndpack(srdPack));
      await store.importPack(archived);
      final exported = await store.exportPack(archived.manifest.id);
      expect(exported!.manifest.toJson(), archived.manifest.toJson());
    });

    test('un identifiant déjà pris par un autre pack est refusé', () async {
      await store.importPack(srdPack);
      final copy = ContentPack(
        manifest: const PackManifest(
          id: '00000000-0000-0000-0000-000000000001',
          namespace: 'srd',
          name: 'Copie',
          version: '1.0.0',
          origin: PackOrigin.local,
          author: 'MJ',
          licence: 'CC-BY-4.0',
          locale: 'fr',
        ),
        entities: srdPack.entities,
      );
      await expectLater(
        store.importPack(copy),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('srd:feat:alert'),
          ),
        ),
      );
      expect(
        (await store.exportPack(srdPack.manifest.id))!.entities,
        hasLength(srdPack.entities.length),
      );
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
