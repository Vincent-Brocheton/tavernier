// Données de jeu (cahier §11.2), plus `character_language` et
// `character_choice` pour stocker tout CharacterInput. Chaque table a une
// clé primaire `id` textuelle (UUID v7 en M1), exigée par PowerSync (M2) ;
// les tables de liaison gardent leurs colonnes de liaison sous un index
// d'unicité. Colonnes JSON en texte.
import 'package:drift/drift.dart';

/// Clé primaire `id` commune.
mixin IdKey on Table {
  TextColumn get id => text()();

  @override
  Set<Column<Object>> get primaryKey => {id};
}

@DataClassName('ProfileRow')
class Profiles extends Table with IdKey {
  @override
  String get tableName => 'profile';
  TextColumn get pseudonym => text()();
  TextColumn get avatar => text().nullable()();
  TextColumn get locale => text().withDefault(const Constant('fr'))();
  TextColumn get settings => text().withDefault(const Constant('{}'))();
}

@DataClassName('GameTableRow')
class GameTables extends Table with IdKey {
  @override
  String get tableName => 'game_table';
  TextColumn get gmUserId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get statMethod => text()();
  TextColumn get longRestRule => text()();
  TextColumn get hpOnLevelRule => text()();
  IntColumn get startingLevel => integer().withDefault(const Constant(1))();
  TextColumn get progressionMode => text()();
  BoolColumn get fullSheetsVisible =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

/// Ligne rattachée à une table de jeu, supprimée avec elle.
mixin TableOwned on Table {
  TextColumn get tableId =>
      text().references(GameTables, #id, onDelete: KeyAction.cascade)();
}

@DataClassName('TableMemberRow')
class TableMembers extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'table_member';
  TextColumn get userId => text()();
  TextColumn get role => text()();
  DateTimeColumn get joinedAt => dateTime()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {tableId, userId},
  ];
}

@DataClassName('TableInviteRow')
class TableInvites extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'table_invite';
  TextColumn get code => text().unique()();
  DateTimeColumn get expiresAt => dateTime()();
  BoolColumn get revoked => boolean().withDefault(const Constant(false))();
}

@DataClassName('TablePackRow')
class TablePacks extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'table_pack';
  TextColumn get packId => text()();
  TextColumn get pinnedVersion => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {tableId, packId},
  ];
}

@DataClassName('TableBannedEntityRow')
class TableBannedEntities extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'table_banned_entity';
  TextColumn get entityId => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {tableId, entityId},
  ];
}

@DataClassName('CharacterRow')
class Characters extends Table with IdKey {
  @override
  String get tableName => 'character';

  /// `null` : personnage libre (§4.3).
  TextColumn get tableId => text().nullable().references(
    GameTables,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get ownerUserId => text().nullable()();

  /// `pc` ou `npc_full`.
  TextColumn get kind => text()();
  TextColumn get name => text()();
  TextColumn get player => text().nullable()();
  TextColumn get speciesId => text()();
  TextColumn get speciesChoices => text().withDefault(const Constant('{}'))();
  TextColumn get backgroundId => text()();

  /// `draft`, `submitted` ou `validated`.
  TextColumn get status => text()();
  IntColumn get xp => integer().withDefault(const Constant(0))();

  /// Origine et niveau déverrouillé (§11.2 `level_unlock`), JSON.
  TextColumn get levelUnlock => text().nullable()();

  /// Jets de la génération aléatoire, JSON.
  TextColumn get scoreRolls => text().nullable()();
}

/// Ligne rattachée à un personnage, supprimée avec lui.
mixin CharacterOwned on Table {
  TextColumn get characterId =>
      text().references(Characters, #id, onDelete: KeyAction.cascade)();
}

@DataClassName('CharacterBaseScoreRow')
class CharacterBaseScores extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_base_scores';

  /// Code de caractéristique (`str`…`cha`).
  TextColumn get abilityId => text()();
  IntColumn get base => integer()();
  TextColumn get method => text()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {characterId, abilityId},
  ];
}

@DataClassName('CharacterBackgroundChoiceRow')
class CharacterBackgroundChoices extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_background_choice';
  TextColumn get distribution => text()();
  TextColumn get bonuses => text()(); // JSON
  TextColumn get featChoices => text().nullable()(); // JSON
  TextColumn get toolChoice => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {characterId},
  ];
}

@DataClassName('CharacterClassLevelRow')
class CharacterClassLevels extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_class_level';
  TextColumn get classId => text()();
  IntColumn get level => integer()();
  TextColumn get subclassId => text().nullable()();
  TextColumn get hpRoll => text().nullable()(); // JSON
  TextColumn get skillChoices => text().withDefault(const Constant('[]'))();
  TextColumn get expertise => text().withDefault(const Constant('[]'))();
  IntColumn get position => integer()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {characterId, classId},
  ];
}

@DataClassName('CharacterFeatRow')
class CharacterFeats extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_feat';
  TextColumn get featId => text()();
  TextColumn get sourceType => text()();
  TextColumn get sourceRef => text()();
  TextColumn get choices => text().nullable()(); // JSON
  IntColumn get position => integer()();
}

