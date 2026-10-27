## ADDED Requirements

### Requirement: Classes du SRD, lot 3
Le pack SRD SHALL contenir le Moine, l'Occultiste, le Paladin, le Rôdeur et le Roublard. Chacun SHALL avoir :
- ses traits de base ;
- sa table de progression sur 20 niveaux ;
- sa sous-classe du SRD ;
- une aptitude par entrée « Niveau N : … », avec le texte copié du PDF ;
- les effets prévus par l'inventaire des aptitudes.

#### Scenario: Moine (SRD p. 64)
- **WHEN** on lit `srd:class:monk`
- **THEN** son dé d'Arts martiaux vaut 6 au niveau 1 et 12 au niveau 20, et son Déplacement sans armure vaut 10 pieds au niveau 2 et 30 pieds au niveau 18

#### Scenario: Magie de pacte (SRD p. 68)
- **WHEN** on lit la table de l'Occultiste aux niveaux 1, 13 et 17
- **THEN** il a 1 emplacement de niveau 1, puis 3 emplacements de niveau 5, puis 4 emplacements de niveau 5

#### Scenario: Attaque sournoise (SRD p. 84)
- **WHEN** on lit la table du Roublard aux niveaux 1 et 19
- **THEN** l'Attaque sournoise compte 1 dé puis 10 dés

#### Scenario: Imposition des mains (SRD p. 75)
- **WHEN** on lit l'aptitude Imposition des mains
- **THEN** sa réserve vaut 5 fois le niveau de Paladin et se recharge au Repos long

#### Scenario: Demi-lanceurs
- **WHEN** on lit les tables du Paladin et du Rôdeur au niveau 20
- **THEN** leurs emplacements sont 4, 3, 3, 3, 2 du niveau 1 au niveau 5
