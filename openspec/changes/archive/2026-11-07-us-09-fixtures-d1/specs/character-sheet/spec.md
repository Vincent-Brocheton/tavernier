## ADDED Requirements

### Requirement: Attaques par action
La fiche SHALL exposer le nombre d'attaques par action, sans cumul entre classes.

#### Scenario: Aldric niveau 5
- **WHEN** la fiche d'Aldric niveau 5 est calculée
- **THEN** il a 2 attaques par action

#### Scenario: Deux classes
- **WHEN** un personnage est Guerrier 5 / Paladin 5
- **THEN** il a toujours 2 attaques par action

### Requirement: Avantage aux compétences
La fiche SHALL lister les compétences testées avec Avantage.

#### Scenario: Athlète accompli
- **WHEN** la fiche d'Aldric niveau 5 est calculée
- **THEN** Athlétisme est testé avec Avantage

### Requirement: Attaque sournoise
La fiche SHALL exposer les dés d'Attaque sournoise.

#### Scenario: Thalia
- **WHEN** la fiche de Thalia, Roublarde 5, est calculée
- **THEN** son Attaque sournoise vaut 3d6
