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
enum MagicItemCategory {
  wondrous,
  armor,
  weapon,
  ring,
  wand,
  staff,
  potion,
  scroll,
  rod,
}

/// Rareté d'un objet magique ; `varies` quand elle dépend de la variante.
@JsonEnum(fieldRename: FieldRename.snake)
enum Rarity { common, uncommon, rare, veryRare, legendary, artifact, varies }

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

/// Objet magique du SRD (une entité par entrée du chapitre, variantes
/// comprises).
@freezed
abstract class MagicItemData with _$MagicItemData implements EntityData {
  const factory MagicItemData({
    required MagicItemCategory category,
    required Rarity rarity,

    /// Ligne de type du SRD, recopiée telle quelle.
    required String typeLine,
    @Default(false) bool attunement,

    /// Créature exigée pour l'harmonisation (« un Magicien »).
    String? attunementBy,
  }) = _MagicItemData;

  factory MagicItemData.fromJson(Map<String, dynamic> json) =>
      _$MagicItemDataFromJson(json);
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

/// Option d'équipement de départ d'une classe (« (A) Hache à deux mains,
/// 4 hachettes… et 15 po »).
@freezed
abstract class StartingEquipmentOption with _$StartingEquipmentOption {
  const factory StartingEquipmentOption({
    @Default(<ItemQuantity>[]) List<ItemQuantity> items,

    /// Un outil à choisir parmi ces catégories (« instrument de musique de
    /// votre choix »).
    @Default(<ToolCategory>[]) List<ToolCategory> toolChoice,

    /// Pièces d'or.
    required int gold,
  }) = _StartingEquipmentOption;

  factory StartingEquipmentOption.fromJson(Map<String, dynamic> json) =>
      _$StartingEquipmentOptionFromJson(json);
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

/// Façon de changer ses sorts préparés (SRD, chaque classe).
@JsonEnum(fieldRename: FieldRename.snake)
enum PreparedChange { longRestAll, longRestOne, levelUpOne }

/// Encadré « En tant que personnage multiclassé » d'une classe, hors dé de vie.
@freezed
abstract class MulticlassTraits with _$MulticlassTraits {
  const factory MulticlassTraits({
    @Default(<String>[]) List<String> weaponProficiencies,
    @Default(<String>[]) List<String> armorTraining,
    @ContentIdConverter()
    @Default(<ContentId>[])
    List<ContentId> toolProficiencies,

    /// Compétences à choisir dans celles de la classe.
    @Default(0) int skillChoiceCount,

    /// Outils à choisir dans la catégorie de la classe.
    @Default(0) int toolChoiceCount,

    /// Part des niveaux de la classe dans le niveau de lanceur : 1 pour tous,
    /// 2 pour la moitié, 0 si elle n'y compte pas (SRD p. 27).
    @Default(0) int casterDivisor,
  }) = _MulticlassTraits;

