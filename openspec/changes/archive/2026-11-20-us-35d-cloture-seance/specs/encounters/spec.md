## ADDED Requirements

### Requirement: PX d'une séance
`sessionXp(awarded)` SHALL rendre, par fiche, la somme des PX accordés à la clôture de chaque rencontre jouée de la séance. Ces PX sont déjà partagés entre les présents de chaque rencontre (EF-SEA-03). Une rencontre sans PX accordés ne compte pas.

#### Scenario: [S4]
- **WHEN** l'embuscade accorde 75 PX à Aldric, Mira, Thalia et Brannoc, et le relais du Sel 750 PX à chacun
- **THEN** chacun gagne 825 PX, et Kael, absent, n'y figure pas
