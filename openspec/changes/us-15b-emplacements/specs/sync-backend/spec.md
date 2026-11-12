## ADDED Requirements

### Requirement: Emplacements au serveur
Le serveur SHALL laisser les membres lire les emplacements de leur table, le MJ les créer et les supprimer, et le joueur d'un emplacement n'y placer qu'une fiche à lui de la même table. Les emplacements SHALL être synchronisés vers les membres.

#### Scenario: Joueur
- **WHEN** un joueur crée un emplacement
- **THEN** le serveur refuse

#### Scenario: Fiche d'un autre
- **WHEN** un joueur place dans son emplacement la fiche d'un autre
- **THEN** le serveur refuse

### Requirement: Statut d'une fiche de table
Le serveur SHALL n'accepter que ces passages : le propriétaire envoie (`draft` ou `changes_requested` → `submitted`) ou reprend (`submitted` → `draft`) ; le MJ de la table valide ou demande des corrections sur une fiche envoyée. Une fiche SHALL n'être rattachée qu'à une table dont son propriétaire est membre.

#### Scenario: Envoi
- **WHEN** le propriétaire envoie sa fiche
- **THEN** elle passe `submitted`

#### Scenario: Validation par soi-même
- **WHEN** le propriétaire passe sa fiche à `validated`
- **THEN** le serveur refuse

#### Scenario: Table étrangère
- **WHEN** un utilisateur rattache sa fiche à une table dont il n'est pas membre
- **THEN** le serveur refuse
