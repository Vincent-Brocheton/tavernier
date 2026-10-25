// Données propres à chaque type d'entité (cahier §11.1,
// docs/packs/FORMAT_DNDPACK.md). Tout champ inconnu est refusé.
import 'package:freezed_annotation/freezed_annotation.dart';

import '../content_id.dart';

part 'entity_data.freezed.dart';
part 'entity_data.g.dart';

/// Lit et écrit un [ContentId] sous sa forme `{namespace}:{type}:{slug}`.
class ContentIdConverter implements JsonConverter<ContentId, String> {
  const ContentIdConverter();

  @override
  ContentId fromJson(String json) =>
      ContentId.tryParse(json) ??
      (throw FormatException('identifiant de contenu invalide : $json'));

  @override
  String toJson(ContentId object) => object.toString();
}

/// Données d'une entité, selon son type.
sealed class EntityData {
  Map<String, dynamic> toJson();
}

@JsonEnum(fieldRename: FieldRename.snake)
enum LanguageCategory { standard, rare }

@JsonEnum(fieldRename: FieldRename.snake)
enum WeaponCategory { simple, martial }

@JsonEnum(fieldRename: FieldRename.snake)
enum WeaponKind { melee, ranged }

@JsonEnum(fieldRename: FieldRename.snake)
enum ArmorCategory { light, medium, heavy, shield }

@JsonEnum(fieldRename: FieldRename.snake)
enum ToolCategory { artisan, gamingSet, musicalInstrument, other }

@JsonEnum(fieldRename: FieldRename.snake)
enum FeatCategory { origin, general, fightingStyle, epicBoon }

@freezed
abstract class AbilityData with _$AbilityData implements EntityData {
  const factory AbilityData({required String abbreviation}) = _AbilityData;

  factory AbilityData.fromJson(Map<String, dynamic> json) =>
      _$AbilityDataFromJson(json);
}

@freezed
abstract class SkillData with _$SkillData implements EntityData {
  const factory SkillData({@ContentIdConverter() required ContentId ability}) =
      _SkillData;

  factory SkillData.fromJson(Map<String, dynamic> json) =>
      _$SkillDataFromJson(json);
}

@freezed
abstract class LanguageData with _$LanguageData implements EntityData {
  const factory LanguageData({required LanguageCategory category}) =
      _LanguageData;

  factory LanguageData.fromJson(Map<String, dynamic> json) =>
      _$LanguageDataFromJson(json);
}

/// Types sans données propres : état, type de dégâts, propriété de botte.
@freezed
abstract class EmptyData with _$EmptyData implements EntityData {
  const factory EmptyData() = _EmptyData;

  factory EmptyData.fromJson(Map<String, dynamic> json) =>
      _$EmptyDataFromJson(json);
}

@freezed
abstract class WeaponData with _$WeaponData implements EntityData {
  const factory WeaponData({
    required WeaponCategory category,
    required WeaponKind kind,
    required String damage,
    @ContentIdConverter() required ContentId damageType,
    @Default(<String>[]) List<String> properties,
    String? versatileDamage,
    List<int>? rangeFeet,
    @ContentIdConverter() required ContentId mastery,
    double? weightKg,
    required int costCp,
  }) = _WeaponData;

  factory WeaponData.fromJson(Map<String, dynamic> json) =>
      _$WeaponDataFromJson(json);
}

@freezed
abstract class ArmorData with _$ArmorData implements EntityData {
  const factory ArmorData({
    required ArmorCategory category,
    required int baseAc,

    /// Plafond du modificateur de DEX : absent = sans limite, 0 = ignoré.
    int? dexCap,
    int? strRequirement,
    @Default(false) bool stealthDisadvantage,
    required double weightKg,
    required int costCp,
  }) = _ArmorData;

  factory ArmorData.fromJson(Map<String, dynamic> json) =>
      _$ArmorDataFromJson(json);
}

@freezed
abstract class ToolData with _$ToolData implements EntityData {
  const factory ToolData({
    required ToolCategory category,
    @ContentIdConverter() ContentId? ability,
    double? weightKg,
    required int costCp,
  }) = _ToolData;

  factory ToolData.fromJson(Map<String, dynamic> json) =>
      _$ToolDataFromJson(json);
}

/// Objet d'équipement courant (cahier §11.1 `item`).
@freezed
abstract class ItemData with _$ItemData implements EntityData {
  const factory ItemData({double? weightKg, int? costCp}) = _ItemData;

  factory ItemData.fromJson(Map<String, dynamic> json) =>
      _$ItemDataFromJson(json);
}

@freezed
abstract class ItemQuantity with _$ItemQuantity {
  const factory ItemQuantity({
    @ContentIdConverter() required ContentId item,
    required int quantity,
  }) = _ItemQuantity;

  factory ItemQuantity.fromJson(Map<String, dynamic> json) =>
      _$ItemQuantityFromJson(json);
}

