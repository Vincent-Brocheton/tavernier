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
    NpcStatblocks,
    Sessions,
    Encounters,
    Combatants,
    EncounterEvents,
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
  int get schemaVersion => 1;

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
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
