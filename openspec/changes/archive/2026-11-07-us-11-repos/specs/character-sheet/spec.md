## ADDED Requirements

### Requirement: Repos court
Un repos court SHALL permettre de dépenser des dés de vie, puis récupérer les ressources de repos court. Il SHALL demander au moins 1 PV.

#### Scenario: Dé de vie
- **WHEN** Aldric, CON +3, dépense un d10 et obtient 7
- **THEN** il récupère 10 PV et il lui reste un dé de moins

#### Scenario: Minimum
- **WHEN** le dé et la CON donnent moins de 1
- **THEN** il récupère 1 PV

#### Scenario: Maximum
- **WHEN** le soin dépasse son maximum
- **THEN** ses PV s'arrêtent à ce maximum

#### Scenario: Une utilisation
- **WHEN** Second souffle est à 2 / 3
- **THEN** il passe à 3 / 3

#### Scenario: Pacte
- **WHEN** un Occultiste termine un repos court
- **THEN** ses emplacements de pacte reviennent

#### Scenario: Emplacements ordinaires
- **WHEN** un Clerc termine un repos court
- **THEN** ses emplacements ne reviennent pas

#### Scenario: 0 PV
- **WHEN** un personnage est à 0 PV
- **THEN** le repos est bloqué

### Requirement: Repos long
Un repos long SHALL rendre PV, dés de vie, emplacements et ressources, et retirer un niveau d'Épuisement, selon la règle de la table.

#### Scenario: Récupération totale
- **WHEN** Aldric termine un repos long
- **THEN** il est à son maximum de PV et de dés de vie

#### Scenario: Épuisement
- **WHEN** il a 2 niveaux d'Épuisement
- **THEN** il lui en reste 1

#### Scenario: Règle par dés de vie
- **WHEN** la table a choisi la récupération par dépense de dés de vie
- **THEN** ses dés reviennent, pas ses PV

#### Scenario: Concentration
- **WHEN** il termine un repos long en se concentrant
- **THEN** sa concentration prend fin

### Requirement: Suivi des PV et des ressources
La fiche SHALL montrer les PV actuels et permettre de dépenser une ressource de classe.

#### Scenario: PV actuels
- **WHEN** Aldric perd 3 PV
- **THEN** la fiche montre 46 / 49

#### Scenario: Ressource
- **WHEN** il utilise Second souffle
- **THEN** il en reste 2 sur 3
