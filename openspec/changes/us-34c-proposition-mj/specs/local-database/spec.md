## ADDED Requirements

### Requirement: Propositions d'une fiche pour son MJ
La base locale SHALL donner toutes les propositions d'une fiche, de la plus récente à la plus ancienne, avec la réponse du joueur. L'accès à une fiche SHALL dire aussi à quelle table elle appartient.

#### Scenario: Refus relu
- **WHEN** Hugo a refusé avec un message
- **THEN** la plus récente proposition de la fiche est refusée, avec ce message
