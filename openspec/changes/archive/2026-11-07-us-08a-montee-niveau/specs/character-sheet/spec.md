## ADDED Requirements

### Requirement: Bonus de caractéristique
Un effet `ability_bonus` actif SHALL augmenter la caractéristique, sans dépasser `max`. Une Amélioration de caractéristique SHALL s'appliquer depuis `{"str": 1, "con": 1}` dans les choix du don.

#### Scenario: Aldric niveau 5
- **WHEN** Aldric a l'Amélioration de caractéristique +1 FOR, +1 CON
- **THEN** sa Force vaut 18 et sa Constitution 16, comme sur [D1]

#### Scenario: Plafond
- **WHEN** un bonus de +2 porte sur une valeur de 19
- **THEN** la valeur s'arrête à 20

#### Scenario: Répartition inconnue
- **WHEN** les choix du don ne correspondent à aucune option
- **THEN** la fiche signale une erreur de choix

### Requirement: Don accordé par une Amélioration de caractéristique
Une aptitude qui accorde un don général SHALL accepter tout don éligible.

#### Scenario: Don d'origines
- **WHEN** un Guerrier niveau 4 prend Doué
- **THEN** aucune erreur de don n'est signalée

### Requirement: Montée de niveau
`levelGain` SHALL rendre les gains du niveau suivant et `applyLevelUp` le personnage monté. L'assistant SHALL enregistrer le personnage sans réseau.

#### Scenario: Aldric du niveau 1 au niveau 5
- **WHEN** Aldric monte quatre fois avec les choix de [D1]
- **THEN** sa fiche retrouve les valeurs de la fixture `aldric_n5`

#### Scenario: Sous-classe
- **WHEN** un Guerrier passe au niveau 3
- **THEN** il choisit sa sous-classe et l'étape reste bloquée sans elle

#### Scenario: Don non répétable
- **WHEN** un personnage a déjà Vigilant
- **THEN** le don est grisé avec sa raison

#### Scenario: Conditions d'un don
- **WHEN** un personnage de Force et Dextérité 12 regarde Empoigneur
- **THEN** le don est grisé avec sa raison

#### Scenario: Style de combat
- **WHEN** un Paladin passe au niveau 2
- **THEN** on lui propose les dons de style de combat, pas les dons généraux

#### Scenario: Toute classe jusqu'au niveau 20
- **WHEN** chaque classe monte du niveau 1 au niveau 20 avec des choix valides
- **THEN** aucune erreur d'intégrité n'est signalée

#### Scenario: Niveau 20
- **WHEN** le personnage est niveau 20
- **THEN** le bouton de montée n'apparaît pas
