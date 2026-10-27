// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AbilityData _$AbilityDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_AbilityData', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['abbreviation']);
      final val = _AbilityData(
        abbreviation: $checkedConvert('abbreviation', (v) => v as String),
      );
      return val;
    });

Map<String, dynamic> _$AbilityDataToJson(_AbilityData instance) =>
    <String, dynamic>{'abbreviation': instance.abbreviation};

_SkillData _$SkillDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SkillData', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['ability']);
      final val = _SkillData(
        ability: $checkedConvert(
          'ability',
          (v) => const ContentIdConverter().fromJson(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$SkillDataToJson(_SkillData instance) =>
    <String, dynamic>{
      'ability': const ContentIdConverter().toJson(instance.ability),
    };

_LanguageData _$LanguageDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_LanguageData', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['category']);
      final val = _LanguageData(
        category: $checkedConvert(
          'category',
          (v) => $enumDecode(_$LanguageCategoryEnumMap, v),
        ),
      );
      return val;
    });

Map<String, dynamic> _$LanguageDataToJson(_LanguageData instance) =>
    <String, dynamic>{
      'category': _$LanguageCategoryEnumMap[instance.category]!,
    };

const _$LanguageCategoryEnumMap = {
  LanguageCategory.standard: 'standard',
  LanguageCategory.rare: 'rare',
};

_EmptyData _$EmptyDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_EmptyData', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const []);
      final val = _EmptyData();
      return val;
    });

Map<String, dynamic> _$EmptyDataToJson(_EmptyData instance) =>
    <String, dynamic>{};

_WeaponData _$WeaponDataFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_WeaponData',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'category',
        'kind',
        'damage',
        'damage_type',
        'properties',
        'versatile_damage',
        'range_feet',
        'mastery',
        'weight_kg',
        'cost_cp',
      ],
    );
    final val = _WeaponData(
      category: $checkedConvert(
        'category',
        (v) => $enumDecode(_$WeaponCategoryEnumMap, v),
      ),
      kind: $checkedConvert('kind', (v) => $enumDecode(_$WeaponKindEnumMap, v)),
      damage: $checkedConvert('damage', (v) => v as String),
      damageType: $checkedConvert(
        'damage_type',
        (v) => const ContentIdConverter().fromJson(v as String),
      ),
      properties: $checkedConvert(
        'properties',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ??
            const <String>[],
      ),
      versatileDamage: $checkedConvert('versatile_damage', (v) => v as String?),
      rangeFeet: $checkedConvert(
        'range_feet',
        (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
      ),
      mastery: $checkedConvert(
        'mastery',
        (v) => const ContentIdConverter().fromJson(v as String),
      ),
      weightKg: $checkedConvert('weight_kg', (v) => (v as num?)?.toDouble()),
      costCp: $checkedConvert('cost_cp', (v) => (v as num).toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'damageType': 'damage_type',
    'versatileDamage': 'versatile_damage',
    'rangeFeet': 'range_feet',
    'weightKg': 'weight_kg',
    'costCp': 'cost_cp',
  },
);

Map<String, dynamic> _$WeaponDataToJson(_WeaponData instance) =>
    <String, dynamic>{
      'category': _$WeaponCategoryEnumMap[instance.category]!,
      'kind': _$WeaponKindEnumMap[instance.kind]!,
      'damage': instance.damage,
      'damage_type': const ContentIdConverter().toJson(instance.damageType),
      'properties': instance.properties,
      'versatile_damage': ?instance.versatileDamage,
      'range_feet': ?instance.rangeFeet,
      'mastery': const ContentIdConverter().toJson(instance.mastery),
      'weight_kg': ?instance.weightKg,
      'cost_cp': instance.costCp,
    };

const _$WeaponCategoryEnumMap = {
  WeaponCategory.simple: 'simple',
  WeaponCategory.martial: 'martial',
};

const _$WeaponKindEnumMap = {
  WeaponKind.melee: 'melee',
  WeaponKind.ranged: 'ranged',
};

_ArmorData _$ArmorDataFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ArmorData',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'category',
        'base_ac',
        'dex_cap',
        'str_requirement',
        'stealth_disadvantage',
        'weight_kg',
        'cost_cp',
      ],
    );
    final val = _ArmorData(
      category: $checkedConvert(
        'category',
        (v) => $enumDecode(_$ArmorCategoryEnumMap, v),
      ),
      baseAc: $checkedConvert('base_ac', (v) => (v as num).toInt()),
      dexCap: $checkedConvert('dex_cap', (v) => (v as num?)?.toInt()),
      strRequirement: $checkedConvert(
        'str_requirement',
        (v) => (v as num?)?.toInt(),
      ),
      stealthDisadvantage: $checkedConvert(
        'stealth_disadvantage',
        (v) => v as bool? ?? false,
      ),
      weightKg: $checkedConvert('weight_kg', (v) => (v as num).toDouble()),
      costCp: $checkedConvert('cost_cp', (v) => (v as num).toInt()),
    );
    return val;
  },
  fieldKeyMap: const {
    'baseAc': 'base_ac',
    'dexCap': 'dex_cap',
    'strRequirement': 'str_requirement',
    'stealthDisadvantage': 'stealth_disadvantage',
    'weightKg': 'weight_kg',
    'costCp': 'cost_cp',
  },
);

