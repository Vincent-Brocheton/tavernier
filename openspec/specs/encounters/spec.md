# encounters Specification

## Purpose
TBD - created by archiving change us-19a-rencontres-donnees. Update Purpose after archive.

## Requirements

### Requirement: Budget de PX d'une rencontre
Le moteur SHALL donner, pour chaque niveau de 1 à 20, les seuils Faible, Modérée et Élevée de la table « Budget de PX par personnage » du SRD. Le budget d'une rencontre SHALL être la somme des seuils de chaque personnage présent, selon son niveau.

#### Scenario: Quatre PJ de niveau 5 ([D1])
- **WHEN** Aldric, Mira, Thalia et Brannoc, tous de niveau 5, sont présents
- **THEN** le budget est Faible 2 000, Modérée 3 000, Élevée 4 400

#### Scenario: Niveaux mêlés
- **WHEN** trois PJ de niveau 5 et Kael, de niveau 3, sont présents
- **THEN** le budget est Faible 1 650, Modérée 2 475, Élevée 3 700

#### Scenario: Niveau 20
- **WHEN** un seul PJ de niveau 20 est présent
- **THEN** le budget est Faible 6 400, Modérée 13 200, Élevée 22 000

### Requirement: Difficulté d'une rencontre
La difficulté SHALL être le plus haut seuil que les PX des adversaires atteignent : Élevée, Modérée ou Faible ; sous le seuil Faible, la rencontre SHALL être « sous le budget faible ».

#### Scenario: Le relais du Sel ([D1])
- **WHEN** 3 000 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est Modérée

#### Scenario: Embuscade sur la route ([D1])
- **WHEN** 300 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est sous le budget faible

#### Scenario: Seuils au niveau 1 ([D1])
- **WHEN** quatre PJ de niveau 1 affrontent 300 PX, puis 200 PX d'adversaires
- **THEN** la première rencontre est Modérée, la seconde Faible

#### Scenario: Au-delà d'Élevée
- **WHEN** 5 000 PX d'adversaires affrontent quatre PJ de niveau 5
- **THEN** la rencontre est Élevée

### Requirement: Journal du combat
Le moteur SHALL décrire un combat par un journal d'événements à liste fermée (`combatant_added`, `combatant_removed`, `initiative_rolled`, `order_set`, `combat_started`, `turn_advanced`, `counter_used`, `counter_restored`, `undo`). L'état du combat SHALL être la projection du journal, dans l'ordre des événements. Un type inconnu SHALL être refusé. `undo` SHALL retirer de la projection l'événement qu'il désigne.

#### Scenario: Projection
- **WHEN** le journal ajoute Aldric et Varga, puis leurs jets d'initiative
- **THEN** l'état contient les deux combattants avec leur total

#### Scenario: Annulation
- **WHEN** le MJ annule le dernier « tour suivant »
- **THEN** le combattant actif redevient le précédent

#### Scenario: Type inconnu
- **WHEN** un événement de type « boule_de_feu » est lu
- **THEN** il est refusé

### Requirement: Jet d'initiative
Le jet d'initiative SHALL être un d20 plus le bonus d'initiative. La surprise SHALL donner le Désavantage ; Avantage et Désavantage SHALL s'annuler. Un groupe à initiative commune SHALL n'avoir qu'un jet pour tous ses membres.

#### Scenario: Aldric ([C3])
- **WHEN** Aldric (+4, Avantage) tire 15 et 11
- **THEN** son initiative est 19, dé écarté 11

#### Scenario: Brannoc surpris ([C3])
- **WHEN** Brannoc (+2), surpris, tire 6 et 14
- **THEN** son initiative est 8, dé écarté 14

#### Scenario: Avantage et surprise
- **WHEN** un combattant a l'Avantage et est surpris
- **THEN** il lance un seul d20

### Requirement: Ordre d'initiative et égalités
L'ordre par défaut SHALL suivre le total décroissant, puis le bonus décroissant. Les unités à égalité de total SHALL être signalées avec qui décide :
- le MJ, entre monstres ou entre un monstre et un PJ ;
- les joueurs concernés, entre PJ.

