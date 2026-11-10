## ADDED Requirements

### Requirement: Modification du compte
L'utilisateur SHALL modifier son pseudonyme, y compris hors ligne, ainsi que son e-mail et son mot de passe, qui demandent le réseau (EF-CPT-09). Un nouvel e-mail SHALL être confirmé par un lien envoyé à la nouvelle adresse. Un nouveau mot de passe SHALL demander le mot de passe actuel et suivre les règles d'EF-CPT-08.

#### Scenario: Pseudonyme hors ligne
- **WHEN** l'utilisateur change son pseudonyme sans réseau et enregistre
- **THEN** le nouveau pseudonyme s'affiche aussitôt et attend l'envoi

#### Scenario: Nouvel e-mail
- **WHEN** l'utilisateur saisit une nouvelle adresse et enregistre
- **THEN** un message dit qu'un lien de confirmation est envoyé à la nouvelle adresse, et que l'ancienne reste active jusque-là

#### Scenario: Mot de passe actuel faux
- **WHEN** le mot de passe actuel saisi est faux
- **THEN** « Mot de passe actuel incorrect » s'affiche et rien n'est changé

#### Scenario: Sans réseau
- **WHEN** l'utilisateur change son e-mail ou son mot de passe sans réseau
- **THEN** l'écran dit que ces changements demandent le réseau
