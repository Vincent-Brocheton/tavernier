// Spec local-database : « Monstres chargés depuis les packs ».
import 'dart:convert';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

import 'support.dart';

final _monsters = ContentPack(
  manifest: srdPack.manifest,
  entities: [
    for (final e in srdPack.entities)
      if (e.type == 'monster') e,
  ],
);

void main() {
  late TavernierDatabase db;
  late PackStore store;
  setUp(() async {
    db = memoryDatabase();
    store = PackStore(db);
    await store.importPack(_monsters);
  });
  tearDown(() => db.close());

  test('Ogre importé : FP 2, 450 PX, Intelligence 5', () async {
    final row = await db
        .customSelect(
          'SELECT creature_type, challenge_rating, xp, intelligence, '
          "stat_block FROM monster WHERE id = 'srd:monster:ogre'",
        )
        .getSingle();
    expect(row.read<String>('creature_type'), 'giant');
    expect(row.read<String>('challenge_rating'), '2');
    expect(row.read<int>('xp'), 450);
    expect(row.read<int>('intelligence'), 5);
    final block =
        jsonDecode(row.read<String>('stat_block')) as Map<String, Object?>;
    expect(block['hp'], 68);
  });

  test('actions de l’Ogre dans l’ordre du profil', () async {
    final rows = await db
        .customSelect(
          'SELECT position, kind, name FROM monster_action '
          "WHERE monster_id = 'srd:monster:ogre' ORDER BY position",
        )
        .get();
    expect(
      [
        for (final r in rows)
          (
            r.read<int>('position'),
            r.read<String>('kind'),
            r.read<String>('name'),
          ),
      ],
      [(0, 'action', 'Massue'), (1, 'action', 'Javeline')],
    );
  });

  test('recharge en clair', () async {
    final json = {
      ..._monsters.entities.firstWhere((e) => e.id.slug == 'wolf').toJson(),
      'id': 'srd:monster:test-wolf',
    };
    final data = json['data']! as Map<String, Object?>;
    data['actions'] = [
      {
        'kind': 'action',
        'name': 'Souffle',
        'uses': {'recharge': '5-6'},
        'text': 'T',
      },
      {
        'kind': 'trait',
        'name': 'Résistance légendaire',
        'uses': {'per_day': 3},
        'text': 'T',
      },
      {'kind': 'bonus', 'name': 'Repli', 'text': 'T'},
    ];
    await store.importPack(
      ContentPack(
        manifest: _monsters.manifest,
        entities: [..._monsters.entities, parseEntity(json, 'x').entity!],
      ),
    );
    final rows = await db
        .customSelect(
          'SELECT recharge FROM monster_action '
          "WHERE monster_id = 'srd:monster:test-wolf' ORDER BY position",
        )
        .get();
    expect(
      [for (final r in rows) r.read<String?>('recharge')],
      ['5-6', '3/day', null],
    );
  });

  test('aller-retour des monstres', () async {
    final exported = await store.exportPack(_monsters.manifest.id);
    expect(
      {for (final e in exported!.entities) '${e.id}': e.toJson()},
      {for (final e in _monsters.entities) '${e.id}': e.toJson()},
    );
  });
}
