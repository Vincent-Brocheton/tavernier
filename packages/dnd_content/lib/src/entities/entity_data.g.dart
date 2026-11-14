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

_MagicItemData _$MagicItemDataFromJson(
  Map<String, dynamic> json,
) => $checkedCreate(
  '_MagicItemData',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'category',
        'rarity',
        'type_line',
        'attunement',
        'attunement_by',
      ],
    );
    final val = _MagicItemData(
      category: $checkedConvert(
        'category',
        (v) => $enumDecode(_$MagicItemCategoryEnumMap, v),
      ),
      rarity: $checkedConvert('rarity', (v) => $enumDecode(_$RarityEnumMap, v)),
      typeLine: $checkedConvert('type_line', (v) => v as String),
      attunement: $checkedConvert('attunement', (v) => v as bool? ?? false),
      attunementBy: $checkedConvert('attunement_by', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {'typeLine': 'type_line', 'attunementBy': 'attunement_by'},
);

Map<String, dynamic> _$MagicItemDataToJson(_MagicItemData instance) =>
    <String, dynamic>{
      'category': _$MagicItemCategoryEnumMap[instance.category]!,
      'rarity': _$RarityEnumMap[instance.rarity]!,
      'type_line': instance.typeLine,
      'attunement': instance.attunement,
      'attunement_by': ?instance.attunementBy,
    };

const _$MagicItemCategoryEnumMap = {
  MagicItemCategory.wondrous: 'wondrous',
  MagicItemCategory.armor: 'armor',
  MagicItemCategory.weapon: 'weapon',
  MagicItemCategory.ring: 'ring',
  MagicItemCategory.wand: 'wand',
  MagicItemCategory.staff: 'staff',
  MagicItemCategory.potion: 'potion',
  MagicItemCategory.scroll: 'scroll',
  MagicItemCategory.rod: 'rod',
};

const _$RarityEnumMap = {
  Rarity.common: 'common',
  Rarity.uncommon: 'uncommon',
  Rarity.rare: 'rare',
  Rarity.veryRare: 'very_rare',
  Rarity.legendary: 'legendary',
  Rarity.artifact: 'artifact',
  Rarity.varies: 'varies',
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

_MulticlassTraits _$MulticlassTraitsFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      '_MulticlassTraits',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          allowedKeys: const [
            'weapon_proficiencies',
            'armor_training',
            'tool_proficiencies',
            'skill_choice_count',
            'tool_choice_count',
            'caster_divisor',
          ],
        );
        final val = _MulticlassTraits(
          weaponProficiencies: $checkedConvert(
            'weapon_proficiencies',
            (v) =>
                (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                const <String>[],
          ),
          armorTraining: $checkedConvert(
            'armor_training',
            (v) =>
                (v as List<dynamic>?)?.map((e) => e as String).toList() ??
                const <String>[],
          ),
          toolProficiencies: $checkedConvert(
            'tool_proficiencies',
            (v) =>
                (v as List<dynamic>?)
                    ?.map(
                      (e) => const ContentIdConverter().fromJson(e as String),
                    )
                    .toList() ??
                const <ContentId>[],
          ),
          skillChoiceCount: $checkedConvert(
            'skill_choice_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          toolChoiceCount: $checkedConvert(
            'tool_choice_count',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
          casterDivisor: $checkedConvert(
            'caster_divisor',
            (v) => (v as num?)?.toInt() ?? 0,
          ),
        );
        return val;
      },
      fieldKeyMap: const {
        'weaponProficiencies': 'weapon_proficiencies',
        'armorTraining': 'armor_training',
        'toolProficiencies': 'tool_proficiencies',
        'skillChoiceCount': 'skill_choice_count',
        'toolChoiceCount': 'tool_choice_count',
        'casterDivisor': 'caster_divisor',
      },
    );

Map<String, dynamic> _$MulticlassTraitsToJson(_MulticlassTraits instance) =>
    <String, dynamic>{
      'weapon_proficiencies': instance.weaponProficiencies,
      'armor_training': instance.armorTraining,
      'tool_proficiencies': instance.toolProficiencies
          .map(const ContentIdConverter().toJson)
          .toList(),
      'skill_choice_count': instance.skillChoiceCount,
      'tool_choice_count': instance.toolChoiceCount,
      'caster_divisor': instance.casterDivisor,
    };

_ClassData _$ClassDataFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_ClassData',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'primary_abilities',
        'primary_abilities_any',
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
        'prepared_change',
        'multiclass',
      ],
    );
    final val = _ClassData(
      primaryAbilities: $checkedConvert(
        'primary_abilities',
        (v) => (v as List<dynamic>)
            .map((e) => const ContentIdConverter().fromJson(e as String))
            .toList(),
      ),
      primaryAbilitiesAny: $checkedConvert(
        'primary_abilities_any',
        (v) => v as bool? ?? false,
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
      preparedChange: $checkedConvert(
        'prepared_change',
        (v) => $enumDecodeNullable(_$PreparedChangeEnumMap, v),
      ),
      multiclass: $checkedConvert(
        'multiclass',
        (v) => v == null
            ? const MulticlassTraits()
            : MulticlassTraits.fromJson(v as Map<String, dynamic>),
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'primaryAbilities': 'primary_abilities',
    'primaryAbilitiesAny': 'primary_abilities_any',
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
    'preparedChange': 'prepared_change',
  },
);

Map<String, dynamic> _$ClassDataToJson(
  _ClassData instance,
) => <String, dynamic>{
  'primary_abilities': instance.primaryAbilities
      .map(const ContentIdConverter().toJson)
      .toList(),
  'primary_abilities_any': instance.primaryAbilitiesAny,
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
  'prepared_change': ?_$PreparedChangeEnumMap[instance.preparedChange],
  'multiclass': instance.multiclass.toJson(),
};

const _$PreparedChangeEnumMap = {
  PreparedChange.longRestAll: 'long_rest_all',
  PreparedChange.longRestOne: 'long_rest_one',
  PreparedChange.levelUpOne: 'level_up_one',
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

_MonsterSpeed _$MonsterSpeedFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonsterSpeed', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const ['walk', 'swim', 'fly', 'climb', 'burrow'],
      );
      final val = _MonsterSpeed(
        walk: $checkedConvert('walk', (v) => (v as num?)?.toInt()),
        swim: $checkedConvert('swim', (v) => (v as num?)?.toInt()),
        fly: $checkedConvert('fly', (v) => (v as num?)?.toInt()),
        climb: $checkedConvert('climb', (v) => (v as num?)?.toInt()),
        burrow: $checkedConvert('burrow', (v) => (v as num?)?.toInt()),
      );
      return val;
    });

