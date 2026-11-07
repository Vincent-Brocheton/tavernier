## ADDED Requirements

### Requirement: Bonus de points de vie maximum
`modify_hp_max` SHALL ajouter `flat` et `per_level` par niveau de l'effet, avec sa source dans la décomposition.

#### Scenario: Ténacité naine
- **WHEN** la fiche de Brannoc, nain de niveau 5, est calculée
- **THEN** ses PV valent 27, dont 5 de Ténacité naine

#### Scenario: Résistance draconique
- **WHEN** un Ensorceleur draconique de niveau 3 est calculé
- **THEN** l'aptitude ajoute 3 PV

#### Scenario: Résistance draconique, niveau suivant
- **WHEN** il passe au niveau 4
- **THEN** l'aptitude ajoute 4 PV

### Requirement: Vision dans le noir
La fiche SHALL exposer la portée de vision dans le noir en pieds.

#### Scenario: Nain
- **WHEN** la fiche de Brannoc est calculée
- **THEN** sa vision dans le noir vaut 120 pieds

### Requirement: Compétences en Expertise
La fiche SHALL lister les compétences en Expertise.

#### Scenario: Érudition
- **WHEN** la fiche de Brannoc est calculée
- **THEN** Arcanes est en Expertise
