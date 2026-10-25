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
    expect(entityTypes, hasLength(16));
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
