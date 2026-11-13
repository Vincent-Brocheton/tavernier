## ADDED Requirements

### Requirement: Proposition du MJ reçue
La fiche SHALL afficher à son propriétaire, en tête, la plus ancienne proposition du MJ en attente ([F4b], EF-PJ-16) : qui propose et quoi, le motif, l'aperçu avant et après des valeurs touchées, un champ « Message si vous refusez », « Refuser » et « Accepter ». Les autres utilisateurs, MJ compris, ne la voient pas sur la fiche.

#### Scenario: Aperçu
- **WHEN** Camille propose à Hugo de remplacer Vigilant par Doué
- **THEN** Hugo lit « Camille propose : remplacer le don Vigilant par Doué », le motif, et l'Initiative et les maîtrises avant et après

#### Scenario: Acceptée
- **WHEN** Hugo accepte
- **THEN** l'encadré disparaît et la fiche a Doué

#### Scenario: Refusée
- **WHEN** Hugo refuse avec un message
- **THEN** l'encadré disparaît et la fiche est inchangée

### Requirement: Proposition acceptée dans l'historique
L'historique de la fiche SHALL montrer une proposition acceptée : « Proposition acceptée : remplacer le don Vigilant par Doué », puis qui l'a proposée et son motif.

#### Scenario: Historique
- **WHEN** Hugo ouvre l'historique après avoir accepté
- **THEN** il lit « Proposée par Camille · Motif : « … » »
