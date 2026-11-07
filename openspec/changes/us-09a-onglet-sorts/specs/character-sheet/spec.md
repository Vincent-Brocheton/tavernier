## ADDED Requirements

### Requirement: Valeurs d'incantation par classe
`computeSheet` SHALL calculer, pour chaque classe de lanceur, la caractéristique, le DD, l'attaque, les sorts mineurs et les sorts préparés de sa table.

#### Scenario: Mira
- **WHEN** la fiche de Mira, Clerc 5 à SAG 17, est calculée
- **THEN** son DD vaut 14, son attaque +6, et elle prépare 9 sorts

#### Scenario: Orin
- **WHEN** la fiche d'Orin, Clerc 3 / Paladin 4, est calculée
- **THEN** le Clerc prépare 6 sorts en SAG et le Paladin 5 en CHA, tous deux à DD 13

### Requirement: Emplacements de sort
Les emplacements SHALL venir de la table de la classe, ou de la table du multiclassage à partir de deux classes à emplacements.

#### Scenario: Une seule classe
- **WHEN** un personnage est Paladin 4
- **THEN** il a 3 emplacements du 1er niveau

#### Scenario: Multiclassage
- **WHEN** un personnage est Ensorceleur 3 / Rôdeur 4
- **THEN** son niveau de lanceur vaut 5 et ses emplacements 4 / 3 / 2

#### Scenario: Une seule classe de lanceur parmi deux
- **WHEN** un personnage est Guerrier 5 / Clerc 3
- **THEN** il a les emplacements d'un Clerc 3

#### Scenario: Magie de pacte
- **WHEN** un personnage est Occultiste 5
- **THEN** il a 2 emplacements du 3e niveau, à part des autres

### Requirement: Sorts de la fiche
La fiche SHALL lister les sorts de classe, les sorts accordés et ceux des dons, avec leur classe.

#### Scenario: Sorts accordés
- **WHEN** la fiche d'un Clerc 5 du Domaine de la Vie est ouverte
- **THEN** ses 6 sorts de domaine apparaissent comme toujours préparés

#### Scenario: Palier de la classe
- **WHEN** un Guerrier 4 / Clerc 3 du Domaine de la Vie est ouvert
- **THEN** ses sorts de domaine du palier 5 n'apparaissent pas

### Requirement: Onglet Sorts
L'onglet Sorts SHALL montrer les valeurs décomposées, les emplacements, les filtres et les sorts par niveau. Un personnage sans sort SHALL voir un état vide.

#### Scenario: Personnage sans sort
- **WHEN** Aldric ouvre l'onglet
- **THEN** il voit « Aucun sort »

#### Scenario: Filtre
- **WHEN** Mira filtre sur Concentration
- **THEN** seuls ses sorts à concentration restent

### Requirement: Fiche de sort
Toucher un sort SHALL ouvrir sa fiche : niveau, école, incantation, portée, composantes, durée et description.

#### Scenario: Bénédiction
- **WHEN** Mira touche Bénédiction
- **THEN** la portée s'affiche en mètres et la durée indique la concentration
