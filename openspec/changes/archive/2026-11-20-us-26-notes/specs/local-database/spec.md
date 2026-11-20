## MODIFIED Requirements

### Requirement: Schéma version 1
Une base neuve SHALL contenir, en version de schéma 5, toutes les tables du contenu de règles (cahier §11.1, plus `language`, `tool`, `feature`, `species_trait`) et des données de jeu (cahier §11.2, plus `character_language`, `character_choice`). La version 2 ajoute la colonne `rule_term.data` (US-24). La version 3 ajoute `combat_view` et `combat_request` (US-36). La version 4 ajoute `group_rest` et `group_rest_done` (US-38). La version 5 ajoute à `note` son titre, sa date de mise à jour et l'autre version d'un conflit (US-26).

#### Scenario: Base neuve
- **WHEN** la base est ouverte pour la première fois
- **THEN** sa version de schéma vaut 5 et chacune des tables attendues existe

### Requirement: Migrations versionnées
Chaque version du schéma SHALL être figée dans un instantané versionné ; un changement de schéma sans nouvelle version et sans migration testée SHALL faire échouer les tests. Chaque étape de migration SHALL ne s'appliquer que jusqu'à la version visée.

#### Scenario: Instantané à jour
- **WHEN** les tests de migration s'exécutent
- **THEN** le schéma produit par le code est identique à l'instantané de la version 5

#### Scenario: Montée de v1 en v2
- **WHEN** une base en version 1 est ouverte
- **THEN** elle monte en version 2 avec la colonne `rule_term.data`, et son schéma est celui de l'instantané v2

#### Scenario: Montée vers v3
- **WHEN** une base en version 1 ou 2 est ouverte
- **THEN** elle monte en version 3, et son schéma est celui de l'instantané v3

#### Scenario: Montée vers v4
- **WHEN** une base en version 1 ou 3 est ouverte
- **THEN** elle monte en version 4, et son schéma est celui de l'instantané v4

#### Scenario: Montée vers v5
- **WHEN** une base en version 1 ou 4 est ouverte
- **THEN** elle monte en version 5, et son schéma est celui de l'instantané v5

### Requirement: Base locale PowerSync
La base locale SHALL être ouverte par PowerSync sur chaque plateforme. Les tables de données de jeu synchronisées (cahier §11.2) SHALL être celles de PowerSync, et leur schéma SHALL être dérivé des tables Drift. Une ancienne table locale `note` (avant la v5) SHALL céder la place à sa vue PowerSync à l'ouverture.

#### Scenario: Tables synchronisées
- **WHEN** la base est ouverte pour la première fois
- **THEN** `character` et ses tables de contenu sont des vues PowerSync, et les tables du contenu de règles des tables ordinaires

#### Scenario: Écriture hors ligne
- **WHEN** un personnage est enregistré sans connexion
- **THEN** il se relit à l'identique et l'écriture attend dans la file d'envoi

#### Scenario: Base d'avant la v5
- **WHEN** une base PowerSync dont `note` est une table locale est rouverte
- **THEN** `note` devient une vue PowerSync, où une note s'écrit et se relit

## ADDED Requirements

### Requirement: Notes en base
`NoteStore` SHALL écrire une note privée, la modifier (titre, texte, rattachement, partage), fusionner un conflit, la supprimer, et suivre les notes qu'un utilisateur voit : les siennes et celles partagées, d'une table s'il y a lieu, la plus récente d'abord. Les valeurs qu'une modification de note remplace SHALL partir avec elle (EF-NOT-06).

#### Scenario: Partage
- **WHEN** Hugo partage sa note « Dette envers Brug »
- **THEN** Camille la voit avec ses propres notes, et la note privée de Camille reste invisible pour Hugo

#### Scenario: Fusion
- **WHEN** une note porte l'autre version d'un conflit, et son auteur enregistre le texte fusionné
- **THEN** la note porte ce texte, sans conflit