L'ordre fixé par le MJ (`order_set`) SHALL remplacer l'ordre par défaut ; un combattant ajouté ensuite SHALL entrer à sa place d'initiative.

#### Scenario: Le relais du Sel ([C3])
- **WHEN** Thalia 22, Aldric 19, Varga 17, Vétérans 1–2 15, Loups sanguinaires 1–3 15, Bandits 1–4 12, l'ogre 9, Brannoc 8 et Mira 8 sont tirés
- **THEN** l'ordre suit ces totaux ; l'égalité à 15 est au MJ, celle à 8 aux joueurs de Brannoc et de Mira

#### Scenario: Réordonner
- **WHEN** le MJ place les loups avant les vétérans
- **THEN** l'ordre garde ce choix

### Requirement: Rounds et tours
`combat_started` SHALL ouvrir le round 1 sur la première unité. `turn_advanced` SHALL passer à l'unité suivante, puis au round suivant après la dernière. Au début du tour d'une unité, sa réaction et ses actions légendaires SHALL lui être rendues. Un combattant SHALL pouvoir être ajouté ou retiré en cours de combat ; le retrait du combattant actif SHALL passer le tour à l'unité suivante.

#### Scenario: Tour suivant
- **WHEN** le combat commence et le MJ passe neuf tours sur neuf unités
- **THEN** le round 2 commence sur Thalia

#### Scenario: Réaction rendue
- **WHEN** Varga utilise sa réaction au round 1
- **THEN** elle est utilisée jusqu'au début du tour de Varga au round 2

#### Scenario: Retrait du combattant actif
- **WHEN** l'ogre est retiré pendant son tour
- **THEN** le tour passe à Brannoc

### Requirement: Compteurs d'un combattant
Le moteur SHALL suivre, par combattant :
- la réaction ;
- les actions légendaires, rendues au début de son tour ;
- les résistances légendaires, jamais rendues pendant la rencontre ;
- les capacités à recharge, rendues par un d6 réussi.

#### Scenario: Actions légendaires
- **WHEN** un dragon a 3 actions légendaires et en utilise 2
- **THEN** il lui en reste 1, puis 3 au début de son tour

#### Scenario: Recharge
- **WHEN** le souffle (recharge 5–6) est utilisé, puis le d6 donne 5 au début de son tour
- **THEN** le souffle est de nouveau disponible ; un 4 ne l'aurait pas rendu

### Requirement: Préparation des combattants
Le moteur SHALL numéroter les membres d'un groupe (« Vétéran 1 », « Vétéran 2 » ; un seul exemplaire garde son nom). Il SHALL aussi tirer les PV d'après les dés de vie (« 8d8 + 16 ») pour le mode « Jet au lancement ».

#### Scenario: Numérotation
- **WHEN** 3 loups sanguinaires sont préparés
- **THEN** ils s'appellent « Loup sanguinaire 1 » à « Loup sanguinaire 3 »

#### Scenario: PV tirés
- **WHEN** les PV du chef de bande (« 8d8 + 16 ») sont tirés
- **THEN** ils valent de 24 à 80

### Requirement: Mode et surprise d'un jet d'initiative
Le journal SHALL garder l'Avantage d'initiative d'un combattant, ainsi que le mode (normal, Avantage, Désavantage) et la surprise de chaque jet. La projection SHALL les rendre.

#### Scenario: Aldric et Brannoc ([C3])
- **WHEN** Aldric (Avantage) tire 15 et 11, et Brannoc, surpris, tire 6 et 14
- **THEN** la projection rend l'Avantage d'Aldric, et pour Brannoc le Désavantage et la surprise

### Requirement: Dernier événement annulable
Le moteur SHALL désigner le dernier événement encore effectif du journal, qui n'est ni une annulation ni déjà annulé. « Annuler » le vise ; sans événement effectif, il n'y a rien à annuler.

#### Scenario: Annuler deux fois
- **WHEN** le journal finit par « tour suivant », puis une annulation de ce tour
- **THEN** le dernier événement annulable est celui qui précède le tour annulé

