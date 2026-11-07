# character-creation Specification

## Purpose
TBD - created by archiving change us-05a-creation-origine. Update Purpose after archive.

## Requirements

### Requirement: Assistant en 9 étapes
L'application SHALL proposer la création d'un personnage en 9 étapes, dans l'ordre du cahier §5.1. Le joueur SHALL pouvoir revenir à toute étape déjà atteinte, et SHALL fonctionner sans réseau.

#### Scenario: Ouverture
- **WHEN** le joueur choisit « Nouveau personnage » dans Personnages
- **THEN** l'étape 1, Classe, s'affiche

#### Scenario: Retour en arrière
- **WHEN** le joueur a atteint l'étape 3 et touche l'étape 1
- **THEN** l'étape 1 s'affiche avec son choix conservé

#### Scenario: Étape non atteinte
- **WHEN** le joueur touche une étape qu'il n'a pas atteinte
- **THEN** l'étape courante ne change pas

### Requirement: Choix manquant bloquant et expliqué
« Suivant » SHALL être désactivé tant qu'un choix obligatoire de l'étape manque, et sa raison SHALL s'afficher au-dessus du bouton.

#### Scenario: Classe non choisie
- **WHEN** aucune classe n'est sélectionnée
- **THEN** « Suivant » est désactivé et la raison demande de choisir une classe

#### Scenario: Outil à choisir (Soldat)
- **WHEN** le joueur choisit Soldat, dont l'outil est une boîte de jeux au choix
- **THEN** « Suivant » reste désactivé jusqu'au choix du type

#### Scenario: Taille à choisir (Humain)
- **WHEN** le joueur choisit Humain
- **THEN** « Suivant » reste désactivé jusqu'au choix de M ou P

#### Scenario: Taille unique (Nain)
- **WHEN** le joueur choisit Nain
- **THEN** la taille M est retenue d'office

### Requirement: Choix de la classe
L'étape Classe SHALL lister les classes du contenu actif avec leur caractéristique principale et leur dé de vie, et SHALL permettre de les chercher par nom et de les filtrer.

#### Scenario: Détail du Guerrier (SRD p. 56)
- **WHEN** le joueur sélectionne le Guerrier
- **THEN** le détail affiche « Force ou Dextérité », d10, et les jets de sauvegarde de Force et de Constitution

#### Scenario: Caractéristiques cumulées (Moine)
- **WHEN** la liste affiche le Moine
- **THEN** sa caractéristique principale se lit « Dextérité et Sagesse »

#### Scenario: Filtre
- **WHEN** le joueur active « Lanceurs de sorts »
- **THEN** le Barbare n'est plus listé et le Barde l'est

### Requirement: Choix de l'Historique
L'étape Historique SHALL afficher pour chaque Historique ses trois caractéristiques et son don d'origines, et en détail ses compétences et son outil.

#### Scenario: Soldat (SRD p. 87)
- **WHEN** le joueur sélectionne Soldat
- **THEN** le détail affiche Force, Dextérité, Constitution, Sauvagerie martiale, Athlétisme et Intimidation

#### Scenario: Changement d'Historique
- **WHEN** le joueur a choisi un outil puis change d'Historique
- **THEN** l'outil choisi est effacé

### Requirement: Choix de l'espèce
L'étape Espèce SHALL lister les espèces avec leurs tailles et leur Vitesse en mètres, et SHALL afficher les traits de l'espèce sélectionnée, sous leur nom du pack.

#### Scenario: Goliath (SRD p. 89)
- **WHEN** la liste affiche le Goliath
- **THEN** sa Vitesse se lit « 10,50 m »

### Requirement: Choix des langues
L'étape Langues SHALL donner le Commun d'office et demander exactement 2 langues courantes (SRD p. 21). Les langues rares ne SHALL pas être proposées.

#### Scenario: Compte incomplet
- **WHEN** le joueur a choisi une langue
- **THEN** « Suivant » est désactivé et la raison demande encore 1 langue

#### Scenario: Troisième langue
- **WHEN** le joueur a choisi deux langues
- **THEN** les autres langues ne peuvent plus être cochées

#### Scenario: Tirage au sort
- **WHEN** le joueur a choisi Nain et touche « Tirer au sort »
- **THEN** Nain reste choisi et une seconde langue courante, différente, est ajoutée

### Requirement: Acquisition par points
L'étape Caractéristiques SHALL répartir 27 points, avec des valeurs de 8 à 15 et le coût de la table du SRD (p. 22). L'étape SHALL rester bloquée tant que les 27 points ne sont pas dépensés.

#### Scenario: Coût
- **WHEN** une valeur passe de 13 à 14
- **THEN** elle coûte 2 points de plus

#### Scenario: Budget épuisé
- **WHEN** il reste moins de points que le coût de l'augmentation
- **THEN** le bouton + de cette caractéristique est désactivé

#### Scenario: Bornes
- **WHEN** une valeur vaut 15, ou vaut 8
- **THEN** son bouton +, ou son bouton −, est désactivé

