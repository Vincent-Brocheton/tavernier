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
