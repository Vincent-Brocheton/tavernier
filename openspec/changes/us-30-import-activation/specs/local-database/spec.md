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
