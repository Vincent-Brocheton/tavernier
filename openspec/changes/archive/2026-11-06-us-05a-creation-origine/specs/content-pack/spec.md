## ADDED Requirements

### Requirement: Caractéristique principale au choix
Une classe SHALL pouvoir déclarer que l'une de ses caractéristiques principales suffit (`primary_abilities_any`). Par défaut, toutes sont requises.

#### Scenario: Guerrier (SRD p. 56)
- **WHEN** on lit `srd:class:fighter`
- **THEN** `primary_abilities_any` est vrai

#### Scenario: Moine (SRD p. 64)
- **WHEN** on lit `srd:class:monk`
- **THEN** `primary_abilities_any` est faux
