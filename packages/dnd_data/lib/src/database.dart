import 'package:drift/drift.dart';
import 'package:powersync/powersync.dart' show PowerSyncDatabase;

import 'content_tables.dart';
import 'game_tables.dart';
import 'powersync.dart';

part 'database.g.dart';

/// Base locale de l'appareil (cahier §10) : contenu de règles et données
/// de jeu. Le [QueryExecutor] vient de la plateforme (`drift_flutter`) ou
/// des tests (`NativeDatabase.memory()`).
@DriftDatabase(
  tables: [
    ContentPacks,
    PackDependencies,
    Abilities,
    Skills,
    Languages,
    Conditions,
    RuleTerms,
    DamageTypes,
    MasteryProperties,
    Weapons,
    Armors,
    Tools,
    Items,
    MagicItems,
    Backgrounds,
    BackgroundAbilities,
    BackgroundProficiencies,
    BackgroundEquipmentOptions,
    ClassEquipmentOptions,
    Feats,
    SpeciesTable,
    SpeciesTraits,
    Classes,
    ClassLevels,
    Subclasses,
    SubclassFeatures,
    Features,
    Spells,
    SpellClasses,
    Monsters,
    MonsterActions,
    StudyReveals,
    Effects,
    EntityTexts,
    Profiles,
    GameTables,
    TableMembers,
    TableInvites,
    TablePacks,
    TableBannedEntities,
    TableActivities,
    PcSlots,
    Sessions,
    SessionAttendances,
    CharacterSummaries,
    Characters,
    CharacterBaseScores,
    CharacterBackgroundChoices,
    CharacterClassLevels,
    CharacterFeats,
    CharacterWeaponMasteries,
    CharacterSpells,
    CharacterItems,
    CharacterStates,
    CharacterContentRefs,
    CharacterChangeLogs,
    CharacterLanguages,
    CharacterChoices,
    CharacterProposals,
    NpcStatblocks,
    Encounters,
    EncounterGroups,
    EncounterEvents,
    CombatViews,
    CombatRequests,
    GroupRests,
    GroupRestDones,
    Notes,
    AuthorIdentities,
  ],
  include: {'content_search.drift'},
)
class TavernierDatabase extends _$TavernierDatabase {
  /// Avec [syncedTablesByPowerSync], les tables synchronisées existent déjà
  /// (vues de PowerSync) : la migration ne les crée pas.
  /// [powerSync] : la base PowerSync sous-jacente, fermée avec celle-ci.
  TavernierDatabase(
    super.executor, {
    this.syncedTablesByPowerSync = false,
    this.powerSync,
  });

  final bool syncedTablesByPowerSync;

  /// Base PowerSync, pour connecter ou déconnecter la synchronisation.
  final Future<PowerSyncDatabase>? powerSync;

  @override
  Future<void> close() async {
    await super.close();
    await (await powerSync)?.close();
  }

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      for (final entity in allSchemaEntities) {
        if (syncedTablesByPowerSync &&
            entity is TableInfo &&
            syncedTables.contains(entity.actualTableName)) {
          continue;
        }
        await m.create(entity);
      }
    },
    onUpgrade: (m, from, to) async {
      // v2 (US-24) : tables d'une règle.
      if (from < 2) await m.addColumn(ruleTerms, ruleTerms.data);
      // v3 (US-36) : vue du combat et demandes des joueurs. Avec PowerSync,
      // ce sont des vues qu'il crée lui-même.
      if (from < 3 && !syncedTablesByPowerSync) {
        await m.createTable(combatViews);
        await m.createTable(combatRequests);
      }
      // v4 (US-38) : repos de groupe.
      if (from < 4 && !syncedTablesByPowerSync) {
        await m.createTable(groupRests);
        await m.createTable(groupRestDones);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
