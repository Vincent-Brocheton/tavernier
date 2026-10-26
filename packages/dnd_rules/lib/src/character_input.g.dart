// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character_input.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_BaseScores _$BaseScoresFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_BaseScores',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'method',
        'rolls',
        'str',
        'dex',
        'con',
        'int',
        'wis',
        'cha',
      ],
    );
    final val = _BaseScores(
      method: $checkedConvert(
        'method',
        (v) => $enumDecode(_$ScoreMethodEnumMap, v),
      ),
      rolls: $checkedConvert(
        'rolls',
        (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
      ),
      strength: $checkedConvert('str', (v) => (v as num).toInt()),
      dexterity: $checkedConvert('dex', (v) => (v as num).toInt()),
      constitution: $checkedConvert('con', (v) => (v as num).toInt()),
      intelligence: $checkedConvert('int', (v) => (v as num).toInt()),
      wisdom: $checkedConvert('wis', (v) => (v as num).toInt()),
      charisma: $checkedConvert('cha', (v) => (v as num).toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'strength': 'str',
    'dexterity': 'dex',
    'constitution': 'con',
    'intelligence': 'int',
    'wisdom': 'wis',
    'charisma': 'cha',
  },
);

Map<String, dynamic> _$BaseScoresToJson(_BaseScores instance) =>
    <String, dynamic>{
      'method': _$ScoreMethodEnumMap[instance.method]!,
      'rolls': ?instance.rolls,
      'str': instance.strength,
      'dex': instance.dexterity,
      'con': instance.constitution,
      'int': instance.intelligence,
      'wis': instance.wisdom,
      'cha': instance.charisma,
    };

const _$ScoreMethodEnumMap = {
  ScoreMethod.pointBuy: 'point_buy',
  ScoreMethod.standardArray: 'standard_array',
  ScoreMethod.random: 'random',
};

_BackgroundChoice _$BackgroundChoiceFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_BackgroundChoice', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const ['distribution', 'bonuses', 'tool_choice'],
      );
      final val = _BackgroundChoice(
        distribution: $checkedConvert('distribution', (v) => v as String),
        bonuses: $checkedConvert(
          'bonuses',
          (v) => Map<String, int>.from(v as Map),
        ),
        toolChoice: $checkedConvert('tool_choice', (v) => v as String?),
      );
      return val;
    }, fieldKeyMap: const {'toolChoice': 'tool_choice'});

Map<String, dynamic> _$BackgroundChoiceToJson(_BackgroundChoice instance) =>
    <String, dynamic>{
      'distribution': instance.distribution,
      'bonuses': instance.bonuses,
      'tool_choice': ?instance.toolChoice,
    };

_ClassLevelInput _$ClassLevelInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_ClassLevelInput',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'class_id',
            'level',
            'subclass_id',
            'hp_roll',
            'skill_choices',
            'expertise',
          ],
        );
        final val = _ClassLevelInput(
          classId: $checkedConvert('class_id', (v) => v as String),
          level: $checkedConvert('level', (v) => (v as num).toInt()),
          subclassId: $checkedConvert('subclass_id', (v) => v as String?),
          hpRoll: $checkedConvert(
            'hp_roll',
            (v) =>
                (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
          ),
          skillChoices: $checkedConvert(
            'skill_choices',
            (v) =>
                (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                const <String>[],
          ),
          expertise: $checkedConvert(
            'expertise',
            (v) =>
                (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                const <String>[],
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'classId': 'class_id',
        'subclassId': 'subclass_id',
        'hpRoll': 'hp_roll',
        'skillChoices': 'skill_choices',
      },
    );

Map<String, dynamic> _$ClassLevelInputToJson(_ClassLevelInput instance) =>
    <String, dynamic>{
      'class_id': instance.classId,
      'level': instance.level,
      'subclass_id': ?instance.subclassId,
      'hp_roll': ?instance.hpRoll,
      'skill_choices': instance.skillChoices,
      'expertise': instance.expertise,
    };

_FeatInput _$FeatInputFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_FeatInput',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const ['feat_id', 'source_type', 'source_ref', 'choices'],
    );
    final val = _FeatInput(
      featId: $checkedConvert('feat_id', (v) => v as String),
      sourceType: $checkedConvert('source_type', (v) => v as String),
      sourceRef: $checkedConvert('source_ref', (v) => v as String),
      choices: $checkedConvert('choices', (v) => v as Map<String, dynamic>?),
    );
    return val;
  },
  fieldKeyMap: const {
    'featId': 'feat_id',
    'sourceType': 'source_type',
    'sourceRef': 'source_ref',
  },
);

Map<String, dynamic> _$FeatInputToJson(_FeatInput instance) =>
    <String, dynamic>{
      'feat_id': instance.featId,
      'source_type': instance.sourceType,
      'source_ref': instance.sourceRef,
      'choices': ?instance.choices,
    };

_WeaponMasteryInput _$WeaponMasteryInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_WeaponMasteryInput', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['weapon_id', 'slot_index']);
      final val = _WeaponMasteryInput(
        weaponId: $checkedConvert('weapon_id', (v) => v as String),
        slotIndex: $checkedConvert('slot_index', (v) => (v as num).toInt()),
      );
      return val;
    }, fieldKeyMap: const {'weaponId': 'weapon_id', 'slotIndex': 'slot_index'});

