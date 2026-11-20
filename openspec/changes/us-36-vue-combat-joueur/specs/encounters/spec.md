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
- pour chaque PJ, ses PV, PV temporaires, états et leur durée, sa concentration, sa réaction, ses jets contre la mort et ses tests de concentration en attente.

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
- `concentration_check` (`success`), si un test de concentration est en attente.

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
