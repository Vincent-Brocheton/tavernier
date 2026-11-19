## ADDED Requirements

### Requirement: Compétence suggérée pour l'Étude
Le moteur SHALL suggérer, pour un type de créature, la compétence de la table `study_skills` du contenu actif. Il SHALL ne rien suggérer pour un type absent de la table ou une cible sans type.

#### Scenario: Varga ([C9])
- **WHEN** Thalia étudie Varga, Humanoïde
- **THEN** Histoire est suggérée

### Requirement: Paliers révélés par l'Étude
Un résultat SHALL atteindre chaque palier d'information cachée dont le DD lui est inférieur ou égal (EF-ACT-01).

#### Scenario: Thalia étudie Varga ([D1], [C9])
- **WHEN** Thalia obtient 16 en Histoire (d20 15 + 1) contre les paliers DD 10, 15 et 20 de Varga
- **THEN** les paliers DD 10 et 15 sont atteints, et le DD 20 reste caché

### Requirement: Assistant Étude
Le combat SHALL ouvrir un assistant « Étude · Influence · Observation ». Son onglet Étude SHALL montrer :
- le personnage qui agit et la cible ;
- les compétences d'Intelligence avec les bonus du personnage, et la compétence suggérée ;
- le résultat, saisi ou lancé ;
- les paliers préparés du PNJ ciblé, atteints ou non.

Valider SHALL écrire un événement `study` (acteur, cible, compétence, total, DD révélés) et marquer ces paliers révélés sur le PNJ. Ni le journal ni les paliers ne SHALL être visibles des joueurs (EF-ACT-07).

#### Scenario: Révéler 2 informations ([C9])
- **WHEN** le MJ valide l'Étude de Thalia sur Varga avec 16
- **THEN** le journal porte l'Étude et les paliers DD 10 et 15 de Varga sont révélés

#### Scenario: Cible sans informations
- **WHEN** la cible est un monstre sans PNJ
- **THEN** l'assistant le dit, et valider inscrit seulement l'Étude au journal

### Requirement: Test d'Influence
Pour une cible Hésitante, le moteur SHALL proposer les façons d'interagir de la table `influence_checks`, filtrées par le type de créature de la cible. Le DD par défaut SHALL valoir 15, ou l'Intelligence de la cible si elle est plus élevée. Le test SHALL avoir l'Avantage contre une cible Amicale et le Désavantage contre une cible Hostile (EF-ACT-03).

#### Scenario: Varga ([C10])
- **WHEN** Aldric influence Varga, Hostile, d'Intelligence 14
- **THEN** le DD vaut 15 et le test a le Désavantage

#### Scenario: Amadouer
- **WHEN** la cible est un Humanoïde
- **THEN** Amadouer n'est pas proposé ; il l'est pour une Bête

### Requirement: Échec d'Influence mémorisé
Un échec SHALL être mémorisé par personnage, cible et approche. Une nouvelle tentative identique SHALL être signalée pendant 24 heures, un délai que le MJ peut changer au moment de l'échec. Les tentatives SHALL se lire dans le journal de toutes les rencontres de la table.

#### Scenario: Échec il y a 2 h ([C10])
- **WHEN** Aldric a échoué à convaincre Varga il y a 2 heures
- **THEN** Convaincre porte « Aldric a échoué il y a 2 h : attendre 24 h pour la même approche »

#### Scenario: Autre approche
- **WHEN** Aldric choisit Intimider
- **THEN** rien n'est signalé

### Requirement: Assistant Influence
L'onglet Influence SHALL demander comment la cible reçoit la requête (EF-ACT-02) :
- Disposée : elle accepte sans test ;
- Réticente : elle refuse sans test ;
- Hésitante : un test est nécessaire.

Enregistrer SHALL écrire un événement `influence` (réception, approche, DD, mode, total, réussite, attitude après l'échange, délai d'attente), et l'attitude d'un PNJ SHALL être enregistrée sur sa fiche (EF-ACT-06). Un monstre sans PNJ SHALL garder son attitude dans le combat, Indifférent par défaut.

#### Scenario: Échec enregistré ([C10])
- **WHEN** Aldric, Intimidation +2, obtient 9 contre DD 15
- **THEN** le journal porte un échec avec Désavantage, total 11, Varga reste Hostile, et l'approche est bloquée 24 h

#### Scenario: Disposée
- **WHEN** Varga est Disposée et le MJ la passe Amicale
- **THEN** la fiche de Varga devient Amicale

### Requirement: Assistant Observation
L'onglet Observation SHALL proposer :
- ce qui est cherché ;
- les compétences de Sagesse avec les bonus du personnage, Perception par défaut, et leur aide ;
- le résultat, saisi ou lancé, et un DD facultatif fixé par le MJ.

Le MJ SHALL rédiger ce qui est découvert, car il n'y a pas d'informations préparées, et pouvoir le lier à un PNJ (EF-ACT-04). « Consigner » SHALL écrire un événement `observation`, réservé au MJ (EF-ACT-07).

#### Scenario: Traces à l'écurie ([F3])
- **WHEN** Aldric, Perception +3, obtient 13 contre DD 15, et le MJ consigne les ornières en les liant à Varga
- **THEN** le journal porte l'Observation, réussie avec 16, sa découverte et le lien au PNJ

#### Scenario: Découverte vide
- **WHEN** rien n'est rédigé dans « Ce qui est découvert »
- **THEN** « Consigner » est inactif

