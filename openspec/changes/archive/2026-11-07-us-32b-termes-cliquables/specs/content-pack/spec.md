## ADDED Requirements

### Requirement: Termes de règles
Le pack SHALL pouvoir porter des entités `rule`, avec un texte obligatoire.

#### Scenario: Pack SRD
- **WHEN** le pack SRD est lu
- **THEN** il porte les six termes du glossaire

#### Scenario: Sans texte
- **WHEN** une entité `rule` n'a pas de texte
- **THEN** elle est refusée