Map<String, dynamic> _$ArmorDataToJson(_ArmorData instance) =>
    <String, dynamic>{
      'category': _$ArmorCategoryEnumMap[instance.category]!,
      'base_ac': instance.baseAc,
      'dex_cap': ?instance.dexCap,
      'str_requirement': ?instance.strRequirement,
      'stealth_disadvantage': instance.stealthDisadvantage,
      'weight_kg': instance.weightKg,
      'cost_cp': instance.costCp,
    };

const _$ArmorCategoryEnumMap = {
  ArmorCategory.light: 'light',
  ArmorCategory.medium: 'medium',
  ArmorCategory.heavy: 'heavy',
  ArmorCategory.shield: 'shield',
};

_ToolData _$ToolDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ToolData', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const ['category', 'ability', 'weight_kg', 'cost_cp'],
      );
      final val = _ToolData(
        category: $checkedConvert(
          'category',
          (v) => $enumDecode(_$ToolCategoryEnumMap, v),
        ),
        ability: $checkedConvert(
          'ability',
          (v) => _$JsonConverterFromJson<String, ContentId>(
            v,
            const ContentIdConverter().fromJson,
          ),
        ),
        weightKg: $checkedConvert('weight_kg', (v) => (v as num?)?.toDouble()),
        costCp: $checkedConvert('cost_cp', (v) => (v as num).toInt()),
      );
      return val;
    }, fieldKeyMap: const {'weightKg': 'weight_kg', 'costCp': 'cost_cp'});

Map<String, dynamic> _$ToolDataToJson(_ToolData instance) => <String, dynamic>{
  'category': _$ToolCategoryEnumMap[instance.category]!,
  'ability': ?_$JsonConverterToJson<String, ContentId>(
    instance.ability,
    const ContentIdConverter().toJson,
  ),
  'weight_kg': ?instance.weightKg,
  'cost_cp': instance.costCp,
};

const _$ToolCategoryEnumMap = {
  ToolCategory.artisan: 'artisan',
  ToolCategory.gamingSet: 'gaming_set',
  ToolCategory.musicalInstrument: 'musical_instrument',
  ToolCategory.other: 'other',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);

_ItemData _$ItemDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ItemData', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['weight_kg', 'cost_cp']);
      final val = _ItemData(
        weightKg: $checkedConvert('weight_kg', (v) => (v as num?)?.toDouble()),
        costCp: $checkedConvert('cost_cp', (v) => (v as num?)?.toInt()),
      );
      return val;
    }, fieldKeyMap: const {'weightKg': 'weight_kg', 'costCp': 'cost_cp'});

