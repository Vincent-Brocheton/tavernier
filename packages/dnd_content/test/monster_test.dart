// Spec content-pack : « Type monstre » et « Cohérence d’un monstre ».
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

ContentPack _pack(List<Map<String, Object?>> monsters) => ContentPack(
  manifest: srdManifest(),
  entities: [
    entity({
      'id': 'srd:damage-type:piercing',
      'type': 'damage-type',
      'name': 'Perforant',
    }),
    entity({
      'id': 'srd:condition:prone',
      'type': 'condition',
      'name': 'À terre',
      'text': {'fr': 'Texte.'},
    }),
    ability('dex'),
    ability('wis'),
    skill('stealth', 'srd:ability:dex'),
    skill('perception', 'srd:ability:wis'),
    for (final m in monsters) entity(m),
  ],
);

List<String> _messages(List<Map<String, Object?>> monsters) => [
  for (final i in validatePack(_pack(monsters))) '${i.path} ${i.message}',
];

void main() {
  test('le Loup se lit : FP 1/4, 50 PX, Intelligence 3, Morsure', () {
    final json = wolf();
    final result = parseEntity(json, 'monster/wolf.json');
    expect(result.issues, isEmpty);
    final data = result.entity!.data as MonsterData;
    expect(data.cr, '1/4');
    expect(data.xp, 50);
    expect(data.abilities['int'], 3);
    expect(data.sizes, [MonsterSize.medium]);
    expect(data.creatureType, CreatureType.beast);
    final bite = data.actions[1];
    expect(bite.kind, MonsterActionKind.action);
    expect(bite.name, 'Morsure');
    expect(bite.attack!.reach, 5);
    expect(bite.attack!.damage.single.type.slug, 'piercing');
    expect(result.entity!.toJson(), json);
  });

  test('champ inconnu refusé, dans le profil comme dans une action', () {
    final paths = [
      for (final json in [
        wolf(data: {'telepathy': 120}),
        wolf(
          actions: [
            {'kind': 'action', 'name': 'X', 'text': 'Y', 'damage': 3},
          ],
        ),
      ])
        ...parseEntity(json, 'monster/wolf.json').issues.map((i) => i.path),
    ];
    expect(paths, hasLength(2));
    expect(paths.first, 'monster/wolf.json.data.telepathy');
    expect(paths.last, startsWith('monster/wolf.json.data'));
  });

  test('les six caractéristiques sont exigées', () {
    final issues = parseEntity(
      wolf(
        data: {
          'abilities': {'str': 14},
        },
      ),
      'monster/wolf.json',
    ).issues;
    expect(issues, isNotEmpty);
  });

  test('usages : X/jour, recharge, après un repos', () {
    final data =
        parseEntity(
              wolf(
                actions: [
                  {
                    'kind': 'trait',
                    'name': 'Résistance légendaire',
                    'uses': {'per_day': 3, 'per_day_lair': 4},
                    'text': 'T',
                  },
                  {
                    'kind': 'action',
                    'name': 'Souffle',
                    'uses': {'recharge': '5-6'},
                    'save': {'ability': 'dex', 'dc': 16},
                    'text': 'T',
                  },
                  {
                    'kind': 'bonus',
                    'name': 'Repli',
                    'uses': {'rest': 'short_or_long'},
                    'text': 'T',
                  },
                ],
              ),
              'monster/wolf.json',
            ).entity!.data
            as MonsterData;
    expect(data.actions.map((a) => a.uses!.label), [
      '3/day',
      '5-6',
      'short_or_long',
    ]);
    expect(data.actions[1].save!.dc, 16);
  });

  test('pack valide avec le Loup', () {
    expect(_messages([wolf()]), isEmpty);
  });

  test('PX incohérents : la construction nomme le monstre', () {
    expect(
      _messages([
        wolf(data: {'xp': 100}),
      ]),
      ['srd:monster:wolf.data.xp FP 1/4 : 50 PX attendus, reçu 100'],
    );
  });

  test('FP inconnu et bonus de maîtrise incohérent refusés', () {
    expect(
      _messages([
        wolf(data: {'cr': '1/3'}),
      ]),
      ['srd:monster:wolf.data.cr FP inconnu : 1/3'],
    );
    expect(
      _messages([
        wolf(data: {'proficiency_bonus': 3}),
      ]),
      [
        'srd:monster:wolf.data.proficiency_bonus FP 1/4 : BM +2 attendu, reçu +3',
      ],
    );
  });

  test('FP 0 : 0 ou 10 PX', () {
    for (final xp in [0, 10]) {
      expect(
        _messages([
          wolf(data: {'cr': '0', 'xp': xp}),
        ]),
        isEmpty,
      );
    }
  });

  test('référence de compétence, de dégâts ou d’état introuvable', () {
    expect(
      _messages([
        wolf(
          data: {
            'skills': {'srd:skill:arcana': 2},
            'resistances': ['srd:damage-type:fire'],
            'condition_immunities': ['srd:damage-type:piercing'],
          },
        ),
      ]),
      unorderedEquals([
        'srd:monster:wolf référence introuvable : srd:skill:arcana',
        'srd:monster:wolf référence introuvable : srd:damage-type:fire',
        'srd:monster:wolf srd:damage-type:piercing : type « condition » '
            'attendu, reçu « damage-type »',
      ]),
    );
  });

  test('action Légendaire sans nombre d’utilisations refusée', () {
    expect(
      _messages([
        wolf(
          actions: [
            {'kind': 'legendary', 'name': 'Bond', 'text': 'T'},
          ],
        ),
      ]),
      [
        'srd:monster:wolf.data.legendary_uses '
            'nombre d’utilisations requis pour une action Légendaire',
      ],
    );
  });

  test('usage vide ou attaque sans allonge ni portée refusés', () {
    expect(
      _messages([
        wolf(
          actions: [
            {
              'kind': 'trait',
              'name': 'R',
              'uses': {'per_day_lair': 4},
              'text': 'T',
            },
            {
              'kind': 'action',
              'name': 'Javeline',
              'attack': {
                'kind': 'melee_or_ranged',
                'bonus': 6,
                'reach': 5,
                'damage': <Object?>[],
              },
              'text': 'T',
            },
          ],
        ),
      ]),
      [
        'srd:monster:wolf.data.actions[0].uses '
            'un seul usage attendu : per_day, recharge ou rest',
        'srd:monster:wolf.data.actions[1].attack '
            'allonge (corps à corps) ou portée [normale, longue] (à distance) '
            'attendue',
      ],
    );
  });
}
