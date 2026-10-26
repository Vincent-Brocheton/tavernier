# dnd_data

Base locale Drift (cahier §10.2, §11) : schéma du contenu et des données de
jeu, import et export de pack, recherche plein texte, enregistrement d'un
personnage. Dart pur : l'application fournit l'exécuteur SQLite de sa
plateforme.

## Ouvrir la base

```dart
// Application (apps/game_table/lib/database.dart) : drift_flutter,
// SQLite natif ou WASM sur le Web.
final db = openTavernierDatabase();

// Tests Dart : base en mémoire.
final db = TavernierDatabase(NativeDatabase.memory());
```

Les clés étrangères sont activées à l'ouverture (`PRAGMA foreign_keys = ON`).

## Importer un pack et chercher

```dart
final store = PackStore(db);
await store.importPack(readDndpack(bytes)); // remplace le pack s'il existe
final pack = await store.exportPack(packId); // null si absent
final hits = await store.search('vigil');    // préfixe, sans accents
```

## Enregistrer un personnage

```dart
final characters = CharacterStore(db);
await characters.save(id, characterInput); // garde l'état de jeu existant
final input = await characters.load(id);   // null si absent
```

Aucun calcul de règles ici : `computeSheet` (dnd_rules) s'applique à la
lecture.

## Changer le schéma

1. Modifier les tables (`lib/src/*_tables.dart`, `content_search.drift`) et
   augmenter `schemaVersion` dans `lib/src/database.dart`, avec sa migration.
2. Régénérer le code : `fvm dart run build_runner build --delete-conflicting-outputs`.
3. Ajouter l'instantané et les tests de migration : `fvm dart run drift_dev make-migrations`.

`test/migration_test.dart` compare le schéma du code à l'instantané de sa
version : une table changée sans nouvelle version fait échouer les tests.
