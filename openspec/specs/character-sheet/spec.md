# character-sheet Specification

## Purpose
Calcule la fiche d'un personnage à partir de ce qui est stocké (choix, dons, niveaux, équipement) et du contenu de règles actif, en gardant la décomposition de chaque valeur et en signalant les choix contraires aux règles 2024.

## Requirements

### Requirement: Fiche calculée par une fonction pure
Le système SHALL calculer la fiche d'un personnage uniquement à partir du personnage stocké et du contenu actif fournis, sans base de données, réseau ni interface. Deux appels avec les mêmes entrées SHALL produire la même fiche.

#### Scenario: Même entrée, même fiche
- **WHEN** la fiche d'Aldric niveau 1 est calculée deux fois avec le pack SRD de l'échantillon M0
- **THEN** les deux fiches sont identiques

#### Scenario: Aldric niveau 1 identique à la planche [D1]
- **WHEN** la fiche est calculée à partir de l'entrée de la fixture `aldric_n1`
- **THEN** chaque valeur attendue de la fixture est reproduite à l'identique (critère de sortie M0, cahier §3)

### Requirement: Valeurs de caractéristique
Chaque valeur de caractéristique SHALL valoir la valeur de base, plus le bonus d'Historique choisi, plus les augmentations accordées par les dons. Le modificateur SHALL suivre la table « Valeurs et modificateurs de caractéristique » (SRD p. 22).

#### Scenario: Force d'Aldric
- **WHEN** Aldric a une base de Force 15 et le bonus +2 du Soldat
- **THEN** sa Force vaut 17 et son modificateur +3

#### Scenario: Intelligence basse
- **WHEN** Aldric a une base d'Intelligence 8 sans bonus
- **THEN** sa valeur est 8 et son modificateur −1

### Requirement: Bonus de maîtrise
Le bonus de maîtrise SHALL dépendre du niveau de personnage selon la table « Progression des personnages » (SRD p. 24).

#### Scenario: Niveau 1
- **WHEN** le personnage est de niveau 1
- **THEN** son bonus de maîtrise est +2

### Requirement: Jets de sauvegarde
Chaque jet de sauvegarde SHALL valoir le modificateur de la caractéristique, plus le bonus de maîtrise si la classe de niveau 1 du personnage accorde cette maîtrise (SRD p. 56 pour le Guerrier).

#### Scenario: Sauvegardes du Guerrier
- **WHEN** Aldric, Guerrier 1 avec FOR 17, DEX 13 et CON 15, est calculé
- **THEN** ses jets valent FOR +5, CON +4 et DEX +1

