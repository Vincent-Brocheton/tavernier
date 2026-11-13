## ADDED Requirements

### Requirement: Avatar du profil
L'utilisateur SHALL pouvoir choisir une image comme avatar, y compris hors ligne (EF-CPT-03, EF-CPT-09). L'image SHALL être recadrée au carré et compressée sur l'appareil sous 200 Ko avant d'être enregistrée. Sans avatar, l'initiale du pseudonyme SHALL s'afficher. L'avatar SHALL s'afficher dans la barre de l'app, le profil et la liste des membres des tables de l'utilisateur.

#### Scenario: Image choisie
- **WHEN** l'utilisateur choisit une photo rectangulaire de plusieurs mégaoctets
- **THEN** l'aperçu montre une image carrée, et l'avatar enregistré pèse moins de 200 Ko

#### Scenario: Hors ligne
- **WHEN** l'utilisateur choisit un avatar sans réseau et enregistre
- **THEN** l'avatar s'affiche aussitôt et attend l'envoi

#### Scenario: Retirer l'avatar
- **WHEN** l'utilisateur retire son avatar et enregistre
- **THEN** l'initiale de son pseudonyme s'affiche de nouveau

#### Scenario: Membres d'une table
- **WHEN** un membre de la table a un avatar
- **THEN** la liste des membres affiche son image à la place de son initiale

#### Scenario: Fichier illisible
- **WHEN** le fichier choisi n'est pas une image lisible
- **THEN** un message le dit et l'avatar ne change pas
