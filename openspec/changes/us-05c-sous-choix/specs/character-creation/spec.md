## ADDED Requirements

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
