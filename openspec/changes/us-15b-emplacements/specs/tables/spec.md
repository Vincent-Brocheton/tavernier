## ADDED Requirements

### Requirement: Emplacements de PJ
Le MJ SHALL pouvoir attribuer un ou plusieurs emplacements de PJ à un membre de la table, et retirer un emplacement vide. L'onglet Membres SHALL montrer chaque emplacement avec le nom et le statut de sa fiche.

#### Scenario: Attribution
- **WHEN** le MJ attribue un emplacement à Hugo
- **THEN** l'emplacement apparaît sous Hugo, « emplacement libre »

#### Scenario: Fiche en cours
- **WHEN** Hugo a créé Aldric dans son emplacement
- **THEN** la ligne affiche « Aldric Varenne (en création) »

### Requirement: Mon personnage
Le joueur SHALL voir ses emplacements dans la vue d'ensemble de la table : « Créer ma fiche » pour un emplacement vide, sinon le nom et le statut de la fiche. Il SHALL pouvoir envoyer au MJ une fiche en création ou à corriger, une fois au niveau de départ de la table, et reprendre une fiche envoyée.

#### Scenario: Envoi
- **WHEN** la fiche est au niveau de départ et le joueur appuie sur « Envoyer au MJ »
- **THEN** la fiche passe « à valider »

#### Scenario: Niveau de départ non atteint
- **WHEN** la table démarre au niveau 3 et la fiche est au niveau 1
- **THEN** « Envoyer au MJ » est inactif, avec le rappel du niveau à atteindre
