## ADDED Requirements

### Requirement: Méthode de caractéristiques
L'étape Caractéristiques SHALL proposer les trois méthodes du SRD : acquisition par points, valeurs standard (15, 14, 13, 12, 10, 8) et génération aléatoire (4d6 sans le plus faible, six fois). La méthode et les jets SHALL être enregistrés avec le personnage.

#### Scenario: Valeurs standard
- **WHEN** le joueur choisit les valeurs standard
- **THEN** les six valeurs sont réparties et l'étape est complète

#### Scenario: Échange
- **WHEN** le joueur donne à la Force la valeur de la Dextérité
- **THEN** la Dextérité reçoit l'ancienne valeur de la Force

#### Scenario: Jets à faire
- **WHEN** le joueur choisit la génération aléatoire sans avoir lancé
- **THEN** l'étape reste bloquée, avec la raison

#### Scenario: Lancer
- **WHEN** le joueur lance les dés
- **THEN** six valeurs de 3 à 18 sont tirées et réparties, la plus haute en Force

#### Scenario: Saisir ses jets
- **WHEN** le joueur saisit six valeurs de 3 à 18
- **THEN** ce sont ses jets ; une valeur hors bornes empêche de valider

#### Scenario: Enregistrement
- **WHEN** un personnage créé par génération aléatoire est enregistré
- **THEN** sa fiche garde la méthode et les jets, et le moteur ne relève aucune erreur
