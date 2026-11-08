## ADDED Requirements

### Requirement: Règles de synchronisation
Le service de synchronisation SHALL n'envoyer à un utilisateur que les lignes que les droits de la base lui laissent lire.

#### Scenario: Joueur
- **WHEN** un joueur se connecte
- **THEN** il reçoit son profil, sa fiche et son contenu, ses tables, leurs membres et leurs packs, mais pas les invitations ni la fiche d'un autre joueur

#### Scenario: MJ
- **WHEN** le MJ se connecte
- **THEN** il reçoit en plus les fiches de sa table, leur contenu et les invitations

#### Scenario: Inconnu
- **WHEN** un utilisateur sans table se connecte
- **THEN** il ne reçoit que son profil

#### Scenario: Fiches visibles
- **WHEN** la table montre les fiches complètes
- **THEN** chaque membre reçoit les fiches des autres membres