Map<String, dynamic> _$ItemDataToJson(_ItemData instance) => <String, dynamic>{
  'weight_kg': ?instance.weightKg,
  'cost_cp': ?instance.costCp,
};

_ItemQuantity _$ItemQuantityFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ItemQuantity', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['item', 'quantity']);
      final val = _ItemQuantity(
        item: $checkedConvert(
          'item',
          (v) => const ContentIdConverter().fromJson(v as String),
        ),
        quantity: $checkedConvert('quantity', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$ItemQuantityToJson(_ItemQuantity instance) =>
    <String, dynamic>{
      'item': const ContentIdConverter().toJson(instance.item),
      'quantity': instance.quantity,
    };

_StartingEquipmentOption _$StartingEquipmentOptionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_StartingEquipmentOption', json, ($checkedConvert) {
  $checkKeys(json, allowedKeys: const ['items', 'tool_choice', 'gold']);
  final val = _StartingEquipmentOption(
    items: $checkedConvert(
      'items',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => ItemQuantity.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <ItemQuantity>[],
    ),
    toolChoice: $checkedConvert(
      'tool_choice',
      (v) =>
          (v as List<dynamic>?)
              ?.map((e) => $enumDecode(_$ToolCategoryEnumMap, e))
              .toList() ??
          const <ToolCategory>[],
    ),
    gold: $checkedConvert('gold', (v) => (v as num).toInt()),
  );
  return val;
}, fieldKeyMap: const {'toolChoice': 'tool_choice'});

Map<String, dynamic> _$StartingEquipmentOptionToJson(
  _StartingEquipmentOption instance,
) => <String, dynamic>{
  'items': instance.items.map((e) => e.toJson()).toList(),
  'tool_choice': instance.toolChoice
      .map((e) => _$ToolCategoryEnumMap[e]!)
      .toList(),
  'gold': instance.gold,
};

_BackgroundData _$BackgroundDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_BackgroundData',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'abilities',
            'origin_feat',
            'origin_feat_choices',
            'skill_proficiencies',
            'tool_proficiency',
            'tool_choice_category',
            'equipment_a',
            'gold_a',
            'gold_b',
          ],
        );
        final val = _BackgroundData(
          abilities: $checkedConvert(
            'abilities',
            (v) => (v as List<dynamic>)
                .map((e) => const ContentIdConverter().fromJson(e as String))
                .toList(),
          ),
          originFeat: $checkedConvert(
            'origin_feat',
            (v) => const ContentIdConverter().fromJson(v as String),
          ),
          originFeatChoices: $checkedConvert(
            'origin_feat_choices',
            (v) => (v as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, e as String),
            ),
          ),
          skillProficiencies: $checkedConvert(
            'skill_proficiencies',
            (v) => (v as List<dynamic>)
                .map((e) => const ContentIdConverter().fromJson(e as String))
                .toList(),
          ),
          toolProficiency: $checkedConvert(
            'tool_proficiency',
            (v) => _$JsonConverterFromJson<String, ContentId>(
              v,
              const ContentIdConverter().fromJson,
            ),
          ),
          toolChoiceCategory: $checkedConvert(
            'tool_choice_category',
            (v) => $enumDecodeNullable(_$ToolCategoryEnumMap, v),
          ),
          equipmentA: $checkedConvert(
            'equipment_a',
            (v) => (v as List<dynamic>)
                .map((e) => ItemQuantity.fromJson(e as Map<String, dynamic>))
                .toList(),
          ),
          goldA: $checkedConvert('gold_a', (v) => (v as num).toInt()),
          goldB: $checkedConvert('gold_b', (v) => (v as num).toInt()),
        );
        return val;
      },
      fieldKeyMap: const {
        'originFeat': 'origin_feat',
        'originFeatChoices': 'origin_feat_choices',
        'skillProficiencies': 'skill_proficiencies',
        'toolProficiency': 'tool_proficiency',
        'toolChoiceCategory': 'tool_choice_category',
        'equipmentA': 'equipment_a',
        'goldA': 'gold_a',
        'goldB': 'gold_b',
      },
    );

