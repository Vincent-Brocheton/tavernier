## ADDED Requirements

### Requirement: Création contrainte par la table
Ouverte depuis un emplacement, la création SHALL imposer la méthode de caractéristiques de la table, sans choix, n'autoriser qu'un seul « Lancer » en génération aléatoire, et rattacher le personnage enregistré à la table et à l'emplacement.

#### Scenario: Méthode imposée
- **WHEN** la table impose les valeurs standard
- **THEN** l'étape Caractéristiques montre « Méthode imposée par la table : Valeurs standard », sans autre choix

#### Scenario: Un seul lancer
- **WHEN** le joueur a lancé les dés dans une table en génération aléatoire
- **THEN** « Lancer » n'est plus proposé

#### Scenario: Rattachement
- **WHEN** le joueur enregistre son personnage
- **THEN** la fiche porte la table et remplit l'emplacement
