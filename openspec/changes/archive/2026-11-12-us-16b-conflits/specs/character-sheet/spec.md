## ADDED Requirements

### Requirement: Conflit résolu signalé
Quand une valeur du joueur a été remplacée à la synchronisation, sa fiche SHALL afficher un bandeau « Conflit résolu » qui dit qui a gardé quelle valeur, avec « Voir l'historique » et « OK ». L'historique SHALL montrer la valeur remplacée barrée, puis la valeur gardée.

#### Scenario: Bandeau
- **WHEN** Camille a gardé les PV d'Aldric à 34 contre les 39 du joueur
- **THEN** la fiche affiche le bandeau, jusqu'à « OK »

#### Scenario: Historique
- **WHEN** le joueur ouvre l'historique
- **THEN** il lit « Conflit résolu : PV », 39 barré, puis 34
