## ADDED Requirements

### Requirement: Rappels de fin de tour
« Tour suivant » SHALL ouvrir le dialogue de fin de tour ([C6]) quand l'unité active a des rappels de fin de tour. Le dialogue montre :
- les sauvegardes à refaire, avec « Lancer », « Échec » et « Réussite » ;
- les états qui expirent ;
- les dégâts récurrents.

« Plus tard » ferme sans passer le tour, et « Tour suivant : <unité> » le passe. Sans rappel, le tour passe directement.

#### Scenario: Sauvegarde réussie ([C6])
- **WHEN** l'ogre, Entravé jusqu'à réussite d'un JS de Force DD 13, finit son tour, et le MJ touche « Réussite »
- **THEN** l'état Entravé est retiré, et le dialogue affiche la réussite
- **AND WHEN** il touche « Tour suivant : Dragon noir adulte »
- **THEN** c'est le tour du dragon

#### Scenario: Plus tard
- **WHEN** le dialogue de fin de tour est ouvert et le MJ touche « Plus tard »
- **THEN** le tour ne passe pas

#### Scenario: Pas de rappel
- **WHEN** le tour du dragon finit, sans rappel
- **THEN** le tour passe à Aldric sans dialogue

### Requirement: Bandeau de début de tour
Au début d'un tour, l'écran de combat SHALL afficher le bandeau « Début du tour · <unité> » ([1a]) s'il y a quelque chose à rappeler. Il liste :
- les états qui viennent d'expirer ;
- ceux qui expirent à la fin de ce tour ;
- les dégâts récurrents, avec « Lancer et appliquer ».

« OK » le masque. Sur les cartes, un état qui expire à la fin du tour en cours affiche « expire ».

#### Scenario: Empoisonné expire à la fin de ce tour ([1a])
- **WHEN** le tour d'Aldric commence, Empoisonné jusqu'à la fin de son tour
- **THEN** le bandeau dit « Empoisonné expire à la fin de ce tour », et la puce affiche « Empoisonné · expire »

#### Scenario: Dégâts récurrents
- **WHEN** le tour de l'ogre, « En feu » (1d4 de feu au début de son tour), commence, et le MJ touche « Lancer et appliquer »
- **THEN** l'ogre perd entre 1 et 4 PV
