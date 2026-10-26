# Proposal

## Why

L'application est offline-first : chaque appareil porte une base SQLite complète, source de vérité locale (cahier §10). M1 a besoin de cette base pour enregistrer les personnages hors-ligne, M2 pour la synchroniser. `dnd_data` est encore vide. Le schéma v1 fige le modèle de données du cahier (§11.1 et §11.2), donc une décision difficile à défaire une fois des données d'utilisateurs stockées.

Carte Trello : [US-04 · Schéma Drift v1 et migrations](https://trello.com/c/DC8WrHf6/26-us-04-sch%C3%A9ma-drift-v1-et-migrations). Exigences : US-04 (« Base créée sur Web, Android, iOS ; FTS5 opérationnel »), ENF-01, ENF-06, ENF-13, cahier §10.1, §11.1, §11.2.

## What Changes

- Base Drift `TavernierDatabase` (schéma version 1) dans `dnd_data`, avec toutes les tables du cahier :
  - **contenu de règles (§11.1), normalisé** : une table par type d'entité (caractéristiques, compétences, Historiques et leurs caractéristiques, maîtrises et équipements, dons, espèces, classes et niveaux de classe, sous-classes, sorts, objets, armes, armures, propriétés de botte, états, types de dégâts, monstres et actions, révélations d'Étude, effets, textes) ;
  - **données de jeu (§11.2)** : profil, tables de jeu, membres, invitations, packs actifs, entités bannies, personnage et ses tables `character_*`, profils de PNJ, séances, rencontres, combattants, événements de combat, notes, identités d'auteur.
- Compléments au §11.1, nécessaires au format de pack validé (`docs/packs/FORMAT_DNDPACK.md`) : tables `language`, `tool` et `feature` (aptitudes de classe, de sous-classe et traits d'espèce), lien espèce → traits. Compléments au §11.2 pour stocker tout `CharacterInput` : langues et choix du personnage.
- **Import et export de pack** : un pack (`ContentPack`) s'écrit dans les tables normalisées et se relit à l'identique ; le pack SRD de l'échantillon sert de test.
- **Recherche plein texte FTS5** sur le nom et le texte des entités de contenu (compendium hors-ligne), insensible aux accents.
- **Enregistrement d'un personnage** : un `CharacterInput` s'écrit dans les tables `character_*` et se relit à l'identique ; Aldric niveau 1 sert de test.
- **Migrations versionnées** : instantané du schéma v1 et harnais de test de migration, prêts pour la v2.
- **Plateformes** : ouverture de la base dans l'application sur Web (SQLite WASM) et Android, vérifiée par un test d'intégration ; iOS vérifié par un job de CI macOS.

Hors périmètre :
- Couche de dépôts unique et UUID v7 générés à l'écriture : M1 (première carte qui écrit depuis l'application). Ici, les identifiants sont fournis par l'appelant.
- Synchronisation PowerSync et règles côté serveur : M2. Le schéma est seulement rendu compatible (voir design).
- Index FTS5 des notes (EF-NOT-03) : M3, par migration.
- Mesures de performance et de persistance du Web (10 000 entités, Safari, OPFS / IndexedDB) : carte T-01.

## Capabilities

### New Capabilities
- `local-database`: base SQLite locale de l'appareil — schéma du contenu de règles et des données de jeu, import et export de packs, recherche plein texte, enregistrement des personnages, migrations versionnées, ouverture sur chaque plateforme.

### Modified Capabilities
_(aucune : `character-sheet` n'est pas modifiée ; le personnage stocké reste celui de `CharacterInput`)_

## Impact

- `packages/dnd_data` : nouveau code Drift (tables, base, import/export, magasin de personnages), dépendances `drift`, `drift_dev`, `build_runner`, `sqlite3` ; dépend de `dnd_content` et `dnd_rules` (types `ContentPack`, `CharacterInput`).
- `apps/game_table` : ouverture de la base (`drift_flutter`), fichiers Web `sqlite3.wasm` et worker Drift, test d'intégration.
- CI : jobs supplémentaires (test d'intégration Web, simulateur iOS sur runner macOS).
- **Écart au cahier §11.1 à valider** : tables `language`, `tool`, `feature`, `species_trait` ajoutées ; `class_level.columns` (JSON) regroupe `weapon_mastery_count`, `spell_slots` et les autres colonnes de la table de classe. **Écart au §11.2** : chaque table synchronisable a une clé primaire `id` unique (contrainte de PowerSync, retenu en M2) ; tables `character_language` et `character_choice` ajoutées.
- Prérequis machine : un émulateur Android (image système d'environ 1 Go à télécharger, avec ton accord) et deux fichiers Web officiels de `sqlite3.dart` / `drift`.
