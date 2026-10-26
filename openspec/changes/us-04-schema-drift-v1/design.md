# Design

## Context

`dnd_data` est vide. `dnd_content` fournit `ContentPack`, `ContentEntity` et les données typées des 16 types d'entités ; `dnd_rules` fournit `CharacterInput`. Le pack SRD de l'échantillon (188 entités) et la fixture d'Aldric niveau 1 existent et servent de jeux de test. Motivation et périmètre : proposal.md. PowerSync (M2) impose qu'une table synchronisée ait une clé primaire `id` unique de type texte.

## Goals / Non-Goals

**Goals:**
- Un schéma Drift unique, du contenu aux données de jeu, que M1 à M3 ne feront qu'étendre par migrations.
- Prouver que le schéma normalisé garde tout le contenu et tout le personnage : aller-retour sans perte.

**Non-Goals:**
- Pas de requêtes métier (listes, filtres du compendium, écrans) : elles arrivent avec les cartes qui les utilisent.
- Pas de dépôts réactifs (Riverpod, flux) : M1.

## Decisions

1. **`dnd_data` reste en Dart pur.** La base (`TavernierDatabase`) reçoit un `QueryExecutor` ; l'application fournit celui de la plateforme avec `drift_flutter` (`driftDatabase`, WASM sur le Web), les tests celui de `NativeDatabase.memory()`. Alternative écartée : ouvrir la base dans `dnd_data`, ce qui y ferait entrer Flutter.
2. **Tables en code Dart Drift, FTS5 en SQL.** Les tables sont des classes Drift (types vérifiés, génération) ; la table virtuelle FTS5 `content_search` est déclarée dans un fichier `.drift` (`tokenize = 'unicode61 remove_diacritics 2'`, recherche par préfixe `*`). Elle est alimentée par l'import de pack, pas par des déclencheurs, parce qu'un nom et un texte viennent de tables différentes.
3. **Contenu normalisé (§11.1), choix du porteur de projet.** Une table par type ; les listes fermées sans requête (propriétés d'arme, tailles, maîtrises d'armes d'une classe, colonnes de la table de classe, prérequis d'un don, choix imposés d'un don d'Historique) restent en colonnes JSON. Les effets vont dans `effect(owner_id, position, payload)` et les textes dans `entity_text(entity_id, locale, description)`, comme au §11.1. Chaque table de contenu porte `id`, `pack_id` (clé étrangère, suppression en cascade) et `name`.
4. **Import et export par type.** `PackStore.importPack(ContentPack)` supprime puis réécrit les entités du pack dans une transaction ; `PackStore.exportPack(packId)` reconstruit un `ContentPack`. Un `switch` exhaustif sur `EntityData` (classe scellée) garantit qu'un nouveau type d'entité ne compile pas sans son stockage.
5. **Données de jeu : clé `id` partout.** Toutes les tables du §11.2 ont `id TEXT PRIMARY KEY` ; les tables de liaison gardent leurs colonnes de liaison avec un index d'unicité (ex. `character_base_scores(character_id, ability_id)`). Clés étrangères actives (`PRAGMA foreign_keys = ON` à l'ouverture), suppression en cascade depuis `character` et `content_pack`. Les colonnes JSON du §11.2 (`ressources`, `diff`, `payload`…) restent du texte JSON.
6. **`CharacterStore.save(id, CharacterInput)` / `load(id)`** écrit et relit le personnage dans `character`, `character_base_scores`, `character_background_choice`, `character_class_level`, `character_feat`, `character_weapon_mastery`, `character_item`, `character_language` et `character_choice`. Il ne fait aucun calcul de règles (`dnd_rules` s'en charge à la lecture).
7. **Migrations** : `schemaVersion = 1`, `onCreate` crée tout ; instantané `drift_schemas/tavernier/drift_schema_v1.json` produit par `drift_dev make-migrations`. Un test compare la structure (colonnes, clés étrangères, index) d'une base créée depuis l'instantané à celle d'une base neuve du code : changer une table sans nouvelle version le fait échouer, en local comme en CI. À la version 2, `make-migrations` ajoute les tests de migration pas à pas.
9. **Table `player_class`** au lieu de `class` (§11.1) : `class` est un mot réservé en Dart et casse le générateur d'utilitaires de migration de Drift. Le type d'entité reste `class` (`srd:class:fighter`).
8. **Plateformes** : test d'intégration `apps/game_table/integration_test/database_test.dart` (ouvrir, importer le pack SRD, rechercher, fermer, rouvrir, relire). Web : `flutter drive` sur Chrome, fichiers `web/sqlite3.wasm` (version publiée de sqlite3.dart correspondant au paquet) et `web/drift_worker.js` (compilé localement depuis `tool/drift_worker.dart`) ; Android : émulateur local ; iOS : job GitHub Actions `macos-latest` sur simulateur. Le pack SRD est une ressource de l'application (`assets/packs/srd-5.2.1-fr.dndpack`, ENF-05), lue par `rootBundle` et `readDndpack` ; `srd_builder` (qui dépend de `dart:io`) n'est pas une dépendance de l'app.

## Risks / Trade-offs

- [Schéma normalisé lourd à faire évoluer] → l'aller-retour du pack SRD complet est testé à chaque build : un champ oublié casse le test, pas les données des utilisateurs.
- [SQLite natif absent pour les tests Dart sous Windows] → le paquet `sqlite3` fournit sa bibliothèque ; à défaut, `sqlite3.dll` officiel est ajouté au chemin du test (vérifié dès la tâche 1).
- [Instantané de schéma oublié] → la CI échoue si `drift_schemas` ne correspond plus au code.
- [Émulateur Android absent] → sa création (téléchargement d'environ 1 Go) attend ton accord ; en attendant, Web et iOS (CI) restent vérifiés.

## Open Questions

- Le job iOS de CI tourne sur un runner macOS facturé dix fois plus qu'Ubuntu sur un dépôt privé ; le dépôt étant public, il est gratuit. À revoir si le dépôt devient privé.
