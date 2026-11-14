// Extraction du bestiaire (change t-06b-extracteur-bestiaire). Extraits
// réels du PDF en ordre de lecture, abrégés.
import 'dart:convert';
import 'dart:io';

import 'package:srd_builder/src/monster_extractor.dart';
import 'package:test/test.dart';

const _text = '''
Monstres de A à Z
Ogre

Ogre

Géant de taille G, Chaotique Mauvais

CA 11 Pv 68 (8d10 + 24) Vitesse 12 m
MOD JS
For 19 +4 +4
Int 5 −3 −3

Initiative −1 (9)

Dex 8 Sag 7

MOD JS
−1 −1 −2 −2

MOD JS
Con 16 +3 +3 Cha 7 −2 −2

Équipement javelines (3), massue Sens Vision dans le noir 18 m ; Perception passive 8 Langues commun, gigant FP 2 (450 PX ; BM +2)

Actions
Massue. Corps à corps : +6, allonge 1,50 m. Touché : 13 (2d8 + 4) dégâts contondants.
Javeline. Corps à corps ou à distance : +6, allonge 1,50 m ou portée 9/36 m. Touché : 11 (2d6 + 4) dégâts perforants.

Ombre

Ombre

Mort-vivant de taille M, Chaotique Mauvais

CA 12 Pv 27 (5d8 + 5) Vitesse 12 m
MOD JS
For 6 −2 −2
Int 6 −2 −2

Initiative +2 (12)
MOD JS
Dex 14 +2 +2 Sag 10 +0 +0

MOD JS
Con 13 +1 +1 Cha 8 −1 −1

Compétences Discrétion +6 Vulnérabilités radiants Résistances acide, feu, foudre, froid, tonnerre Immunités nécrotiques, poison ; À terre, Agrippé, Effrayé,
Empoisonné, Entravé, Épuisement, Inconscient, Paralysé, Pétrifié Sens Vision dans le noir 18 m ; Perception passive 10 Langues aucune FP 1/2 (100 PX ; BM +2)

Traits
Informe. L’ombre peut se déplacer dans un espace étroit d’une largeur minimale de 2,5 cm sans dépense supplémentaire en déplacement.
Actions
Caresse dévitalisante. Corps à corps : +4, allonge 1,50 m. Touché : 5 (1d6 + 2) dégâts nécrotiques, et la valeur de Force de la cible est réduite de 1d4.
Actions Bonus
Discrétion dans les ombres. Tant qu’elle reste dans les Ténèbres ou sous une Lumière faible, l’ombre peut entreprendre l’action Furtivité.

Dragons rouges

Dragon rouge adulte

Dragon (Chromatique) de taille TG, Chaotique Mauvais

CA 19

Initiative +12 (22)

Pv 256 (19d12 + 133)

Vitesse 12 m, escalade 12 m, vol 24 m

MOD JS
For 27 +8 +8 Int 16 +3 +3

MOD JS
Dex 10 +0 +6 Sag 13 +1 +7

MOD JS
Con 25 +7 +7 Cha 23 +6 +6

Compétences Discrétion +6, Perception +13 Immunités feu Sens Vision aveugle 18 m, Vision dans le noir 36 m ;
Perception passive 23 Langues commun, draconique FP 17 (18 000 PX, ou 20 000 dans son antre ; BM +6)

Traits
Résistance légendaire (3/jour, ou 4/jour dans son antre). Si le dragon rate un jet de sauvegarde, il peut décider de le réussir tout de même.

Actions
Saignée. Corps à corps : +14, allonge 3 m. Touché : 13 (1d10 + 8) dégâts tranchants plus 5 (2d4) dégâts de feu.
Incantation. Le dragon lance l’un des sorts suivants sans composantes matérielles, le Charisme étant sa caractéristique d’incantation (DD de sauvegarde 20, +12 pour toucher) :
À volonté : détection de la magie, injonction (au 2e niveau), rayon ardent
1/jour : boule de feu
Souffle de feu (recharge 5–6). JS Dextérité : DD 21, chaque créature dans un Cône de 18 m. Échec : 59 (17d6) dégâts de feu. Réussite : demi-dégâts.
Actions Légendaires
Utilisations d’action Légendaire : 3 (4 dans son antre). Aussitôt après le tour d’une autre créature, le dragon peut dépenser une utilisation pour entreprendre l’une des actions ci-après. Le dragon récupère toutes ses utilisations dépensées au début de chacun de ses tours.
Assaut incisif. Le dragon se déplace à concurrence de la moitié de sa Vitesse et effectue une attaque de Saignée.

301 Document de Référence du Système 5.2.1

Loup-garou

Loup-garou

Monstruosité (Lycanthrope) de taille M ou P, Chaotique Mauvaise

CA 15

Initiative +4 (14)

Pv 71 (11d8 + 22)

Vitesse 9 m, 12 m (forme de loup uniquement)

MOD JS
For 16 +3 +3 Dex 14 +2 +2 Con 14 +2 +2
Int 10 +0 +0 Sag 11 +0 +0 Cha 10 +0 +0

Sens Vision dans le noir 18 m ; Perception passive 14 Langues commun (ne parle pas sous forme de loup) FP 3 (700 PX ; BM +2)

Actions
Éraflure. Corps à corps : +5, allonge 1,50 m. Touché : 10 (2d6 + 3) dégâts tranchants.

Animaux

Nuée de chauves-souris

Nuée de taille G de Bêtes de taille TP, non alignée

CA 12

Initiative +2 (12)

Pv 11 (2d10)

Vitesse 1,50 m, vol 9 m

For 5 Int 2

MOD JS
−3 −3 −4 −4

MOD JS
Dex 15 +2 +2 Sag 12 +1 +1

MOD JS
Con 10 +0 +0 Cha 4 −3 −3

Résistances contondants, perforants, tranchants Immunités À terre, Agrippé, Charmé, Effrayé, Entravé,
Étourdi, Paralysé, Pétrifié Sens Vision aveugle 18 m ; Perception passive 11 Langues aucune FP 1/4 (50 PX ; BM +2)

Actions
Morsures. Corps à corps : +4, allonge 1,50 m. Touché : 5 (2d4) dégâts perforants, ou 2 (1d4) dégâts perforants si la nuée est En péril.
''';

