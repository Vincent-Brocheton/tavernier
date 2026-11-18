## ADDED Requirements

### Requirement: Dernier événement annulable
Le moteur SHALL désigner le dernier événement encore effectif du journal, qui n'est ni une annulation ni déjà annulé. « Annuler » le vise ; sans événement effectif, il n'y a rien à annuler.

#### Scenario: Annuler deux fois
- **WHEN** le journal finit par « tour suivant », puis une annulation de ce tour
- **THEN** le dernier événement annulable est celui qui précède le tour annulé