Map<String, dynamic> _$WeaponMasteryInputToJson(_WeaponMasteryInput instance) =>
    <String, dynamic>{
      'weapon_id': instance.weaponId,
      'slot_index': instance.slotIndex,
    };

_ItemInput _$ItemInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ItemInput', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const ['item_id', 'quantity', 'equipped', 'attuned'],
      );
      final val = _ItemInput(
        itemId: $checkedConvert('item_id', (v) => v as String),
        quantity: $checkedConvert('quantity', (v) => (v as num).toInt()),
        equipped: $checkedConvert('equipped', (v) => v as bool? ?? false),
        attuned: $checkedConvert('attuned', (v) => v as bool? ?? false),
      );
      return val;
    }, fieldKeyMap: const {'itemId': 'item_id'});

Map<String, dynamic> _$ItemInputToJson(_ItemInput instance) =>
    <String, dynamic>{
      'item_id': instance.itemId,
      'quantity': instance.quantity,
      'equipped': instance.equipped,
      'attuned': instance.attuned,
    };

_CharacterInput _$CharacterInputFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_CharacterInput',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'name',
            'player',
            'kind',
            'species_id',
            'species_choices',
            'background_id',
            'base_scores',
            'background_choice',
            'class_levels',
            'feats',
            'choices',
            'languages',
            'weapon_masteries',
            'items',
            'xp',
          ],
        );
        final val = _CharacterInput(
          name: $checkedConvert('name', (v) => v as String),
          player: $checkedConvert('player', (v) => v as String?),
          kind: $checkedConvert('kind', (v) => v as String),
          speciesId: $checkedConvert('species_id', (v) => v as String),
          speciesChoices: $checkedConvert(
            'species_choices',
            (v) =>
                (v as Map<String, dynamic>?)?.map(
                  (k, e) => MapEntry(k, e as String),
                ) ??
                const <String, String>{},
          ),
          backgroundId: $checkedConvert('background_id', (v) => v as String),
          baseScores: $checkedConvert(
            'base_scores',
            (v) => BaseScores.fromJson(v as Map<String, dynamic>),
          ),
          backgroundChoice: $checkedConvert(
            'background_choice',
            (v) => BackgroundChoice.fromJson(v as Map<String, dynamic>),
          ),
          classLevels: $checkedConvert(
            'class_levels',
            (v) => (v as List<dynamic>)
                .map((e) => ClassLevelInput.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          feats: $checkedConvert(
            'feats',
            (v) =>
                (v as List<dynamic>?)
                    ?.map((e) => FeatInput.fromJson(e as Map<String, dynamic>))
                    .toList() ??
                const <FeatInput>[],
          ),
          choices: $checkedConvert(
            'choices',
            (v) =>
                (v as Map<String, dynamic>?)?.map(
                  (k, e) => MapEntry(
                    k,
                    (e as List<dynamic>).map((e) => e as String).toList(),
                  ),
                ) ??
                const <String, List<String>>{},
          ),
          languages: $checkedConvert(
            'languages',
            (v) =>
                (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                const <String>[],
          ),
          weaponMasteries: $checkedConvert(
            'weapon_masteries',
            (v) =>
                (v as List<dynamic>?)
                    ?.map(
                      (e) => WeaponMasteryInput.fromJson(
                        e as Map<String, dynamic>,
                      ),
                    )
                    .toList() ??
                const <WeaponMasteryInput>[],
          ),
          items: $checkedConvert(
            'items',
            (v) =>
                (v as List<dynamic>?)
                    ?.map((e) => ItemInput.fromJson(e as Map<String, dynamic>))
                    .toList() ??
                const <ItemInput>[],
          ),
          xp: $checkedConvert('xp', (v) => (v as num?)?.toInt() ?? 0),
        );
        return val;
      },
      fieldKeyMap: const {
        'speciesId': 'species_id',
        'speciesChoices': 'species_choices',
        'backgroundId': 'background_id',
        'baseScores': 'base_scores',
        'backgroundChoice': 'background_choice',
        'classLevels': 'class_levels',
        'weaponMasteries': 'weapon_masteries',
      },
    );

Map<String, dynamic> _$CharacterInputToJson(
  _CharacterInput instance,
) => <String, dynamic>{
  'name': instance.name,
  'player': ?instance.player,
  'kind': instance.kind,
  'species_id': instance.speciesId,
  'species_choices': instance.speciesChoices,
  'background_id': instance.backgroundId,
  'base_scores': instance.baseScores.toJson(),
  'background_choice': instance.backgroundChoice.toJson(),
  'class_levels': instance.classLevels.map((e) => e.toJson()).toList(),
  'feats': instance.feats.map((e) => e.toJson()).toList(),
  'choices': instance.choices,
  'languages': instance.languages,
  'weapon_masteries': instance.weaponMasteries.map((e) => e.toJson()).toList(),
  'items': instance.items.map((e) => e.toJson()).toList(),
  'xp': instance.xp,
};
