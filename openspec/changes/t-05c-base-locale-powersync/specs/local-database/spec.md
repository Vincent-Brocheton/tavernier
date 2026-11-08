## ADDED Requirements

### Requirement: Base locale PowerSync
La base locale SHALL être ouverte par PowerSync sur chaque plateforme. Les tables de données de jeu synchronisées (cahier §11.2) SHALL être celles de PowerSync, et leur schéma SHALL être dérivé des tables Drift.

#### Scenario: Tables synchronisées
- **WHEN** la base est ouverte pour la première fois
- **THEN** `character` et ses tables de contenu sont des vues PowerSync, et les tables du contenu de règles des tables ordinaires

#### Scenario: Écriture hors ligne
- **WHEN** un personnage est enregistré sans connexion
- **THEN** il se relit à l'identique et l'écriture attend dans la file d'envoi

## MODIFIED Requirements

### Requirement: Intégrité référentielle
La base SHALL refuser une ligne de contenu de règles qui cite un parent absent (clés étrangères actives), et supprimer en cascade les lignes dépendantes d'un pack supprimé. Sur les tables synchronisées, le serveur SHALL refuser les orphelins à l'envoi, et l'application SHALL supprimer elle-même les lignes dépendantes.

#### Scenario: Niveau de classe orphelin
- **WHEN** un niveau de classe est envoyé au serveur pour un personnage inexistant
- **THEN** le serveur le refuse

#### Scenario: Suppression d'un personnage
- **WHEN** un personnage est supprimé
- **THEN** ses valeurs de base, niveaux de classe, dons, bottes, objets, langues, choix et son état de jeu sont supprimés avec lui

### Requirement: Stockage Web
Sur le Web, la base SHALL utiliser OPFS quand le navigateur le permet, et SHALL basculer seule sur IndexedDB sinon, sans perte de fonction (cahier §10.1, §14.1), que la page soit isolée ou non.

#### Scenario: Page isolée sur Chrome
- **WHEN** la base est ouverte dans Chrome avec les en-têtes COOP/COEP
- **THEN** le test d'intégration réussit

#### Scenario: Page non isolée
- **WHEN** la base est ouverte sans ces en-têtes
- **THEN** le test d'intégration réussit aussi

### Requirement: Liste des personnages
`CharacterStore` SHALL lister les personnages enregistrés, du plus ancien au plus récent, dans l'ordre de leurs identifiants UUID v7.

#### Scenario: Deux personnages
- **WHEN** deux personnages sont enregistrés
- **THEN** la liste les rend avec leur identifiant, le plus ancien d'abord