Map<String, dynamic> _$BackgroundDataToJson(
  _BackgroundData instance,
) => <String, dynamic>{
  'abilities': instance.abilities
      .map(const ContentIdConverter().toJson)
      .toList(),
  'origin_feat': const ContentIdConverter().toJson(instance.originFeat),
  'origin_feat_choices': ?instance.originFeatChoices,
  'skill_proficiencies': instance.skillProficiencies
      .map(const ContentIdConverter().toJson)
      .toList(),
  'tool_proficiency': ?_$JsonConverterToJson<String, ContentId>(
    instance.toolProficiency,
    const ContentIdConverter().toJson,
  ),
  'tool_choice_category': ?_$ToolCategoryEnumMap[instance.toolChoiceCategory],
  'equipment_a': instance.equipmentA.map((e) => e.toJson()).toList(),
  'gold_a': instance.goldA,
  'gold_b': instance.goldB,
};

_SpeciesData _$SpeciesDataFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SpeciesData',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const ['creature_type', 'sizes', 'speed_feet', 'traits'],
    );
    final val = _SpeciesData(
      creatureType: $checkedConvert('creature_type', (v) => v as String),
      sizes: $checkedConvert(
        'sizes',
        (v) => (v as List<dynamic>).map((e) => e as String).toList(),
      ),
      speedFeet: $checkedConvert('speed_feet', (v) => (v as num).toInt()),
      traits: $checkedConvert(
        'traits',
        (v) => (v as List<dynamic>)
            .map((e) => const ContentIdConverter().fromJson(e as String))
            .toList(),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'creatureType': 'creature_type',
    'speedFeet': 'speed_feet',
  },
);

Map<String, dynamic> _$SpeciesDataToJson(_SpeciesData instance) =>
    <String, dynamic>{
      'creature_type': instance.creatureType,
      'sizes': instance.sizes,
      'speed_feet': instance.speedFeet,
      'traits': instance.traits.map(const ContentIdConverter().toJson).toList(),
    };

_FeatPrerequisites _$FeatPrerequisitesFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_FeatPrerequisites',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const ['min_level', 'ability_min_any', 'feature'],
        );
        final val = _FeatPrerequisites(
          minLevel: $checkedConvert('min_level', (v) => (v as num?)?.toInt()),
          abilityMinAny: $checkedConvert(
            'ability_min_any',
            (v) => (v as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, (e as num).toInt()),
            ),
          ),
          feature: $checkedConvert('feature', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {
        'minLevel': 'min_level',
        'abilityMinAny': 'ability_min_any',
      },
    );

Map<String, dynamic> _$FeatPrerequisitesToJson(_FeatPrerequisites instance) =>
    <String, dynamic>{
      'min_level': ?instance.minLevel,
      'ability_min_any': ?instance.abilityMinAny,
      'feature': ?instance.feature,
    };

_FeatData _$FeatDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FeatData', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const ['category', 'prerequisites', 'repeatable'],
      );
      final val = _FeatData(
        category: $checkedConvert(
          'category',
          (v) => $enumDecode(_$FeatCategoryEnumMap, v),
        ),
        prerequisites: $checkedConvert(
          'prerequisites',
          (v) => v == null
              ? null
              : FeatPrerequisites.fromJson(v as Map<String, dynamic>),
        ),
        repeatable: $checkedConvert('repeatable', (v) => v as bool? ?? false),
      );
      return val;
    });

Map<String, dynamic> _$FeatDataToJson(_FeatData instance) => <String, dynamic>{
  'category': _$FeatCategoryEnumMap[instance.category]!,
  'prerequisites': ?instance.prerequisites?.toJson(),
  'repeatable': instance.repeatable,
};

