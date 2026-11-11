## ADDED Requirements

### Requirement: Dépôt des tables de jeu
`TableStore` SHALL créer une table, l'inscription de son MJ et ses packs dans une seule transaction, et SHALL lister les tables d'un utilisateur, MJ ou membre.

#### Scenario: Une transaction
- **WHEN** une table est créée
- **THEN** `game_table`, `table_member` et `table_pack` sont écrits ensemble, ou rien ne l'est

#### Scenario: Liste
- **WHEN** un utilisateur est MJ d'une table et membre d'une autre
- **THEN** la liste rend les deux, avec son rôle dans chacune
