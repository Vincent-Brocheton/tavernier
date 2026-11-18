## ADDED Requirements

### Requirement: Journal du combat stocké
La base locale SHALL garder le journal dans la table synchronisée `encounter_event`. `CombatStore` SHALL :
- ajouter des événements en une transaction ;
- suivre le journal d'une rencontre dans l'ordre de ses identifiants, et sa projection ;
- lancer une rencontre (état « En cours » et premiers événements, en une transaction) ;
- la terminer.

La table locale `combatant` SHALL disparaître : les combattants se déduisent du journal.

#### Scenario: Lancement
- **WHEN** le MJ lance « Le relais du Sel » avec l'ajout d'Aldric et de l'ogre
- **THEN** la rencontre est « En cours », et la projection compte deux combattants

#### Scenario: Ordre du journal
- **WHEN** le MJ ajoute « combat_started » puis « turn_advanced »
- **THEN** le journal les rend dans cet ordre, et la projection est au deuxième tour

#### Scenario: Fin
- **WHEN** le MJ termine la rencontre
- **THEN** elle est « Terminée »
