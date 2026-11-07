## ADDED Requirements

### Requirement: PV et Épuisement dans l'état de jeu
Le dépôt SHALL écrire et relire les PV actuels et l'Épuisement d'un personnage.

#### Scenario: Relecture
- **WHEN** un état avec des PV et de l'Épuisement est enregistré puis relu
- **THEN** ces valeurs sont identiques

#### Scenario: Personnage indemne
- **WHEN** aucun PV n'a été enregistré
- **THEN** les PV actuels sont vides, soit le maximum
