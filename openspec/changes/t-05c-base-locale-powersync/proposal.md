# Proposal

## Why

Carte Trello [T-05](https://trello.com/c/DouzMTWV), troisième change. Le service PowerSync et ses règles tournent (t-05b), et l'instance hébergée (UE) est en ligne. L'app doit maintenant ouvrir sa base locale par PowerSync, qui tient la copie locale des tables synchronisées. Ce change s'arrête à la base locale : sans réseau ni compte, l'app doit faire tout ce qu'elle fait en M1. La connexion à Supabase et la synchronisation entre appareils viennent au change suivant.

## What Changes

- **Base locale par PowerSync** sur toutes les plateformes. Drift reste l'outil d'accès (`drift_sqlite_async`), PowerSync remplace le moteur. Sur le Web, ses fichiers (`sqlite3.wasm`, `powersync_db.worker.js`) remplacent ceux de Drift.
- **Tables synchronisées** (profil, tables de jeu, personnage et son contenu) : PowerSync les crée lui-même sous forme de vues, à partir d'un schéma dérivé des tables Drift. Drift ne crée que les autres : contenu de règles, recherche, données de M3.
- **Écritures compatibles avec les vues :**
  - plus d'`INSERT … ON CONFLICT` sur ces tables, mais une mise à jour puis une insertion ;
  - liste des personnages triée par `id` (UUID v7) au lieu de `rowid` ;
  - dates stockées en texte ISO 8601, comme les transporte PowerSync.
- **Intégrité :** sur les tables synchronisées, plus de clés étrangères locales (des vues n'en portent pas). Le serveur refuse les orphelins, et l'app supprime elle-même les lignes dépendantes.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `local-database` : moteur PowerSync, tables synchronisées en vues, intégrité et stockage Web.

## Impact

- `packages/dnd_data` : dépendances `powersync` et `drift_sqlite_async`, schéma PowerSync, migration, `CharacterStore`, tests.
- `apps/game_table` : ouverture de la base, fichiers Web, service worker, tests d'intégration.
- Pas de changement du schéma Supabase.

**Hors périmètre :**
- **Connexion à Supabase**, envoi des écritures et tests de fusion entre appareils : change suivant (lot 3b).
- **Comptes et écrans de connexion :** US-39, US-40, US-12.
- **Fichier de la base existante :** non repris. Aucune version n'est publiée, et les données de test locales sont perdues à la mise à jour.
