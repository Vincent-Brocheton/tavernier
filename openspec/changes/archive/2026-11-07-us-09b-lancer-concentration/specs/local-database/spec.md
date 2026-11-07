## ADDED Requirements

### Requirement: État de jeu d'un personnage
Le dépôt SHALL écrire et relire les dépenses et la concentration d'un personnage, sans toucher à son entrée stockée.

#### Scenario: Relecture
- **WHEN** un état est enregistré puis relu
- **THEN** ses dépenses et sa concentration sont identiques

#### Scenario: Sans état
- **WHEN** un personnage n'a pas d'état enregistré
- **THEN** son état est vide

#### Scenario: Personnage réenregistré
- **WHEN** le personnage est enregistré après une montée de niveau
- **THEN** son état de jeu ne change pas