Map<String, dynamic> _$MonsterSpeedToJson(_MonsterSpeed instance) =>
    <String, dynamic>{
      'walk': ?instance.walk,
      'swim': ?instance.swim,
      'fly': ?instance.fly,
      'climb': ?instance.climb,
      'burrow': ?instance.burrow,
    };

_MonsterSenses _$MonsterSensesFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonsterSenses', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const [
          'darkvision',
          'blindsight',
          'blind_beyond',
          'tremorsense',
          'truesight',
        ],
      );
      final val = _MonsterSenses(
        darkvision: $checkedConvert('darkvision', (v) => (v as num?)?.toInt()),
        blindsight: $checkedConvert('blindsight', (v) => (v as num?)?.toInt()),
        blindBeyond: $checkedConvert('blind_beyond', (v) => v as bool?),
        tremorsense: $checkedConvert(
          'tremorsense',
          (v) => (v as num?)?.toInt(),
        ),
        truesight: $checkedConvert('truesight', (v) => (v as num?)?.toInt()),
      );
      return val;
    }, fieldKeyMap: const {'blindBeyond': 'blind_beyond'});

Map<String, dynamic> _$MonsterSensesToJson(_MonsterSenses instance) =>
    <String, dynamic>{
      'darkvision': ?instance.darkvision,
      'blindsight': ?instance.blindsight,
      'blind_beyond': ?instance.blindBeyond,
      'tremorsense': ?instance.tremorsense,
      'truesight': ?instance.truesight,
    };

_MonsterUses _$MonsterUsesFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_MonsterUses',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const ['per_day', 'per_day_lair', 'recharge', 'rest'],
    );
    final val = _MonsterUses(
      perDay: $checkedConvert('per_day', (v) => (v as num?)?.toInt()),
      perDayLair: $checkedConvert('per_day_lair', (v) => (v as num?)?.toInt()),
      recharge: $checkedConvert('recharge', (v) => v as String?),
      rest: $checkedConvert('rest', (v) => v as String?),
    );
    return val;
  },
  fieldKeyMap: const {'perDay': 'per_day', 'perDayLair': 'per_day_lair'},
);

