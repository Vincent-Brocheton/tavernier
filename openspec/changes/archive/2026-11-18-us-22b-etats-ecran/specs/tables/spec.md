## ADDED Requirements

### Requirement: Ajouter un état
L'écran de combat SHALL proposer « État » pour les cibles choisies. La feuille « Ajouter un état » ([C5]) SHALL offrir :
- les 15 états du SRD, avec icône et libellé, et « Autre effet » à libellé libre ;
- le résumé de la règle de l'état choisi ;
- une durée : nombre de rounds, jusqu'au début ou à la fin du tour d'un combattant, jusqu'à réussite d'une sauvegarde (DD et caractéristique), ou indéfinie.

#### Scenario: Entravé jusqu'à une sauvegarde ([C5])
- **WHEN** le MJ cible le Loup sanguinaire 2, choisit Entravé, « Jusqu'à réussite d'une sauvegarde », DD 13, Force, puis « Ajouter Entravé »
- **THEN** la carte du loup montre « Entravé · JS FOR DD 13 »

#### Scenario: Deux cibles
- **WHEN** le MJ cible Aldric et l'ogre, choisit Effrayé pour 2 rounds et l'ajoute
- **THEN** les deux cartes montrent « Effrayé · 2 rd »

### Requirement: Cas particuliers de l'ajout d'un état
La feuille « Ajouter un état » SHALL remplacer la durée de l'Épuisement par un nombre de niveaux, offrir des dégâts récurrents facultatifs à « Autre effet », et griser un état auquel toutes les cibles sont immunisées.

#### Scenario: Épuisement
- **WHEN** le MJ ajoute 2 niveaux d'Épuisement à Aldric
- **THEN** sa carte montre « Épuisement 2 »

#### Scenario: Autre effet avec dégâts récurrents
- **WHEN** le MJ ajoute « En feu » à l'ogre, avec 1d4 dégâts de feu au début de son tour
- **THEN** la carte de l'ogre montre « En feu »

#### Scenario: Immunité
- **WHEN** le MJ cible un squelette
- **THEN** la tuile Empoisonné est grisée

### Requirement: Fiche d'état
Toucher une puce d'état SHALL ouvrir sa fiche ([K4]), qui montre :
- le texte de la règle du SRD ;
- le porteur et la durée en clair ;
- « Retirer l'état » et, pour l'Épuisement, « Retirer un niveau ».

#### Scenario: Retirer Entravé ([K4])
- **WHEN** le MJ touche la puce Entravé du loup
- **THEN** la fiche montre la règle « Vitesse 0 » et la ligne « Loup sanguinaire 2 · jusqu'à réussite d'un JS de Force DD 13, refait à la fin de chacun de ses tours »
- **AND WHEN** il touche « Retirer l'état »
- **THEN** la puce disparaît de la carte
