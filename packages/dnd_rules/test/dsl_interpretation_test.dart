// Interprétation des conditions et valeurs du DSL v1 (docs/dsl/DSL_V1.md),
// sur un trait d'espèce de test ajouté à l'Humain d'Aldric.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

/// Contenu SRD où l'Humain a en plus un trait portant [effects].
ActiveContent _humanWith(List<Map<String, Object?>> effects) {
  final human = srdPack.entities.firstWhere(
    (e) => '${e.id}' == 'srd:species:human',
  );
  final json = human.toJson();
  ((json['data']! as Map<String, Object?>)['traits']! as List<Object?>).add(
    'test:feature:trait',
  );
  return srdContent([
    parseEntity(json, 'test').entity!,
    parseEntity({
      'id': 'test:feature:trait',
      'type': 'feature',
      'name': 'Trait de test',
      'data': {'source': 'srd:species:human'},
      'effects': effects,
      'text': {'fr': 'Texte.'},
    }, 'test').entity!,
  ]);
}

ComputedSheet _sheet(
  List<Map<String, Object?>> effects, [
  void Function(Map<String, Object?> json)? change,
]) => computeSheet(aldric(change), _humanWith(effects));

void _unequipArmor(Map<String, Object?> json) {
  for (final item
      in (json['items']! as List<Object?>).cast<Map<String, Object?>>()) {
    if ('${item['item_id']}'.startsWith('srd:armor:')) item['equipped'] = false;
  }
}

void main() {
  group('conditions when', () {
    Map<String, Object?> ac(Map<String, Object?> when) => {
      'op': 'modify_ac',
      'value': 1,
      'when': when,
    };

    test('armor: none ne s\'applique que sans armure', () {
      expect(
        _sheet([
          ac({'armor': 'none'}),
        ]).armorClass.value,
        19,
      );
      expect(
        _sheet([
          ac({'armor': 'none'}),
        ], _unequipArmor).armorClass.value,
        12,
      );
    });

    test('armor: heavy et not_heavy suivent la catégorie portée', () {
      expect(
        _sheet([
          ac({'armor': 'heavy'}),
        ]).armorClass.value,
        20,
      );
      expect(
        _sheet([
          ac({'armor': 'not_heavy'}),
        ]).armorClass.value,
        19,
      );
    });

    test('shield: false exige de ne pas tenir de bouclier', () {
      expect(
        _sheet([
          ac({'shield': false}),
        ]).armorClass.value,
        19,
      );
      expect(
        _sheet([
          ac({'shield': true}),
        ]).armorClass.value,
        20,
      );
    });
  });

  test('modify_speed walk ajoute un bonus en pieds', () {
    final sheet = _sheet([
      {
        'op': 'modify_speed',
        'mode': 'walk',
        'value': 10,
        'when': {'armor': 'not_heavy'},
      },
      {'op': 'modify_speed', 'mode': 'climb', 'equal_to': 'walk'},
    ], _unequipArmor);
    expect(sheet.speedFeet, 40);
  });

  test('ability_mod avec min et times', () {
    final sheet = _sheet([
      {
        'op': 'grant_resource',
        'id': 'test:resource:min',
        'max': {'ref': 'ability_mod', 'ability': 'int', 'min': 1},
        'recharge': [
          {'on': 'long_rest', 'amount': 'all'},
        ],
      },
      {
        'op': 'grant_resource',
        'id': 'test:resource:times',
        'max': {'ref': 'character_level', 'times': 5},
        'recharge': [
          {'on': 'long_rest', 'amount': 'all'},
        ],
      },
    ]);
    expect(sheet.resources['test:resource:min'], 1);
    expect(sheet.resources['test:resource:times'], 5);
  });

  test('grant_proficiency weapon_category rend une arme maîtrisée', () {
    final militia =
        srdPack.entities
            .firstWhere((e) => '${e.id}' == 'srd:class:fighter')
            .toJson()
          ..['id'] = 'test:class:militia';
    (militia['data']! as Map<String, Object?>)['weapon_proficiencies'] = [
      'simple',
    ];
    final content = ActiveContent([
      ..._humanWith([
        {
          'op': 'grant_proficiency',
          'kind': 'weapon_category',
          'ref': 'martial',
        },
      ]).packs,
      ContentPack(
        manifest: srdPack.manifest,
        entities: [parseEntity(militia, 'test').entity!],
      ),
    ]);
    final sheet = computeSheet(
      aldric((json) {
        ((json['class_levels']! as List<Object?>).first!
                as Map<String, Object?>)['class_id'] =
            'test:class:militia';
      }),
      content,
    );
    expect(
      sheet.integrityErrors.where((e) => e.rule == IntegrityRule.weaponMastery),
      isEmpty,
    );
  });

  test("la botte d'une arme inconnue est une erreur de référence", () {
    final sheet = computeSheet(
      aldric((json) {
        ((json['weapon_masteries']! as List<Object?>).first!
                as Map<String, Object?>)['weapon_id'] =
            'srd:weapon:boomerang';
      }),
      srdContent(),
    );
    expect(
      sheet.integrityErrors.map((e) => '$e'),
      contains(contains('weapon_masteries[0]')),
    );
  });

  test('un code de caractéristique inconnu est refusé', () {
    expect(() => aldric().baseScores.of('luck'), throwsArgumentError);
  });
}