Map<String, dynamic> _$MonsterUsesToJson(_MonsterUses instance) =>
    <String, dynamic>{
      'per_day': ?instance.perDay,
      'per_day_lair': ?instance.perDayLair,
      'recharge': ?instance.recharge,
      'rest': ?instance.rest,
    };

_MonsterDamage _$MonsterDamageFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonsterDamage', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['average', 'dice', 'type']);
      final val = _MonsterDamage(
        average: $checkedConvert('average', (v) => (v as num).toInt()),
        dice: $checkedConvert('dice', (v) => v as String?),
        type: $checkedConvert(
          'type',
          (v) => const ContentIdConverter().fromJson(v as String),
        ),
      );
      return val;
    });

Map<String, dynamic> _$MonsterDamageToJson(_MonsterDamage instance) =>
    <String, dynamic>{
      'average': instance.average,
      'dice': ?instance.dice,
      'type': const ContentIdConverter().toJson(instance.type),
    };

_MonsterAttack _$MonsterAttackFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonsterAttack', json, ($checkedConvert) {
      $checkKeys(
        json,
        allowedKeys: const ['kind', 'bonus', 'reach', 'range', 'damage'],
      );
      final val = _MonsterAttack(
        kind: $checkedConvert(
          'kind',
          (v) => $enumDecode(_$MonsterAttackKindEnumMap, v),
        ),
        bonus: $checkedConvert('bonus', (v) => (v as num).toInt()),
        reach: $checkedConvert('reach', (v) => (v as num?)?.toInt()),
        range: $checkedConvert(
          'range',
          (v) => (v as List<dynamic>?)?.map((e) => (e as num).toInt()).toList(),
        ),
        damage: $checkedConvert(
          'damage',
          (v) =>
              (v as List<dynamic>?)
                  ?.map(
                    (e) => MonsterDamage.fromJson(e as Map<String, dynamic>),
                  )
                  .toList() ??
              const <MonsterDamage>[],
        ),
      );
      return val;
    });

Map<String, dynamic> _$MonsterAttackToJson(_MonsterAttack instance) =>
    <String, dynamic>{
      'kind': _$MonsterAttackKindEnumMap[instance.kind]!,
      'bonus': instance.bonus,
      'reach': ?instance.reach,
      'range': ?instance.range,
      'damage': instance.damage.map((e) => e.toJson()).toList(),
    };

const _$MonsterAttackKindEnumMap = {
  MonsterAttackKind.melee: 'melee',
  MonsterAttackKind.ranged: 'ranged',
  MonsterAttackKind.meleeOrRanged: 'melee_or_ranged',
};

_MonsterSave _$MonsterSaveFromJson(Map<String, dynamic> json) =>
    $checkedCreate('_MonsterSave', json, ($checkedConvert) {
      $checkKeys(json, allowedKeys: const ['ability', 'dc']);
      final val = _MonsterSave(
        ability: $checkedConvert('ability', (v) => v as String),
        dc: $checkedConvert('dc', (v) => (v as num).toInt()),
      );
      return val;
    });

Map<String, dynamic> _$MonsterSaveToJson(_MonsterSave instance) =>
    <String, dynamic>{'ability': instance.ability, 'dc': instance.dc};

_MonsterAction _$MonsterActionFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_MonsterAction', json, ($checkedConvert) {
  $checkKeys(
    json,
    allowedKeys: const ['kind', 'name', 'uses', 'attack', 'save', 'text'],
  );
  final val = _MonsterAction(
    kind: $checkedConvert(
      'kind',
      (v) => $enumDecode(_$MonsterActionKindEnumMap, v),
    ),
    name: $checkedConvert('name', (v) => v as String),
    uses: $checkedConvert(
      'uses',
      (v) => v == null ? null : MonsterUses.fromJson(v as Map<String, dynamic>),
    ),
    attack: $checkedConvert(
      'attack',
      (v) =>
          v == null ? null : MonsterAttack.fromJson(v as Map<String, dynamic>),
    ),
    save: $checkedConvert(
      'save',
      (v) => v == null ? null : MonsterSave.fromJson(v as Map<String, dynamic>),
    ),
    text: $checkedConvert('text', (v) => v as String),
  );
  return val;
});

Map<String, dynamic> _$MonsterActionToJson(_MonsterAction instance) =>
    <String, dynamic>{
      'kind': _$MonsterActionKindEnumMap[instance.kind]!,
      'name': instance.name,
      'uses': ?instance.uses?.toJson(),
      'attack': ?instance.attack?.toJson(),
      'save': ?instance.save?.toJson(),
      'text': instance.text,
    };

