# Spec Delta

## Purpose

Calcule la fiche d'un personnage à partir de ce qui est stocké (choix, dons, niveaux, équipement) et du contenu de règles actif, en gardant la décomposition de chaque valeur et en signalant les choix contraires aux règles 2024.

## ADDED Requirements

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

### Requirement: Erreurs signalées sans interrompre le calcul
Un personnage invalide SHALL produire une fiche calculée accompagnée de ses erreurs d'intégrité (règle, chemin, message), jamais une exception. Un identifiant absent du contenu actif SHALL produire une erreur de référence.

#### Scenario: Personnage invalide
- **WHEN** un personnage enfreint une règle d'intégrité
- **THEN** la fiche est calculée et liste l'erreur avec la règle concernée

#### Scenario: Référence inconnue
- **WHEN** le personnage cite une espèce absente du contenu actif
- **THEN** la fiche signale une erreur de référence
