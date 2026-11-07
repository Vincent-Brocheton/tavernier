## ADDED Requirements

### Requirement: Poids de lanceur d'une classe
Le bloc `multiclass` SHALL pouvoir porter `caster_divisor` : la part des niveaux de la classe comptée dans le niveau de lanceur.

#### Scenario: Pack SRD
- **WHEN** le pack SRD est lu
- **THEN** le Clerc vaut 1, le Paladin 2 et l'Occultiste 0
