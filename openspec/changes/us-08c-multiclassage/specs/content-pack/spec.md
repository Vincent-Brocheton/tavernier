## ADDED Requirements

### Requirement: Traits de multiclassage d'une classe
Une classe SHALL pouvoir porter un bloc `multiclass` : armes, armures, outils d'office, nombre de compétences et d'instruments à choisir.

#### Scenario: Pack SRD
- **WHEN** le pack SRD est lu
- **THEN** chaque classe porte les traits de son encadré « En tant que personnage multiclassé »

#### Scenario: Bloc absent
- **WHEN** une classe de pack n'a pas ce bloc
- **THEN** elle n'accorde que son dé de vie à un personnage multiclassé
