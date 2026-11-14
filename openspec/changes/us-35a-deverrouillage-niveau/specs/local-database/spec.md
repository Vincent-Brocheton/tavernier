## ADDED Requirements

### Requirement: Niveau accordé et montée dans l'historique
Accorder ou débloquer un niveau SHALL écrire `character.level_unlock` : niveau, origine (`milestone` ou `override`), auteur, motif, et séance s'il y en a une. Ce choix SHALL aussi être inscrit dans l'historique de la fiche. Une montée de niveau SHALL être inscrite dans l'historique, avec le niveau atteint et l'origine de son déverrouillage, sans validation du MJ.

#### Scenario: Jalon inscrit
- **WHEN** le MJ accorde le niveau 6 à Aldric avec un motif
- **THEN** `level_unlock` vaut `{level: 6, origin: milestone, by, reason}` et l'historique a une entrée « niveau accordé »

#### Scenario: Montée inscrite
- **WHEN** Aldric monte au niveau 6
- **THEN** l'historique a une entrée « montée au niveau 6 » qui cite le jalon
