## ADDED Requirements

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