### Requirement: Répartition des bonus d'Historique
L'étape SHALL répartir `+2 et +1` ou `+1, +1 et +1` sur les trois seules caractéristiques de l'Historique.

#### Scenario: Caractéristique non éligible
- **WHEN** l'Historique est Soldat
- **THEN** l'Intelligence ne peut pas recevoir de bonus et sa ligne affiche « Non éligible pour Soldat »

#### Scenario: Même ligne
- **WHEN** le +2 est sur Force
- **THEN** le +1 de Force est désactivé et la ligne l'explique

#### Scenario: Total et modificateur
- **WHEN** Force vaut 15 avec le +2
- **THEN** son total est 17 et son modificateur +3

#### Scenario: Répartition incomplète
- **WHEN** seul le +2 est placé
- **THEN** « Suivant » est désactivé et la raison demande de placer les bonus

### Requirement: Choix devenu invalide
Un bonus placé sur une caractéristique que l'Historique n'autorise plus SHALL rester visible, être expliqué par un bandeau et bloquer l'étape.

#### Scenario: Soldat puis Sage
- **WHEN** le joueur a mis le +2 sur Force en Soldat puis revient choisir Sage
- **THEN** l'étape Caractéristiques signale le bonus de Force et bloque « Suivant » jusqu'à sa correction

#### Scenario: Saut par la liste des étapes
- **WHEN** une étape déjà franchie est devenue invalide
- **THEN** la liste des étapes ne permet pas de sauter au-delà de celle-ci

### Requirement: Sous-choix de niveau 1
L'étape Sous-choix SHALL présenter, selon la classe, l'Historique et l'espèce, chaque choix ouvert au niveau 1 hors sorts. L'étape SHALL rester bloquée tant qu'un choix est incomplet ou invalide.

#### Scenario: Compétences déjà maîtrisées
- **WHEN** un Guerrier Soldat choisit ses compétences
- **THEN** Athlétisme et Intimidation sont grisées avec la règle, et il en choisit 2 autres

#### Scenario: Style de combat
- **WHEN** le personnage est Guerrier
- **THEN** il choisit un don de style de combat parmi 4

#### Scenario: Pas de style de combat
- **WHEN** le personnage est Barde
- **THEN** l'étape ne propose pas de style de combat

#### Scenario: Don de l'Humain
- **WHEN** un Humain Soldat choisit son don d'origines
- **THEN** Sauvagerie martiale, déjà obtenue et non répétable, est grisée

#### Scenario: Choix de classe nommé
- **WHEN** le personnage est Clerc
- **THEN** il choisit entre Protecteur et Thaumaturge

#### Scenario: Lignage
- **WHEN** le personnage est Elfe
- **THEN** il choisit Drow, Elfe sylvestre ou Haut-elfe, et une compétence de Sens aiguisés

#### Scenario: Expertise
- **WHEN** un Roublard choisit son Expertise
- **THEN** seules les compétences qu'il maîtrise sont disponibles

#### Scenario: Bottes
- **WHEN** un Guerrier a choisi 3 bottes
- **THEN** il ne peut pas en ajouter, et un Barbare ne voit que des armes de corps à corps

#### Scenario: Choix devenu invalide
- **WHEN** le joueur a pris Perception puis choisit un Historique qui l'accorde
- **THEN** la compétence est signalée et l'étape reste bloquée jusqu'à sa correction

### Requirement: Récapitulatif de l'étape
Sur grand écran, l'étape Sous-choix SHALL afficher l'état de chaque choix dans un panneau « À compléter ».

#### Scenario: Compteur
- **WHEN** une compétence sur deux est choisie
- **THEN** la ligne correspondante indique qu'il en reste une

### Requirement: Sorts de départ
L'étape Sous-choix SHALL demander à un lanceur de sorts ses sorts de niveau 1, en nombre donné par sa table de classe, dans la liste de sa classe. L'étape SHALL rester bloquée tant que le compte n'y est pas.

#### Scenario: Clerc
- **WHEN** le personnage est Clerc
- **THEN** il choisit 3 sorts mineurs et 4 sorts préparés du 1er niveau

#### Scenario: Paladin
- **WHEN** le personnage est Paladin
- **THEN** il choisit 2 sorts préparés et aucun sort mineur

#### Scenario: Sort mineur supplémentaire
- **WHEN** un Clerc choisit l'Ordre divin Thaumaturge
- **THEN** il choisit 4 sorts mineurs

#### Scenario: Grimoire du Magicien
- **WHEN** le personnage est Magicien
- **THEN** il choisit 6 sorts du 1er niveau pour son grimoire, puis 4 sorts préparés parmi eux

#### Scenario: Sort retiré du grimoire
- **WHEN** un Magicien retire de son grimoire un sort préparé
- **THEN** ce sort n'est plus préparé

#### Scenario: Changement de classe
- **WHEN** le joueur change de classe
- **THEN** ses sorts de classe sont effacés

