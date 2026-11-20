// Données de jeu (cahier §11.2), plus `character_language` et
// `character_choice` pour stocker tout CharacterInput. Chaque table a une
// clé primaire `id` textuelle (UUID v7 en M1), exigée par PowerSync (M2) ;
// les tables de liaison gardent leurs colonnes de liaison sous un index
// d'unicité. Les listes d'un CharacterInput (langues, bottes…) n'en ont pas :
// une entrée non encore validée se stocke telle quelle, dnd_rules signale
// les doublons. Colonnes JSON en texte.
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
  TextColumn get description => text().nullable()();
  TextColumn get statMethod => text()();
  TextColumn get longRestRule => text()();
  TextColumn get hpOnLevelRule => text()();
  IntColumn get startingLevel => integer().withDefault(const Constant(1))();
  TextColumn get progressionMode => text()();
  BoolColumn get fullSheetsVisible =>
      boolean().withDefault(const Constant(false))();
  BoolColumn get archived => boolean().withDefault(const Constant(false))();
}

/// Ligne rattachée à une table de jeu. Pas de clé étrangère locale : la
/// table de jeu est une vue PowerSync (T-05) ; le serveur vérifie.
mixin TableOwned on Table {
  TextColumn get tableId => text()();
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

/// Activité d'une table (EF-TAB-11) : chaque changement de configuration
/// ou d'archivage, daté avec son auteur. On ajoute, on ne corrige pas.
@DataClassName('TableActivityRow')
class TableActivities extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'table_activity';
  TextColumn get authorUserId => text().nullable()();
  DateTimeColumn get at => dateTime()();
  TextColumn get kind => text()();
  TextColumn get detail => text().withDefault(const Constant('{}'))();
}

/// Emplacement de PJ attribué par le MJ à un joueur (US-15, cahier §4.3).
@DataClassName('PcSlotRow')
class PcSlots extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'pc_slot';
  TextColumn get playerUserId => text()();
  TextColumn get characterId => text().nullable()();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

/// Séance d'une table (US-35, EF-SEA-01) : `planned`, `in_progress` ou
/// `closed`. Son numéro se déduit de l'ordre des dates.
@DataClassName('SessionRow')
class Sessions extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'session';
  TextColumn get title => text()();
  TextColumn get date => text()(); // AAAA-MM-JJ
  TextColumn get status => text().withDefault(const Constant('planned'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

/// Personnage prévu à une séance (EF-SEA-02) ; sans ligne, il est absent.
/// `id` : `<séance>:<personnage>`.
@DataClassName('SessionAttendanceRow')
class SessionAttendances extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'session_attendance';
  TextColumn get sessionId => text()();
  TextColumn get characterId => text()();
}

/// Résumé d'une fiche de table, lu par les autres joueurs (US-15,
/// EF-TAB-09) : `id` est celui de la fiche ; aucun PV chiffré.
@DataClassName('CharacterSummaryRow')
class CharacterSummaries extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'character_summary';
  TextColumn get ownerUserId => text().nullable()();
  TextColumn get name => text()();
  TextColumn get speciesId => text()();
  TextColumn get classes => text().withDefault(const Constant('[]'))(); // JSON
  TextColumn get health => text()();
  DateTimeColumn get updatedAt => dateTime().nullable()();
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
  TextColumn get tableId => text().nullable()();
  TextColumn get ownerUserId => text().nullable()();

  /// `pc` ou `npc_full`.
  TextColumn get kind => text()();
  TextColumn get name => text()();
  TextColumn get player => text().nullable()();
  TextColumn get speciesId => text()();
  TextColumn get speciesChoices => text().withDefault(const Constant('{}'))();
  TextColumn get backgroundId => text()();

  /// `draft`, `submitted`, `validated`, `changes_requested` ou `archived`.
  TextColumn get status => text()();

  /// Message du joueur à l'envoi au MJ (US-15).
  TextColumn get submitMessage => text().nullable()();

  /// Commentaire du MJ à la revue (US-15).
  TextColumn get reviewComment => text().nullable()();
  IntColumn get xp => integer().withDefault(const Constant(0))();

  /// Origine et niveau déverrouillé (§11.2 `level_unlock`), JSON.
  TextColumn get levelUnlock => text().nullable()();

  /// Jets de la génération aléatoire, JSON.
  TextColumn get scoreRolls => text().nullable()();

  /// Monnaie par pièce, JSON.
  TextColumn get coins => text().withDefault(const Constant('{}'))();
  TextColumn get alignment => text().nullable()();
  TextColumn get appearance => text().nullable()();
  TextColumn get personality => text().nullable()();
  TextColumn get backstory => text().nullable()();
}