const _$FeatCategoryEnumMap = {
  FeatCategory.origin: 'origin',
  FeatCategory.general: 'general',
  FeatCategory.fightingStyle: 'fighting_style',
  FeatCategory.epicBoon: 'epic_boon',
};

_ClassLevelData _$ClassLevelDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_ClassLevelData', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const [
          'level',
          'proficiency_bonus',
          'features',
          'columns',
        ],
      );
      final val = _ClassLevelData(
        level: $checkedConvert('level', (v) => (v as num).toInt()),
        proficiencyBonus: $checkedConvert(
          'proficiency_bonus',
          (v) => (v as num).toInt(),
        ),
        features: $checkedConvert(
          'features',
          (v) =>
              (v as List<dynamic>?)
                  ?.map((e) => const ContentIdConverter().fromJson(e as String))
                  .toList() ??
              const <ContentId>[],
        ),
        columns: $checkedConvert(
          'columns',
          (v) =>
              (v as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const <String, int>{},
        ),
      );
      return val;
    }, fieldKeyMap: const {'proficiencyBonus': 'proficiency_bonus'});

Map<String, dynamic> _$ClassLevelDataToJson(
  _ClassLevelData instance,
) => <String, dynamic>{
  'level': instance.level,
  'proficiency_bonus': instance.proficiencyBonus,
  'features': instance.features.map(const ContentIdConverter().toJson).toList(),
  'columns': instance.columns,
};

_ClassData _$ClassDataFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ClassData',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'primary_abilities',
        'hit_die',
        'saving_throws',
        'skill_choice_count',
        'skill_choices',
        'weapon_proficiencies',
        'armor_training',
        'subclass_level',
        'levels',
        'spell_list',
        'spellcasting_ability',
        'tool_proficiencies',
        'tool_choice_count',
        'tool_choice_category',
        'starting_equipment',
      ],
    );
    final val = _ClassData(
      primaryAbilities: $checkedConvert(
        'primary_abilities',
        (v) => (v as List<dynamic>)
            .map((e) => const ContentIdConverter().fromJson(e as String))
            .toList(),
      ),
      hitDie: $checkedConvert('hit_die', (v) => (v as num).toInt()),
      savingThrows: $checkedConvert(
        'saving_throws',
        (v) => (v as List<dynamic>)
            .map((e) => const ContentIdConverter().fromJson(e as String))
            .toList(),
      ),
      skillChoiceCount: $checkedConvert(
        'skill_choice_count',
        (v) => (v as num).toInt(),
      ),
      skillChoices: $checkedConvert(
        'skill_choices',
        (v) => (v as List<dynamic>)
            .map((e) => const ContentIdConverter().fromJson(e as String))
            .toList(),
      ),
      weaponProficiencies: $checkedConvert(
        'weapon_proficiencies',
        (v) => (v as List<dynamic>).map((e) => e as String).toList(),
      ),
      armorTraining: $checkedConvert(
        'armor_training',
        (v) => (v as List<dynamic>).map((e) => e as String).toList(),
      ),
      subclassLevel: $checkedConvert(
        'subclass_level',
        (v) => (v as num).toInt(),
      ),
      levels: $checkedConvert(
        'levels',
        (v) => (v as List<dynamic>)
            .map((e) => ClassLevelData.fromJson(e as Map<String, dynamic>))
            .toList(),
      ),
      spellList: $checkedConvert(
        'spell_list',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => const ContentIdConverter().fromJson(e as String))
                .toList() ??
            const <ContentId>[],
      ),
      spellcastingAbility: $checkedConvert(
        'spellcasting_ability',
        (v) => _$JsonConverterFromJson<String, ContentId>(
          v,
          const ContentIdConverter().fromJson,
        ),
      ),
      toolProficiencies: $checkedConvert(
        'tool_proficiencies',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => const ContentIdConverter().fromJson(e as String))
                .toList() ??
            const <ContentId>[],
      ),
      toolChoiceCount: $checkedConvert(
        'tool_choice_count',
        (v) => (v as num?)?.toInt() ?? 0,
      ),
      toolChoiceCategory: $checkedConvert(
        'tool_choice_category',
        (v) => $enumDecodeNullable(_$ToolCategoryEnumMap, v),
      ),
      startingEquipment: $checkedConvert(
        'starting_equipment',
        (v) =>
            (v as List<dynamic>?)
                ?.map(
                  (e) => StartingEquipmentOption.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList() ??
            const <StartingEquipmentOption>[],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'primaryAbilities': 'primary_abilities',
    'hitDie': 'hit_die',
    'savingThrows': 'saving_throws',
    'skillChoiceCount': 'skill_choice_count',
    'skillChoices': 'skill_choices',
    'weaponProficiencies': 'weapon_proficiencies',
    'armorTraining': 'armor_training',
    'subclassLevel': 'subclass_level',
    'spellList': 'spell_list',
    'spellcastingAbility': 'spellcasting_ability',
    'toolProficiencies': 'tool_proficiencies',
    'toolChoiceCount': 'tool_choice_count',
    'toolChoiceCategory': 'tool_choice_category',
    'startingEquipment': 'starting_equipment',
  },
);