Map<String, Map<String, Object?>> _extract(
  String text, {
  List<String>? problems,
  List<String>? suspects,
}) => {
  for (final m in extractMonsters(
    text,
    problems: problems ?? [],
    suspects: suspects,
  ))
    m.name: m.data,
};

void main() {
  final monsters = _extract(_text);

  test('un profil par ligne de type, titres de groupe écartés', () {
    expect(monsters.keys, [
      'Ogre',
      'Ombre',
      'Dragon rouge adulte',
      'Loup-garou',
      'Nuée de chauves-souris',
    ]);
    final legendary = monsters['Dragon rouge adulte']!['actions']! as List;
    expect((legendary.last as Map)['text'], isNot(contains('Loup-garou')));
  });

  test('Ogre : caractéristiques mêlées remises en ordre, « gigant » → '
      '« géant »', () {
    final ogre = monsters['Ogre']!;
    expect(ogre['abilities'], {
      'str': 19,
      'dex': 8,
      'con': 16,
      'int': 5,
      'wis': 7,
      'cha': 7,
    });
    expect((ogre['abilities']! as Map).keys, [
      'str',
      'dex',
      'con',
      'int',
      'wis',
      'cha',
    ]);
    expect(ogre['saving_throws'], {
      'str': 4,
      'dex': -1,
      'con': 3,
      'int': -3,
      'wis': -2,
      'cha': -2,
    });
    expect(ogre['initiative'], -1);
    expect(ogre['hit_dice'], '8d10 + 24');
    expect(ogre['speed'], {'walk': 40});
    expect(ogre['gear'], ['javelines (3)', 'massue']);
    expect(ogre['languages'], 'commun, géant');
    expect(ogre['senses'], {'darkvision': 60});
    expect(ogre['passive_perception'], 8);
    final javelin = (ogre['actions']! as List).last as Map;
    expect(javelin['attack'], {
      'kind': 'melee_or_ranged',
      'bonus': 6,
      'reach': 5,
      'range': [30, 120],
      'damage': [
        {'average': 11, 'dice': '2d6 + 4', 'type': 'srd:damage-type:piercing'},
      ],
    });
  });

  test('Ombre : immunités sur deux lignes, dégâts puis états ; rubriques', () {
    final shadow = monsters['Ombre']!;
    expect(shadow['skills'], {'srd:skill:stealth': 6});
    expect(shadow['vulnerabilities'], ['srd:damage-type:radiant']);
    expect(shadow['resistances'], hasLength(5));
    expect(shadow['immunities'], [
      'srd:damage-type:necrotic',
      'srd:damage-type:poison',
    ]);
    expect(shadow['condition_immunities'], hasLength(9));
    expect(shadow['cr'], '1/2');
    expect(shadow['xp'], 100);
    expect(
      [
        for (final a in shadow['actions']! as List)
          ((a as Map)['kind'], a['name']),
      ],
      [
        ('trait', 'Informe'),
        ('action', 'Caresse dévitalisante'),
        ('bonus', 'Discrétion dans les ombres'),
      ],
    );
  });

  test('Dragon rouge adulte : antre, Légendaire, recharge, JS, sorts', () {
    final dragon = monsters['Dragon rouge adulte']!;
    expect(dragon['type_tags'], ['Chromatique']);
    expect(dragon['xp'], 18000);
    expect(dragon['xp_lair'], 20000);
    expect(dragon['proficiency_bonus'], 6);
    expect(dragon['legendary_uses'], 3);
    expect(dragon['legendary_uses_lair'], 4);
    expect(dragon['speed'], {'walk': 40, 'climb': 40, 'fly': 80});
    expect(dragon['senses'], {'darkvision': 120, 'blindsight': 60});
    final actions = {
      for (final a in dragon['actions']! as List) (a as Map)['name']: a,
    };
    expect(actions['Résistance légendaire']!['uses'], {
      'per_day': 3,
      'per_day_lair': 4,
    });
    expect(
      actions['Saignée']!['attack'],
      containsPair('damage', [
        {'average': 13, 'dice': '1d10 + 8', 'type': 'srd:damage-type:slashing'},
        {'average': 5, 'dice': '2d4', 'type': 'srd:damage-type:fire'},
      ]),
    );
    expect(
      actions['Incantation']!['text'],
      endsWith(
        ':\nÀ volonté : détection de la magie, injonction (au 2e niveau), '
        'rayon ardent\n1/jour : boule de feu',
      ),
    );
    final breath = actions['Souffle de feu']!;
    expect(breath['uses'], {'recharge': '5-6'});
    expect(breath['save'], {'ability': 'dex', 'dc': 21});
    expect(breath.containsKey('attack'), isFalse);
    expect(actions['Assaut incisif']!['kind'], 'legendary');
    expect(actions.keys, isNot(contains(startsWith('Utilisations'))));
  });

  test('Loup-garou : Vitesse de forme dans speed_note', () {
    final werewolf = monsters['Loup-garou']!;
    expect(werewolf['sizes'], ['medium', 'small']);
    expect(werewolf['speed'], {'walk': 30});
    expect(werewolf['speed_note'], '12 m (forme de loup uniquement)');
  });

  test('Nuée de chauves-souris : taille de la nuée et de ses créatures', () {
    final swarm = monsters['Nuée de chauves-souris']!;
    expect(swarm['sizes'], ['large']);
    expect(swarm['swarm_size'], 'tiny');
    expect(swarm['creature_type'], 'beast');
    expect(swarm['speed'], {'walk': 5, 'fly': 30});
    expect(swarm['senses'], {'blindsight': 60});
  });

  test('ligne de sorts en fin de profil gardée (Chouette géante)', () {
    final text = _text.replaceFirst(
      'Touché : 10 (2d6 + 3) dégâts tranchants.\n',
      'Touché : 10 (2d6 + 3) dégâts tranchants.\n'
          'Incantation. Le loup-garou lance l’un des sorts suivants :\n'
          'À volonté : détection de la magie\n'
          '1/jour : clairvoyance\n',
    );
    final actions = _extract(text)['Loup-garou']!['actions']! as List;
    expect((actions.last as Map)['text'], endsWith('\n1/jour : clairvoyance'));
  });

  test('précision de sens dans senses_note', () {
    final text = _text.replaceFirst(
      'Vision dans le noir 18 m ; Perception passive 8',
      'Vision dans le noir 36 m (perce les Ténèbres magiques) ; '
          'Perception passive 8',
    );
    final ogre = _extract(text)['Ogre']!;
    expect(ogre['senses'], {'darkvision': 120});
    expect(
      ogre['senses_note'],
      'Vision dans le noir 36 m (perce les Ténèbres magiques)',
    );
  });

  test('modificateur discordant : profil refusé', () {
    final problems = <String>[];
    final result = _extract(
      _text.replaceFirst('For 19 +4 +4', 'For 19 +3 +4'),
      problems: problems,
    );
    expect(result.keys, isNot(contains('Ogre')));
    expect(problems, ['Ogre : modificateur de For 3 pour 19']);
  });

  test('dégâts non reconnus : à relire, attaque gardée', () {
    final suspects = <String>[];
    final ogre = _extract(
      _text.replaceFirst('13 (2d8 + 4) dégâts contondants.', 'la cible tombe.'),
      suspects: suspects,
    )['Ogre']!;
    expect(
      ((ogre['actions']! as List).first as Map)['attack'],
      containsPair('damage', isEmpty),
    );
    expect(suspects, ['Ogre : dégâts non lus : la cible tombe.']);
  });

  group('commande', () {
    late Directory sources;
    setUp(() => sources = Directory.systemTemp.createTempSync('monsters'));
    tearDown(() => sources.deleteSync(recursive: true));

    const slugs = {
      'Ogre': 'ogre',
      'Ombre': 'shadow',
      'Dragon rouge adulte': 'adult-red-dragon',
      'Loup-garou': 'werewolf',
      'Nuée de chauves-souris': 'swarm-of-bats',
    };

    List<String> run(Map<String, String> slugs) => extractMonsterSources(
      readingOrder: _text,
      slugs: slugs,
      sources: sources.path,
      report: StringBuffer(),
    );

    test('écrit un fichier par profil', () {
      expect(run(slugs), isEmpty);
      final json = jsonDecode(
        File('${sources.path}/monster/ogre.json').readAsStringSync(),
      ) as Map<String, Object?>;
      expect(json['id'], 'srd:monster:ogre');
      expect(json['name'], 'Ogre');
      expect((json['data']! as Map)['xp'], 450);
    });

    test('slug manquant : rien n’est écrit', () {
      expect(run({...slugs}..remove('Ombre')), ['monstre sans slug : Ombre']);
      expect(Directory('${sources.path}/monster').existsSync(), isFalse);
    });

    test('source orpheline signalée', () {
      File('${sources.path}/monster/old.json').createSync(recursive: true);
      expect(run(slugs), [
        allOf(startsWith('source orpheline : '), endsWith('old.json')),
      ]);
    });
  });
}
