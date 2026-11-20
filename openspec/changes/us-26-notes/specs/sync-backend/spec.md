## ADDED Requirements

### Requirement: Notes au serveur
Une note SHALL être lue par son auteur, et par tous les membres de sa table si elle est partagée (`private` faux). Elle SHALL être écrite, modifiée et supprimée par son seul auteur, sur une table dont il est membre (EF-NOT-02, 04). PowerSync SHALL envoyer à chacun ses notes et celles partagées avec ses tables.

#### Scenario: Note privée du MJ
- **WHEN** Camille écrit une note privée
- **THEN** Hugo, joueur de la table, ne la voit pas

#### Scenario: Note partagée
- **WHEN** Camille partage « Calendrier et factions »
- **THEN** Hugo la lit, sans pouvoir la modifier

#### Scenario: Écriture refusée
- **WHEN** Hugo écrit une note au nom d'un autre, ou sur une table dont il n'est pas membre
- **THEN** l'écriture est refusée

### Requirement: Conflit d'une note
À l'envoi d'une modification de note, si le texte en place n'est pas celui que l'appareil remplaçait, le serveur SHALL écrire la nouvelle version et garder l'autre dans `conflict`, pour que l'auteur fusionne (EF-NOT-06).

#### Scenario: Deux appareils hors-ligne
- **WHEN** les deux appareils de Hugo modifient la même note sans réseau, puis envoient l'un après l'autre
- **THEN** la note porte le texte du second, et `conflict` celui du premier
