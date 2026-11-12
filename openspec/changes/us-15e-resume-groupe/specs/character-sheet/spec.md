## ADDED Requirements

### Requirement: Fiche en lecture seule
Une fiche que l'utilisateur ne peut pas modifier (celle d'un autre joueur, ouverte par le MJ, ou une fiche archivée) SHALL s'afficher sans montée de niveau, sans repos et sans actions qui écrivent dans l'inventaire ou les sorts.

#### Scenario: Fiche d'un autre joueur
- **WHEN** un joueur ouvre la fiche de Mira
- **THEN** il la consulte, sans « Monter au niveau 2 » ni repos
