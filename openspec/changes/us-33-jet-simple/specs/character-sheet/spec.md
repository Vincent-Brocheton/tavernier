## ADDED Requirements

### Requirement: Jet simple
Partout où un jet est attendu, l'écran SHALL proposer « Saisir mon jet » et « Lancer », afficher le détail, et laisser le résultat modifiable avant validation.

#### Scenario: Lancer
- **WHEN** le joueur lance 1d10 + 3 et obtient 7
- **THEN** l'écran affiche « d10 7 + 3 = 10 »

#### Scenario: Plusieurs dés
- **WHEN** il lance 2d4 + 2 et obtient 3 et 2
- **THEN** l'écran affiche « 2d4 (3, 2) + 2 = 7 »

#### Scenario: Avantage
- **WHEN** il lance un d20 avec Avantage et obtient 15 et 4
- **THEN** 15 est gardé et 4 est barré

#### Scenario: Jet impossible
- **WHEN** il saisit 11 pour un d10
- **THEN** le jet ne peut pas être validé

#### Scenario: Modification
- **WHEN** il change le résultat lancé avant de valider
- **THEN** sa valeur est retenue