  factory MulticlassTraits.fromJson(Map<String, dynamic> json) =>
      _$MulticlassTraitsFromJson(json);
}

@freezed
abstract class ClassData with _$ClassData implements EntityData {
  const factory ClassData({
    @ContentIdConverter() required List<ContentId> primaryAbilities,

    /// L'une des caractéristiques principales suffit (Guerrier : Force ou
    /// Dextérité) ; sinon toutes sont requises (Moine).
    @Default(false) bool primaryAbilitiesAny,
    required int hitDie,
    @ContentIdConverter() required List<ContentId> savingThrows,
    required int skillChoiceCount,
    @ContentIdConverter() required List<ContentId> skillChoices,
    required List<String> weaponProficiencies,
    required List<String> armorTraining,
    required int subclassLevel,
    required List<ClassLevelData> levels,

    /// Liste de sorts de la classe (le sort ne cite pas ses classes).
    @ContentIdConverter() @Default(<ContentId>[]) List<ContentId> spellList,

    /// Caractéristique d'incantation des sorts de la classe.
    @ContentIdConverter() ContentId? spellcastingAbility,

    /// Outils maîtrisés d'office (Druide : matériel d'herboriste).
    @ContentIdConverter()
    @Default(<ContentId>[])
    List<ContentId> toolProficiencies,

    /// Outils à choisir dans une catégorie (Barde : 3 instruments).
    @Default(0) int toolChoiceCount,
    ToolCategory? toolChoiceCategory,

    /// Options d'équipement de départ, dans l'ordre du SRD (A, B, C).
    @Default(<StartingEquipmentOption>[])
    List<StartingEquipmentOption> startingEquipment,

    /// Façon de changer les sorts préparés ; vide sans lanceur.
    PreparedChange? preparedChange,

    /// Traits reçus quand ce n'est pas la classe de départ.
    @Default(MulticlassTraits()) MulticlassTraits multiclass,
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

@JsonEnum(fieldRename: FieldRename.snake)
enum SpellSchool {
  abjuration,
  conjuration,
  divination,
  enchantment,
  evocation,
  illusion,
  necromancy,
  transmutation,
}

/// Genre de portée d'un sort ; `feet` seul porte une distance.
@JsonEnum(fieldRename: FieldRename.snake)
enum RangeKind { self, touch, feet, sight, unlimited, special }

/// Portée d'un sort, en pieds (affichée en mètres : 5 pieds = 1,50 m).
@freezed
abstract class SpellRange with _$SpellRange {
  const factory SpellRange({required RangeKind kind, int? feet}) = _SpellRange;

  factory SpellRange.fromJson(Map<String, dynamic> json) =>
      _$SpellRangeFromJson(json);
}

SpellRange _spellRange(Map<String, dynamic> json) {
  final range = SpellRange.fromJson(json);
  if ((range.kind == RangeKind.feet) != (range.feet != null)) {
    throw ArgumentError('distance en pieds requise pour « feet » seulement');
  }
  return range;
}

/// Composantes verbale, somatique et matérielle (texte du SRD).
@freezed
abstract class SpellComponents with _$SpellComponents {
  const factory SpellComponents({
    required bool verbal,
    required bool somatic,
    String? material,
  }) = _SpellComponents;

  factory SpellComponents.fromJson(Map<String, dynamic> json) =>
      _$SpellComponentsFromJson(json);
}

int _spellLevel(Object? json) {
  final level = json! as int;
  if (level < 0 || level > 9) {
    throw ArgumentError('niveau de sort entre 0 et 9 attendu');
  }
  return level;
}

/// Sort (cahier §11.1 `spell`). Il ne cite pas ses classes : chaque classe
/// porte sa liste de sorts.
@freezed
abstract class SpellData with _$SpellData implements EntityData {
  const factory SpellData({
    @JsonKey(fromJson: _spellLevel) required int level,
    required SpellSchool school,

    /// Temps d'incantation, tel que dans le SRD (« action », « 1 minute »…).
    required String castingTime,
    required bool ritual,
    @JsonKey(fromJson: _spellRange) required SpellRange range,
    required SpellComponents components,
    int? materialCostCp,
    required bool materialConsumed,

    /// Durée, telle que dans le SRD (« instantanée », « 1 heure »…).
    required String duration,
    required bool concentration,
  }) = _SpellData;

  factory SpellData.fromJson(Map<String, dynamic> json) =>
      _$SpellDataFromJson(json);
}

@JsonEnum(fieldRename: FieldRename.snake)
enum MonsterSize { tiny, small, medium, large, huge, gargantuan }

@JsonEnum(fieldRename: FieldRename.snake)
enum CreatureType {
  aberration,
  beast,
  celestial,
  construct,
  dragon,
  elemental,
  fey,
  fiend,
  giant,
  humanoid,
  monstrosity,
  ooze,
  plant,
  undead,
}

/// Section du profil : Traits, Actions, Actions Bonus, Réactions, Actions
/// Légendaires.
@JsonEnum(fieldRename: FieldRename.snake)
enum MonsterActionKind { trait, action, bonus, reaction, legendary }

@JsonEnum(fieldRename: FieldRename.snake)
enum MonsterAttackKind { melee, ranged, meleeOrRanged }

const _abilityKeys = {'str', 'dex', 'con', 'int', 'wis', 'cha'};

Map<String, int> _sixAbilities(Object? json) {
  final map = Map<String, int>.from(json! as Map);
  if (map.length != 6 || !map.keys.toSet().containsAll(_abilityKeys)) {
    throw ArgumentError('les six caractéristiques attendues : $_abilityKeys');
  }
  return map;
}

/// Vitesses en pieds.
@freezed
abstract class MonsterSpeed with _$MonsterSpeed {
  const factory MonsterSpeed({
    int? walk,
    int? swim,
    int? fly,
    int? climb,
    int? burrow,
  }) = _MonsterSpeed;

  factory MonsterSpeed.fromJson(Map<String, dynamic> json) =>
      _$MonsterSpeedFromJson(json);
}

/// Sens, en pieds.
@freezed
abstract class MonsterSenses with _$MonsterSenses {
  const factory MonsterSenses({
    int? darkvision,
    int? blindsight,

    /// `true` pour « (aveugle au-delà) » après la Vision aveugle.
    bool? blindBeyond,
    int? tremorsense,
    int? truesight,
  }) = _MonsterSenses;

  factory MonsterSenses.fromJson(Map<String, dynamic> json) =>
      _$MonsterSensesFromJson(json);
}

/// Usages limités : « (2/jour) », « (Recharge 5–6) », « (Recharge après un
/// Repos court ou long) ».
@freezed
abstract class MonsterUses with _$MonsterUses {
  const factory MonsterUses({
    int? perDay,
    int? perDayLair,
    String? recharge,

    /// `short_or_long` ou `long`.
    String? rest,
  }) = _MonsterUses;
  const MonsterUses._();

  factory MonsterUses.fromJson(Map<String, dynamic> json) =>
      _$MonsterUsesFromJson(json);

  /// Forme courte gardée dans `monster_action.recharge`.
  String get label => recharge ?? rest ?? '$perDay/day';
}

@freezed
abstract class MonsterDamage with _$MonsterDamage {
  const factory MonsterDamage({
    required int average,

    /// Absent pour des dégâts fixes (« Touché : 1 dégât perforant »).
    String? dice,
    @ContentIdConverter() required ContentId type,
  }) = _MonsterDamage;

  factory MonsterDamage.fromJson(Map<String, dynamic> json) =>
      _$MonsterDamageFromJson(json);
}

/// Jet d'attaque d'une action, en pieds (allonge, ou portée normale et
/// longue).
@freezed
abstract class MonsterAttack with _$MonsterAttack {
  const factory MonsterAttack({
    required MonsterAttackKind kind,
    required int bonus,
    int? reach,
    List<int>? range,
    @Default(<MonsterDamage>[]) List<MonsterDamage> damage,
  }) = _MonsterAttack;

  factory MonsterAttack.fromJson(Map<String, dynamic> json) =>
      _$MonsterAttackFromJson(json);
}

@freezed
abstract class MonsterSave with _$MonsterSave {
  const factory MonsterSave({required String ability, required int dc}) =
      _MonsterSave;

  factory MonsterSave.fromJson(Map<String, dynamic> json) =>
      _$MonsterSaveFromJson(json);
}

/// Trait ou action du profil ; [text] reste la référence de règles.
@freezed
abstract class MonsterAction with _$MonsterAction {
  const factory MonsterAction({
    required MonsterActionKind kind,
    required String name,
    MonsterUses? uses,
    MonsterAttack? attack,
    MonsterSave? save,
    required String text,
  }) = _MonsterAction;

  factory MonsterAction.fromJson(Map<String, dynamic> json) =>
      _$MonsterActionFromJson(json);
}

/// Profil de jeu (cahier §11.1 `monster`), recopié tel qu'imprimé : rien
/// n'est recalculé.
@freezed
abstract class MonsterData with _$MonsterData implements EntityData {
  const factory MonsterData({
    required List<MonsterSize> sizes,
    required CreatureType creatureType,

    /// Texte entre parenthèses après le type (« Démon »).
    @Default(<String>[]) List<String> typeTags,
    required String alignment,
    required int ac,

    /// Texte qui suit la CA.
    String? acNote,
    required int initiative,
    required int hp,
    required String hitDice,
    required MonsterSpeed speed,
    @Default(false) bool hover,
    @JsonKey(fromJson: _sixAbilities) required Map<String, int> abilities,
    @JsonKey(fromJson: _sixAbilities) required Map<String, int> savingThrows,

    /// Bonus par identifiant de compétence.
    @Default(<String, int>{}) Map<String, int> skills,
    @ContentIdConverter()
    @Default(<ContentId>[])
    List<ContentId> vulnerabilities,
    @ContentIdConverter() @Default(<ContentId>[]) List<ContentId> resistances,
    @ContentIdConverter() @Default(<ContentId>[]) List<ContentId> immunities,
    @ContentIdConverter()
    @Default(<ContentId>[])
    List<ContentId> conditionImmunities,

    /// Ligne « Équipement », un objet par entrée.
    @Default(<String>[]) List<String> gear,
    @Default(MonsterSenses()) MonsterSenses senses,
    required int passivePerception,

    /// Ligne « Langues », telle qu'imprimée.
    required String languages,
    required String cr,
    required int xp,
    int? xpLair,
    required int proficiencyBonus,
    int? legendaryUses,
    int? legendaryUsesLair,
    @Default(<MonsterAction>[]) List<MonsterAction> actions,
  }) = _MonsterData;

  factory MonsterData.fromJson(Map<String, dynamic> json) =>
      _$MonsterDataFromJson(json);
}

/// Lecteur des données de chaque type d'entité.
final Map<String, EntityData Function(Map<String, dynamic>)> dataReaders = {
  'ability': AbilityData.fromJson,
  'skill': SkillData.fromJson,
  'language': LanguageData.fromJson,
  'condition': EmptyData.fromJson,
  'rule': EmptyData.fromJson,
  'damage-type': EmptyData.fromJson,
  'mastery': EmptyData.fromJson,
  'weapon': WeaponData.fromJson,
  'armor': ArmorData.fromJson,
  'tool': ToolData.fromJson,
  'item': ItemData.fromJson,
  'magic-item': MagicItemData.fromJson,
  'background': BackgroundData.fromJson,
  'species': SpeciesData.fromJson,
  'feat': FeatData.fromJson,
  'class': ClassData.fromJson,
  'subclass': SubclassData.fromJson,
  'feature': FeatureData.fromJson,
  'spell': SpellData.fromJson,
  'monster': MonsterData.fromJson,
};