@DataClassName('CharacterWeaponMasteryRow')
class CharacterWeaponMasteries extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_weapon_mastery';
  TextColumn get weaponId => text()();
  IntColumn get slotIndex => integer()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {characterId, slotIndex},
  ];
}

@DataClassName('CharacterSpellRow')
class CharacterSpells extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_spell';
  TextColumn get spellId => text()();
  TextColumn get source => text()();
  BoolColumn get prepared => boolean().withDefault(const Constant(false))();
  BoolColumn get inSpellbook => boolean().withDefault(const Constant(false))();
}

@DataClassName('CharacterItemRow')
class CharacterItems extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_item';
  TextColumn get itemId => text()();
  IntColumn get quantity => integer()();
  BoolColumn get equipped => boolean()();
  BoolColumn get attuned => boolean()();
  IntColumn get position => integer()();
}

@DataClassName('CharacterStateRow')
class CharacterStates extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_state';
  IntColumn get hpCurrent => integer().nullable()();
  IntColumn get hpTemp => integer().withDefault(const Constant(0))();
  IntColumn get hitDiceUsed => integer().withDefault(const Constant(0))();
  TextColumn get deathSaves => text().withDefault(const Constant('{}'))();
  IntColumn get exhaustion => integer().withDefault(const Constant(0))();
  BoolColumn get heroicInspiration =>
      boolean().withDefault(const Constant(false))();
  TextColumn get resources => text().withDefault(const Constant('{}'))();

  /// Un seul sort à concentration à la fois (§11.3).
  TextColumn get concentrationSpellId => text().nullable()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {characterId},
  ];
}

@DataClassName('CharacterContentRefRow')
class CharacterContentRefs extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_content_ref';
  TextColumn get entityId => text()();
  TextColumn get packId => text()();
  TextColumn get packVersion => text()();
  TextColumn get snapshot => text()(); // JSON
}

@DataClassName('CharacterChangeLogRow')
class CharacterChangeLogs extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_change_log';
  TextColumn get authorUserId => text().nullable()();
  DateTimeColumn get timestamp => dateTime()();
  TextColumn get diff => text()(); // JSON
}

@DataClassName('CharacterLanguageRow')
class CharacterLanguages extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_language';
  TextColumn get languageId => text()();
  IntColumn get position => integer()();

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {characterId, languageId},
  ];
}

@DataClassName('CharacterChoiceRow')
class CharacterChoices extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_choice';
  TextColumn get choiceKey => text()();
  TextColumn get selections => text()(); // JSON

  @override
  List<Set<Column<Object>>> get uniqueKeys => [
    {characterId, choiceKey},
  ];
}

@DataClassName('NpcStatblockRow')
class NpcStatblocks extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'npc_statblock';
  TextColumn get monsterId => text().nullable()();
  TextColumn get statBlock => text().nullable()(); // JSON
  TextColumn get attitude => text().nullable()();
  TextColumn get hiddenInfo => text().nullable()(); // JSON
}

@DataClassName('SessionRow')
class Sessions extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'session';
  DateTimeColumn get date => dateTime()();
  TextColumn get title => text()();
}

@DataClassName('EncounterRow')
class Encounters extends Table with IdKey {
  @override
  String get tableName => 'encounter';
  TextColumn get sessionId => text().nullable().references(
    Sessions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get status => text()();
  TextColumn get difficulty => text().nullable()();
  TextColumn get hpMode => text()();
}

@DataClassName('CombatantRow')
class Combatants extends Table with IdKey {
  @override
  String get tableName => 'combatant';
  TextColumn get encounterId =>
      text().references(Encounters, #id, onDelete: KeyAction.cascade)();
  TextColumn get kind => text()();
  TextColumn get refId => text().nullable()();
  TextColumn get label => text()();
  IntColumn get initiative => integer().nullable()();
  TextColumn get groupId => text().nullable()();
  IntColumn get hp => integer().nullable()();
  IntColumn get ac => integer().nullable()();
  TextColumn get attitude => text().nullable()();
  BoolColumn get visible => boolean().withDefault(const Constant(true))();
}

@DataClassName('EncounterEventRow')
class EncounterEvents extends Table with IdKey {
  @override
  String get tableName => 'encounter_event';
  TextColumn get encounterId =>
      text().references(Encounters, #id, onDelete: KeyAction.cascade)();
  IntColumn get round => integer()();
  TextColumn get actorId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get payload => text()(); // JSON
  TextColumn get authorUserId => text().nullable()();
}

@DataClassName('NoteRow')
class Notes extends Table with IdKey {
  @override
  String get tableName => 'note';
  TextColumn get ownerUserId => text()();
  TextColumn get tableId => text().nullable().references(
    GameTables,
    #id,
    onDelete: KeyAction.cascade,
  )();

  /// `table`, `session`, `npc` ou `encounter`.
  TextColumn get scope => text()();
  TextColumn get refId => text().nullable()();
  TextColumn get content => text()();
  BoolColumn get private => boolean().withDefault(const Constant(true))();
}

@DataClassName('AuthorIdentityRow')
class AuthorIdentities extends Table with IdKey {
  @override
  String get tableName => 'author_identity';
  TextColumn get publicKey => text()();
}
