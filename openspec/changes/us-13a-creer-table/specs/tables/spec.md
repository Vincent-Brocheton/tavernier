## ADDED Requirements

### Requirement: Création d'une table
Un MJ connecté SHALL créer une table avec un nom, une description, un niveau de départ de 1 à 20, une méthode de caractéristiques, une règle de repos long, un mode de PV à la montée de niveau et une progression en PX ou en jalons (EF-TAB-01 à 03, EF-TAB-10). Le pack SRD SHALL y être actif (EF-TAB-04).

#### Scenario: Création
- **WHEN** le MJ remplit le nom et crée la table
- **THEN** la table existe avec ses réglages, il en est le MJ et membre, et le pack SRD y est actif

#### Scenario: Nom obligatoire
- **WHEN** le nom est vide
- **THEN** « Créer la table » est désactivé

#### Scenario: Hors ligne
- **WHEN** le MJ crée une table sans réseau
- **THEN** elle apparaît dans sa liste et part au serveur à la reconnexion

### Requirement: Liste des tables
L'onglet Tables SHALL lister, à un utilisateur connecté, les tables dont il est MJ ou membre, et proposer « Nouvelle table ».

#### Scenario: Après création
- **WHEN** le MJ revient à l'onglet Tables
- **THEN** sa nouvelle table y figure avec le rôle « MJ »
