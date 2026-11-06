## ADDED Requirements

### Requirement: Prérequis de multiclassage selon la caractéristique principale
Le prérequis de 13 (SRD p. 26) SHALL porter sur toutes les caractéristiques principales d'une classe, sauf si la classe déclare que l'une suffit.

#### Scenario: Moine à deux caractéristiques
- **WHEN** un personnage se multiclasse en Moine avec 13 en Dextérité et 12 en Sagesse
- **THEN** une erreur de multiclassage est signalée

#### Scenario: Guerrier, l'une ou l'autre
- **WHEN** un personnage se multiclasse en Guerrier avec 13 en Dextérité et 8 en Force
- **THEN** le prérequis du Guerrier est rempli
