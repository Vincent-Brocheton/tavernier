## ADDED Requirements

### Requirement: Rejoindre une table
Le serveur SHALL ajouter comme joueur l'utilisateur qui présente le code d'une invitation valide (ni révoquée, ni expirée, table non archivée) et rendre l'identifiant de la table. Il SHALL refuser un code inconnu, expiré ou révoqué avec un motif distinct, et freiner un compte après 10 échecs en une heure.

#### Scenario: Code valide
- **WHEN** un utilisateur présente un code valide
- **THEN** il devient joueur de la table

#### Scenario: Déjà membre
- **WHEN** un membre présente à nouveau le code
- **THEN** rien ne change et la table est rendue

#### Scenario: Code expiré ou révoqué
- **WHEN** l'invitation est expirée ou révoquée
- **THEN** le serveur refuse avec le motif `expired_code`

#### Scenario: Recherche au hasard
- **WHEN** un compte a échoué 10 fois dans l'heure
- **THEN** le serveur refuse avec le motif `too_many_attempts`, même pour un code valide

### Requirement: Retrait d'un joueur
Quand un joueur quitte une table ou en est retiré, le serveur SHALL passer ses fiches de cette table au statut `archived`, sans les supprimer, et refuser ensuite toute écriture sur elles.

#### Scenario: Retrait
- **WHEN** le MJ retire un joueur
- **THEN** la fiche du joueur dans la table est archivée et reste lisible par son propriétaire

#### Scenario: Fiche archivée
- **WHEN** le propriétaire modifie une fiche archivée
- **THEN** le serveur refuse
