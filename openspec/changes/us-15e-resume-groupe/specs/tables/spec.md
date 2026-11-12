## ADDED Requirements

### Requirement: Résumé du groupe
La vue d'ensemble d'une table SHALL montrer les autres PJ : nom, espèce, classes et niveaux, état de santé qualitatif avec icône et libellé, sans PV chiffrés (EF-TAB-09). Quand le MJ a ouvert les fiches complètes, toucher un PJ SHALL ouvrir sa fiche en lecture seule.

#### Scenario: Blessé
- **WHEN** Thalia a 20 PV sur 33
- **THEN** le groupe affiche Thalia « Blessé », sans chiffres

#### Scenario: Fiches fermées
- **WHEN** le MJ n'a pas ouvert les fiches complètes
- **THEN** toucher un PJ du groupe n'ouvre rien
