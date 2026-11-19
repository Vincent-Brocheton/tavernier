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
