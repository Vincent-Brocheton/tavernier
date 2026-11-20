## ADDED Requirements

### Requirement: Liste des notes
L'onglet Notes de la table (MJ, [N3]) et celui de la fiche (joueur, [N4], EF-NOT-05) SHALL montrer les notes de l'utilisateur et celles partagées avec la table. Elles sont groupées par rattachement, avec des filtres comptés. Chaque carte porte un extrait, son rattachement, « Partagée avec la table », ou « Partagée par … · lecture seule » pour celle d'un autre, et « Deux versions à fusionner » en cas de conflit.

#### Scenario: [N3]
- **WHEN** Camille ouvre les notes de Brumeval
- **THEN** elle voit ses deux notes et celle partagée par Hugo, pas la note privée de Hugo, et le filtre PNJ ne garde que « Dette envers Brug »

#### Scenario: Vue du joueur
- **WHEN** Hugo ouvre les notes
- **THEN** il voit ses notes et « Calendrier et factions », partagée par Camille, pas sa note privée de séance

### Requirement: Recherche hors-ligne
La recherche SHALL porter sur le titre et le texte des notes de l'appareil, sans tenir compte des accents ni de la casse (EF-NOT-03, [N6]).

#### Scenario: Accents et casse
- **WHEN** Camille cherche « GUILDÉ »
- **THEN** « Calendrier et factions » est le seul résultat

### Requirement: Éditeur de note
L'éditeur ([N5]) SHALL proposer le rattachement (table, séance, PNJ, rencontre), le titre, le texte avec gras, liste et lien vers un PNJ ou une rencontre, et le partage avec la table. Une note neuve SHALL être privée et rattachée à la séance en cours s'il y en a une. La note d'un autre SHALL s'ouvrir en lecture seule, et ses liens SHALL mener au PNJ ou à la rencontre pour le MJ. Une note en conflit SHALL montrer l'autre version, avec « Ajouter à mon texte » et « Écarter l'autre version » (EF-NOT-06).

#### Scenario: Nouvelle note
- **WHEN** Camille écrit « Ce que le loup portait », insère un lien vers Varga, partage et enregistre
- **THEN** la note est partagée, rattachée à la séance en cours, et son texte porte `[Varga la Balafrée](npc:<id>)`

#### Scenario: Lecture seule
- **WHEN** Camille ouvre la note de Hugo
- **THEN** elle la lit sans champ ni « Enregistrer »

#### Scenario: Fusion
- **WHEN** Camille ajoute l'autre version à son texte
- **THEN** la note porte les deux textes, sans conflit
