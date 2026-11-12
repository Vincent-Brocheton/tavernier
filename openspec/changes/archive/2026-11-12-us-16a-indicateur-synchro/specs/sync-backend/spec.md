## ADDED Requirements

### Requirement: Fusion entre les comptes d'une table
Des modifications faites hors ligne par le MJ et deux joueurs d'une même table, sur trois appareils, SHALL toutes arriver au serveur à la reconnexion, et chaque appareil SHALL recevoir celles qu'il a le droit de lire (critère de sortie de M2).

#### Scenario: MJ et deux joueurs
- **WHEN** le MJ change un réglage de la table et chaque joueur modifie sa fiche, hors ligne, puis tous se reconnectent
- **THEN** le serveur a les trois modifications, chaque joueur a le réglage, le MJ a les deux fiches, et aucune écriture n'est écartée
