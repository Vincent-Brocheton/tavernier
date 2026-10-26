# Tasks

Branche `feature/us-04-schema-drift-v1`. Chaque tâche commence par le test qui échoue (superpowers:test-driven-development) ; sauf mention, vérification : `cd packages/dnd_data && fvm dart test` vert.

## 1. Mise en place

- [ ] 1.1 Ajouter `drift`, `sqlite3`, `dnd_content`, `dnd_rules` à `dnd_data`, et `drift_dev`, `build_runner` en dev ; test : une base `NativeDatabase.memory()` s'ouvre et `pragma compile_options` contient `ENABLE_FTS5` (sinon, ajouter `sqlite3.dll` officiel au chemin des tests et le documenter)

## 2. Contenu de règles (§11.1)

- [ ] 2.1 Test « Base neuve » (version 1, tables du contenu présentes) ; écrire les tables du contenu (§11.1 + `language`, `tool`, `feature`, `species_trait`) et `TavernierDatabase`
- [ ] 2.2 Test : supprimer un `content_pack` supprime ses entités, effets et textes (cascade) ; activer `foreign_keys` à l'ouverture

## 3. Import et export de pack

- [ ] 3.1 Test « Pack SRD aller-retour » (188 entités, export égal au pack d'origine, entité par entité, via `toJson`) ; implémenter `PackStore.importPack` et `exportPack` avec un `switch` exhaustif sur `EntityData`
- [ ] 3.2 Test « Réimport » (aucun doublon) ; import transactionnel qui remplace les entités du pack

## 4. Recherche plein texte

- [ ] 4.1 Tests « Recherche avec ou sans accent », « Début de mot », « Texte de règles » ; table virtuelle FTS5 `content_search` (`.drift`), alimentée par l'import, et `PackStore.search(query)` qui renvoie id, type et nom

## 5. Données de jeu (§11.2)

- [ ] 5.1 Test « Base neuve » étendu aux tables du §11.2 (+ `character_language`, `character_choice`) et test « Tables de liaison » (clé primaire = `id`) ; écrire ces tables avec leurs index d'unicité
- [ ] 5.2 Tests « Niveau de classe orphelin » et « Suppression d'un personnage » ; clés étrangères et cascades depuis `character`

## 6. Enregistrement d'un personnage

- [ ] 6.1 Tests « Aldric aller-retour » (égal à l'entrée de la fixture [D1]) et « Modification » ; implémenter `CharacterStore.save` et `load`

## 7. Migrations

- [ ] 7.1 Produire `drift_schemas/drift_schema_v1.json` (`drift_dev schema dump`) et le test de migration généré ; vérifier qu'il passe, puis qu'ajouter une colonne sans nouvelle version le fait échouer
- [ ] 7.2 Script Melos `schema:check` (instantané à jour) ajouté à la CI ; vérifier qu'il échoue sur un instantané périmé

## 8. Plateformes

- [ ] 8.1 Ouvrir la base dans `apps/game_table` avec `drift_flutter` ; ajouter `web/sqlite3.wasm` et `web/drift_worker.js` des versions publiées correspondant aux paquets (téléchargement à confirmer avec le porteur de projet) ; vérifier que `fvm flutter build web` réussit
- [ ] 8.2 Test d'intégration `integration_test/database_test.dart` (créer, importer le pack SRD, rechercher, fermer, rouvrir, relire) ; vérifier qu'il passe sur Chrome (`flutter drive`)
- [ ] 8.3 Créer un émulateur Android (image système à télécharger, accord du porteur de projet) et vérifier que le test d'intégration y passe
- [ ] 8.4 Jobs de CI : test d'intégration Web (Chrome) et iOS (runner macOS, simulateur) ; vérifier qu'ils passent sur la pull request

## 9. Intégration

- [ ] 9.1 `packages/dnd_data/README.md` (ouverture de la base, import de pack, enregistrement d'un personnage, migrations) et section Commandes de CLAUDE.md (génération Drift, instantané de schéma, test d'intégration) ; vérifier que chaque commande documentée s'exécute
- [ ] 9.2 `fvm exec melos run format`, `analyze`, `test`, `coverage` et `schema:check` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello US-04 à l'ouverture de la PR ; carte dans « Fait » après la fusion.
- `openspec archive us-04-schema-drift-v1` après la fusion.
