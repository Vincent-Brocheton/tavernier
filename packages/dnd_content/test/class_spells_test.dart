// Spec content-pack : « Liste de sorts d'une classe ».
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

Map<String, Object?> _wizard({Map<String, Object?> data = const {}}) => {
  'id': 'srd:class:wizard',
  'type': 'class',
  'name': 'Magicien',
  'data': {
    'primary_abilities': ['srd:ability:int'],
    'hit_die': 6,
    'saving_throws': ['srd:ability:int', 'srd:ability:wis'],
    'skill_choice_count': 2,
    'skill_choices': <String>[],
    'weapon_proficiencies': ['simple'],
    'armor_training': <String>[],
    'subclass_level': 3,
    'tool_proficiencies': <String>[],
    'tool_choice_count': 0,
    'spell_list': <String>[],
    'starting_equipment': <Object?>[],
    'levels': [
      {
        'level': 1,
        'proficiency_bonus': 2,
        'features': <String>[],
        'columns': {'cantrips': 3, 'prepared_spells': 4, 'slot_1': 2},
      },
    ],
    ...data,
  },
};

ContentEntity _spell(String slug) => entity({
  'id': 'srd:spell:$slug',
  'type': 'spell',
  'name': slug,
  'data': {
    'level': 3,
    'school': 'evocation',
    'casting_time': 'action',
    'ritual': false,
    'range': {'kind': 'self'},
    'components': {'verbal': true, 'somatic': false},
    'material_consumed': false,
    'duration': 'instantanée',
    'concentration': false,
  },
  'text': {'fr': 'Texte.'},
});

ContentPack _pack(List<ContentEntity> entities) => ContentPack(
  manifest: validPack().manifest,
  entities: [...validPack().entities, ...entities],
);

void main() {
  test('liste de sorts et caractéristique d’incantation lues et réécrites', () {
    final json = _wizard(
      data: {
        'spell_list': ['srd:spell:fireball'],
        'spellcasting_ability': 'srd:ability:int',
      },
    );
    final entity = parseEntity(json, 'class/wizard.json').entity!;
    final data = entity.data as ClassData;
    expect(data.spellList, [ContentId.tryParse('srd:spell:fireball')]);
    expect(data.spellcastingAbility, ContentId.tryParse('srd:ability:int'));
    expect(entity.toJson(), json);
  });

  test('maîtrises et choix d’outils (Druide, Barde)', () {
    final json = _wizard(
      data: {
        'tool_proficiencies': ['srd:tool:herbalism-kit'],
        'tool_choice_count': 3,
        'tool_choice_category': 'musical_instrument',
      },
    );
    final entity = parseEntity(json, 'class/x.json').entity!;
    final data = entity.data as ClassData;
    expect(data.toolProficiencies, [
      ContentId.tryParse('srd:tool:herbalism-kit'),
    ]);
    expect(
      (data.toolChoiceCount, data.toolChoiceCategory),
      (3, ToolCategory.musicalInstrument),
    );
    expect(entity.toJson(), json);
  });

  test('équipement de départ : objets, outil à choisir, or (Barde)', () {
    final json = _wizard(
      data: {
        'starting_equipment': [
          {
            'items': [
              {'item': 'srd:weapon:dagger', 'quantity': 2},
            ],
            'tool_choice': ['musical_instrument'],
            'gold': 19,
          },
          {'items': <Object?>[], 'tool_choice': <Object?>[], 'gold': 90},
        ],
      },
    );
    final entity = parseEntity(json, 'class/bard.json').entity!;
    final options = (entity.data as ClassData).startingEquipment;
    expect(options, hasLength(2));
    expect(options.first.items.single.quantity, 2);
    expect(options.first.toolChoice, [ToolCategory.musicalInstrument]);
    expect([for (final o in options) o.gold], [19, 90]);
    expect(entity.toJson(), json);
  });

  test('un objet d’équipement de départ qui n’est pas un objet est refusé', () {
    final wizard = entity(
      _wizard(
        data: {
          'starting_equipment': [
            {
              'items': [
                {'item': 'srd:ability:int', 'quantity': 1},
              ],
              'gold': 5,
            },
          ],
        },
      ),
    );
    final issues = validatePack(_pack([wizard, ability('int'), ability('wis')]))
        .map((i) => '$i');
    expect(issues, contains(contains('srd:ability:int')));
  });

  test('une classe sans sorts reste valide, liste vide', () {
    final entity = parseEntity(_wizard(), 'class/wizard.json').entity!;
    expect((entity.data as ClassData).spellList, isEmpty);
    expect((entity.data as ClassData).spellcastingAbility, isNull);
  });

  test('une liste qui cite autre chose qu’un sort est refusée', () {
    final wizard = entity(
      _wizard(
        data: {
          'spell_list': ['srd:spell:fireball', 'srd:ability:int'],
          'spellcasting_ability': 'srd:ability:int',
        },
      ),
    );
    final issues = validatePack(
      _pack([wizard, _spell('fireball'), ability('int'), ability('wis')]),
    ).map((i) => '$i');
    expect(issues, contains(contains('srd:ability:int')));
    expect(
      validatePack(
        _pack([
          entity(
            _wizard(
              data: {
                'spell_list': ['srd:spell:fireball'],
                'spellcasting_ability': 'srd:ability:int',
              },
            ),
          ),
          _spell('fireball'),
          ability('int'),
          ability('wis'),
        ]),
      ),
      isEmpty,
    );
  });
}
