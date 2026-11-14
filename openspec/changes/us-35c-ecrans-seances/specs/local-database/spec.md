## ADDED Requirements

### Requirement: Séance créée avec ses présences
`SessionStore.create` SHALL accepter les personnages prévus et les enregistrer avec la séance, en une seule transaction.

#### Scenario: Création avec présences
- **WHEN** le MJ crée une séance avec Aldric et Mira prévus
- **THEN** la séance existe, et ses présences sont Aldric et Mira
