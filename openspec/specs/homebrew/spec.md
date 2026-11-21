# homebrew Specification

## Purpose
TBD - created by archiving change us-27-editeurs-homebrew. Update Purpose after archive.

## Requirements

### Requirement: Mes packs
L'onglet Homebrew ([H01]) SHALL lister les brouillons de l'utilisateur, avec leur version, leur contenu et l'état de leur vérification, et le pack SRD 5.2.1, verrouillé. « Nouveau pack » SHALL créer un brouillon avec un nom, un espace de noms, la version 0.1.0, une licence et un auteur. « Créer une entité » SHALL proposer les 8 types d'entités.

#### Scenario: Nouveau pack
- **WHEN** Inès crée le pack « Gardiens des Marches »
- **THEN** il apparaît dans « Mes packs » en version 0.1.0, brouillon, et reste après un redémarrage de l'app

### Requirement: Vérification d'un pack
La page d'un pack SHALL montrer ses entités par type et le panneau « Vérification ». Ce panneau porte les problèmes de `validatePack` et les contraintes 2024 de chaque type (cahier §7.1). Un problème SHALL bloquer la publication sans bloquer l'enregistrement : un brouillon peut rester incomplet.

#### Scenario: Historique incomplet
- **WHEN** un Historique n'a que 2 caractéristiques
- **THEN** le brouillon s'enregistre, et la vérification indique « Exactement 3 caractéristiques »

### Requirement: Éditeur d'effets
L'éditeur d'effets ([H03]) SHALL ne proposer que les opérations du DSL v1, chacune par un formulaire guidé, sans formule libre ni code (EF-HB-01). Il SHALL montrer « Ce que le joueur lira ». Un effet enregistré SHALL passer `validateEffect`.

#### Scenario: Bonus de CA avec bouclier
- **WHEN** l'auteur ajoute « Modifier la CA » de +1, tant qu'il porte un bouclier
- **THEN** l'effet enregistré est `modify_ac` de valeur 1, avec sa condition, et il passe `validateEffect`

#### Scenario: Ressource à utilisations
- **WHEN** l'auteur ajoute « Ressource à utilisations », d'un nombre égal au bonus de maîtrise, rechargée en entier par un Repos long
- **THEN** l'effet enregistré est `grant_resource` de maximum `{"ref": "proficiency_bonus"}`, avec la recharge `long_rest` de `all`, et il passe `validateEffect`

#### Scenario: Choix imbriqué
- **WHEN** l'auteur ajoute un choix « Lignage » de deux options nommées, chacune avec ses propres effets, dont un sort accordé à partir du niveau 3
- **THEN** l'effet enregistré est `choice`, avec ses `labels` et ses `options`, et le sort porte `when.level` 3

### Requirement: Éditeur de Don
L'éditeur de Don SHALL exiger une catégorie (origine, général, style de combat ou faveur épique), et proposer les prérequis, « Répétable » et les effets.

#### Scenario: Don sans catégorie
- **WHEN** un Don est enregistré sans catégorie
- **THEN** la vérification signale la catégorie manquante