### Requirement: Compétences et Perception passive
Chaque compétence SHALL valoir le modificateur de sa caractéristique, plus le bonus de maîtrise si une source accorde la maîtrise (Historique, choix de classe, choix d'espèce). La Perception passive SHALL valoir 10 plus le bonus de Sagesse (Perception) (SRD p. 23).

#### Scenario: Compétences d'Aldric
- **WHEN** Aldric maîtrise Athlétisme et Intimidation (Soldat), Perception et Survie (Guerrier) et Intuition (Compétent)
- **THEN** Athlétisme vaut +5, Intimidation +2, Perception +3, Intuition +3 et Arcanes −1

#### Scenario: Perception passive d'Aldric
- **WHEN** Aldric a Perception +3
- **THEN** sa Perception passive vaut 13

### Requirement: Initiative
L'Initiative SHALL valoir le modificateur de Dextérité plus les bonus des effets `modify_initiative`, et indiquer l'Avantage quand un effet l'accorde (SRD p. 24 et p. 92).

#### Scenario: Vigilant
- **WHEN** Aldric (DEX +1) a le don Vigilant au niveau 1
- **THEN** son Initiative vaut +3 sans Avantage

### Requirement: Classe d'armure
La CA SHALL suivre l'armure équipée (base, modificateur de Dextérité plafonné selon la catégorie), plus le bouclier équipé, plus les effets `modify_ac` dont la condition d'équipement est remplie ; sans armure, elle vaut 10 plus le modificateur de Dextérité (SRD p. 24 et p. 98).

#### Scenario: Cotte de mailles, bouclier et Défense
- **WHEN** Aldric porte une cotte de mailles et un bouclier et a le don Défense
- **THEN** sa CA vaut 19

#### Scenario: Sans armure
- **WHEN** Aldric n'a ni armure ni bouclier équipés
- **THEN** sa CA vaut 11 et Défense ne s'applique pas

### Requirement: Vitesse, points de vie et dés de vie
La vitesse SHALL être celle de l'espèce, en pieds. Au niveau 1, les PV maximum SHALL valoir le maximum du dé de vie de la classe plus le modificateur de Constitution, et le personnage SHALL disposer d'un dé de vie de ce type (SRD p. 24).

#### Scenario: Aldric niveau 1
- **WHEN** Aldric, Humain Guerrier 1 avec CON 15, est calculé
- **THEN** sa vitesse vaut 30 pieds, ses PV maximum 12 et il dispose de 1 dé de vie d10

### Requirement: Emplacements de bottes
Le nombre d'emplacements de bottes SHALL venir des effets `grant_mastery_slots` au niveau de la classe (SRD p. 56).

#### Scenario: Bottes du Guerrier 1
- **WHEN** Aldric est Guerrier 1
- **THEN** il dispose de 3 emplacements de bottes

### Requirement: Attaques
Chaque arme portée SHALL donner une attaque : modificateur (Force au corps à corps et pour le lancer, Dextérité à distance, le meilleur des deux avec Finesse) plus la maîtrise si l'arme est maîtrisée ; dégâts = dé de l'arme plus ce modificateur ; botte indiquée si choisie. Les mains nues SHALL valoir Force plus maîtrise, pour 1 + Force contondants (SRD p. 97, p. 189).

#### Scenario: Épée longue et javeline
- **WHEN** Aldric (FOR +3, maîtrise +2) porte une épée longue et des javelines avec leurs bottes choisies
- **THEN** l'épée longue attaque à +5 pour 1d8+3 tranchants avec Sape, et la javeline à +5 pour 1d6+3 perforants, portée 30/120 pieds, avec Ralentissement

#### Scenario: Mains nues
- **WHEN** Aldric attaque à mains nues
- **THEN** l'attaque est à +5 et inflige 4 dégâts contondants

### Requirement: Ressources
Chaque effet `grant_resource` SHALL donner une ressource avec son maximum au niveau du personnage.

#### Scenario: Second souffle et Inspiration héroïque
- **WHEN** Aldric est un Humain Guerrier 1
- **THEN** il a Second souffle 2 utilisations et l'Inspiration héroïque (Ingénieux)

### Requirement: Décomposition de chaque valeur
Chaque valeur calculée SHALL porter la liste de ses contributions (source et valeur), dont la somme égale la valeur (EF-PJ-03). Une source est la base, une caractéristique ou l'identifiant de l'entité qui contribue.

#### Scenario: Force décomposée
- **WHEN** la Force d'Aldric est calculée
- **THEN** sa décomposition est « base 15 » et « Soldat +2 »

#### Scenario: CA décomposée
- **WHEN** la CA d'Aldric est calculée
- **THEN** sa décomposition est « cotte de mailles 16 », « bouclier +2 » et « Défense +1 »

### Requirement: Bonus d'Historique conformes
Les bonus d'Historique SHALL porter uniquement sur les 3 caractéristiques de l'Historique, selon une répartition +2/+1 ou +1/+1/+1, sans porter une valeur au-delà de 20 (cahier §11.3, SRD p. 87). Un écart SHALL produire une erreur d'intégrité.

#### Scenario: Caractéristique non éligible
- **WHEN** un Soldat place son +1 en Intelligence
- **THEN** la fiche signale une erreur sur la répartition de l'Historique

#### Scenario: Répartition 1-1-1 valide
- **WHEN** un Soldat répartit +1 en Force, Dextérité et Constitution
- **THEN** aucune erreur n'est signalée sur la répartition

#### Scenario: Plafond de 20
- **WHEN** une valeur de base de 19 reçoit +2 de l'Historique
- **THEN** la fiche signale une erreur de plafond

### Requirement: Dons accordés conformes
Chaque don du personnage SHALL correspondre à un don accordé par une source (Historique, espèce, classe), dans la catégorie exigée par cette source ; le don d'un Historique est forcément un don d'origines (cahier §11.3).

#### Scenario: Polyvalent avec un don qui n'est pas d'origines
- **WHEN** un Humain choisit Défense comme don de Polyvalent
- **THEN** la fiche signale une erreur de catégorie de don

#### Scenario: Don d'un Historique remplacé
- **WHEN** un Soldat déclare Vigilant au lieu de Sauvagerie martiale comme don d'Historique
- **THEN** la fiche signale une erreur sur le don d'origine

### Requirement: Bottes choisies conformes
Le nombre de bottes choisies SHALL être au plus égal au nombre d'emplacements, et chaque botte SHALL porter sur une arme maîtrisée par une classe du personnage (cahier §11.3).

#### Scenario: Trop de bottes
- **WHEN** Aldric, Guerrier 1, choisit 4 bottes
- **THEN** la fiche signale une erreur de nombre de bottes

#### Scenario: Arme non maîtrisée
- **WHEN** un personnage dont la classe ne maîtrise que les armes courantes choisit la botte de l'épée longue
- **THEN** la fiche signale une erreur de botte sur une arme non maîtrisée

### Requirement: Prérequis de multiclassage
Chaque classe ajoutée au-delà de la première SHALL exiger une valeur de 13 dans la caractéristique principale de la nouvelle classe et de chaque classe existante ; pour une classe à plusieurs caractéristiques principales au choix, une seule suffit (cahier §11.3, SRD p. 26).

#### Scenario: Prérequis non remplis
- **WHEN** un Guerrier avec FOR 12 et DEX 12 prend un niveau dans une seconde classe
- **THEN** la fiche signale une erreur de prérequis de multiclassage

#### Scenario: Prérequis remplis
- **WHEN** un Guerrier avec FOR 15 prend un niveau dans une seconde classe dont il a 13 dans la caractéristique principale
- **THEN** aucune erreur de multiclassage n'est signalée

### Requirement: Génération des valeurs
Les valeurs de base SHALL respecter la méthode déclarée : acquisition par points (valeurs de 8 à 15, 27 points dépensés exactement, SRD p. 22), valeurs standard (15, 14, 13, 12, 10, 8 dans un ordre quelconque) ou génération aléatoire (jets déclarés, de 3 à 18, répartis tels quels).

#### Scenario: Acquisition par points d'Aldric
- **WHEN** Aldric a pour bases FOR 15, DEX 13, CON 14, INT 8, SAG 12, CHA 10
- **THEN** le coût vaut 27 et aucune erreur n'est signalée

#### Scenario: Points dépassés
- **WHEN** des bases en acquisition par points coûtent 29 points
- **THEN** la fiche signale une erreur de génération des valeurs

### Requirement: Choix conformes
Chaque effet `choice` actif SHALL recevoir exactement `count` sélections, chacune correspondant à une option. Les choix d'un don SHALL être rangés dans l'instance de ce don, pour qu'un don répétable pris deux fois garde deux sélections distinctes ; les autres choix sont rangés par identifiant de choix.

#### Scenario: Trop de sélections
- **WHEN** un Humain sélectionne deux compétences pour Compétent
- **THEN** la fiche signale une erreur de choix et n'accorde aucune des deux maîtrises

#### Scenario: Choix manquant
- **WHEN** un Humain n'a rien sélectionné pour Compétent
- **THEN** la fiche signale une erreur de choix

#### Scenario: Don répétable pris deux fois
- **WHEN** un personnage prend Doué deux fois avec trois compétences différentes à chaque fois
- **THEN** il maîtrise les six compétences

### Requirement: Erreurs signalées sans interrompre le calcul
Un personnage invalide SHALL produire une fiche calculée accompagnée de ses erreurs d'intégrité (règle, chemin, message), jamais une exception. Un identifiant absent du contenu actif SHALL produire une erreur de référence.

#### Scenario: Personnage invalide
- **WHEN** un personnage enfreint une règle d'intégrité
- **THEN** la fiche est calculée et liste l'erreur avec la règle concernée

#### Scenario: Référence inconnue
- **WHEN** le personnage cite une espèce absente du contenu actif
- **THEN** la fiche signale une erreur de référence

### Requirement: Prérequis de multiclassage selon la caractéristique principale
Le prérequis de 13 (SRD p. 26) SHALL porter sur toutes les caractéristiques principales d'une classe, sauf si la classe déclare que l'une suffit.

#### Scenario: Moine à deux caractéristiques
- **WHEN** un personnage se multiclasse en Moine avec 13 en Dextérité et 12 en Sagesse
- **THEN** une erreur de multiclassage est signalée

#### Scenario: Guerrier, l'une ou l'autre
- **WHEN** un personnage se multiclasse en Guerrier avec 13 en Dextérité et 8 en Force
- **THEN** le prérequis du Guerrier est rempli

### Requirement: Option nommée d'un choix
Une sélection SHALL pouvoir désigner une option de `choice` par son nom. Les effets de l'option deviennent alors actifs.

#### Scenario: Protecteur (SRD p. 38)
- **WHEN** un Clerc choisit « Protecteur »
- **THEN** il maîtrise les armes de guerre

### Requirement: Bottes de corps à corps
Une classe dont les bottes sont réservées au corps à corps SHALL refuser une arme à distance.

#### Scenario: Barbare (SRD p. 31)
- **WHEN** un Barbare prend une botte sur un arc long
- **THEN** une erreur de botte est signalée

### Requirement: Expertise
L'Expertise SHALL doubler le bonus de maîtrise de la compétence concernée, qu'elle vienne d'un effet `grant_expertise` ou de `class_levels[].expertise`.

#### Scenario: Roublard
- **WHEN** un Roublard niveau 1 de Dextérité 15 a l'Expertise en Discrétion, qu'il maîtrise
- **THEN** son bonus de Discrétion vaut +2 + 2 + 2 = +6

### Requirement: Décomposition des compétences et des sauvegardes
Chaque compétence, chaque jet de sauvegarde et la Vitesse SHALL porter leurs contributions, dont la somme égale la valeur.

#### Scenario: Athlétisme d'Aldric
- **WHEN** l'Athlétisme d'Aldric est calculée
- **THEN** sa décomposition est « Force +3 » et « maîtrise +2 »

#### Scenario: Compétence bonifiée par un effet
- **WHEN** un Clerc Thaumaturge de Sagesse 15 calcule Religion
- **THEN** sa décomposition compte le bonus de l'Ordre divin

### Requirement: Fiche du personnage
La page d'un personnage enregistré SHALL afficher son en-tête et ses 7 onglets. Principal et Compétences SHALL afficher les valeurs calculées, et toucher une valeur SHALL ouvrir sa décomposition.

#### Scenario: Ouverture
- **WHEN** le joueur touche un personnage de la liste
- **THEN** sa fiche s'ouvre sur l'onglet Principal

#### Scenario: Décomposition d'une caractéristique
- **WHEN** le joueur touche sa Force
- **THEN** il voit la base, le bonus d'Historique, le total, la règle du modificateur et ce qui l'utilise

#### Scenario: Personnage introuvable
- **WHEN** l'identifiant de l'adresse n'existe pas
- **THEN** la page le dit et propose de revenir

### Requirement: Décomposition d'une attaque
Le bonus d'une attaque SHALL porter ses contributions, dont la somme égale le bonus.

#### Scenario: Épée longue d'Aldric
- **WHEN** l'attaque à l'épée longue d'Aldric est calculée
- **THEN** sa décomposition est « Force +3 » et « maîtrise +2 »

#### Scenario: Archerie
- **WHEN** un personnage avec Archerie attaque à l'arc
- **THEN** sa décomposition compte le don

### Requirement: Onglet Combat
L'onglet Combat SHALL lister les attaques, les ressources et les bottes d'arme. Une botte choisie SHALL afficher son effet.

#### Scenario: Botte sur l'arme
- **WHEN** Aldric a choisi la botte de l'épée longue
- **THEN** la carte de l'arme montre Sape et son effet

#### Scenario: Décomposition du toucher
- **WHEN** le joueur touche le bonus d'attaque
- **THEN** la décomposition s'ouvre

### Requirement: Onglet Aptitudes
L'onglet Aptitudes SHALL grouper les aptitudes atteintes par origine, avec un filtre sur celles qui ont des utilisations et sur les dons.

#### Scenario: Groupes
- **WHEN** l'onglet s'ouvre pour un Guerrier humain
- **THEN** il voit Guerrier 1, Humain et Dons

#### Scenario: Aptitude d'un niveau supérieur
- **WHEN** le personnage est niveau 1
- **THEN** les aptitudes des niveaux suivants sont absentes

#### Scenario: Filtre
- **WHEN** le joueur choisit « Avec utilisations »
- **THEN** seules les aptitudes à ressource restent

### Requirement: Bonus de caractéristique
Un effet `ability_bonus` actif SHALL augmenter la caractéristique, sans dépasser `max`. Une Amélioration de caractéristique SHALL s'appliquer depuis `{"str": 1, "con": 1}` dans les choix du don.

#### Scenario: Aldric niveau 5
- **WHEN** Aldric a l'Amélioration de caractéristique +1 FOR, +1 CON
- **THEN** sa Force vaut 18 et sa Constitution 16, comme sur [D1]

#### Scenario: Plafond
- **WHEN** un bonus de +2 porte sur une valeur de 19
- **THEN** la valeur s'arrête à 20

#### Scenario: Répartition inconnue
- **WHEN** les choix du don ne correspondent à aucune option
- **THEN** la fiche signale une erreur de choix

### Requirement: Don accordé par une Amélioration de caractéristique
Une aptitude qui accorde un don général SHALL accepter tout don éligible.

#### Scenario: Don d'origines
- **WHEN** un Guerrier niveau 4 prend Doué
- **THEN** aucune erreur de don n'est signalée

### Requirement: Montée de niveau
`levelGain` SHALL rendre les gains du niveau suivant et `applyLevelUp` le personnage monté. L'assistant SHALL enregistrer le personnage sans réseau.

#### Scenario: Aldric du niveau 1 au niveau 5
- **WHEN** Aldric monte quatre fois avec les choix de [D1]
- **THEN** sa fiche retrouve les valeurs de la fixture `aldric_n5`

#### Scenario: Sous-classe
- **WHEN** un Guerrier passe au niveau 3
- **THEN** il choisit sa sous-classe et l'étape reste bloquée sans elle

#### Scenario: Don non répétable
- **WHEN** un personnage a déjà Vigilant
- **THEN** le don est grisé avec sa raison

#### Scenario: Conditions d'un don
- **WHEN** un personnage de Force et Dextérité 12 regarde Empoigneur
- **THEN** le don est grisé avec sa raison

#### Scenario: Style de combat
- **WHEN** un Paladin passe au niveau 2
- **THEN** on lui propose les dons de style de combat, pas les dons généraux

#### Scenario: Toute classe jusqu'au niveau 20
- **WHEN** chaque classe monte du niveau 1 au niveau 20 avec des choix valides
- **THEN** aucune erreur d'intégrité n'est signalée

#### Scenario: Niveau 20
- **WHEN** le personnage est niveau 20
- **THEN** le bouton de montée n'apparaît pas

### Requirement: Sorts à la montée de niveau
`spellGain` SHALL rendre les sorts gagnés au niveau suivant et l'assistant SHALL les demander. Un sort déjà connu SHALL être grisé avec la règle.

#### Scenario: Clerc niveau 4
- **WHEN** un Clerc passe du niveau 3 au niveau 4
- **THEN** il gagne 1 sort mineur et 1 sort préparé

#### Scenario: Magicien niveau 2
- **WHEN** un Magicien passe au niveau 2
- **THEN** il ajoute 2 sorts à son grimoire et prépare 1 sort de plus

#### Scenario: Niveau de sort atteint
- **WHEN** un Clerc passe au niveau 3
- **THEN** on lui propose des sorts jusqu'au 2e niveau

#### Scenario: Occultiste
- **WHEN** un Occultiste passe au niveau 3
- **THEN** le niveau de sort atteint vient de son niveau de pacte, soit le 2e

#### Scenario: Toute classe au niveau 20
- **WHEN** un lanceur monte jusqu'au niveau 20
- **THEN** ses sorts mineurs et préparés valent ceux de sa table

### Requirement: Initié à la magie à la montée de niveau
L'Initié à la magie SHALL être proposé comme don, avec une liste autre que celles déjà prises.

#### Scenario: Seconde prise
- **WHEN** un Acolyte prend le don au niveau 4
- **THEN** la liste du Clerc est grisée

### Requirement: Sorts mineurs d'un Combattant béni
Une option qui donne accès à des sorts mineurs d'une autre liste SHALL les demander dans cette liste.

#### Scenario: Paladin
- **WHEN** un Paladin choisit Combattant béni au niveau 2
- **THEN** il choisit 2 sorts mineurs de Clerc

### Requirement: Choix de la classe à la montée de niveau
L'assistant SHALL proposer les classes actuelles et les autres classes, avec le prérequis de 13 dans la caractéristique principale de la nouvelle classe et des classes existantes.

#### Scenario: Prérequis rempli
- **WHEN** Aldric, DEX 13, monte de niveau
- **THEN** Roublard est proposé avec « Dextérité 13 requise · Dextérité 13 ✓ »

#### Scenario: Prérequis manquant
- **WHEN** Aldric, SAG 12, monte de niveau
- **THEN** Clerc est grisé avec « Sagesse 12 : il manque 1 »

### Requirement: Premier niveau d'une nouvelle classe
Une nouvelle classe SHALL n'accorder que les traits de son multiclassage, ses aptitudes de niveau 1 et les PV de ses niveaux suivants.

#### Scenario: Points de vie
- **WHEN** un personnage de CON +2 prend un niveau de Roublard
- **THEN** il gagne 5 + 2 PV, pas le maximum du dé

#### Scenario: Armes
- **WHEN** un Magicien prend un niveau de Roublard
- **THEN** il ne maîtrise pas la rapière

#### Scenario: Compétence
- **WHEN** un personnage prend un niveau de Barde, de Rôdeur ou de Roublard
- **THEN** il choisit 1 compétence de cette classe, hors celles qu'il maîtrise

#### Scenario: Magicien
- **WHEN** un personnage prend un niveau de Magicien
- **THEN** il inscrit 6 sorts dans son grimoire

### Requirement: Dés de vie par type
Les dés de vie SHALL se regrouper par type.

#### Scenario: Clerc et Paladin
- **WHEN** un personnage est Clerc 5 / Paladin 5
- **THEN** il a 5 d8 et 5 d10

#### Scenario: Paladin et Guerrier
- **WHEN** un personnage est Paladin 5 / Guerrier 5
- **THEN** il a 10 d10

### Requirement: Une seule formule de classe d'armure
Une formule `ac_formula` valide SHALL remplacer 10 + DEX, et une seule SHALL s'appliquer.

#### Scenario: Barbare
- **WHEN** un Barbare de DEX +1 et CON +2 ne porte pas d'armure
- **THEN** sa CA vaut 13

#### Scenario: Barbare et Moine
- **WHEN** ce Barbare a aussi un niveau de Moine et SAG +1
- **THEN** sa CA vaut toujours 13

### Requirement: Valeurs d'incantation par classe
`computeSheet` SHALL calculer, pour chaque classe de lanceur, la caractéristique, le DD, l'attaque, les sorts mineurs et les sorts préparés de sa table.

#### Scenario: Mira
- **WHEN** la fiche de Mira, Clerc 5 à SAG 17, est calculée
- **THEN** son DD vaut 14, son attaque +6, et elle prépare 9 sorts

#### Scenario: Orin
- **WHEN** la fiche d'Orin, Clerc 3 / Paladin 4, est calculée
- **THEN** le Clerc prépare 6 sorts en SAG et le Paladin 5 en CHA, tous deux à DD 13

### Requirement: Emplacements de sort
Les emplacements SHALL venir de la table de la classe, ou de la table du multiclassage à partir de deux classes à emplacements.

#### Scenario: Une seule classe
- **WHEN** un personnage est Paladin 4
- **THEN** il a 3 emplacements du 1er niveau

#### Scenario: Multiclassage
- **WHEN** un personnage est Ensorceleur 3 / Rôdeur 4
- **THEN** son niveau de lanceur vaut 5 et ses emplacements 4 / 3 / 2

#### Scenario: Une seule classe de lanceur parmi deux
- **WHEN** un personnage est Guerrier 5 / Clerc 3
- **THEN** il a les emplacements d'un Clerc 3

#### Scenario: Magie de pacte
- **WHEN** un personnage est Occultiste 5
- **THEN** il a 2 emplacements du 3e niveau, à part des autres

### Requirement: Sorts de la fiche
La fiche SHALL lister les sorts de classe, les sorts accordés et ceux des dons, avec leur classe.

#### Scenario: Sorts accordés
- **WHEN** la fiche d'un Clerc 5 du Domaine de la Vie est ouverte
- **THEN** ses 6 sorts de domaine apparaissent comme toujours préparés

#### Scenario: Palier de la classe
- **WHEN** un Guerrier 4 / Clerc 3 du Domaine de la Vie est ouvert
- **THEN** ses sorts de domaine du palier 5 n'apparaissent pas

### Requirement: Onglet Sorts
L'onglet Sorts SHALL montrer les valeurs décomposées, les emplacements, les filtres et les sorts par niveau. Un personnage sans sort SHALL voir un état vide.

#### Scenario: Personnage sans sort
- **WHEN** Aldric ouvre l'onglet
- **THEN** il voit « Aucun sort »

#### Scenario: Filtre
- **WHEN** Mira filtre sur Concentration
- **THEN** seuls ses sorts à concentration restent

### Requirement: Fiche de sort
Toucher un sort SHALL ouvrir sa fiche : niveau, école, incantation, portée, composantes, durée et description.

#### Scenario: Bénédiction
- **WHEN** Mira touche Bénédiction
- **THEN** la portée s'affiche en mètres et la durée indique la concentration
