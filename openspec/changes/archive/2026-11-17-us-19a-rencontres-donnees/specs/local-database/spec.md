## ADDED Requirements

### Requirement: Rencontres stockées
La base locale SHALL garder les rencontres et leurs groupes dans des tables synchronisées (`encounter`, `encounter_group`). `EncounterStore` SHALL :
- créer, modifier, dupliquer et supprimer une rencontre ;
- suivre les rencontres d'une table avec leurs groupes, dans l'ordre de leur position puis de leur création ;
- ajouter, modifier et retirer un groupe.

Ajouter une référence déjà présente dans la rencontre SHALL augmenter la quantité de son groupe. Dupliquer SHALL créer « <titre> (copie) » en brouillon, dans la même séance, avec les mêmes groupes et le même mode de PV.

#### Scenario: Ajout d'adversaires
- **WHEN** le MJ ajoute deux fois le loup sanguinaire et une fois l'ogre au « Relais du Sel »
- **THEN** la rencontre a 2 loups sanguinaires puis 1 ogre, dans l'ordre d'ajout

#### Scenario: Duplication
- **WHEN** le MJ duplique « Le relais du Sel », prête, en jet de PV
- **THEN** « Le relais du Sel (copie) » est en brouillon, en jet de PV, avec les mêmes groupes

#### Scenario: Suppression
- **WHEN** le MJ supprime une rencontre
- **THEN** ses groupes disparaissent avec elle
