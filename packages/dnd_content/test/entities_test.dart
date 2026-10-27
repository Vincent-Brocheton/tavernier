import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

Map<String, Object?> _longsword() => {
  'id': 'srd:weapon:longsword',
  'type': 'weapon',
  'name': 'Épée longue',
  'data': {
    'category': 'martial',
    'kind': 'melee',
    'damage': '1d8',
    'damage_type': 'srd:damage-type:slashing',
    'properties': ['versatile'],
    'versatile_damage': '1d10',
    'mastery': 'srd:mastery:sap',
    'weight_kg': 1.5,
    'cost_cp': 1500,
  },
};

Map<String, Object?> _soldier() => {
  'id': 'srd:background:soldier',
  'type': 'background',
  'name': 'Soldat',
  'data': {
    'abilities': ['srd:ability:str', 'srd:ability:dex', 'srd:ability:con'],
    'origin_feat': 'srd:feat:savage-attacker',
    'skill_proficiencies': ['srd:skill:athletics', 'srd:skill:intimidation'],
    'tool_choice_category': 'gaming_set',
    'equipment_a': [
      {'item': 'srd:weapon:shortbow', 'quantity': 1},
    ],
    'gold_a': 14,
    'gold_b': 50,
  },
  'text': {'fr': 'Texte du Soldat.'},
};

List<String> _issuePaths(Object? json) => parseEntity(
  json,
  'weapon/longsword.json',
).issues.map((i) => i.path).toList();

void main() {
  test('les 16 types de l\'échantillon sont connus', () {
    expect(entityTypes, hasLength(17));
    expect(
      entityTypes,
      containsAll(['weapon', 'background', 'feature', 'damage-type']),
    );
  });

  test('l\'épée longue se lit en WeaponData', () {
    final result = parseEntity(_longsword(), 'weapon/longsword.json');
    expect(result.issues, isEmpty);
    final entity = result.entity!;
    expect(entity.id, ContentId.tryParse('srd:weapon:longsword'));
    final data = entity.data as WeaponData;
    expect(data.damage, '1d8');
    expect(data.damageType, ContentId.tryParse('srd:damage-type:slashing'));
    expect(data.versatileDamage, '1d10');
    expect(data.mastery.slug, 'sap');
    expect(data.weightKg, 1.5);
    expect(data.costCp, 1500);
  });

  test('le Soldat se lit en BackgroundData avec trois caractéristiques', () {
    final result = parseEntity(_soldier(), 'background/soldier.json');
    expect(result.issues, isEmpty);
    final data = result.entity!.data as BackgroundData;
    expect(data.abilities.map((a) => a.slug), ['str', 'dex', 'con']);
    expect(data.originFeat.slug, 'savage-attacker');
    expect(result.entity!.textFr, 'Texte du Soldat.');
  });

  test('chaque type se lit puis se réécrit à l\'identique', () {
    expect(_oneOfEachType.map((e) => e['type']).toSet(), entityTypes);
    for (final json in _oneOfEachType) {
      final result = parseEntity(json, '${json['id']}');
      expect(result.issues, isEmpty, reason: '${json['id']}');
      final again = parseEntity(result.entity!.toJson(), 'relu');
      expect(
        again.entity!.toJson(),
        result.entity!.toJson(),
        reason: '${json['id']}',
      );
    }
  });

  test('le poids d\'une arme est facultatif (« — » dans le SRD)', () {
    final json = _longsword();
    (json['data']! as Map<String, Object?>).remove('weight_kg');
    final result = parseEntity(json, 'weapon/longsword.json');
    expect(result.issues, isEmpty);
    expect((result.entity!.data as WeaponData).weightKg, isNull);
  });

  test('une valeur d\'énumération inconnue est refusée', () {
    final json = _longsword();
    (json['data']! as Map<String, Object?>)['category'] = 'exotic';
    expect(_issuePaths(json), contains('weapon/longsword.json.data.category'));
  });

  test('un effet valide est lu', () {
    final json = {
      'id': 'srd:feat:defense',
      'type': 'feat',
      'name': 'Défense',
      'data': {'category': 'fighting_style', 'repeatable': false},
      'effects': [
        {
          'op': 'modify_ac',
          'value': 1,
          'when': {'armor': 'any'},
        },
      ],
      'text': {'fr': 'Tant que vous portez une armure…'},
    };
    final result = parseEntity(json, 'feat/defense.json');
    expect(result.issues, isEmpty);
    expect(result.entity!.effects.single.op, 'modify_ac');
  });

  group('entités invalides', () {
    test('type inconnu', () {
      expect(
        _issuePaths({..._longsword(), 'type': 'spellbook'}),
        contains('weapon/longsword.json.type'),
      );
    });
    test('champ inconnu dans data', () {
      final json = _longsword();
      (json['data']! as Map<String, Object?>)['sharpness'] = 3;
      expect(
        _issuePaths(json),
        contains('weapon/longsword.json.data.sharpness'),
      );
    });
    test('champ requis absent dans data', () {
      final json = _longsword();
      (json['data']! as Map<String, Object?>).remove('mastery');
      expect(_issuePaths(json), contains('weapon/longsword.json.data.mastery'));
    });
    test('référence mal formée dans data', () {
      final json = _longsword();
      (json['data']! as Map<String, Object?>)['mastery'] = 'sap';
      expect(_issuePaths(json), contains('weapon/longsword.json.data.mastery'));
    });
    test('id dont le type diffère du champ type', () {
      expect(
        _issuePaths({..._longsword(), 'type': 'armor'}),
        contains('weapon/longsword.json.id'),
      );
    });
    test('champ inconnu dans l\'enveloppe', () {
      expect(
        _issuePaths({..._longsword(), 'rarity': 'common'}),
        contains('weapon/longsword.json.rarity'),
      );
    });
    test('effet invalide', () {
      expect(
        _issuePaths({
          ..._longsword(),
          'effects': [
            {'op': 'nope'},
          ],
        }),
        contains('weapon/longsword.json.effects[0].op'),
      );
    });
    test('texte non textuel', () {
      expect(
        _issuePaths({
          ..._longsword(),
          'text': {'fr': 5},
        }),
        contains('weapon/longsword.json.text'),
      );
    });
    test('nom vide', () {
      expect(
        _issuePaths({..._longsword(), 'name': ''}),
        contains('weapon/longsword.json.name'),
      );
    });
    test('texte obligatoire absent pour une aptitude', () {
      final json = {
        'id': 'srd:feature:fighter-second-wind',
        'type': 'feature',
        'name': 'Second souffle',
        'data': {'source': 'srd:class:fighter', 'level': 1},
      };
      expect(_issuePaths(json), contains('weapon/longsword.json.text'));
    });
    test('une entité qui n\'est pas un objet', () {
      expect(_issuePaths([1, 2]), ['weapon/longsword.json']);
    });
  });
}

