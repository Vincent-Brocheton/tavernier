## ADDED Requirements

### Requirement: Fiche en attente de validation, jouable
La fiche envoyée au MJ ou à corriger SHALL rester modifiable par son propriétaire (EF-PJ-20). Pour lui, elle SHALL afficher en tête le bandeau « En attente de validation par <MJ> · utilisable en jeu », qui rappelle que les corrections ne font perdre ni PV ni emplacements. Une fiche à corriger SHALL montrer en plus le commentaire du MJ.

#### Scenario: Fiche envoyée
- **WHEN** Léo ouvre Kael, envoyée à Camille
- **THEN** il lit « En attente de validation par Camille · utilisable en jeu », et peut toujours modifier ses PV

#### Scenario: Fiche à corriger
- **WHEN** Camille a demandé « Remplacer Sommeil »
- **THEN** Léo lit « Corrections demandées » et « Remplacer Sommeil » sous le bandeau

#### Scenario: Fiche validée
- **WHEN** la fiche est validée
- **THEN** aucun bandeau d'attente ne s'affiche

#### Scenario: Fiche vue par le MJ
- **WHEN** Camille ouvre la fiche envoyée de Kael
- **THEN** le bandeau d'attente ne s'affiche pas
