## ADDED Requirements

### Requirement: Termes cliquables
Dans les aptitudes et les sorts, un terme de règle SHALL ouvrir sa définition sans quitter la fiche.

#### Scenario: Désavantage
- **WHEN** une aptitude cite Désavantage et que le joueur le touche
- **THEN** la feuille montre sa définition du SRD

#### Scenario: État
- **WHEN** un sort cite À terre
- **THEN** le terme ouvre le texte de l'état

#### Scenario: Minuscule
- **WHEN** un texte contient « un avantage certain »
- **THEN** aucun lien n'apparaît

#### Scenario: Lecteur d'écran
- **WHEN** un lecteur d'écran passe sur le terme
- **THEN** il annonce un lien « Désavantage, définition »
