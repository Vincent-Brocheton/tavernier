## ADDED Requirements

### Requirement: Avatar borné par le serveur
Le serveur SHALL refuser un avatar de profil qui n'est pas une image JPEG, PNG ou WebP en data URI base64, ou dont l'image dépasse 200 Ko (EF-CPT-03). L'écriture refusée SHALL être écartée sans bloquer les autres opérations envoyées.

#### Scenario: Avatar conforme
- **WHEN** un utilisateur enregistre une image JPEG de 50 Ko en data URI
- **THEN** l'avatar est accepté

#### Scenario: Avatar trop lourd
- **WHEN** un utilisateur envoie une image de plus de 200 Ko
- **THEN** l'écriture est refusée

#### Scenario: Pas une image
- **WHEN** un utilisateur envoie un texte quelconque comme avatar
- **THEN** l'écriture est refusée
