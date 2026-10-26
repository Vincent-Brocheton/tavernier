import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

/// Valide un effet isolé comme s'il était le premier de la liste.
List<ContentIssue> _check(Map<String, Object?> json) =>
    validateEffect(json, 'effects[0]');

void _expectIssueAt(Map<String, Object?> json, String path) {
  final issues = _check(json);
  expect(
    issues.map((i) => i.path),
    contains(path),
    reason: 'problèmes : $issues',
  );
}

void main() {
  test('la v1 compte exactement les 22 opérations de DSL_V1.md', () {
    expect(dslV1Ops, {
      'ability_bonus',
      'grant_proficiency',
      'grant_expertise',
      'grant_feat',
      'modify_ac',
      'ac_formula',
      'modify_speed',
      'modify_hp_max',
      'grant_sense',
      'grant_defense',
      'modify_initiative',
      'grant_advantage',
      'modify_check',
      'set_attacks_per_action',
      'set_crit_range',
      'grant_mastery_slots',
      'modify_damage',
      'grant_resource',
      'grant_spell',
      'grant_spell_list_access',
      'modify_attunement_slots',
      'choice',
    });
  });

  test('chaque code de caractéristique a son identifiant de contenu', () {
    expect(abilityIdByCode, {
      'str': 'srd:ability:strength',
      'dex': 'srd:ability:dexterity',
      'con': 'srd:ability:constitution',
      'int': 'srd:ability:intelligence',
      'wis': 'srd:ability:wisdom',
      'cha': 'srd:ability:charisma',
    });
  });

  group('effets valides', () {
    final valid = <String, Map<String, Object?>>{
      'Défense': {
        'op': 'modify_ac',
        'value': 1,
        'when': {'armor': 'any'},
      },
      'Vigilant': {
        'op': 'modify_initiative',
        'add': {'ref': 'proficiency_bonus'},
      },
      'Second souffle': {
        'op': 'grant_resource',
        'id': 'srd:resource:second-wind',
        'max': {
          'by_level': {'1': 2, '4': 3, '10': 4},
        },
        'recharge': [
          {'on': 'short_rest', 'amount': 1},
          {'on': 'long_rest', 'amount': 'all'},
        ],
      },
      'Imposition des mains': {
        'op': 'grant_resource',
        'id': 'srd:resource:lay-on-hands',
        'max': {'ref': 'class_level', 'class': 'srd:class:paladin', 'times': 5},
        'recharge': [
          {'on': 'long_rest', 'amount': 'all'},
        ],
      },
      'Archerie': {
        'op': 'modify_check',
        'scope': 'ranged_weapon_attack',
        'add': 2,
      },
      'Compétent': {
        'op': 'choice',
        'id': 'skillful',
        'count': 1,
        'options': [
          [
            {
              'op': 'grant_proficiency',
              'kind': 'skill',
              'ref': 'srd:skill:insight',
            },
          ],
        ],
      },
      'Défense sans armure': {
        'op': 'ac_formula',
        'base': 10,
        'abilities': ['dex', 'con'],
        'allows_shield': true,
        'when': {'armor': 'none'},
      },
      'Ascendance féerique': {
        'op': 'grant_advantage',
        'on': 'saving_throw_vs:charmed',
      },
      'Formation aux armures': {
        'op': 'grant_proficiency',
        'kind': 'armor',
        'ref': 'heavy',
      },
    };
    valid.forEach((name, json) {
      test(name, () => expect(_check(json), isEmpty));
    });
  });

  group('effets invalides', () {
    test('opération inconnue', () {
      _expectIssueAt({'op': 'cast_fireball'}, 'effects[0].op');
    });
    test('champ inconnu', () {
      _expectIssueAt({
        'op': 'modify_ac',
        'value': 1,
        'bonus': 2,
      }, 'effects[0].bonus');
    });
    test('champ requis absent', () {
      _expectIssueAt({'op': 'modify_ac'}, 'effects[0].value');
    });
    test('armure de when hors liste', () {
      _expectIssueAt({
        'op': 'modify_ac',
        'value': 1,
        'when': {'armor': 'plate'},
      }, 'effects[0].when.armor');
    });
    test('scope de modify_check hors liste', () {
      _expectIssueAt({
        'op': 'modify_check',
        'scope': 'saving',
        'add': 1,
      }, 'effects[0].scope');
    });
    test('déclencheur de recharge hors liste', () {
      _expectIssueAt({
        'op': 'grant_resource',
        'id': 'srd:resource:x',
        'max': 1,
        'recharge': [
          {'on': 'dusk', 'amount': 'all'},
        ],
      }, 'effects[0].recharge[0].on');
    });
    test('référence mal formée', () {
      _expectIssueAt({'op': 'grant_feat', 'feat': 'alert'}, 'effects[0].feat');
    });
    test('référence vers un autre type que celui attendu', () {
      _expectIssueAt({
        'op': 'grant_proficiency',
        'kind': 'skill',
        'ref': 'srd:weapon:longsword',
      }, 'effects[0].ref');
    });
    test('effet imbriqué invalide dans un choix', () {
      _expectIssueAt({
        'op': 'choice',
        'id': 'x',
        'count': 1,
        'options': [
          [
            {'op': 'nope'},
          ],
        ],
      }, 'effects[0].options[0][0].op');
    });
    test('valeur par niveau dont la clé n\'est pas un niveau', () {
      _expectIssueAt({
        'op': 'grant_mastery_slots',
        'count': {
          'by_level': {'un': 3},
        },
      }, 'effects[0].count.by_level.un');
    });
    test('un dé dans by_level hors du champ die', () {
      _expectIssueAt({
        'op': 'grant_resource',
        'id': 'srd:resource:x',
        'max': {
          'by_level': {'1': 'd6'},
        },
        'recharge': [
          {'on': 'long_rest', 'amount': 'all'},
        ],
      }, 'effects[0].max.by_level.1');
    });
    test('un dé dans by_level est accepté pour le champ die', () {
      expect(
        validateEffect({
          'op': 'grant_resource',
          'id': 'srd:resource:x',
          'max': 2,
          'die': {
            'by_level': {'1': 'd6', '5': 'd8'},
          },
          'recharge': [
            {'on': 'long_rest', 'amount': 'all'},
          ],
        }, 'effects[0]'),
        isEmpty,
      );
    });
    test('un effet qui n\'est pas un objet', () {
      _expectIssueAt({'op': 42}, 'effects[0].op');
      expect(validateEffect('modify_ac', 'effects[0]'), isNotEmpty);
    });
  });

  group('références', () {
    test('grant_proficiency cite sa compétence', () {
      final effect = Effect.fromJson({
        'op': 'grant_proficiency',
        'kind': 'skill',
        'ref': 'srd:skill:insight',
      });
      expect(effectReferences(effect), ['srd:skill:insight']);
    });
    test('grant_resource ne cite aucune entité', () {
      final effect = Effect.fromJson({
        'op': 'grant_resource',
        'id': 'srd:resource:second-wind',
        'max': 2,
        'recharge': [
          {'on': 'long_rest', 'amount': 'all'},
        ],
      });
      expect(effectReferences(effect), isEmpty);
    });
    test('les références d\'un choix et d\'une valeur sont collectées', () {
      final effect = Effect.fromJson({
        'op': 'choice',
        'id': 'x',
        'count': 1,
        'options': [
          [
            {'op': 'grant_feat', 'feat': 'srd:feat:alert'},
          ],
          [
            {
              'op': 'grant_mastery_slots',
              'count': {'ref': 'class_level', 'class': 'srd:class:fighter'},
            },
          ],
        ],
      });
      expect(effectReferences(effect), {'srd:feat:alert', 'srd:class:fighter'});
    });
  });
}