### Requirement: Éditeur d'Historique
L'éditeur d'Historique SHALL exiger exactement 3 caractéristiques, un don de catégorie origine, 2 compétences et un outil (ou une catégorie d'outil). Il SHALL proposer l'équipement et l'or des options A et B.

#### Scenario: Don d'une autre catégorie
- **WHEN** l'auteur choisit un don de catégorie générale comme don d'origine
- **THEN** le choix est refusé : seuls les dons d'origine sont proposés

### Requirement: Éditeur de Sort
L'éditeur de Sort SHALL proposer :
- le niveau (0 à 9) et l'école ;
- le temps d'incantation et le rituel ;
- la portée et les composantes ;
- la durée et la concentration ;
- les listes de classes, parmi les seules classes qui ont une liste de sorts.

Un sort qui cite une classe SHALL entrer dans la liste de cette classe quand son pack est actif, sans modifier la classe.

#### Scenario: Sort du Magicien
- **WHEN** l'auteur crée « Lanterne de brume », sort d'Illusion de 1er niveau, pour le Magicien
- **THEN** le sort cite `srd:class:wizard`, et la liste du Magicien est celle du SRD suivie de ce sort

### Requirement: Éditeur d'Objet
L'éditeur d'Objet ([H05]) SHALL proposer une arme, une armure, un objet magique ou un objet courant.
- Une arme SHALL avoir une botte d'arme ; sans elle, la vérification le signale.
- Une rareté SHALL rendre magique une arme ou une armure. Ses effets s'appliquent quand elle est équipée, et harmonisée si elle le demande.

#### Scenario: Arme sans botte
- **WHEN** une arme est enregistrée sans botte d'arme
- **THEN** le brouillon s'enregistre, et la vérification indique « une arme a toujours une botte d'arme »

#### Scenario: Bouclier magique harmonisé
- **WHEN** Aldric remplace son bouclier par un bouclier peu courant qui demande l'harmonisation et porte « +1 à la CA »
- **THEN** sa CA passe de 19 à 20 une fois le bouclier harmonisé, et reste à 19 sans harmonisation

### Requirement: Éditeur d'Espèce
L'éditeur d'Espèce SHALL proposer le type de créature, les tailles, la Vitesse et les traits, sans bonus de caractéristique (règles 2024). Chaque trait SHALL être une entité `feature` du pack, de source l'espèce et de niveau 1, avec son nom, son texte et ses effets. Une sous-lignée SHALL être un trait à choix, comme le Lignage elfique du SRD. Une espèce sans taille SHALL être signalée par la vérification.

#### Scenario: Espèce et son trait
- **WHEN** l'auteur crée l'espèce « Brumelin », Petite, de 9 m de Vitesse, avec le trait « Vision brumeuse » (Vision dans le noir de 18 m)
- **THEN** le pack contient `…:species:brumelin`, qui cite `…:feature:brumelin-vision-brumeuse`, et ce trait a pour source l'espèce et pour effet `grant_sense` de 60 pieds

#### Scenario: Espèce sans taille
- **WHEN** une espèce est enregistrée sans taille
- **THEN** la vérification indique « une espèce a au moins une taille »

### Requirement: Éditeur de Classe
L'éditeur de Classe SHALL proposer :
- les traits de base : dé de vie, caractéristiques principales, jets de sauvegarde (2), compétences, maîtrises d'armes, d'armures et d'outils, or de départ ;
- la sous-classe : le niveau où on la choisit, et les niveaux de ses aptitudes ;
- l'incantation : caractéristique, changement des sorts préparés, emplacements repris d'une classe du contenu, liste de sorts, part du niveau de lanceur en multiclassage ;
- les colonnes de la table, valeur par valeur ;
- les 20 niveaux, chacun avec son bonus de maîtrise, tiré du contenu, et ses aptitudes.

Chaque aptitude SHALL être une entité `feature` du pack, de source la classe et du niveau où elle est placée. Une classe sans ses 20 niveaux, ou dont les niveaux de sous-classe ne commencent pas au niveau où on la choisit, SHALL être signalée par la vérification (EF-HB-11).

#### Scenario: Classe lanceuse
- **WHEN** l'auteur crée la classe « Veilleur », d10, Sagesse, reprend les emplacements du Magicien et place « Œil du guet » au niveau 1
- **THEN** la classe a ses 20 niveaux, avec 2 emplacements de niveau 1 au niveau 1 et 2 de niveau 3 au niveau 5, un bonus de maîtrise de +3 au niveau 5, et l'aptitude `…:feature:veilleur-oeil-du-guet` de niveau 1

#### Scenario: Progression incomplète
- **WHEN** une classe n'a que 12 niveaux
- **THEN** la vérification indique « progression incomplète : une classe a ses 20 niveaux »

### Requirement: Éditeur de Sous-classe
L'éditeur de Sous-classe ([H02]) SHALL demander la classe parente et rappeler ses niveaux de sous-classe. Il SHALL proposer d'ajouter une aptitude à chacun de ces niveaux. Une aptitude placée à un autre niveau SHALL être signalée, avec « Déplacer au niveau » suivant et « Autre niveau… ». La vérification SHALL signaler une aptitude hors de ces niveaux, et chaque niveau sans aptitude. La sous-classe s'enregistre quand même et se teste (EF-HB-11).

#### Scenario: Gardien du rempart
- **WHEN** l'auteur crée « Gardien du rempart », sous-classe du Guerrier, avec une aptitude au niveau 3 et une au niveau 10
- **THEN** l'éditeur rappelle « 3, 7, 10, 15, 18 », le pack contient les deux aptitudes, de source la sous-classe, et la vérification indique « progression incomplète : aucune aptitude aux niveaux 7, 15, 18 »

#### Scenario: Aptitude mal placée
- **WHEN** une aptitude de niveau 4 est rattachée à une sous-classe du Guerrier
- **THEN** l'éditeur propose « Déplacer au niveau 7 », et la vérification indique « la classe parente n’accorde pas d’aptitude de sous-classe au niveau 4 »

### Requirement: Variante d'une entité du SRD
« Dériver d'une entité du SRD » SHALL copier dans le pack un Don, un Historique, une Espèce, une Classe, une Sous-classe, un Sort ou un objet du SRD. Une espèce, une classe ou une sous-classe dérivée garde les traits et les aptitudes du SRD, que l'auteur peut retirer ou compléter. La copie reçoit un nouvel identifiant, avec `extends_id` vers l'original. L'original SHALL rester inchangé (EF-HB-02).

#### Scenario: Hache d'armes peu courante
- **WHEN** l'auteur dérive la Hache d'armes, la nomme « Hache des Marches », la rend peu courante et demande l'harmonisation
- **THEN** l'entité `…:weapon:hache-des-marches` garde la botte Renversement et cite `srd:weapon:battleaxe`, et la Hache d'armes du SRD n'a toujours pas de rareté

### Requirement: Éditeur de Monstre
L'éditeur de Monstre SHALL proposer le profil de jeu complet :
- tailles, type, précision du type et alignement ;
- CA, Initiative, dés de vie, Vitesses ;
- les six caractéristiques, JS et compétences maîtrisés ;
- vulnérabilités, résistances et immunités ; sens et langues ;
- FP, traits et actions (attaque, sauvegarde, usages), actions Légendaires ;
- informations d'Étude par palier.

Il SHALL calculer, avec les tables du SRD de `dnd_content` :
- les PX et le bonus de maîtrise du FP ;
- les PV moyens des dés de vie ;
- les JS et les compétences, depuis les caractéristiques et les maîtrises ;
- la Perception passive ;
- les dégâts moyens d'une attaque.

La CA SHALL être calculée depuis l'armure portée, la Dextérité et le bouclier, avec sa formule affichée ; une CA naturelle porte un libellé. Un monstre sans Intelligence SHALL être signalé par la vérification (DD d'Influence).

