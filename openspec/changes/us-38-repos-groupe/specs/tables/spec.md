## ADDED Requirements

### Requirement: Repos de groupe
Sur la page d'une séance en cours, le MJ SHALL pouvoir déclencher un repos court ou long pour les PJ présents ([J9]). Tant que le repos est ouvert, chaque PJ visé SHALL montrer « Terminé » avec son récapitulatif (dés de vie dépensés, PV avant et après), ou « En attente » avec « Faire pour… », qui ouvre l'écran de repos sur sa fiche ; « Clore le repos » SHALL le clore.

La fiche d'un PJ attendu SHALL porter, pour son propriétaire ou le MJ, le bandeau « Camille lance un repos court pour le groupe » ; « Faire le repos » SHALL ouvrir l'écran de repos habituel avec l'origine en tête, et « Terminer » SHALL signaler la fin avec son récapitulatif ([J10]). Le repos individuel reste possible hors séance.

#### Scenario: [J9]
- **WHEN** Camille déclenche un repos court à la séance en cours où Aldric et Mira sont présents, puis Hugo termine pour Aldric après 2 dés de vie
- **THEN** Aldric est « Terminé » avec « 2 dés de vie dépensés · PV 34 → 49 », Mira « En attente » avec « Faire pour Mira Solen », et « Clore le repos » rend le choix du repos

#### Scenario: Séance prévue
- **WHEN** la séance n'est pas encore ouverte
- **THEN** la page ne propose pas de repos de groupe

#### Scenario: [J10]
- **WHEN** un repos court attend Aldric, à 4 PV sur 12, et Hugo dépense un d10 de 6
- **THEN** l'écran porte « Aldric Varenne · demandé par … », la fin signalée porte 1 dé, 4 → 12 PV, et le bandeau disparaît