/// Ligne rattachée à un personnage. Pas de clé étrangère locale (vue
/// PowerSync) : `CharacterStore.delete` supprime le contenu avec la fiche.
mixin CharacterOwned on Table {
  TextColumn get characterId => text()();
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
}

@DataClassName('CharacterSpellRow')
class CharacterSpells extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_spell';
  TextColumn get spellId => text()();
  TextColumn get source => text()();
  BoolColumn get prepared => boolean().withDefault(const Constant(false))();
  BoolColumn get inSpellbook => boolean().withDefault(const Constant(false))();

  /// Classe du sort ; vide : la première classe de lanceur.
  TextColumn get classId => text().nullable()();
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

/// Proposition structurelle du MJ (US-34, EF-PJ-16).
@DataClassName('CharacterProposalRow')
class CharacterProposals extends Table with IdKey, CharacterOwned, TableOwned {
  @override
  String get tableName => 'character_proposal';
  TextColumn get authorUserId => text().nullable()();
  TextColumn get kind => text()();
  TextColumn get change => text()(); // JSON
  TextColumn get reason => text()();
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get reply => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get decidedAt => dateTime().nullable()();
}

@DataClassName('CharacterLanguageRow')
class CharacterLanguages extends Table with IdKey, CharacterOwned {
  @override
  String get tableName => 'character_language';
  TextColumn get languageId => text()();
  IntColumn get position => integer()();
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

/// PNJ du MJ (US-18, EF-PNJ-01 à 03) : bloc de stats (monstre de départ,
/// bloc JSON) ou fiche complète liée ; attitude et informations cachées.
@DataClassName('NpcStatblockRow')
class NpcStatblocks extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'npc_statblock';
  TextColumn get name => text()();
  TextColumn get folder => text().nullable()();
  TextColumn get monsterId => text().nullable()();
  TextColumn get statBlock => text().nullable()(); // JSON
  TextColumn get characterId => text().nullable()();

  /// `friendly`, `indifferent` ou `hostile`.
  TextColumn get attitude =>
      text().withDefault(const Constant('indifferent'))();
  TextColumn get hiddenInfo => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

@DataClassName('EncounterRow')
class Encounters extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'encounter';

  /// Séance de la rencontre ; `null` : en réserve. Pas de clé étrangère :
  /// `session` est une vue PowerSync.
  TextColumn get sessionId => text().nullable()();
  TextColumn get title => text()();

  /// `draft`, `ready`, `running` ou `finished`.
  TextColumn get status => text().withDefault(const Constant('draft'))();

  /// `average` ou `roll` (EF-REN-04).
  TextColumn get hpMode => text().withDefault(const Constant('average'))();
  IntColumn get position => integer().withDefault(const Constant(0))();
  DateTimeColumn get createdAt => dateTime().nullable()();
}

/// Groupe d'adversaires préparé (US-19, EF-REN-02) : un monstre ou un PNJ,
/// en quantité.
@DataClassName('EncounterGroupRow')
class EncounterGroups extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'encounter_group';
  TextColumn get encounterId => text()();

  /// `monster` ou `npc`.
  TextColumn get kind => text()();
  TextColumn get refId => text()();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  BoolColumn get sharedInitiative =>
      boolean().withDefault(const Constant(true))();
  IntColumn get position => integer().withDefault(const Constant(0))();
}