### Requirement: Dégâts
Un événement `damage` SHALL infliger un montant d'un type de dégâts à une ou plusieurs cibles. Pour chaque cible :
- l'Immunité annule les dégâts ;
- la Résistance les divise par deux, arrondi à l'inférieur, puis la Vulnérabilité les double ;
- les défenses du profil s'ajoutent aux corrections manuelles (« Résistance ½ », « Vulnérabilité ×2 ») ;
- les PV temporaires sont consommés en premier ;
- les PV ne descendent pas sous 0.

#### Scenario: Mira ([1b])
- **WHEN** Mira, à 22 PV sur 38, subit 12 dégâts tranchants
- **THEN** elle est à 10 PV

#### Scenario: Résistance puis Vulnérabilité (SRD)
- **WHEN** une créature résistante et vulnérable au feu subit 23 dégâts de feu
- **THEN** elle en subit 22 (23 ÷ 2 = 11, puis × 2)

#### Scenario: Immunité
- **WHEN** un dragon noir, immunisé à l'acide, subit 30 dégâts d'acide
- **THEN** ses PV ne changent pas

#### Scenario: PV temporaires d'abord
- **WHEN** Aldric, à 41 PV et 5 PV temporaires, subit 8 dégâts
- **THEN** il a 0 PV temporaire et 38 PV

#### Scenario: Plusieurs cibles
- **WHEN** deux loups subissent 10 dégâts de feu
- **THEN** chacun perd 10 PV

### Requirement: Soins et PV temporaires
Un soin SHALL rendre des PV sans dépasser le maximum. Des PV temporaires SHALL ne pas se cumuler : le plus élevé est gardé, sauf demande de remplacement.

#### Scenario: Soin plafonné
- **WHEN** Mira, à 10 PV sur 38, reçoit 40 PV de soin
- **THEN** elle est à 38 PV

#### Scenario: PV temporaires non cumulés
- **WHEN** Aldric a 5 PV temporaires et en reçoit 3, puis 8
- **THEN** il en a 5, puis 8

### Requirement: Zéro point de vie
À 0 PV, un PJ SHALL être Inconscient et faire ses jets contre la mort :
- trois réussites le stabilisent, trois échecs le tuent ;
- un 20 naturel lui rend 1 PV, un 1 naturel compte deux échecs ;
- chaque dégât subi à 0 PV compte un échec, deux sur un coup critique ;
- un soin le relève et remet ses jets à zéro.

À 0 PV, un monstre SHALL être hors de combat et rester dans l'ordre.

#### Scenario: Mira tombe
- **WHEN** Mira, à 10 PV, subit 15 dégâts
- **THEN** elle est à 0 PV, Inconsciente, sans réussite ni échec

#### Scenario: Coup critique à 0 PV
- **WHEN** Mira, à 0 PV avec un échec, subit un coup critique
- **THEN** elle compte trois échecs et meurt

#### Scenario: Stabilisée
- **WHEN** Mira réussit trois jets contre la mort
- **THEN** elle est stabilisée, toujours Inconsciente

#### Scenario: 20 naturel
- **WHEN** Mira obtient un 20 naturel
- **THEN** elle revient à 1 PV, consciente, et ses jets repartent de zéro

#### Scenario: Monstre hors de combat
- **WHEN** un loup tombe à 0 PV
- **THEN** il est hors de combat et reste dans l'ordre d'initiative

### Requirement: Aperçu des dégâts
Le moteur SHALL donner, pour une cible et des dégâts envisagés, les dégâts subis et les PV avant et après, sans rien écrire au journal.

#### Scenario: Aperçu
- **WHEN** le MJ envisage 12 dégâts tranchants sur Mira, à 22 PV
- **THEN** l'aperçu donne 12 dégâts, de 22 à 10 PV

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

### Requirement: Concentration d'un combattant
Un événement `concentration_started` SHALL faire se concentrer un combattant sur un sort. Un événement `concentration_ended` SHALL y mettre fin. Un combattant n'a qu'une concentration à la fois : en commencer une autre met fin à la précédente (SRD).

À la fin d'une concentration, les états posés avec un lien vers ce lanceur SHALL être retirés de tous les combattants (EF-CON-05).