/// Une entité minimale valide de chaque type de l'échantillon.
final _oneOfEachType = <Map<String, Object?>>[
  {
    'id': 'srd:ability:str',
    'type': 'ability',
    'name': 'Force',
    'data': {'abbreviation': 'FOR'},
  },
  {
    'id': 'srd:skill:athletics',
    'type': 'skill',
    'name': 'Athlétisme',
    'data': {'ability': 'srd:ability:str'},
  },
  {
    'id': 'srd:language:common',
    'type': 'language',
    'name': 'Commun',
    'data': {'category': 'standard'},
  },
  {
    'id': 'srd:condition:blinded',
    'type': 'condition',
    'name': 'Aveuglé',
    'text': {'fr': 'Texte.'},
  },
  {'id': 'srd:damage-type:fire', 'type': 'damage-type', 'name': 'Feu'},
  {
    'id': 'srd:mastery:sap',
    'type': 'mastery',
    'name': 'Sape',
    'text': {'fr': 'Texte.'},
  },
  _longsword(),
  {
    'id': 'srd:armor:chain-mail',
    'type': 'armor',
    'name': 'Cotte de mailles',
    'data': {
      'category': 'heavy',
      'base_ac': 16,
      'dex_cap': 0,
      'str_requirement': 13,
      'stealth_disadvantage': true,
      'weight_kg': 27.5,
      'cost_cp': 7500,
    },
  },
  {
    'id': 'srd:tool:dice-set',
    'type': 'tool',
    'name': 'Dés',
    'data': {
      'category': 'gaming_set',
      'ability': 'srd:ability:wis',
      'cost_cp': 10,
    },
  },
  {
    'id': 'srd:item:healers-kit',
    'type': 'item',
    'name': 'Trousse de soins',
    'data': {'weight_kg': 1.5, 'cost_cp': 500},
  },
  _soldier(),
  {
    'id': 'srd:species:human',
    'type': 'species',
    'name': 'Humain',
    'data': {
      'creature_type': 'humanoid',
      'sizes': ['M', 'P'],
      'speed_feet': 30,
      'traits': ['srd:feature:human-skillful'],
    },
  },
  {
    'id': 'srd:feat:grappler',
    'type': 'feat',
    'name': 'Empoigneur',
    'data': {
      'category': 'general',
      'prerequisites': {
        'min_level': 4,
        'ability_min_any': {'str': 13, 'dex': 13},
      },
      'repeatable': false,
    },
    'text': {'fr': 'Texte.'},
  },
  {
    'id': 'srd:class:fighter',
    'type': 'class',
    'name': 'Guerrier',
    'data': {
      'primary_abilities': ['srd:ability:str', 'srd:ability:dex'],
      'hit_die': 10,
      'saving_throws': ['srd:ability:str', 'srd:ability:con'],
      'skill_choice_count': 2,
      'skill_choices': ['srd:skill:athletics'],
      'weapon_proficiencies': ['simple', 'martial'],
      'armor_training': ['light', 'medium', 'heavy', 'shield'],
      'subclass_level': 3,
      'levels': [
        {
          'level': 1,
          'proficiency_bonus': 2,
          'features': ['srd:feature:fighter-second-wind'],
          'columns': {'second_wind': 2, 'weapon_mastery': 3},
        },
      ],
    },
  },
  {
    'id': 'srd:subclass:champion',
    'type': 'subclass',
    'name': 'Champion',
    'data': {
      'parent_class': 'srd:class:fighter',
      'features': ['srd:feature:champion-improved-critical'],
    },
  },
  {
    'id': 'srd:feature:fighter-second-wind',
    'type': 'feature',
    'name': 'Second souffle',
    'data': {'source': 'srd:class:fighter', 'level': 1},
    'text': {'fr': 'Texte.'},
  },
  {
    'id': 'srd:spell:acid-splash',
    'type': 'spell',
    'name': 'Aspersion acide',
    'data': {
      'level': 0,
      'school': 'evocation',
      'casting_time': 'action',
      'ritual': false,
      'range': {'kind': 'feet', 'feet': 60},
      'components': {'verbal': true, 'somatic': true},
      'material_consumed': false,
      'duration': 'instantanée',
      'concentration': false,
    },
    'text': {'fr': 'Texte.'},
  },
];
