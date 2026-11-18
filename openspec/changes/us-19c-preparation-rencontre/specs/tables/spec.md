## ADDED Requirements

### Requirement: Préparer une rencontre
La page d'une rencontre SHALL montrer sa jauge de difficulté, les personnages présents, ses adversaires et le mode de PV des monstres. Chaque groupe d'adversaires SHALL afficher son FP, sa numérotation (« numérotés Vétéran 1 à 2 » ou « unique »), son initiative commune, sa quantité modifiable et ses PX. La jauge SHALL se mettre à jour à chaque changement.

#### Scenario: Le relais du Sel ([C1], [D1])
- **WHEN** Camille ouvre « Le relais du Sel », avec 2 vétérans, un ogre et 4 bandits, et Aldric et Mira, de niveau 5, présents
- **THEN** elle lit « 1 950 PX », « Modérée », « Vétéran », « FP 3 · numérotés Vétéran 1 à 2 », « 1 400 PX », « Ogre », « FP 2 · unique », « Bandit » et « numérotés Bandit 1 à 4 »

#### Scenario: Quantité
- **WHEN** Camille touche « + » sur l'ogre, puis « − » deux fois
- **THEN** l'ogre passe à 2 (« numérotés Ogre 1 à 2 »), puis le groupe disparaît, et la jauge suit

#### Scenario: Mode de PV et état
- **WHEN** Camille choisit « Jet au lancement » et active « Prête à jouer »
- **THEN** la rencontre est en jet de PV et prête

### Requirement: Ajouter des adversaires
La préparation SHALL proposer les monstres des packs actifs et les PNJ de la table, avec une recherche sans accents ni casse et un filtre de FP. Chaque monstre SHALL montrer son type, son FP, ses PX et sa source. Ajouter un adversaire déjà présent SHALL augmenter sa quantité.

#### Scenario: Monstre
- **WHEN** Camille cherche « loup sanguinaire » et touche « + »
- **THEN** le loup sanguinaire rejoint les adversaires, et les PX augmentent de 200

#### Scenario: PNJ
- **WHEN** Camille passe sur « PNJ » et ajoute Varga
- **THEN** Varga rejoint les adversaires avec les PX de son chef de bande

#### Scenario: Filtre de FP
- **WHEN** Camille limite le FP de 1 à 2
- **THEN** l'ogre (FP 2) est proposé, mais ni le bandit (FP 1/8) ni le vétéran (FP 3)