#### Scenario: Bénédiction
- **WHEN** Mira se concentre sur Bénédiction, et le MJ pose « Béni » sur Aldric et Thalia, lié à la concentration de Mira
- **THEN** Mira est concentrée sur Bénédiction, et Aldric et Thalia ont l'effet « Béni »

#### Scenario: Fin de concentration
- **WHEN** le MJ met fin à la concentration de Mira
- **THEN** Mira n'est plus concentrée, et « Béni » est retiré d'Aldric et de Thalia ; leurs autres états restent

#### Scenario: Nouvelle concentration
- **WHEN** Mira, concentrée sur Bénédiction, se concentre sur Immobilisation de personne
- **THEN** Mira est concentrée sur Immobilisation de personne, et les effets liés à Bénédiction sont retirés

### Requirement: Test de concentration
Chaque événement `damage` qui inflige au moins 1 dégât à un combattant concentré SHALL ajouter un test de concentration en attente. Son DD est le plus élevé de 10 et de la moitié des dégâts subis (arrondie à l'inférieur), plafonné à 30 (SRD). Les dégâts comptés sont ceux d'après Résistance et Vulnérabilité, PV temporaires compris.

Un événement `concentration_check` SHALL résoudre le plus ancien test en attente. Une réussite garde la concentration. Un échec y met fin, avec ses effets liés.

#### Scenario: DD 10 ([1c])
- **WHEN** Mira, concentrée, subit 12 dégâts tranchants
- **THEN** un test de concentration est en attente : JS de Constitution DD 10

#### Scenario: DD de la moitié
- **WHEN** un combattant concentré subit 45 dégâts
- **THEN** le DD vaut 22

#### Scenario: Plafond
- **WHEN** un combattant concentré subit 70 dégâts
- **THEN** le DD vaut 30

#### Scenario: Échec
- **WHEN** Mira rate son test de concentration
- **THEN** Bénédiction prend fin, et « Béni » est retiré d'Aldric et de Thalia

#### Scenario: Aucun dégât
- **WHEN** un combattant concentré, immunisé contre le poison, subit des dégâts de poison
- **THEN** aucun test n'est en attente

### Requirement: Alerte de concentration
Le combat SHALL afficher une alerte de concentration ([1c]) pour chaque test en attente. Elle porte :
- le combattant, « Constitution DD n » ;
- l'explication du DD et le bonus de JS de Constitution s'il est connu ;
- ce qu'un échec retire ;
- les boutons Échec et Réussite.

Un échec SHALL demander confirmation avant d'être écrit.

La carte d'un combattant concentré SHALL porter la puce « Concentration · <sort> ».

L'aperçu du pavé de dégâts SHALL annoncer, pour une cible concentrée, « Concentration : JS de CON DD n ».

#### Scenario: Alerte et réussite
- **WHEN** Mira, concentrée sur Bénédiction, subit 12 dégâts, et le MJ touche « Réussite »
- **THEN** l'alerte « Constitution DD 10 » s'affiche, puis disparaît, et la puce « Concentration · Bénédiction » reste

#### Scenario: Échec confirmé
- **WHEN** le MJ touche « Échec » sur l'alerte, puis confirme
- **THEN** la puce de concentration et l'effet « Béni » lié disparaissent

### Requirement: Concentration au détail et à la pose d'un état
Le détail d'un combattant SHALL proposer :
- « Se concentrer », avec le nom du sort, quand il n'est pas concentré ;
- « Mettre fin », avec confirmation, quand il l'est.

La feuille « Ajouter un état » [C5] SHALL proposer « Lié à un sort de concentration » : « Aucun », ou un des combattants concentrés. La fiche d'un état lié SHALL le mentionner.

#### Scenario: Se concentrer puis lier
- **WHEN** le MJ fait se concentrer Mira sur Bénédiction depuis son détail, puis pose un effet « Béni » sur Aldric, lié à « Mira · Bénédiction »
- **THEN** la carte de Mira porte « Concentration · Bénédiction », et la fiche de l'effet sur Aldric mentionne la concentration de Mira
