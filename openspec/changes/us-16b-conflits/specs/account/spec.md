## ADDED Requirements

### Requirement: Conflit dans l'indicateur
L'indicateur de synchronisation SHALL passer à « Conflit résolu » tant qu'un conflit qui a remplacé une valeur de l'utilisateur n'a pas été vu, avant tout autre état.

#### Scenario: Conflit non vu
- **WHEN** un conflit a remplacé une valeur de l'utilisateur et n'a pas été vu
- **THEN** l'indicateur affiche « Conflit résolu »
