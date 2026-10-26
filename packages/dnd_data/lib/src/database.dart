import 'package:drift/drift.dart';

import 'content_tables.dart';

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
    DamageTypes,
    MasteryProperties,
    Weapons,
    Armors,
    Tools,
    Items,
    Backgrounds,
    BackgroundAbilities,
    BackgroundProficiencies,
    BackgroundEquipmentOptions,
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
  ],
  include: {'content_search.drift'},
)
class TavernierDatabase extends _$TavernierDatabase {
  TavernierDatabase(super.executor);

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
  );
}
