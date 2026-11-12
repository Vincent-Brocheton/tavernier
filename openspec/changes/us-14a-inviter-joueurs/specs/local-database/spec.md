## ADDED Requirements

### Requirement: Invitations et membres
`TableStore` SHALL créer une invitation (code, expiration à 7 jours) en révoquant celle en cours, rendre l'invitation en cours d'une table, la révoquer, rendre les membres avec leur pseudonyme et retirer un membre.

#### Scenario: Une seule invitation en cours
- **WHEN** le MJ crée deux invitations de suite
- **THEN** seule la seconde est en cours

#### Scenario: Retrait
- **WHEN** le MJ retire un membre
- **THEN** il n'apparaît plus dans les membres

### Requirement: Tables réactives
Les listes de tables, une table, ses membres et son invitation SHALL se mettre à jour quand la base change, synchronisation comprise.

#### Scenario: Écriture locale
- **WHEN** une table est créée pendant qu'on observe la liste
- **THEN** la liste la montre sans nouvelle demande
