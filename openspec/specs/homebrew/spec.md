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

### Requirement: Bac à sable d'une entité
L'éditeur d'un Don, d'un Historique, d'une Espèce, d'une Classe, d'une Sous-classe, d'une arme, d'une armure ou d'un objet magique SHALL proposer « Tester sur un personnage » ([H04], EF-HB-03). Le test SHALL porter sur l'entité telle qu'elle est à l'écran, avec les autres entités du brouillon, sans rien enregistrer. Aucune fiche réelle n'est lue ni modifiée.

#### Scenario: Gardien du rempart au niveau 7
- **WHEN** l'auteur teste la sous-classe « Gardien du rempart », dont l'aptitude de niveau 3 donne +1 CA avec un bouclier, sur le Guerrier prétiré au niveau 7, bouclier porté
- **THEN** la ligne « Classe d'armure » montre la CA sans la sous-classe, puis 1 de plus avec, et a pour source « Rempart vivant »

#### Scenario: Bouclier retiré
- **WHEN** l'auteur décoche « Porte un bouclier »
- **THEN** la CA avec la sous-classe est égale à la CA sans elle

### Requirement: Personnage de test
Le panneau « Personnage de test » SHALL proposer une base prétirée par classe du contenu et du brouillon, un niveau de 1 à 20 et « Porte un bouclier ». Pour une sous-classe, la base SHALL être sa classe parente et le niveau SHALL commencer au niveau de sous-classe. Pour une classe, la base SHALL être cette classe.

#### Scenario: Niveau d'une sous-classe
- **WHEN** l'auteur teste une sous-classe du Guerrier
- **THEN** la base est « Guerrier prétiré (Humain, Soldat) » et le niveau va de 3 à 20

### Requirement: Résultat du test
Le panneau « Résultat du test » SHALL indiquer :
- que toutes les valeurs se calculent sans erreur au niveau choisi ;
- ou les règles enfreintes que l'entité ajoute à la fiche, et un calcul qui échoue.

Il SHALL aussi lister les problèmes de la vérification du brouillon qui concernent l'entité ou ses aptitudes, à corriger avant de publier, sans empêcher le test (EF-HB-11).

#### Scenario: Progression incomplète
- **WHEN** l'auteur teste une sous-classe à laquelle il manque les aptitudes des niveaux 10, 15 et 18
- **THEN** le test se calcule, et le résultat cite « progression incomplète : aucune aptitude aux niveaux 10, 15, 18 » dans ce qui reste à corriger

### Requirement: Aperçu d'un monstre
« Tester » SHALL montrer, pour un monstre, son profil tel que le MJ le verra en jeu, avec le bloc de stats de [C2].

#### Scenario: Profil d'un monstre homebrew
- **WHEN** l'auteur teste le monstre « Loup des brumes »
- **THEN** le bloc de stats affiche son nom, sa CA et ses actions

### Requirement: Publier une version
La page « Publier une version » ([H06]) SHALL proposer :
- la description, la licence et l'auteur, avec la signature de l'appareil ;
- le type de version (correctif, mineure, majeure), avec la version qui en résulte ;
- les changements depuis la version publiée ;
- l'attestation ;
- les contrôles : taille, nombre d'entités, règles validées et dépendances.

La première publication garde la version du brouillon. « Publier la version » SHALL rester grisé tant que la vérification signale un problème ou que l'attestation n'est pas cochée. Publier SHALL signer le pack, l'importer dans le contenu de l'appareil (origine `local`) et porter la version dans le brouillon.

#### Scenario: Première publication
- **WHEN** Inès coche l'attestation et publie « Gardiens des Marches » 0.1.0, qui passe la vérification
- **THEN** le pack 0.1.0 est dans le contenu de l'appareil, signé par la clé de l'appareil

#### Scenario: Version mineure
- **WHEN** elle ajoute un Don, choisit « Mineure » et publie
- **THEN** la page annonce « 0.1.0 → 0.2.0 » et liste le Don en « Ajouté », et le contenu de l'appareil porte la 0.2.0

#### Scenario: Attestation manquante
- **WHEN** l'attestation n'est pas cochée
- **THEN** « Publier la version » est grisé

### Requirement: Export signé
« Exporter le .dndpack signé » SHALL partager le fichier de la version publiée par la feuille de partage du système, sans réseau (EF-HB-05). Le fichier SHALL se relire, et sa signature SHALL être valide.

#### Scenario: Export hors ligne
- **WHEN** Inès exporte la 0.2.0 sans réseau
- **THEN** la feuille de partage reçoit `gardiens-des-marches-0.2.0.dndpack`, dont la signature est valide

### Requirement: Importer un pack
« Importer un pack » SHALL ouvrir un fichier `.dndpack` et montrer son aperçu ([H08]) avant toute écriture :
- nom, auteur, licence, dépendances, version importée et version installée ;
- contenu : entités nouvelles et modifiées, et le nombre d'entités inchangées ;
- vérifications : taille, signature, format et contenu, dépendances.

