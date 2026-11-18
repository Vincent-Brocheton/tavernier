## ADDED Requirements

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