Map<String, dynamic> _$ClassDataToJson(
  _ClassData instance,
) => <String, dynamic>{
  'primary_abilities': instance.primaryAbilities
      .map(const ContentIdConverter().toJson)
      .toList(),
  'hit_die': instance.hitDie,
  'saving_throws': instance.savingThrows
      .map(const ContentIdConverter().toJson)
      .toList(),
  'skill_choice_count': instance.skillChoiceCount,
  'skill_choices': instance.skillChoices
      .map(const ContentIdConverter().toJson)
      .toList(),
  'weapon_proficiencies': instance.weaponProficiencies,
  'armor_training': instance.armorTraining,
  'subclass_level': instance.subclassLevel,
  'levels': instance.levels.map((e) => e.toJson()).toList(),
  'spell_list': instance.spellList
      .map(const ContentIdConverter().toJson)
      .toList(),
  'spellcasting_ability': ?_$JsonConverterToJson<String, ContentId>(
    instance.spellcastingAbility,
    const ContentIdConverter().toJson,
  ),
  'tool_proficiencies': instance.toolProficiencies
      .map(const ContentIdConverter().toJson)
      .toList(),
  'tool_choice_count': instance.toolChoiceCount,
  'tool_choice_category': ?_$ToolCategoryEnumMap[instance.toolChoiceCategory],
  'starting_equipment': instance.startingEquipment
      .map((e) => e.toJson())
      .toList(),
};

_SubclassData _$SubclassDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SubclassData', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['parent_class', 'features']);
      final val = _SubclassData(
        parentClass: $checkedConvert(
          'parent_class',
          (v) => const ContentIdConverter().fromJson(v as String),
        ),
        features: $checkedConvert(
          'features',
          (v) => (v as List<dynamic>)
              .map((e) => const ContentIdConverter().fromJson(e as String))
              .toList(),
        ),
      );
      return val;
    }, fieldKeyMap: const {'parentClass': 'parent_class'});

Map<String, dynamic> _$SubclassDataToJson(
  _SubclassData instance,
) => <String, dynamic>{
  'parent_class': const ContentIdConverter().toJson(instance.parentClass),
  'features': instance.features.map(const ContentIdConverter().toJson).toList(),
};

