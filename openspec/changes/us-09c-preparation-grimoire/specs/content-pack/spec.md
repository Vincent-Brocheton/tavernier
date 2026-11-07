## ADDED Requirements

### Requirement: Changement des sorts d'une classe
Une classe SHALL pouvoir porter `prepared_change`.

#### Scenario: Pack SRD
- **WHEN** le pack SRD est lu
- **THEN** le Clerc vaut `long_rest_all`, le Paladin `long_rest_one` et le Barde `level_up_one`
