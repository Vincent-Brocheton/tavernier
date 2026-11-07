## ADDED Requirements

### Requirement: Soin d'un consommable
L'opération `consumable_heal` SHALL décrire le soin d'un objet : `dice`, `bonus` et `action`. Elle ne change pas la fiche tant que l'objet n'est pas utilisé.

#### Scenario: Potion de guérison
- **WHEN** le pack SRD est lu
- **THEN** la potion de guérison porte 2d4, un bonus de 2 et une action Bonus
