## ADDED Requirements

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
