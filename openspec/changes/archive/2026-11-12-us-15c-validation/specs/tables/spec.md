## ADDED Requirements

### Requirement: Validation d'une fiche par le MJ
Le MJ SHALL voir chaque fiche envoyée dans un panneau « Fiche à valider », avec ses contrôles (méthode, niveau de départ, intégrité) et le message du joueur. Il SHALL pouvoir la valider, ou demander des corrections avec un commentaire obligatoire. Le joueur SHALL voir ce commentaire sur sa fiche à corriger.

#### Scenario: Validation
- **WHEN** le MJ valide une fiche envoyée
- **THEN** elle passe « validée » et quitte le panneau

#### Scenario: Corrections sans commentaire
- **WHEN** le commentaire est vide
- **THEN** « Demander des corrections » est inactif

#### Scenario: Commentaire lu par le joueur
- **WHEN** le MJ demande des corrections avec un commentaire
- **THEN** le joueur lit ce commentaire dans « Mon personnage »

### Requirement: Transfert d'un PJ
Le MJ SHALL pouvoir transférer un emplacement rempli, et sa fiche, à un autre membre de la table.

#### Scenario: Transfert
- **WHEN** le MJ transfère l'emplacement d'Aldric de Hugo à Inès
- **THEN** l'emplacement apparaît sous Inès, et la fiche est à elle
