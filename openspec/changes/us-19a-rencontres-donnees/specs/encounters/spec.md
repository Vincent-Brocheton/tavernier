## ADDED Requirements

### Requirement: Budget de PX d'une rencontre
Le moteur SHALL donner, pour chaque niveau de 1 à 20, les seuils Faible, Modérée et Élevée de la table « Budget de PX par personnage » du SRD. Le budget d'une rencontre SHALL être la somme des seuils de chaque personnage présent, selon son niveau.

#### Scenario: Quatre PJ de niveau 5 ([D1])
- **WHEN** Aldric, Mira, Thalia et Brannoc, tous de niveau 5, sont présents
- **THEN** le budget est Faible 2 000, Modérée 3 000, Élevée 4 400

#### Scenario: Niveaux mêlés
- **WHEN** trois PJ de niveau 5 et Kael, de niveau 3, sont présents
- **THEN** le budget est Faible 1 650, Modérée 2 475, Élevée 3 700

#### Scenario: Niveau 20
- **WHEN** un seul PJ de niveau 20 est présent
- **THEN** le budget est Faible 6 400, Modérée 13 200, Élevée 22 000

### Requirement: Difficulté d'une rencontre
La difficulté SHALL être le plus haut seuil que les PX des adversaires atteignent : Élevée, Modérée ou Faible ; sous le seuil Faible, la rencontre SHALL être « sous le budget faible ».

#### Scenario: Le relais du Sel ([D1])
- **WHEN** 3 000 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est Modérée

#### Scenario: Embuscade sur la route ([D1])
- **WHEN** 300 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est sous le budget faible

#### Scenario: Seuils au niveau 1 ([D1])
- **WHEN** quatre PJ de niveau 1 affrontent 300 PX, puis 200 PX d'adversaires
- **THEN** la première rencontre est Modérée, la seconde Faible

#### Scenario: Au-delà d'Élevée
- **WHEN** 5 000 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est Élevée