const _$MonsterActionKindEnumMap = {
  MonsterActionKind.trait: 'trait',
  MonsterActionKind.action: 'action',
  MonsterActionKind.bonus: 'bonus',
  MonsterActionKind.reaction: 'reaction',
  MonsterActionKind.legendary: 'legendary',
};

_MonsterData _$MonsterDataFromJson(Map<String, dynamic> json) => $checkedCreate(
  '_MonsterData',
  json,
  ($checkedConvert) {
    $checkKeys(
      json,
      allowedKeys: const [
        'sizes',
        'creature_type',
        'swarm_size',
        'type_tags',
        'alignment',
        'ac',
        'ac_note',
        'initiative',
        'hp',
        'hit_dice',
        'speed',
        'speed_note',
        'hover',
        'abilities',
        'saving_throws',
        'skills',
        'vulnerabilities',
        'resistances',
        'immunities',
        'condition_immunities',
        'gear',
        'senses',
        'senses_note',
        'passive_perception',
        'languages',
        'cr',
        'xp',
        'xp_lair',
        'proficiency_bonus',
        'legendary_uses',
        'legendary_uses_lair',
        'actions',
      ],
    );
    final val = _MonsterData(
      sizes: $checkedConvert(
        'sizes',
        (v) => (v as List<dynamic>)
            .map((e) => $enumDecode(_$MonsterSizeEnumMap, e))
            .toList(),
      ),
      creatureType: $checkedConvert(
        'creature_type',
        (v) => $enumDecode(_$CreatureTypeEnumMap, v),
      ),
      swarmSize: $checkedConvert(
        'swarm_size',
        (v) => $enumDecodeNullable(_$MonsterSizeEnumMap, v),
      ),
      typeTags: $checkedConvert(
        'type_tags',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ??
            const <String>[],
      ),
      alignment: $checkedConvert('alignment', (v) => v as String),
      ac: $checkedConvert('ac', (v) => (v as num).toInt()),
      acNote: $checkedConvert('ac_note', (v) => v as String?),
      initiative: $checkedConvert('initiative', (v) => (v as num).toInt()),
      hp: $checkedConvert('hp', (v) => (v as num).toInt()),
      hitDice: $checkedConvert('hit_dice', (v) => v as String),
      speed: $checkedConvert(
        'speed',
        (v) => MonsterSpeed.fromJson(v as Map<String, dynamic>),
      ),
      speedNote: $checkedConvert('speed_note', (v) => v as String?),
      hover: $checkedConvert('hover', (v) => v as bool? ?? false),
      abilities: $checkedConvert('abilities', (v) => _sixAbilities(v)),
      savingThrows: $checkedConvert('saving_throws', (v) => _sixAbilities(v)),
      skills: $checkedConvert(
        'skills',
        (v) =>
            (v as Map<String, dynamic>?)?.map(
              (k, e) => MapEntry(k, (e as num).toInt()),
            ) ??
            const <String, int>{},
      ),
      vulnerabilities: $checkedConvert(
        'vulnerabilities',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => const ContentIdConverter().fromJson(e as String))
                .toList() ??
            const <ContentId>[],
      ),
      resistances: $checkedConvert(
        'resistances',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => const ContentIdConverter().fromJson(e as String))
                .toList() ??
            const <ContentId>[],
      ),
      immunities: $checkedConvert(
        'immunities',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => const ContentIdConverter().fromJson(e as String))
                .toList() ??
            const <ContentId>[],
      ),
      conditionImmunities: $checkedConvert(
        'condition_immunities',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => const ContentIdConverter().fromJson(e as String))
                .toList() ??
            const <ContentId>[],
      ),
      gear: $checkedConvert(
        'gear',
        (v) =>
            (v as List<dynamic>?)?.map((e) => e as String).toList() ??
            const <String>[],
      ),
      senses: $checkedConvert(
        'senses',
        (v) => v == null
            ? const MonsterSenses()
            : MonsterSenses.fromJson(v as Map<String, dynamic>),
      ),
      sensesNote: $checkedConvert('senses_note', (v) => v as String?),
      passivePerception: $checkedConvert(
        'passive_perception',
        (v) => (v as num).toInt(),
      ),
      languages: $checkedConvert('languages', (v) => v as String),
      cr: $checkedConvert('cr', (v) => v as String),
      xp: $checkedConvert('xp', (v) => (v as num).toInt()),
      xpLair: $checkedConvert('xp_lair', (v) => (v as num?)?.toInt()),
      proficiencyBonus: $checkedConvert(
        'proficiency_bonus',
        (v) => (v as num).toInt(),
      ),
      legendaryUses: $checkedConvert(
        'legendary_uses',
        (v) => (v as num?)?.toInt(),
      ),
      legendaryUsesLair: $checkedConvert(
        'legendary_uses_lair',
        (v) => (v as num?)?.toInt(),
      ),
      actions: $checkedConvert(
        'actions',
        (v) =>
            (v as List<dynamic>?)
                ?.map((e) => MonsterAction.fromJson(e as Map<String, dynamic>))
                .toList() ??
            const <MonsterAction>[],
      ),
    );
    return val;
  },
  fieldKeyMap: const {
    'creatureType': 'creature_type',
    'swarmSize': 'swarm_size',
    'typeTags': 'type_tags',
    'acNote': 'ac_note',
    'hitDice': 'hit_dice',
    'speedNote': 'speed_note',
    'savingThrows': 'saving_throws',
    'conditionImmunities': 'condition_immunities',
    'sensesNote': 'senses_note',
    'passivePerception': 'passive_perception',
    'xpLair': 'xp_lair',
    'proficiencyBonus': 'proficiency_bonus',
    'legendaryUses': 'legendary_uses',
    'legendaryUsesLair': 'legendary_uses_lair',
  },
);

