## ADDED Requirements

### Requirement: Brouillons homebrew
`HomebrewStore` SHALL créer, enregistrer, lister et supprimer des brouillons de packs. Chacun est gardé en entier, en JSON, dans la table locale `homebrew_draft`, non synchronisée, même s'il ne passe pas encore les validations. Un brouillon relu SHALL être identique au pack enregistré.

#### Scenario: Aller-retour
- **WHEN** un brouillon avec un Don et un Historique incomplet est enregistré, puis relu
- **THEN** il est identique, entités et manifeste compris