#### Scenario: Loup des brumes
- **WHEN** l'auteur crée un monstre de Dextérité 15, en armure de cuir clouté avec un bouclier, de dés de vie 2d8 + 2, FP 1/4, maîtrisant la Perception, avec une Morsure de 1d6 + 2 perforants et un palier d'Étude de DD 10
- **THEN** le monstre a une CA de 16 (« Armure de cuir clouté, Bouclier »), 11 PV, 50 PX, un bonus de maîtrise de +2, Perception +2 et une Perception passive de 12, une Morsure de 5 dégâts moyens, et la vérification indique « Prêt à publier »

#### Scenario: Intelligence manquante
- **WHEN** un monstre n'a pas de valeur d'Intelligence
- **THEN** la vérification indique « un monstre a une valeur d’Intelligence (DD d’Influence) »

### Requirement: Paliers d'Étude d'un monstre
Un PNJ créé depuis un monstre SHALL recevoir ses paliers d'Étude en informations cachées, non révélées. L'assistant d'Étude SHALL lire les paliers d'un monstre en combat qui n'a pas de PNJ.

#### Scenario: PNJ d'un monstre homebrew
- **WHEN** le MJ crée « Grisaille » depuis le Loup des brumes, qui a deux paliers d'Étude
- **THEN** le PNJ a ces deux informations cachées, à leur DD, non révélées
