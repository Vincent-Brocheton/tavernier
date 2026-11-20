## MODIFIED Requirements

### Requirement: Schéma version 1
Une base neuve SHALL contenir, en version de schéma 4, toutes les tables du contenu de règles (cahier §11.1, plus `language`, `tool`, `feature`, `species_trait`) et des données de jeu (cahier §11.2, plus `character_language`, `character_choice`). La version 2 ajoute la colonne `rule_term.data` (US-24). La version 3 ajoute `combat_view` et `combat_request` (US-36). La version 4 ajoute `group_rest` et `group_rest_done` (US-38).

#### Scenario: Base neuve
- **WHEN** la base est ouverte pour la première fois
- **THEN** sa version de schéma vaut 4 et chacune des tables attendues existe

### Requirement: Migrations versionnées
Chaque version du schéma SHALL être figée dans un instantané versionné ; un changement de schéma sans nouvelle version et sans migration testée SHALL faire échouer les tests.

#### Scenario: Instantané à jour
- **WHEN** les tests de migration s'exécutent
- **THEN** le schéma produit par le code est identique à l'instantané de la version 4

#### Scenario: Montée de v1 en v2
- **WHEN** une base en version 1 est ouverte
- **THEN** elle monte en version 2 avec la colonne `rule_term.data`, et son schéma est celui de l'instantané v2

#### Scenario: Montée vers v3
- **WHEN** une base en version 1 ou 2 est ouverte
- **THEN** elle monte en version 3, et son schéma est celui de l'instantané v3

#### Scenario: Montée vers v4
- **WHEN** une base en version 1 ou 3 est ouverte
- **THEN** elle monte en version 4, et son schéma est celui de l'instantané v4

## ADDED Requirements

### Requirement: Repos de groupe en base
`GroupRestStore` SHALL déclencher un repos pour des PJ, le clore, et signaler la fin d'un PJ avec son récapitulatif. Il SHALL suivre les repos ouverts d'une table, le repos ouvert qui attend encore un PJ, et les récapitulatifs d'un repos par PJ. Sous PowerSync, ces tables SHALL être synchronisées.

#### Scenario: Repos suivi
- **WHEN** un repos court est déclenché pour Aldric et Mira, puis Aldric le termine
- **THEN** il n'attend plus que Mira, le récapitulatif d'Aldric se lit, et après la clôture il n'attend plus personne
