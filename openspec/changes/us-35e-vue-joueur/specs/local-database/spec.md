## ADDED Requirements

### Requirement: Gains d'une séance
`CharacterStore.watchSessionGains(sessionId)` SHALL suivre les entrées d'historique des fiches qui ajoutent des PX ou accordent un niveau à la clôture de cette séance, et seulement celles-là.

#### Scenario: Deux séances
- **WHEN** Aldric gagne 825 PX à la séance 12 et 10 PX à la séance 11
- **THEN** les gains de la séance 12 ne portent que les 825 PX d'Aldric
