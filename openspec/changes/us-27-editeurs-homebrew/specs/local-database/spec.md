## ADDED Requirements

### Requirement: Brouillons homebrew
`HomebrewStore` SHALL créer, enregistrer, lister et supprimer des brouillons de packs. Chacun est gardé en entier, en JSON, dans la table locale `homebrew_draft`, non synchronisée, même s'il ne passe pas encore les validations. Un brouillon relu SHALL être identique au pack enregistré.

#### Scenario: Aller-retour
- **WHEN** un brouillon avec un Don et un Historique incomplet est enregistré, puis relu
- **THEN** il est identique, entités et manifeste compris

### Requirement: Arme magique et listes de classes d'un sort
Le schéma v7 SHALL garder la rareté et l'harmonisation d'une arme ou d'une armure, et les classes citées par un sort. L'export d'un pack importé SHALL rendre ces champs à l'identique, sans changer la liste de sorts d'une classe d'un autre pack.

#### Scenario: Aller-retour d'un pack homebrew
- **WHEN** un pack avec une hache peu courante harmonisée, un bouclier rare et un sort du Magicien est importé après le SRD, puis exporté
- **THEN** les deux packs exportés sont identiques à ceux qui ont été importés

### Requirement: Niveaux de sous-classe d'une classe
Le schéma v8 SHALL garder les niveaux d'aptitude de sous-classe d'une classe (`player_class.subclass_feature_levels`). L'export d'un pack importé SHALL les rendre à l'identique ; une base v7 SHALL monter en v8.

#### Scenario: Aller-retour du SRD
- **WHEN** le pack SRD est importé puis exporté
- **THEN** le Guerrier exporté a pour niveaux de sous-classe 3, 7, 10, 15 et 18

### Requirement: Paliers d'Étude indexés
L'import d'un pack SHALL écrire les paliers d'Étude d'un monstre dans `study_reveal` (monstre, DD, texte), et l'export SHALL les rendre à l'identique.

#### Scenario: Aller-retour d'un monstre homebrew
- **WHEN** un monstre à deux paliers d'Étude est importé, puis exporté
- **THEN** il est identique, et `study_reveal` porte ses deux paliers
