## ADDED Requirements

### Requirement: Propositions stockées
La base locale SHALL garder les propositions du MJ, avec leur modification : des champs de premier niveau de la fiche, au format JSON. Elle SHALL donner les propositions en attente d'une fiche, de la plus ancienne à la plus récente.

#### Scenario: En attente
- **WHEN** Camille propose une modification de la fiche d'Aldric
- **THEN** la proposition figure dans les propositions en attente d'Aldric

### Requirement: Réponse à une proposition
Accepter SHALL appliquer les champs proposés à la fiche sans toucher à son état de jeu, inscrire une entrée « proposition » dans l'historique et clore la proposition. Refuser SHALL clore la proposition avec le message du joueur, sans toucher à la fiche.

#### Scenario: Acceptée
- **WHEN** Hugo accepte de remplacer Vigilant par Doué, à 7 PV
- **THEN** la fiche a Doué, garde 7 PV, et son historique porte la proposition

#### Scenario: Refusée
- **WHEN** Hugo refuse
- **THEN** la fiche est inchangée et la proposition n'est plus en attente
