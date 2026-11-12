## ADDED Requirements

### Requirement: Historique de la fiche
La fiche SHALL donner accès à une page « Historique », qui liste ses entrées de la plus récente à la plus ancienne, avec auteur et date. Une dérogation SHALL y montrer l'écart, la valeur de la table et celle de la fiche, et le message du MJ.

#### Scenario: Dérogation consultée
- **WHEN** le joueur ouvre l'historique de Kael
- **THEN** il lit « Dérogation : niveau 3 accepté », par Camille (MJ), avec 1 → 3
