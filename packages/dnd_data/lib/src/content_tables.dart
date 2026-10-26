// Contenu de règles par pack (cahier §11.1), plus `language`, `tool`,
// `feature` et `species_trait` exigés par docs/packs/FORMAT_DNDPACK.md.
// Les références entre entités ne sont pas des clés étrangères : un pack
// peut citer ses dépendances, et validatePack garantit déjà ces références.
// Les listes fermées sans requête sont stockées en JSON (design §3).
import 'package:drift/drift.dart';

@DataClassName('ContentPackRow')
class ContentPacks extends Table {
  @override
  String get tableName => 'content_pack';

  TextColumn get id => text()();
  TextColumn get namespace => text()();
  TextColumn get name => text()();
  TextColumn get version => text()();
  TextColumn get origin => text()();
  TextColumn get author => text()();
  TextColumn get licence => text()();
  TextColumn get attribution => text().nullable()();
  IntColumn get dslVersion => integer()();
  TextColumn get locale => text()();
  TextColumn get checksum => text().nullable()();
  TextColumn get signature => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('PackDependencyRow')
class PackDependencies extends Table {
  @override
  String get tableName => 'pack_dependency';

  TextColumn get packId =>
      text().references(ContentPacks, #id, onDelete: KeyAction.cascade)();
  TextColumn get dependsOnPackId => text()();
  TextColumn get versionRange => text()();

  @override
  Set<Column<Object>> get primaryKey => {packId, dependsOnPackId};
}

/// Colonnes communes à toute entité de contenu.
mixin ContentEntityColumns on Table {
  TextColumn get id => text()();
  TextColumn get packId =>
      text().references(ContentPacks, #id, onDelete: KeyAction.cascade)();
  TextColumn get name => text()();
  TextColumn get extendsId => text().nullable()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

/// Lignes rattachées à une entité et supprimées avec son pack.
mixin PackOwned on Table {
  TextColumn get packId =>
      text().references(ContentPacks, #id, onDelete: KeyAction.cascade)();
}

@DataClassName('AbilityRow')
class Abilities extends Table with ContentEntityColumns {
  @override
  String get tableName => 'ability';
  TextColumn get abbreviation => text()();
}

@DataClassName('SkillRow')
class Skills extends Table with ContentEntityColumns {
  @override
  String get tableName => 'skill';
  TextColumn get abilityId => text()();
}

@DataClassName('LanguageRow')
class Languages extends Table with ContentEntityColumns {
  @override
  String get tableName => 'language';
  TextColumn get category => text()();
}

@DataClassName('ConditionRow')
class Conditions extends Table with ContentEntityColumns {
  @override
  String get tableName => 'condition';
}

@DataClassName('DamageTypeRow')
class DamageTypes extends Table with ContentEntityColumns {
  @override
  String get tableName => 'damage_type';
}

@DataClassName('MasteryPropertyRow')
class MasteryProperties extends Table with ContentEntityColumns {
  @override
  String get tableName => 'mastery_property';
}

@DataClassName('WeaponRow')
class Weapons extends Table with ContentEntityColumns {
  @override
  String get tableName => 'weapon';
  TextColumn get category => text()();
  TextColumn get kind => text()();
  TextColumn get damage => text()();
  TextColumn get damageTypeId => text()();
  TextColumn get properties => text()(); // JSON
  TextColumn get versatileDamage => text().nullable()();
  IntColumn get rangeNormalFeet => integer().nullable()();
  IntColumn get rangeLongFeet => integer().nullable()();
  TextColumn get masteryPropertyId => text()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get costCp => integer()();
}

@DataClassName('ArmorRow')
class Armors extends Table with ContentEntityColumns {
  @override
  String get tableName => 'armor';
  TextColumn get category => text()();
  IntColumn get baseAc => integer()();
  IntColumn get dexCap => integer().nullable()();
  IntColumn get strRequirement => integer().nullable()();
  BoolColumn get stealthDisadvantage => boolean()();
  RealColumn get weightKg => real()();
  IntColumn get costCp => integer()();
}

@DataClassName('ToolRow')
class Tools extends Table with ContentEntityColumns {
  @override
  String get tableName => 'tool';
  TextColumn get category => text()();
  TextColumn get abilityId => text().nullable()();
  RealColumn get weightKg => real().nullable()();
  IntColumn get costCp => integer()();
}

@DataClassName('ItemRow')
class Items extends Table with ContentEntityColumns {
  @override
  String get tableName => 'item';
  RealColumn get weightKg => real().nullable()();
  IntColumn get costCp => integer().nullable()();
  TextColumn get rarity => text().nullable()();
  BoolColumn get attunement => boolean().withDefault(const Constant(false))();
}

@DataClassName('BackgroundRow')
class Backgrounds extends Table with ContentEntityColumns {
  @override
  String get tableName => 'background';
  TextColumn get originFeatId => text()();
  TextColumn get originFeatChoices => text().nullable()(); // JSON
  TextColumn get toolChoiceCategory => text().nullable()();
  IntColumn get goldA => integer()();
  IntColumn get equipmentGoldAlt => integer()();
}

@DataClassName('BackgroundAbilityRow')
class BackgroundAbilities extends Table with PackOwned {
  @override
  String get tableName => 'background_ability';
  TextColumn get backgroundId => text()();
  IntColumn get position => integer()();
  TextColumn get abilityId => text()();

  @override
  Set<Column<Object>> get primaryKey => {backgroundId, position};
}

@DataClassName('BackgroundProficiencyRow')
class BackgroundProficiencies extends Table with PackOwned {
  @override
  String get tableName => 'background_proficiency';
  TextColumn get backgroundId => text()();
  IntColumn get position => integer()();

  /// `skill` ou `tool`.
  TextColumn get type => text()();
  TextColumn get refId => text()();

  @override
  Set<Column<Object>> get primaryKey => {backgroundId, position};
}

@DataClassName('BackgroundEquipmentOptionRow')
class BackgroundEquipmentOptions extends Table with PackOwned {
  @override
  String get tableName => 'background_equipment_option';
  TextColumn get backgroundId => text()();
  TextColumn get option => text()(); // A
  TextColumn get items => text()(); // JSON

  @override
  Set<Column<Object>> get primaryKey => {backgroundId, option};
}

@DataClassName('FeatRow')
class Feats extends Table with ContentEntityColumns {
  @override
  String get tableName => 'feat';
  TextColumn get category => text()();
  TextColumn get prerequisites => text().nullable()(); // JSON
  BoolColumn get repeatable => boolean()();
}

@DataClassName('SpeciesRow')
class SpeciesTable extends Table with ContentEntityColumns {
  @override
  String get tableName => 'species';
  TextColumn get creatureType => text()();
  TextColumn get sizes => text()(); // JSON
  IntColumn get speedFeet => integer()();
}

@DataClassName('SpeciesTraitRow')
class SpeciesTraits extends Table with PackOwned {
  @override
  String get tableName => 'species_trait';
  TextColumn get speciesId => text()();
  IntColumn get position => integer()();
  TextColumn get featureId => text()();

  @override
  Set<Column<Object>> get primaryKey => {speciesId, position};
}

@DataClassName('ClassRow')
class Classes extends Table with ContentEntityColumns {
  @override
  String get tableName => 'class';
  IntColumn get hitDie => integer()();
  TextColumn get primaryAbilities => text()(); // JSON
  TextColumn get savingThrows => text()(); // JSON
  IntColumn get skillChoiceCount => integer()();
  TextColumn get skillChoices => text()(); // JSON
  TextColumn get weaponProficiencies => text()(); // JSON
  TextColumn get armorTraining => text()(); // JSON
  IntColumn get subclassLevel => integer()();
}

@DataClassName('ClassLevelRow')
class ClassLevels extends Table with PackOwned {
  @override
  String get tableName => 'class_level';
  TextColumn get classId => text()();
  IntColumn get level => integer()();
  IntColumn get profBonus => integer()();
  TextColumn get features => text()(); // JSON
  /// Colonnes de la table de classe (bottes, Second souffle, emplacements…).
  TextColumn get columns => text()(); // JSON

  @override
  Set<Column<Object>> get primaryKey => {classId, level};
}

@DataClassName('SubclassRow')
class Subclasses extends Table with ContentEntityColumns {
  @override
  String get tableName => 'subclass';
  TextColumn get parentClassId => text()();
}

@DataClassName('SubclassFeatureRow')
class SubclassFeatures extends Table with PackOwned {
  @override
  String get tableName => 'subclass_feature';
  TextColumn get subclassId => text()();
  IntColumn get position => integer()();
  TextColumn get featureId => text()();

  @override
  Set<Column<Object>> get primaryKey => {subclassId, position};
}

@DataClassName('FeatureRow')
class Features extends Table with ContentEntityColumns {
  @override
  String get tableName => 'feature';
  TextColumn get sourceId => text()();
  IntColumn get level => integer().nullable()();
}

@DataClassName('SpellRow')
class Spells extends Table with ContentEntityColumns {
  @override
  String get tableName => 'spell';
  IntColumn get level => integer()();
  TextColumn get school => text()();
  TextColumn get castingTime => text()();
  TextColumn get range => text()();
  TextColumn get components => text()(); // JSON
  IntColumn get materialCostCp => integer().nullable()();
  BoolColumn get materialConsumed => boolean()();
  TextColumn get duration => text()();
  BoolColumn get concentration => boolean()();
  BoolColumn get ritual => boolean()();
}

@DataClassName('SpellClassRow')
class SpellClasses extends Table with PackOwned {
  @override
  String get tableName => 'spell_class';
  TextColumn get spellId => text()();
  TextColumn get classId => text()();

  @override
  Set<Column<Object>> get primaryKey => {spellId, classId};
}

@DataClassName('MonsterRow')
class Monsters extends Table with ContentEntityColumns {
  @override
  String get tableName => 'monster';
  TextColumn get creatureType => text()();
  TextColumn get challengeRating => text()();
  IntColumn get xp => integer()();
  IntColumn get intelligence => integer()();
  TextColumn get statBlock => text()(); // JSON
}

@DataClassName('MonsterActionRow')
class MonsterActions extends Table with PackOwned {
  @override
  String get tableName => 'monster_action';
  TextColumn get monsterId => text()();
  IntColumn get position => integer()();

  /// `action`, `bonus`, `reaction`, `legendary`…
  TextColumn get kind => text()();
  TextColumn get name => text()();
  TextColumn get recharge => text().nullable()();
  TextColumn get data => text()(); // JSON

  @override
  Set<Column<Object>> get primaryKey => {monsterId, position};
}

@DataClassName('StudyRevealRow')
class StudyReveals extends Table with PackOwned {
  @override
  String get tableName => 'study_reveal';
  TextColumn get monsterId => text()();
  IntColumn get dc => integer()();
  TextColumn get revealText => text()();

  @override
  Set<Column<Object>> get primaryKey => {monsterId, dc};
}

@DataClassName('EffectRow')
class Effects extends Table with PackOwned {
  @override
  String get tableName => 'effect';
  TextColumn get ownerId => text()();
  TextColumn get ownerType => text()();
  IntColumn get position => integer()();
  TextColumn get payload => text()(); // JSON

  @override
  Set<Column<Object>> get primaryKey => {ownerId, position};
}

@DataClassName('EntityTextRow')
class EntityTexts extends Table with PackOwned {
  @override
  String get tableName => 'entity_text';
  TextColumn get entityId => text()();
  TextColumn get locale => text()();
  TextColumn get description => text()();

  @override
  Set<Column<Object>> get primaryKey => {entityId, locale};
}
