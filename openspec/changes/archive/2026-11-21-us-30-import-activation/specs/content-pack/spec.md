## ADDED Requirements

### Requirement: Aperçu d'un import
`inspectImport` SHALL rendre, pour un pack lu, la nature de l'import face aux versions installées :
- nouveau : identifiant inconnu ;
- mise à jour : même identifiant, même clé, version absente ;
- pack distinct : même identifiant, autre clé ;
- déjà installé : même identifiant, même clé, même version.

Il SHALL aussi rendre :
- la validité de la signature ;
- les dépendances manquantes ;
- les problèmes de `validatePack` ;
- les changements depuis la dernière version installée du même auteur ;
- les conflits de noms avec les autres packs.

#### Scenario: Autre auteur
- **WHEN** un pack de même identifiant qu'un pack installé est signé par une autre clé
- **THEN** l'import est un pack distinct

### Requirement: Changer l'identité d'un pack
`rebrandPack` SHALL donner à un pack un nouvel identifiant, un nouvel espace de noms et un nouveau nom, et réécrire chaque identifiant d'entité et chaque référence à l'ancien espace de noms. Les références vers d'autres packs ne changent pas. La signature et la clé d'auteur sont retirées : le pack obtenu n'est plus celui de l'auteur.

#### Scenario: Références suivies
- **WHEN** un pack `gardiens` dont la sous-classe cite `gardiens:feature:rempart` et `srd:class:fighter` prend l'espace de noms `gardiens-karl`
- **THEN** la sous-classe cite `gardiens-karl:feature:rempart` et toujours `srd:class:fighter`
