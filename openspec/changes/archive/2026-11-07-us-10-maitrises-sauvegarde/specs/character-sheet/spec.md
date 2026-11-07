## ADDED Requirements

### Requirement: Maîtrises de jets de sauvegarde accordées
Un effet `grant_proficiency` de sorte `saving_throw` SHALL ajouter le bonus de maîtrise au jet de sauvegarde visé.

#### Scenario: Esprit fuyant
- **WHEN** un Roublard atteint le niveau 15
- **THEN** il maîtrise les jets de Sagesse et de Charisme

#### Scenario: Avant le palier
- **WHEN** il est de niveau 14
- **THEN** il ne les maîtrise pas

#### Scenario: Survivant discipliné
- **WHEN** un Moine atteint le niveau 14
- **THEN** il maîtrise les six jets de sauvegarde

#### Scenario: Multiclassage
- **WHEN** un Guerrier prend ensuite un niveau de Roublard
- **THEN** il ne gagne pas les maîtrises de jets du Roublard
