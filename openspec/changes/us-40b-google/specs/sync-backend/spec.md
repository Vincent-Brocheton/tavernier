## ADDED Requirements

### Requirement: Âge des comptes sans date à l'inscription
Le serveur SHALL enregistrer la vérification d'âge d'un compte créé sans date de naissance (Google) quand il déclare 15 ans révolus, sans garder la date, et SHALL supprimer le compte sinon.

#### Scenario: Quinze ans
- **WHEN** l'utilisateur déclare une date de 15 ans révolus
- **THEN** ses métadonnées portent `age_checked_at`, sans la date

#### Scenario: Trop jeune
- **WHEN** il déclare une date de moins de 15 ans
- **THEN** son compte est supprimé

### Requirement: Mot de passe défini
Le serveur SHALL dire à l'utilisateur si son compte a un mot de passe, sans rien en révéler d'autre.

#### Scenario: Compte Google
- **WHEN** un compte créé par Google demande s'il a un mot de passe
- **THEN** la réponse est non, puis oui une fois qu'il en a défini un