### Requirement: Un sort ne se prend pas deux fois
L'étape Sous-choix SHALL griser, avec la règle, un sort déjà choisi dans une autre section ou accordé au niveau 1 par la classe, l'espèce ou un lignage. Le grimoire et les sorts préparés du Magicien SHALL rester exemptés entre eux.

#### Scenario: Sort d'espèce
- **WHEN** un Clerc Tieffelin choisit ses sorts mineurs
- **THEN** Thaumaturgie est grisée avec la règle

#### Scenario: Sort pris par l'Initié à la magie
- **WHEN** un Clerc Acolyte a choisi Assistance comme sort mineur de classe
- **THEN** Assistance est grisée dans les sorts mineurs de l'Initié à la magie

#### Scenario: Sort accordé par la classe
- **WHEN** un Rôdeur choisit ses sorts préparés
- **THEN** Marque du chasseur est grisée avec la règle

#### Scenario: Sort devenu connu
- **WHEN** un Magicien a choisi Prestidigitation, puis choisit le lignage Haut-elfe
- **THEN** Prestidigitation est signalée « À refaire »

### Requirement: Initié à la magie
L'étape Sous-choix SHALL demander, pour chaque Initié à la magie, la caractéristique d'incantation, 2 sorts mineurs et 1 sort du 1er niveau de sa liste. Un Historique SHALL imposer sa liste. Pris par Polyvalent, le don SHALL proposer le Clerc, le Druide et le Magicien.

#### Scenario: Acolyte
- **WHEN** l'Historique est Acolyte
- **THEN** les sorts viennent de la liste du Clerc, sans choix de liste

#### Scenario: Polyvalent
- **WHEN** un Humain Soldat prend Initié à la magie
- **THEN** il choisit sa liste, puis ses sorts dans cette liste

#### Scenario: Seconde prise du don
- **WHEN** un Humain Acolyte prend Initié à la magie
- **THEN** la liste du Clerc est grisée avec la règle

#### Scenario: Changement de liste
- **WHEN** le joueur change de liste
- **THEN** les sorts choisis dans l'ancienne liste sont effacés

### Requirement: Caractéristique d'incantation d'un lignage
L'étape Sous-choix SHALL demander la caractéristique d'incantation du Lignage elfique, du Lignage gnome et de l'Héritage fiélon.

#### Scenario: Elfe
- **WHEN** l'espèce est Elfe
- **THEN** il choisit entre Intelligence, Sagesse et Charisme

### Requirement: Équipement de départ
L'étape Équipement SHALL proposer les lots de la classe et les deux options de l'Historique, et rester bloquée tant qu'ils ne sont pas choisis, ainsi que l'outil d'un lot qui en demande un.

#### Scenario: Guerrier Soldat
- **WHEN** le personnage est Guerrier Soldat
- **THEN** il choisit parmi 3 lots de classe, puis entre le lot de l'Historique avec 14 po et 50 po

#### Scenario: Instrument du Barde
- **WHEN** un Barde choisit le lot qui comprend un instrument
- **THEN** il choisit cet instrument avant de continuer

#### Scenario: Changement de classe
- **WHEN** le joueur change de classe
- **THEN** son lot de classe et son outil sont effacés

### Requirement: Détails du personnage
L'étape Détails SHALL exiger un nom et laisser l'alignement, l'apparence, la personnalité et l'histoire optionnels.

#### Scenario: Nom vide
- **WHEN** le nom est vide ou ne contient que des espaces
- **THEN** l'étape reste bloquée avec la raison

### Requirement: Récapitulatif
L'étape Récapitulatif SHALL afficher la fiche calculée par `computeSheet`. Une erreur d'intégrité SHALL bloquer l'enregistrement. Une alerte SHALL rester sans effet sur l'enregistrement.

#### Scenario: Aldric
- **WHEN** le joueur refait les choix d'Aldric de [D1]
- **THEN** la fiche calculée est celle de la fixture `aldric_n1`, au matériel près

#### Scenario: Botte sur une arme absente
- **WHEN** une botte porte sur une arme absente de l'équipement
- **THEN** une alerte le signale et l'enregistrement reste possible

### Requirement: Enregistrement du personnage créé
L'assistant SHALL enregistrer le personnage sans réseau, puis revenir à la page Personnages, qui le liste.

#### Scenario: Toute combinaison
- **WHEN** un brouillon complet est converti, quelles que soient sa classe, son Historique et son espèce
- **THEN** `computeSheet` ne signale aucune erreur d'intégrité

#### Scenario: Sélection périmée
- **WHEN** une sélection de `choices` n'appartient à aucune section ouverte
- **THEN** elle n'est pas enregistrée

#### Scenario: Échec d'écriture
- **WHEN** l'écriture échoue
- **THEN** l'erreur s'affiche et le brouillon reste ouvert

### Requirement: Compétences du Récapitulatif
Le Récapitulatif SHALL lister toutes les compétences maîtrisées, dans l'ordre alphabétique français.

#### Scenario: Identifiant à tiret
- **WHEN** le personnage maîtrise Escamotage
- **THEN** Escamotage apparaît au Récapitulatif
