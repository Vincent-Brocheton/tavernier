## ADDED Requirements

### Requirement: Suggestions
« Suggérer » SHALL préremplir un choix modifiable, avec sa raison en une ligne, et rien ne SHALL s'appliquer sans ce geste.

#### Scenario: Valeurs du Guerrier
- **WHEN** un Guerrier suggère ses valeurs
- **THEN** il obtient 15, 14, 13, 8, 10, 12, soit 27 points

#### Scenario: Bonus d'Historique
- **WHEN** un Soldat suit la suggestion
- **THEN** +2 va à la plus haute valeur éligible et +1 à la suivante

#### Scenario: Toutes les classes
- **WHEN** n'importe quelle classe du SRD suggère ses valeurs
- **THEN** elles coûtent 27 points

#### Scenario: Compétences
- **WHEN** un Roublard suggère ses compétences
- **THEN** celles de Dextérité passent d'abord

#### Scenario: Bottes
- **WHEN** un Guerrier suggère ses bottes
- **THEN** les armes de son équipement de départ passent d'abord

#### Scenario: Amélioration
- **WHEN** Aldric, FOR 18, suggère son don au niveau 6
- **THEN** Amélioration de caractéristique, FOR 18 → 20

#### Scenario: Caractéristique proche du plafond
- **WHEN** sa FOR vaut 19
- **THEN** +1 en FOR et +1 sur sa suivante