Un fichier illisible, trop gros, non signé, mal signé, ou dont une dépendance manque SHALL être refusé, avec la raison. Rien n'est importé avant la confirmation (EF-HB-06).

#### Scenario: Nouveau pack
- **WHEN** Camille importe « Gardiens des Marches » 0.1.0, signé par Inès, qu'elle n'a pas
- **THEN** l'aperçu montre ses entités en « Nouveau », la signature d'Inès et la dépendance au SRD 5.2.1, et « Importer » l'installe

#### Scenario: Fichier refusé
- **WHEN** le fichier n'est pas un `.dndpack` lisible, ou sa signature ne correspond pas
- **THEN** l'aperçu indique pourquoi, et aucun bouton d'import n'est proposé

### Requirement: Mise à jour du même auteur
Un pack de même identifiant SHALL être une mise à jour seulement s'il est signé par la même clé que la version installée (EF-HB-07). L'aperçu indique alors « Même auteur que la version installée, donc c'est une mise à jour », avec les entités modifiées. Les versions précédentes restent sur l'appareil : une table garde la sienne. Une version déjà installée SHALL être refusée.

#### Scenario: Mise à jour
- **WHEN** Camille, qui a la 0.1.0 d'Inès, importe la 0.2.0 signée par Inès
- **THEN** l'aperçu indique « installée : 0.1.0 », liste les entités nouvelles et modifiées, et « Importer la mise à jour » installe la 0.2.0 sans effacer la 0.1.0

### Requirement: Pack d'un autre auteur
Un pack de même identifiant signé par une autre clé SHALL être importé comme un pack distinct ([H09]), sans toucher au pack installé. Son nom dans la bibliothèque est proposé avec le nom de son auteur entre parenthèses, et il reçoit un autre identifiant et un autre espace de noms.

#### Scenario: Signé par Karl
- **WHEN** Camille, qui a « Gardiens des Marches » d'Inès, importe un pack de même identifiant signé par Karl
- **THEN** l'aperçu indique « Ce n'est pas une mise à jour », propose « Gardiens des Marches (Karl) », et « Importer comme pack distinct » l'installe à côté du pack d'Inès, qui ne change pas

### Requirement: Conflits de noms
L'aperçu SHALL signaler une entité nouvelle qui porte le nom d'une entité d'un autre pack installé. Il propose « Garder les deux » (par défaut, chacune avec le badge de son pack) ou « Renommer le nouveau… ». Un renommage ne vaut que dans la bibliothèque de l'appareil : le fichier n'est pas modifié.

#### Scenario: Renommer
- **WHEN** le pack importé apporte un Don « Veilleur » alors que la bibliothèque en a déjà un, et que Camille le renomme « Veilleur des Marches »
- **THEN** la bibliothèque montre « Veilleur des Marches », et le fichier gardé reste celui de l'auteur

### Requirement: Dupliquer un pack importé
« Dupliquer pour modifier » SHALL créer un brouillon à partir d'un pack importé, sous le nom de l'utilisateur (EF-HB-08). Il est à son nom d'auteur, dans un espace de noms tiré de son nom, avec un nouvel identifiant, en version 0.1.0, et les références entre ses entités suivent.

#### Scenario: Duplication
- **WHEN** Camille duplique « Gardiens des Marches » d'Inès
- **THEN** un brouillon « Gardiens des Marches (copie) » apparaît dans « Mes packs », d'auteur Camille, dont les entités ont l'espace de noms du brouillon

### Requirement: Activer un pack sur une table
Le MJ SHALL activer, depuis l'onglet Configuration de sa table, un pack de sa bibliothèque (importé ou publié), à une version qu'il choisit et qui reste figée (EF-HB-09). Il SHALL pouvoir passer la table à une autre version installée, ou retirer le pack. Le SRD 5.2.1 y figure toujours, verrouillé. Activer SHALL envoyer le fichier de la version au stockage du serveur, puis l'inscrire dans la table. Sans connexion, l'activation est refusée avec la raison, et rien ne change.

#### Scenario: Activation
- **WHEN** Camille active « Gardiens des Marches » 0.1.0 sur « Les Marches de Brumeval »
- **THEN** la carte « Packs » de la table montre « Gardiens des Marches · 0.1.0 », le fichier est dans le stockage sous son empreinte, et `table_pack` cite cette empreinte

#### Scenario: Version figée
- **WHEN** Camille importe la 0.2.0 du même pack
- **THEN** la table reste sur la 0.1.0 tant qu'elle ne choisit pas la 0.2.0 dans la configuration

### Requirement: Diffusion aux membres
Chaque membre d'une table SHALL recevoir les packs actifs de la table sans action de sa part (EF-HB-09). Un pack actif absent de l'appareil SHALL être téléchargé dès que l'appareil est en ligne, vérifié (empreinte et signature) puis installé. Hors ligne, il reste utilisable. Le contenu actif de l'appareil SHALL être le SRD, plus les packs actifs sur ses tables, à leur version figée. Ainsi un PJ utilise une sous-classe homebrew activée sur sa table (critère de sortie de M4).

