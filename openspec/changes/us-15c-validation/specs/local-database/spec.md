## ADDED Requirements

### Requirement: Revue et transfert des fiches de table
`CharacterStore` SHALL envoyer une fiche avec un message, la valider ou demander des corrections avec un commentaire, et la reprendre. `TableStore` SHALL transférer un emplacement et sa fiche à un autre joueur, et rendre le message et le commentaire avec chaque emplacement.

#### Scenario: Corrections
- **WHEN** le MJ demande des corrections avec un commentaire
- **THEN** l'emplacement rend le statut `changes_requested` et le commentaire

#### Scenario: Transfert
- **WHEN** le MJ transfère un emplacement
- **THEN** l'emplacement et la fiche ont le nouveau joueur
