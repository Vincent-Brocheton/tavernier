// Spec local-database : « Sorts dans la base ».
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

import 'support.dart';

ContentEntity _spell(String slug, String name, Map<String, Object?> data) =>
    parseEntity({
      'id': 'srd:spell:$slug',
      'type': 'spell',
      'name': name,
      'data': {
        'casting_time': 'action',
        'ritual': false,
        'material_consumed': false,
        'duration': 'instantanée',
        'concentration': false,
        ...data,
      },
      'text': {'fr': 'Texte de $name.'},
    }, slug).entity!;

final _pack = ContentPack(
  manifest: srdPack.manifest,
  entities: [
    _spell('fireball', 'Boule de feu', {
      'level': 3,
      'school': 'evocation',
      'range': {'kind': 'feet', 'feet': 150},
      'components': {
        'verbal': true,
        'somatic': true,
        'material': 'une boulette de guano de chauve-souris et de soufre',
      },
    }),
    _spell('raise-dead', 'Rappel à la vie', {
      'level': 5,
      'school': 'necromancy',
      'casting_time': '1 heure',
      'range': {'kind': 'touch'},
      'components': {
        'verbal': true,
        'somatic': true,
        'material': 'un diamant d’une valeur minimale de 500 po',
      },
      'material_cost_cp': 50000,
      'material_consumed': true,
    }),
  ],
);

void main() {
  late TavernierDatabase db;
  late PackStore store;
  setUp(() async {
    db = memoryDatabase();
    store = PackStore(db);
    await store.importPack(_pack);
  });
  tearDown(() => db.close());

  test('aller-retour des sorts', () async {
    final exported = await store.exportPack(_pack.manifest.id);
    expect(
      {for (final e in exported!.entities) '${e.id}': e.toJson()},
      {for (final e in _pack.entities) '${e.id}': e.toJson()},
    );
  });

  test('colonnes de la table spell', () async {
    final row = await db
        .customSelect("SELECT * FROM spell WHERE id = 'srd:spell:raise-dead'")
        .getSingle();
    expect(row.read<int>('level'), 5);
    expect(row.read<String>('school'), 'necromancy');
    expect(row.read<int>('material_cost_cp'), 50000);
    expect(row.read<bool>('material_consumed'), isTrue);
  });

  test('recherche par nom', () async {
    final hit = (await store.search('boule de feu')).first;
    expect((hit.id, hit.type), ('srd:spell:fireball', 'spell'));
  });
}