_FeatureData _$FeatureDataFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_FeatureData', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['source', 'level']);
      final val = _FeatureData(
        source: $checkedConvert(
          'source',
          (v) => const ContentIdConverter().fromJson(v as String),
        ),
        level: $checkedConvert('level', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$FeatureDataToJson(_FeatureData instance) =>
    <String, dynamic>{
      'source': const ContentIdConverter().toJson(instance.source),
      'level': ?instance.level,
    };

_SpellRange _$SpellRangeFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SpellRange',
  json,
  ($checkedConvert) {
    $checkKeys(json, allowedKeys: const ['kind', 'feet']);
    final val = _SpellRange(
      kind: $checkedConvert('kind', (v) => $enumDecode(_$RangeKindEnumMap, v)),
      feet: $checkedConvert('feet', (v) => (v as num?)?.toInt()),
    );
    return val;
  },
);

Map<String, dynamic> _$SpellRangeToJson(_SpellRange instance) =>
    <String, dynamic>{
      'kind': _$RangeKindEnumMap[instance.kind]!,
      'feet': ?instance.feet,
    };

const _$RangeKindEnumMap = {
  RangeKind.self: 'self',
  RangeKind.touch: 'touch',
  RangeKind.feet: 'feet',
  RangeKind.sight: 'sight',
  RangeKind.unlimited: 'unlimited',
  RangeKind.special: 'special',
};

_SpellComponents _$SpellComponentsFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_SpellComponents', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['verbal', 'somatic', 'material']);
      final val = _SpellComponents(
        verbal: $checkedConvert('verbal', (v) => v as bool),
        somatic: $checkedConvert('somatic', (v) => v as bool),
        material: $checkedConvert('material', (v) => v as String?),
      );
      return val;
    });

Map<String, dynamic> _$SpellComponentsToJson(_SpellComponents instance) =>
    <String, dynamic>{
      'verbal': instance.verbal,
      'somatic': instance.somatic,
      'material': ?instance.material,
    };

_SpellData _$SpellDataFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_SpellData',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'level',
        'school',
        'casting_time',
        'ritual',
        'range',
        'components',
        'material_cost_cp',
        'material_consumed',
        'duration',
        'concentration',
      ],
    );
    final val = _SpellData(
      level: $checkedConvert('level', (v) => _spellLevel(v)),
      school: $checkedConvert(
        'school',
        (v) => $enumDecode(_$SpellSchoolEnumMap, v),
      ),
      castingTime: $checkedConvert('casting_time', (v) => v as String),
      ritual: $checkedConvert('ritual', (v) => v as bool),
      range: $checkedConvert(
        'range',
        (v) => _spellRange(v as Map<String, dynamic>),
      ),
      components: $checkedConvert(
        'components',
        (v) => SpellComponents.fromJson(v as Map<String, dynamic>),
      ),
      materialCostCp: $checkedConvert(
        'material_cost_cp',
        (v) => (v as num?)?.toInt(),
      ),
      materialConsumed: $checkedConvert('material_consumed', (v) => v as bool),
      duration: $checkedConvert('duration', (v) => v as String),
      concentration: $checkedConvert('concentration', (v) => v as bool),
    );
    return val;
  },
  fieldKeyMap: const {
    'castingTime': 'casting_time',
    'materialCostCp': 'material_cost_cp',
    'materialConsumed': 'material_consumed',
  },
);

Map<String, dynamic> _$SpellDataToJson(_SpellData instance) =>
    <String, dynamic>{
      'level': instance.level,
      'school': _$SpellSchoolEnumMap[instance.school]!,
      'casting_time': instance.castingTime,
      'ritual': instance.ritual,
      'range': instance.range.toJson(),
      'components': instance.components.toJson(),
      'material_cost_cp': ?instance.materialCostCp,
      'material_consumed': instance.materialConsumed,
      'duration': instance.duration,
      'concentration': instance.concentration,
    };

const _$SpellSchoolEnumMap = {
  SpellSchool.abjuration: 'abjuration',
  SpellSchool.conjuration: 'conjuration',
  SpellSchool.divination: 'divination',
  SpellSchool.enchantment: 'enchantment',
  SpellSchool.evocation: 'evocation',
  SpellSchool.illusion: 'illusion',
  SpellSchool.necromancy: 'necromancy',
  SpellSchool.transmutation: 'transmutation',
};
