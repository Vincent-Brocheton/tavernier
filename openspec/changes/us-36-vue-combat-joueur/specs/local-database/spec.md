## MODIFIED Requirements

### Requirement: Schéma version 1
Une base neuve SHALL contenir, en version de schéma 3, toutes les tables du contenu de règles (cahier §11.1, plus `language`, `tool`, `feature`, `species_trait`) et des données de jeu (cahier §11.2, plus `character_language`, `character_choice`). La version 2 ajoute la colonne `rule_term.data` (US-24). La version 3 ajoute `combat_view` et `combat_request` (US-36).

#### Scenario: Base neuve
- **WHEN** la base est ouverte pour la première fois
- **THEN** sa version de schéma vaut 3 et chacune des tables attendues existe

### Requirement: Migrations versionnées
Chaque version du schéma SHALL être figée dans un instantané versionné ; un changement de schéma sans nouvelle version et sans migration testée SHALL faire échouer les tests.

#### Scenario: Instantané à jour
- **WHEN** les tests de migration s'exécutent
- **THEN** le schéma produit par le code est identique à l'instantané de la version 3

#### Scenario: Montée de v1 en v2
- **WHEN** une base en version 1 est ouverte
- **THEN** elle monte en version 2 avec la colonne `rule_term.data`, et son schéma est celui de l'instantané v2

#### Scenario: Montée vers v3
- **WHEN** une base en version 1 ou 2 est ouverte
- **THEN** elle monte en version 3, et son schéma est celui de l'instantané v3

## ADDED Requirements

### Requirement: Vue du combat et demandes en base
`CombatViewStore` SHALL publier la vue d'une rencontre (sans la réécrire si elle n'a pas changé), la suivre, suivre la plus récente où figure un PJ, et la retirer. `CombatRequestStore` SHALL envoyer une demande, suivre celles d'une rencontre dans l'ordre d'envoi et retirer une demande appliquée. Sous PowerSync, ces tables SHALL être synchronisées.

#### Scenario: Vue inchangée
- **WHEN** la même vue est publiée deux fois
- **THEN** la seconde n'écrit rien

#### Scenario: Demandes dans l'ordre
- **WHEN** Hugo envoie des dégâts puis des soins
- **THEN** ils se lisent dans cet ordre, et un retrait n'enlève que la demande visée

#### Scenario: Vue d'un PJ
- **WHEN** deux vues sont publiées, l'une avec Aldric, l'autre avec Thalia
- **THEN** la vue suivie pour Aldric est la première, et Mira n'en a aucune

