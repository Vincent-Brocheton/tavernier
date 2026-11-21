## ADDED Requirements

### Requirement: Fichiers de packs par version
La table locale `pack_file` (schéma v10, non synchronisée) SHALL garder chaque version importée d'un pack, telle que reçue :
- identifiant local et identifiant source ;
- version, espace de noms et nom dans la bibliothèque ;
- clé de l'auteur, empreinte, fichier ;
- renommages.

`PackLibrary.install` SHALL y écrire la version, et mettre les tables de contenu à cette version si c'est la plus récente de ce pack. Les versions précédentes SHALL rester lisibles par `PackLibrary.version`.

#### Scenario: Deux versions
- **WHEN** la 0.1.0 puis la 0.2.0 d'un pack sont installées
- **THEN** les tables de contenu portent la 0.2.0, et la 0.1.0 se relit telle qu'importée

#### Scenario: Pack distinct
- **WHEN** un pack d'un autre auteur est installé sous l'espace de noms `gardiens-karl`
- **THEN** les tables de contenu portent ses entités sous cet espace de noms, à côté de celles du pack d'origine

### Requirement: Empreinte d'un pack de table
Le schéma v11 SHALL garder l'empreinte du fichier d'un pack activé sur une table (`table_pack.file_sha256`). `TableStore` SHALL :
- activer un pack sur une table, à une version et avec une empreinte, ou changer sa version ;
- le retirer ;
- suivre les packs actifs de toutes mes tables.

#### Scenario: Activer puis changer de version
- **WHEN** un pack est activé en 0.1.0 sur une table, puis passé en 0.2.0
- **THEN** la table n'a qu'une ligne pour ce pack, en 0.2.0, avec l'empreinte de la 0.2.0

### Requirement: Entités bannies d'une table
`TableStore` SHALL bannir et rétablir une entité pour une table (une ligne de `table_banned_entity` par entité et par table), et suivre les entités bannies d'une table.

#### Scenario: Bannir deux fois
- **WHEN** Sommeil est banni deux fois, puis rétabli
- **THEN** la table n'a eu qu'une ligne pour Sommeil, puis aucune

### Requirement: Références de contenu d'une fiche
`CharacterStore` SHALL lire et écrire les références de contenu d'une fiche (`character_content_ref`). Il SHALL inscrire le choix du joueur, migrer ou garder, dans `character_change_log`, et lister les fiches d'une table qui utilisent des entités données d'un pack.

#### Scenario: Migrer
- **WHEN** le joueur migre une entité vers 0.2.0
- **THEN** la référence porte 0.2.0 et le nouvel instantané, et le journal a une ligne `content_update` avec le choix