@freezed
abstract class BackgroundData with _$BackgroundData implements EntityData {
  const factory BackgroundData({
    @ContentIdConverter() required List<ContentId> abilities,
    @ContentIdConverter() required ContentId originFeat,

    /// Sous-choix imposé du don d'origine, ex. `{"spell_list": "cleric"}`.
    Map<String, String>? originFeatChoices,
    @ContentIdConverter() required List<ContentId> skillProficiencies,
    @ContentIdConverter() ContentId? toolProficiency,
    ToolCategory? toolChoiceCategory,
    required List<ItemQuantity> equipmentA,
    required int goldA,
    required int goldB,
  }) = _BackgroundData;

  factory BackgroundData.fromJson(Map<String, dynamic> json) =>
      _$BackgroundDataFromJson(json);
}

@freezed
abstract class SpeciesData with _$SpeciesData implements EntityData {
  const factory SpeciesData({
    required String creatureType,
    required List<String> sizes,
    required int speedFeet,
    @ContentIdConverter() required List<ContentId> traits,
  }) = _SpeciesData;

  factory SpeciesData.fromJson(Map<String, dynamic> json) =>
      _$SpeciesDataFromJson(json);
}

@freezed
abstract class FeatPrerequisites with _$FeatPrerequisites {
  const factory FeatPrerequisites({
    int? minLevel,

    /// Au moins une de ces valeurs minimales, ex. `{"str": 13, "dex": 13}`.
    Map<String, int>? abilityMinAny,

    /// Aptitude requise : `fighting_style` ou `spellcasting`.
    String? feature,
  }) = _FeatPrerequisites;

  factory FeatPrerequisites.fromJson(Map<String, dynamic> json) =>
      _$FeatPrerequisitesFromJson(json);
}

@freezed
abstract class FeatData with _$FeatData implements EntityData {
  const factory FeatData({
    required FeatCategory category,
    FeatPrerequisites? prerequisites,
    @Default(false) bool repeatable,
  }) = _FeatData;

  factory FeatData.fromJson(Map<String, dynamic> json) =>
      _$FeatDataFromJson(json);
}

@freezed
abstract class ClassLevelData with _$ClassLevelData {
  const factory ClassLevelData({
    required int level,
    required int proficiencyBonus,
    @ContentIdConverter() @Default(<ContentId>[]) List<ContentId> features,

    /// Colonnes propres à la classe, ex. `second_wind`, `weapon_mastery`.
    @Default(<String, int>{}) Map<String, int> columns,
  }) = _ClassLevelData;

  factory ClassLevelData.fromJson(Map<String, dynamic> json) =>
      _$ClassLevelDataFromJson(json);
}

@freezed
abstract class ClassData with _$ClassData implements EntityData {
  const factory ClassData({
    @ContentIdConverter() required List<ContentId> primaryAbilities,
    required int hitDie,
    @ContentIdConverter() required List<ContentId> savingThrows,
    required int skillChoiceCount,
    @ContentIdConverter() required List<ContentId> skillChoices,
    required List<String> weaponProficiencies,
    required List<String> armorTraining,
    required int subclassLevel,
    required List<ClassLevelData> levels,
  }) = _ClassData;

  factory ClassData.fromJson(Map<String, dynamic> json) =>
      _$ClassDataFromJson(json);
}

@freezed
abstract class SubclassData with _$SubclassData implements EntityData {
  const factory SubclassData({
    @ContentIdConverter() required ContentId parentClass,
    @ContentIdConverter() required List<ContentId> features,
  }) = _SubclassData;

  factory SubclassData.fromJson(Map<String, dynamic> json) =>
      _$SubclassDataFromJson(json);
}

@freezed
abstract class FeatureData with _$FeatureData implements EntityData {
  const factory FeatureData({
    @ContentIdConverter() required ContentId source,
    int? level,
  }) = _FeatureData;

  factory FeatureData.fromJson(Map<String, dynamic> json) =>
      _$FeatureDataFromJson(json);
}

/// Lecteur des données de chaque type d'entité.
final Map<String, EntityData Function(Map<String, dynamic>)> dataReaders = {
  'ability': AbilityData.fromJson,
  'skill': SkillData.fromJson,
  'language': LanguageData.fromJson,
  'condition': EmptyData.fromJson,
  'damage-type': EmptyData.fromJson,
  'mastery': EmptyData.fromJson,
  'weapon': WeaponData.fromJson,
  'armor': ArmorData.fromJson,
  'tool': ToolData.fromJson,
  'item': ItemData.fromJson,
  'background': BackgroundData.fromJson,
  'species': SpeciesData.fromJson,
  'feat': FeatData.fromJson,
  'class': ClassData.fromJson,
  'subclass': SubclassData.fromJson,
  'feature': FeatureData.fromJson,
};