/// Journal du combat (US-20, cahier §10) : l'état d'une rencontre est la
/// projection de ses événements, dans l'ordre de leurs identifiants
/// (UUID v7). Les combattants s'en déduisent.
@DataClassName('EncounterEventRow')
class EncounterEvents extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'encounter_event';

  /// Pas de clé étrangère : `encounter` est une vue PowerSync (US-19).
  TextColumn get encounterId => text()();
  TextColumn get authorUserId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get payload => text().withDefault(const Constant('{}'))(); // JSON
  DateTimeColumn get createdAt => dateTime().nullable()();
}

/// Vue du combat pour les joueurs (US-36) : publiée par l'appareil du MJ,
/// une par rencontre (son identifiant est celui de la rencontre).
@DataClassName('CombatViewRow')
class CombatViews extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'combat_view';
  TextColumn get payload => text().withDefault(const Constant('{}'))(); // JSON
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

/// Demande d'un joueur pour son PJ (US-36, EF-VJ-05, 06) : l'appareil du MJ
/// l'applique au journal.
@DataClassName('CombatRequestRow')
class CombatRequests extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'combat_request';

  /// Pas de clé étrangère : `encounter` et `character` sont des vues
  /// PowerSync.
  TextColumn get encounterId => text()();
  TextColumn get characterId => text()();
  TextColumn get authorUserId => text().nullable()();
  TextColumn get type => text()();
  TextColumn get payload => text().withDefault(const Constant('{}'))(); // JSON
  DateTimeColumn get createdAt => dateTime().nullable()();
}

/// Repos de groupe (US-38, EF-PJ-19) : déclenché par le MJ pour des PJ.
@DataClassName('GroupRestRow')
class GroupRests extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'group_rest';
  TextColumn get sessionId => text().nullable()();

  /// `short` ou `long`.
  TextColumn get kind => text()();
  TextColumn get characters => text().withDefault(const Constant('[]'))();
  DateTimeColumn get createdAt => dateTime().nullable()();
  DateTimeColumn get closedAt => dateTime().nullable()();
}

/// Fin d'un repos de groupe pour un PJ, avec son récapitulatif (US-38).
@DataClassName('GroupRestDoneRow')
class GroupRestDones extends Table with IdKey, TableOwned {
  @override
  String get tableName => 'group_rest_done';

  /// Pas de clé étrangère : les tables visées sont des vues PowerSync.
  TextColumn get restId => text()();
  TextColumn get characterId => text()();
  TextColumn get authorUserId => text().nullable()();
  TextColumn get summary => text().withDefault(const Constant('{}'))(); // JSON
  DateTimeColumn get createdAt => dateTime().nullable()();
}

/// Note (US-26, EF-NOT-01 à 06) : texte en Markdown réduit, privée par
/// défaut, partageable avec la table en lecture seule.
@DataClassName('NoteRow')
class Notes extends Table with IdKey {
  @override
  String get tableName => 'note';
  TextColumn get ownerUserId => text()();
  TextColumn get tableId => text().nullable()();

  /// `table`, `session`, `npc` ou `encounter`.
  TextColumn get scope => text()();
  TextColumn get refId => text().nullable()();
  TextColumn get content => text()();
  BoolColumn get private => boolean().withDefault(const Constant(true))();
  TextColumn get title => text().withDefault(const Constant(''))();
  DateTimeColumn get updatedAt => dateTime().nullable()();

  /// L'autre version d'une note modifiée sur deux appareils (EF-NOT-06).
  TextColumn get conflict => text().nullable()();
}

/// Brouillon d'un pack homebrew (US-27) : le manifeste et les entités en
/// JSON brut, même incomplets. Local, jamais synchronisé.
@DataClassName('HomebrewDraftRow')
class HomebrewDrafts extends Table with IdKey {
  @override
  String get tableName => 'homebrew_draft';
  TextColumn get pack => text()(); // JSON {manifest, entities}
  DateTimeColumn get updatedAt => dateTime().nullable()();
}

@DataClassName('AuthorIdentityRow')
class AuthorIdentities extends Table with IdKey {
  @override
  String get tableName => 'author_identity';
  TextColumn get publicKey => text()();
}