Map<String, dynamic> _$MonsterDataToJson(_MonsterData instance) =>
    <String, dynamic>{
      'sizes': instance.sizes.map((e) => _$MonsterSizeEnumMap[e]!).toList(),
      'creature_type': _$CreatureTypeEnumMap[instance.creatureType]!,
      'swarm_size': ?_$MonsterSizeEnumMap[instance.swarmSize],
      'type_tags': instance.typeTags,
      'alignment': instance.alignment,
      'ac': instance.ac,
      'ac_note': ?instance.acNote,
      'initiative': instance.initiative,
      'hp': instance.hp,
      'hit_dice': instance.hitDice,
      'speed': instance.speed.toJson(),
      'speed_note': ?instance.speedNote,
      'hover': instance.hover,
      'abilities': instance.abilities,
      'saving_throws': instance.savingThrows,
      'skills': instance.skills,
      'vulnerabilities': instance.vulnerabilities
          .map(const ContentIdConverter().toJson)
          .toList(),
      'resistances': instance.resistances
          .map(const ContentIdConverter().toJson)
          .toList(),
      'immunities': instance.immunities
          .map(const ContentIdConverter().toJson)
          .toList(),
      'condition_immunities': instance.conditionImmunities
          .map(const ContentIdConverter().toJson)
          .toList(),
      'gear': instance.gear,
      'senses': instance.senses.toJson(),
      'senses_note': ?instance.sensesNote,
      'passive_perception': instance.passivePerception,
      'languages': instance.languages,
      'cr': instance.cr,
      'xp': instance.xp,
      'xp_lair': ?instance.xpLair,
      'proficiency_bonus': instance.proficiencyBonus,
      'legendary_uses': ?instance.legendaryUses,
      'legendary_uses_lair': ?instance.legendaryUsesLair,
      'actions': instance.actions.map((e) => e.toJson()).toList(),
    };

const _$MonsterSizeEnumMap = {
  MonsterSize.tiny: 'tiny',
  MonsterSize.small: 'small',
  MonsterSize.medium: 'medium',
  MonsterSize.large: 'large',
  MonsterSize.huge: 'huge',
  MonsterSize.gargantuan: 'gargantuan',
};

const _$CreatureTypeEnumMap = {
  CreatureType.aberration: 'aberration',
  CreatureType.beast: 'beast',
  CreatureType.celestial: 'celestial',
  CreatureType.construct: 'construct',
  CreatureType.dragon: 'dragon',
  CreatureType.elemental: 'elemental',
  CreatureType.fey: 'fey',
  CreatureType.fiend: 'fiend',
  CreatureType.giant: 'giant',
  CreatureType.humanoid: 'humanoid',
  CreatureType.monstrosity: 'monstrosity',
  CreatureType.ooze: 'ooze',
  CreatureType.plant: 'plant',
  CreatureType.undead: 'undead',
};
