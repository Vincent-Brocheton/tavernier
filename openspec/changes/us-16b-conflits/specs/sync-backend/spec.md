## ADDED Requirements

### Requirement: Conflits détectés et tracés
Le serveur SHALL reconnaître un conflit quand une modification de fiche ou d'état de jeu remplace, pour un champ, une valeur différente de celle que l'appareil avait. Le dernier écrit SHALL gagner, sauf sur l'état de jeu quand la valeur en place vient du MJ de la table et l'écriture d'un autre : la valeur du MJ SHALL rester. Chaque conflit SHALL inscrire dans l'historique de la fiche le champ, la valeur gardée et la valeur remplacée, avec leurs auteurs.

#### Scenario: Le MJ prime en combat
- **WHEN** le MJ a réglé les PV d'Aldric à 34 pendant que le joueur, hors ligne, les passait de 29 à 39
- **THEN** les PV restent à 34 et l'historique trace la valeur 39 remplacée

#### Scenario: Dernier écrit gagnant
- **WHEN** deux appareils renomment la même fiche hors ligne
- **THEN** le dernier envoyé gagne, et l'historique trace le nom remplacé

#### Scenario: Pas de conflit
- **WHEN** une modification remplace la valeur que le serveur a
- **THEN** aucune entrée de conflit n'est inscrite