#### Scenario: Sous-classe homebrew chez un joueur
- **WHEN** Camille active « Gardiens des Marches » sur sa table, et l'appareil de Hugo, membre de la table, se synchronise
- **THEN** le pack est installé chez Hugo, et la sous-classe « Gardien du rempart » est proposée pour son Guerrier

#### Scenario: Fichier altéré
- **WHEN** le fichier téléchargé ne correspond pas à son empreinte ou à sa signature
- **THEN** il n'est pas installé

### Requirement: Bannir une entité pour une table
Le MJ SHALL pouvoir bannir, pour sa table, une entité du SRD (EF-HB-10). Il le fait depuis la carte « Packs » de la configuration, qui liste les entités bannies ; il peut aussi la rétablir. Une entité bannie SHALL disparaître des listes de choix des personnages de la table (création, montée de niveau, sorts préparés). Elle SHALL rester lisible par son identifiant : une fiche qui l'a déjà ne change pas.

#### Scenario: Sommeil banni
- **WHEN** Camille bannit Sommeil pour « Les Marches de Brumeval »
- **THEN** la carte « Packs » montre Sommeil parmi les entités bannies, et la liste de sorts d'un Magicien de la table ne le propose plus

### Requirement: Compendium
L'onglet Compendium SHALL chercher hors ligne parmi les entités du contenu (EF-CMP-01), par nom, sans tenir compte des accents ni de la casse, avec des filtres par type (sorts, dons, objets, monstres, états). Par défaut, la recherche se limite aux packs actifs de la table choisie, et le contexte est affiché. « Tous mes packs » l'élargit au SRD et à la bibliothèque. Chaque résultat SHALL porter sa source, et « BANNI » s'il est banni dans la table. La fiche d'une entité SHALL rester consultable même bannie.

#### Scenario: Recherche dans une table
- **WHEN** Hugo cherche « bouclier » dans le contexte des Marches de Brumeval
- **THEN** les résultats viennent du SRD et des packs actifs de la table, chacun avec sa source, et un résultat d'un pack inactif est signalé avec « Afficher »

#### Scenario: Entité bannie
- **WHEN** Hugo cherche « invisibilté » et que l'Invisibilité est bannie à cette table
- **THEN** « Aucun résultat » propose « Invisibilité » marquée « BANNI ICI », dont la fiche reste lisible, et « Chercher dans tous mes packs »

### Requirement: Contenu figé par fiche
Une fiche SHALL garder la version de chaque entité homebrew qu'elle utilise (espèce, Historique, classe, sous-classe, don, sort, objet), avec un instantané de l'entité et de ses aptitudes (EF-PJ-14). Quand le pack passe à une autre version sur la table, la fiche SHALL se calculer avec son instantané tant que son propriétaire n'a pas choisi de migrer. Une entité inchangée suit la nouvelle version sans rien demander.

#### Scenario: Version gardée
- **WHEN** la table de Hugo passe « Gardiens des Marches » de 0.1.0 à 0.2.0, où « Rempart vivant » donne +2 CA au lieu de +1
- **THEN** la fiche de Hugo garde +1 CA tant qu'il n'a pas choisi

### Requirement: Alerte « contenu modifié »
Quand une entité utilisée par une fiche a changé dans la version de la table, la fiche de son propriétaire SHALL montrer l'alerte « Contenu modifié » ([H10]). Elle ouvre la comparaison : le pack et ses deux versions, puis le texte et les effets de chaque version. Le joueur choisit « Passer à la nouvelle version » ou « Garder la version N ». Le choix SHALL être inscrit dans l'historique de la fiche ; après un choix, l'alerte ne revient pas pour cette version. Le MJ, qui lit la fiche, ne voit pas ces boutons.

#### Scenario: Migrer
- **WHEN** Hugo choisit « Passer à la nouvelle version »
- **THEN** sa fiche prend +2 CA, et l'historique indique « Rempart vivant : passé de 0.1.0 à 0.2.0 »

#### Scenario: Garder
- **WHEN** Hugo choisit « Garder la version 0.1.0 »
- **THEN** sa fiche garde +1 CA, l'alerte disparaît, et l'historique indique « Rempart vivant : version 0.1.0 gardée »

### Requirement: Passer une table à une nouvelle version
La carte « Packs » SHALL annoncer, pour chaque pack actif, une version plus récente de la bibliothèque, avec ses entités ajoutées et modifiées, et « Passer en N » pour le MJ ([H9]). Elle SHALL indiquer combien de fiches de la table utilisent une entité modifiée, et rappeler que leurs joueurs choisiront.

#### Scenario: Annonce
- **WHEN** Camille a la 0.2.0 dans sa bibliothèque alors que sa table est figée en 0.1.0, et qu'une fiche de la table utilise « Gardien du rempart », modifié
- **THEN** la carte indique « Version 0.2.0 disponible : 0 ajout, 1 modification », que le passage touche 1 fiche, et propose « Passer en 0.2.0 »
