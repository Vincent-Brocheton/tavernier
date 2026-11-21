// Spec homebrew : « Vérification d'un pack », « Mes packs » (US-27).
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

void main() {
  final srd = [
    ability('str'),
    ability('dex'),
    ability('con'),
    ability('wis'),
    skill('athletics', 'srd:ability:str'),
    skill('perception', 'srd:ability:wis'),
    feat('alert', 'origin'),
    feat('grappler', 'general'),
  ];
  final manifest = newHomebrewManifest(
    id: '0193a000-0000-7000-8000-000000000001',
    name: 'Gardiens des Marches',
    namespace: 'gardiens',
    author: 'Inès',
    srd: srdManifest(),
  );

  Map<String, Object?> background(List<String> abilities, String feat) => {
    'id': 'gardiens:background:sentinelle',
    'type': 'background',
    'name': 'Sentinelle',
    'data': {
      'abilities': abilities,
      'origin_feat': feat,
      'skill_proficiencies': ['srd:skill:athletics', 'srd:skill:perception'],
      'equipment_a': <Object?>[],
      'gold_a': 15,
      'gold_b': 50,
    },
    'text': {'fr': 'Texte.'},
  };

  test('nouveau pack : manifeste valide, version 0.1.0', () {
    expect(PackManifest.parse(manifest).issues, isEmpty);
    expect(manifest['version'], '0.1.0');
    expect(checkDraft(manifest, const [], dependencies: srd), isEmpty);
  });

  test('Historique incomplet : les règles 2024 se lisent déjà', () {
    final messages = [
      for (final i in checkDraft(manifest, [
        {
          'id': 'gardiens:background:sentinelle',
          'type': 'background',
          'name': 'Sentinelle',
          'data': {
            'abilities': ['srd:ability:str'],
          },
        },
      ], dependencies: srd))
        i.message,
    ];
    expect(
      messages,
      contains('un Historique cite exactement 3 caractéristiques'),
    );
    expect(
      messages,
      contains('un Historique accorde exactement 2 compétences'),
    );
  });

  test('Historique complet : aucun problème', () {
    final issues = checkDraft(manifest, [
      background([
        'srd:ability:str',
        'srd:ability:dex',
        'srd:ability:con',
      ], 'srd:feat:alert'),
    ], dependencies: srd);
    expect(issues, isEmpty);
  });

  test('Historique à 2 caractéristiques et don général : signalés', () {
    final messages = [
      for (final i in checkDraft(manifest, [
        background(['srd:ability:str', 'srd:ability:dex'], 'srd:feat:grappler'),
      ], dependencies: srd))
        i.message,
    ];
    expect(messages, contains(contains('exactement 3 caractéristiques')));
    expect(messages, contains(contains('don d\'origines')));
  });

  test('Don sans catégorie : signalé, le reste se lit', () {
    final issues = checkDraft(manifest, [
      {
        'id': 'gardiens:feat:veilleur',
        'type': 'feat',
        'name': 'Veilleur',
        'data': <String, Object?>{},
        'text': {'fr': 'Texte.'},
      },
    ], dependencies: srd);
    expect(issues.single.path, contains('category'));
  });

  test('Arme sans botte : la règle 2024 est signalée', () {
    final issues = checkDraft(manifest, [
      {
        'id': 'gardiens:weapon:hache',
        'type': 'weapon',
        'name': 'Hache',
        'data': {
          'category': 'martial',
          'kind': 'melee',
          'damage': '1d8',
          'damage_type': 'srd:damage-type:slashing',
          'cost_cp': 1000,
        },
      },
    ], dependencies: srd);
    expect(
      issues.map((i) => i.message),
      contains('une arme a toujours une botte d’arme'),
    );
  });

  test('Espèce sans taille : signalée ; avec son trait, prête', () {
    Map<String, Object?> species(List<String> sizes) => {
      'id': 'gardiens:species:brumelin',
      'type': 'species',
      'name': 'Brumelin',
      'data': {
        'creature_type': 'humanoid',
        'sizes': sizes,
        'speed_feet': 30,
        'traits': ['gardiens:feature:brumelin-vision-brumeuse'],
      },
    };
    const trait = {
      'id': 'gardiens:feature:brumelin-vision-brumeuse',
      'type': 'feature',
      'name': 'Vision brumeuse',
      'data': {'source': 'gardiens:species:brumelin', 'level': 1},
      'text': {'fr': 'Vous voyez dans la brume.'},
      'effects': [
        {'op': 'grant_sense', 'sense': 'darkvision', 'range': 60},
      ],
    };
    expect(
      checkDraft(manifest, [
        species([]),
        trait,
      ], dependencies: srd).map((i) => i.message),
      ['une espèce a au moins une taille'],
    );
    expect(
      checkDraft(manifest, [
        species(['P']),
        trait,
      ], dependencies: srd),
      isEmpty,
    );
  });

  Map<String, Object?> cls(
    String id, {
    int levels = 20,
    List<int> subclassLevels = const [3, 7, 10, 15, 18],
  }) => {
    'id': id,
    'type': 'class',
    'name': 'Guerrier',
    'data': {
      'primary_abilities': ['srd:ability:str'],
      'hit_die': 10,
      'saving_throws': ['srd:ability:str', 'srd:ability:con'],
      'skill_choice_count': 1,
      'skill_choices': ['srd:skill:athletics', 'srd:skill:perception'],
      'weapon_proficiencies': ['simple', 'martial'],
      'armor_training': ['light'],
      'subclass_level': 3,
      'subclass_feature_levels': subclassLevels,
      'levels': [
        for (var l = 1; l <= levels; l++)
          {'level': l, 'proficiency_bonus': 2 + (l - 1) ~/ 4},
      ],
    },
  };

  test('[H02] sous-classe : niveaux alignés sur le parent, tous remplis', () {
    final deps = [...srd, entity(cls('srd:class:fighter'))];
    List<Map<String, Object?>> draft(List<int> levels) => [
      {
        'id': 'gardiens:subclass:rempart',
        'type': 'subclass',
        'name': 'Gardien du rempart',
        'data': {
          'parent_class': 'srd:class:fighter',
          'features': [for (final l in levels) 'gardiens:feature:rempart-$l'],
        },
      },
      for (final l in levels)
        {
          'id': 'gardiens:feature:rempart-$l',
          'type': 'feature',
          'name': 'Aptitude $l',
          'data': {'source': 'gardiens:subclass:rempart', 'level': l},
          'text': {'fr': 'Texte.'},
        },
    ];
    expect(
      checkDraft(
        manifest,
        draft([3, 4, 7]),
        dependencies: deps,
      ).map((i) => i.message),
      [
        'la classe parente n’accorde pas d’aptitude de sous-classe au niveau 4',
        'progression incomplète : aucune aptitude aux niveaux 10, 15, 18',
      ],
    );
    expect(
      checkDraft(manifest, draft([3, 7, 10, 15, 18]), dependencies: deps),
      isEmpty,
    );
  });

  test('classe : 20 niveaux, niveaux de sous-classe dès son choix', () {
    List<String> messages(Map<String, Object?> c) => [
      for (final i in checkDraft(manifest, [c], dependencies: srd)) i.message,
    ];
    expect(messages(cls('gardiens:class:veilleur')), isEmpty);
    expect(messages(cls('gardiens:class:veilleur', levels: 12)), [
      'progression incomplète : une classe a ses 20 niveaux',
    ]);
    expect(messages(cls('gardiens:class:veilleur', subclassLevels: [])), [
      'les aptitudes de sous-classe commencent au niveau où on la choisit',
    ]);
    expect(
      messages(cls('gardiens:class:veilleur', subclassLevels: [3, 9, 6])),
      ['les niveaux de sous-classe vont croissant, jusqu’au niveau 20'],
    );
  });

  test('Monstre : Intelligence obligatoire, un DD par palier d’Étude', () {
    Map<String, Object?> monster(Map<String, Object?> data) {
      final base = wolf(
        actions: const [],
        data: {
          'skills': {'srd:skill:perception': 5},
          ...data,
        },
      );
      return {...base, 'id': 'gardiens:monster:loup-des-brumes'};
    }

    List<String> messages(Map<String, Object?> data) => [
      for (final i in checkDraft(manifest, [monster(data)], dependencies: srd))
        i.message,
    ];
    const reveals = [
      {'dc': 10, 'text': 'Il chasse en meute.'},
      {'dc': 15, 'text': 'La brume le cache.'},
    ];
    expect(messages({'study_reveals': reveals}), isEmpty);
    expect(
      messages({
        'abilities': {'str': 14, 'dex': 15, 'con': 12, 'wis': 12, 'cha': 6},
      }),
      contains('un monstre a une valeur d’Intelligence (DD d’Influence)'),
    );
    expect(
      messages({
        'study_reveals': [
          ...reveals,
          {'dc': 15, 'text': 'Autre chose.'},
        ],
      }),
      ['palier d’Étude : un DD par palier, et un texte'],
    );
  });

  test('identifiants : slug sans accents, unique dans le pack', () {
    expect(slugOf('Gardiens des Marches'), 'gardiens-des-marches');
    expect(
      homebrewEntityId('gardiens', 'feat', 'Œil de la Sentinelle', const []),
      'gardiens:feat:oeil-de-la-sentinelle',
    );
    expect(
      homebrewEntityId('gardiens', 'feat', 'Veilleur', [
        'gardiens:feat:veilleur',
      ]),
      'gardiens:feat:veilleur-2',
    );
  });
}
