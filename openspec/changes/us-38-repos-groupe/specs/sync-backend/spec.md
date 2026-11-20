## ADDED Requirements

### Requirement: Repos de groupe au serveur
`group_rest` SHALL être lu par les membres de la table et écrit par le MJ d'une table active ; sa séance, s'il en a une, SHALL être de la table. `group_rest_done` SHALL être inséré, au nom de son auteur, par le propriétaire du PJ ou par le MJ, pour un PJ visé d'un repos ouvert de la même table ; les membres le lisent, le MJ peut le supprimer. PowerSync SHALL envoyer les deux tables à tous les membres de la table.

#### Scenario: Repos déclenché
- **WHEN** Camille, MJ, déclenche un repos court pour Aldric et Mira
- **THEN** Hugo, joueur, le lit ; un joueur ne peut pas en déclencher

#### Scenario: Fin signalée
- **WHEN** Hugo signale la fin pour Aldric
- **THEN** l'écriture passe ; pour Mira (le PJ d'un autre), pour un PJ non visé ou après la clôture, elle est refusée

#### Scenario: Pour un joueur hors-ligne
- **WHEN** Camille signale la fin pour Mira
- **THEN** l'écriture passe

#### Scenario: Hors de la table
- **WHEN** Zoé, d'une autre table, lit les repos
- **THEN** elle n'en voit aucun
