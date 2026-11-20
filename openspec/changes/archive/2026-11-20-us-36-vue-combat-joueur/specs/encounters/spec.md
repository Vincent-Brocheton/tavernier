## ADDED Requirements

### Requirement: Adversaire masqué aux joueurs
Un adversaire SHALL être visible des joueurs par défaut. L'événement `combatant_hidden` (`combatant`, `hidden`) SHALL le masquer ou le rendre visible (EF-VJ-03).

#### Scenario: Masqué puis visible
- **WHEN** le MJ masque l'assassin, puis le rend visible
- **THEN** il disparaît de la vue des joueurs, puis y revient

### Requirement: Vue du combat du joueur
`playerCombatView(state)` SHALL rendre, en JSON :
- le round et l'unité active ;
- l'ordre des combattants visibles : un adversaire avec son seul nom, un PJ avec sa fiche, son joueur et sa santé qualitative ;
- pour chaque PJ, ses PV, PV temporaires, états et leur durée restante, sa concentration, sa réaction, ses jets contre la mort et ses tests de concentration en attente.

L'appareil du MJ y ajoute le titre de la rencontre, que le joueur ne lit pas.

Elle SHALL ne porter ni journal, ni Étude, ni PV, CA ou profil d'un adversaire, ni adversaire masqué (EF-VJ-03). `turnsUntil(view, fiche)` SHALL donner le nombre de tours avant celui du PJ, un par unité (EF-VJ-02).

#### Scenario: [J1]
- **WHEN** au round 3, c'est le tour du Chef de bande
- **THEN** l'ordre montre Thalia indemne, Chef de bande, Loup 2, Aldric blessé et Mira gravement blessée, sans l'adversaire masqué ; Aldric joue dans 2 tours, à 41 PV sur 49 et 5 PV temporaires, avec sa réaction disponible

#### Scenario: Concentration en attente
- **WHEN** Mira, concentrée sur Bénédiction, subit 4 dégâts
- **THEN** sa vue porte Bénédiction et un test DD 10 en attente

### Requirement: Demandes des joueurs appliquées par le MJ
`requestEvents(state, id, character, type, payload)` SHALL traduire une demande du joueur en événements du journal, portant `request` (l'id de la demande), et ne visant que le PJ de la fiche `character` :
- `damage` (`amount`, `type`), `heal` et `temp_hp`, avec un `amount` entier positif ;
- `death_save` (`outcome` : `success`, `failure`, `nat1` ou `nat20`), si le PJ est à terre, instable et vivant ;
- `concentration_check` (`success`), si un test de concentration est en attente ;
- `concentration_started` (`spell`) et `concentration_ended`, s'il est concentré ;
- `turn_advanced`, si c'est son tour.

`deathSaveOutcome(d20)` SHALL donner l'issue d'un jet contre la mort (SRD) : 1 compte deux échecs, 20 rend 1 PV, 10 ou plus réussit.

Tout autre type, une valeur invalide, un PJ absent ou une demande que l'état du MJ a dépassée SHALL ne rien donner : la version du MJ prime (EF-VJ-06).

#### Scenario: Dégâts demandés par Hugo
- **WHEN** Hugo demande 7 dégâts tranchants pour Aldric, en visant d'autres combattants
- **THEN** seul Aldric les subit : ses 5 PV temporaires, puis 2 PV, et l'événement porte la référence de la demande

#### Scenario: Demande dépassée
- **WHEN** Hugo envoie un jet contre la mort alors qu'Aldric est debout
- **THEN** rien n'est écrit

### Requirement: Liaison du combat côté MJ
Tant que la page du combat est ouverte chez le MJ et la rencontre en cours, l'appareil du MJ SHALL publier `playerCombatView` à chaque changement du journal, et appliquer chaque demande reçue une seule fois, puis la retirer, même refusée. La clôture de la rencontre SHALL retirer la vue. La fiche d'un adversaire SHALL porter l'interrupteur « Masquer aux joueurs » (`combatant_hidden`).

#### Scenario: Demande appliquée
- **WHEN** une demande de 5 dégâts d'Hugo arrive pendant le combat
- **THEN** le journal porte les dégâts d'Aldric avec la référence, la demande est retirée et la vue publiée montre Aldric à 36 PV

#### Scenario: Fin de la rencontre
- **WHEN** le MJ clôt la rencontre
- **THEN** la vue publiée disparaît

#### Scenario: Dragon masqué
- **WHEN** le MJ active « Masquer aux joueurs » sur le dragon, puis le désactive
- **THEN** le dragon quitte l'ordre de la vue publiée, puis y revient

### Requirement: Écran « En combat » du joueur
Quand une vue publiée montre le PJ du joueur connecté, sa fiche SHALL s'ouvrir sur l'écran « En combat » ; « Fiche complète » SHALL ramener à la fiche, qui garde un bandeau « Revenir au combat » (EF-VJ-01). Le MJ qui ouvre la fiche reste sur la fiche.

L'écran SHALL montrer :
- le bandeau : titre et round, tour en cours et « vous jouez dans n tours » ; à son tour, « C'est votre tour », l'économie d'actions à cocher et « Finir mon tour » (EF-VJ-02) ;
- l'ordre simplifié de la vue (EF-VJ-03) ;
- son PJ : PV, PV temporaires, concentration, réaction, Dégâts, Soins et PV temp., états reçus avec leur source et leur durée ; ses attaques et ressources, et ses sorts, dont la concentration est relayée au MJ (EF-VJ-04) ;
- les jets demandés : test de concentration (DD, bonus de JS de CON) et jet contre la mort, saisis ou lancés (EF-VJ-05) ;
- hors-ligne, le dernier état connu et « Hors-ligne : dites vos changements au MJ » ; les demandes en attente sont comptées (EF-VJ-06).

Chaque changement du joueur SHALL partir en demande (`combat_request`).

#### Scenario: [J1]
- **WHEN** Hugo ouvre la fiche d'Aldric au round 3, tour du Chef de bande
- **THEN** il lit « Tour : Chef de bande · vous jouez dans 2 tours », 41 / 49, +5 PV temp., Réaction disponible, Béni de Mira Solen pour 8 rounds, et l'ordre sans PV des adversaires

#### Scenario: Dégâts envoyés
- **WHEN** Hugo saisit 7 dégâts
- **THEN** une demande `damage` de 7 part pour Aldric, et « 1 changement en attente du MJ » s'affiche

#### Scenario: [J2]
- **WHEN** c'est le tour d'Aldric
- **THEN** « C'est votre tour » s'affiche avec Action, Action Bonus, Réaction et Déplacement à cocher, et « Finir mon tour » envoie `turn_advanced`

#### Scenario: [J5]
- **WHEN** Aldric doit un test de concentration DD 10 et Hugo saisit 6 (JS de CON +4)
- **THEN** une réussite part chez le MJ

#### Scenario: [J3]
- **WHEN** l'appareil est hors-ligne
- **THEN** le bandeau porte « dernier état connu » et l'avertissement hors-ligne, sans « vous jouez dans »

