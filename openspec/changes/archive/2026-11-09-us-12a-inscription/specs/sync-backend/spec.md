## ADDED Requirements

### Requirement: Inscription côté serveur
Le serveur SHALL refuser une inscription sans date de naissance ou de moins de 15 ans, SHALL ne pas conserver la date de naissance, et SHALL créer le profil avec le pseudonyme fourni.

#### Scenario: Quinze ans révolus
- **WHEN** un compte est créé avec une date de naissance de plus de 15 ans
- **THEN** son profil existe avec le pseudonyme, et ses métadonnées ne contiennent plus la date de naissance

#### Scenario: Trop jeune
- **WHEN** un compte est créé avec une date de naissance de moins de 15 ans
- **THEN** la création échoue
