## ADDED Requirements

### Requirement: Activité d'une table au serveur
Le serveur SHALL laisser les membres d'une table lire son activité, le MJ y ajouter des entrées, et personne les modifier ou les supprimer. L'activité SHALL être synchronisée vers les membres.

#### Scenario: Joueur
- **WHEN** un joueur ajoute une entrée d'activité
- **THEN** le serveur la refuse

#### Scenario: Synchronisation
- **WHEN** le MJ ajoute une entrée
- **THEN** chaque membre la reçoit

### Requirement: Table archivée en lecture seule
Le serveur SHALL refuser toute écriture sur les fiches d'une table archivée, et toute modification de la table autre que sa restauration par le MJ.

#### Scenario: Fiche d'une table archivée
- **WHEN** le propriétaire modifie sa fiche dans une table archivée
- **THEN** le serveur la refuse

#### Scenario: Restauration
- **WHEN** le MJ restaure la table
- **THEN** elle redevient modifiable
