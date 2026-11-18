## ADDED Requirements

### Requirement: États d'un combattant
Un événement `condition_added` SHALL poser un état (l'un des 15 du SRD) ou un effet libellé sur un combattant, avec une durée. Un événement `condition_removed` SHALL le retirer.
- Un état ne se cumule pas avec lui-même : chaque source garde son instance et sa durée.
- L'Épuisement gagne un niveau à chaque ajout, jusqu'à 6. Un retrait peut ôter des niveaux, et l'état prend fin à 0.
- Un combattant immunisé contre un état ne le reçoit pas.

#### Scenario: Entravé ([C5])
- **WHEN** le MJ pose Entravé sur le Loup sanguinaire 2, jusqu'à réussite d'un JS de Force DD 13
- **THEN** le loup a l'état Entravé, avec cette durée

#### Scenario: Épuisement cumulatif
- **WHEN** Aldric reçoit l'Épuisement deux fois, puis perd un niveau
- **THEN** il est à l'Épuisement 2, puis 1

#### Scenario: Immunité
- **WHEN** le MJ pose Empoisonné sur un squelette, immunisé contre cet état
- **THEN** le squelette n'a aucun état

### Requirement: Durée d'un état
Un état SHALL expirer selon sa durée :
- **N rounds** : au début du tour de l'unité active quand il a été posé, N rounds plus tard ;
- **jusqu'au début du tour de X** : au prochain début de tour de X ;
- **jusqu'à la fin du tour de X** : à la prochaine fin de tour de X, y compris celui en cours ;
- **jusqu'à réussite d'une sauvegarde** : quand un `condition_save` réussi est saisi ;
- **indéfinie** : jamais d'elle-même.

L'expiration vient de la projection : annuler le passage du tour rend l'état.

#### Scenario: Deux rounds
- **WHEN** pendant le tour d'Aldric, round 1, le MJ pose Aveuglé pour 2 rounds sur un bandit
- **THEN** l'état est présent pendant tout le round 2 et prend fin au début du tour d'Aldric au round 3

#### Scenario: Fin du tour de Mira
- **WHEN** le loup est Effrayé jusqu'à la fin du tour de Mira, et le tour de Mira se termine
- **THEN** le loup n'est plus Effrayé

#### Scenario: Sauvegarde réussie
- **WHEN** le loup, Entravé jusqu'à réussite d'un JS de Force DD 13, rate puis réussit sa sauvegarde
- **THEN** il reste Entravé après l'échec et ne l'est plus après la réussite

#### Scenario: Annuler le tour
- **WHEN** l'état d'un bandit expire au passage du tour, puis le MJ annule ce passage
- **THEN** le bandit a de nouveau l'état

### Requirement: Rappels de tour
`turnReminders` SHALL donner, pour le début ou la fin du tour de l'unité active :
- **au début** : les états qui viennent d'expirer, ceux qui expireront à la fin de ce tour, et les dégâts récurrents « au début » ;
- **à la fin** : les états qui expirent à la fin de ce tour, les sauvegardes à refaire (DD, caractéristique et bonus du porteur), et les dégâts récurrents « à la fin ».

#### Scenario: Fin du tour du loup ([C6])
- **WHEN** le tour du Loup sanguinaire 2 se termine, avec Entravé (JS de Force DD 13, bonus +3) et Effrayé jusqu'à la fin de son tour
- **THEN** les rappels sont : Entravé, sauvegarde à refaire, JS de Force DD 13, bonus +3 ; Effrayé, qui expire

#### Scenario: Début du tour du Chef de bande ([1a])
- **WHEN** le tour du Chef de bande commence, Empoisonné jusqu'à la fin de son tour
- **THEN** le rappel annonce qu'Empoisonné expire à la fin de ce tour

#### Scenario: Dégâts récurrents
- **WHEN** un bandit en feu subit 1d4 dégâts de feu au début de chacun de ses tours, et son tour commence
- **THEN** le rappel donne 1d4 dégâts de feu

### Requirement: Sauvegardes et immunités au lancement
Le lancement et les renforts SHALL porter dans `combatant_added` les bonus de sauvegarde du combattant (du profil d'un monstre, ou de la fiche d'un PJ ou d'un PNJ) et les immunités d'état d'un monstre.

#### Scenario: Ogre
- **WHEN** une rencontre avec un ogre est lancée
- **THEN** son combattant porte ses bonus de sauvegarde du SRD
