## MODIFIED Requirements

### Requirement: Schéma version 1
Une base neuve SHALL contenir, en version de schéma 2, toutes les tables du contenu de règles (cahier §11.1, plus `language`, `tool`, `feature`, `species_trait`) et des données de jeu (cahier §11.2, plus `character_language`, `character_choice`). La version 2 ajoute la colonne `rule_term.data` (US-24).

#### Scenario: Base neuve
- **WHEN** la base est ouverte pour la première fois
- **THEN** sa version de schéma vaut 2 et chacune des tables attendues existe

### Requirement: Migrations versionnées
Chaque version du schéma SHALL être figée dans un instantané versionné ; un changement de schéma sans nouvelle version et sans migration testée SHALL faire échouer les tests.

#### Scenario: Instantané à jour
- **WHEN** les tests de migration s'exécutent
- **THEN** le schéma produit par le code est identique à l'instantané de la version 2

#### Scenario: Montée de v1 en v2
- **WHEN** une base en version 1 est ouverte
- **THEN** elle monte en version 2 avec la colonne `rule_term.data`, et son schéma est celui de l'instantané v2

## ADDED Requirements

### Requirement: Tables d'une règle en base
L'import d'un pack SHALL garder les tables d'une entité `rule` (`rule_term.data`, JSON), et l'export SHALL les rendre à l'identique.

#### Scenario: Aller-retour du pack SRD
- **WHEN** le pack SRD est importé puis exporté
- **THEN** `srd:rule:study` et `srd:rule:influence` gardent leurs tables
