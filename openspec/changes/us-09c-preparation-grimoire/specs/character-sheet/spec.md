## ADDED Requirements

### Requirement: Modifier ses sorts
L'onglet Sorts SHALL permettre de changer les sorts préparés et sorts mineurs d'une classe, sans dépasser son maximum ni sa limite de remplacements.

#### Scenario: Clerc
- **WHEN** Mira ouvre la modification de ses sorts
- **THEN** elle peut remplacer plusieurs sorts préparés

#### Scenario: Paladin
- **WHEN** un Paladin a remplacé un sort
- **THEN** aucun autre sort préparé ne peut être retiré

#### Scenario: Maximum
- **WHEN** le maximum de sorts préparés est atteint
- **THEN** il faut en retirer un pour en ajouter un

#### Scenario: Magicien
- **WHEN** un Magicien modifie ses sorts
- **THEN** seuls les sorts de son grimoire sont proposés

#### Scenario: Sort déjà connu
- **WHEN** un sort est connu par une autre classe ou accordé
- **THEN** il est bloqué

### Requirement: Recopier un sort
Un Magicien SHALL pouvoir recopier un sort de Magicien d'un niveau qu'il peut préparer, pour 2 heures et 50 po par niveau.

#### Scenario: Recopie
- **WHEN** Brannoc recopie un sort du 2e niveau
- **THEN** le sort rejoint son grimoire et il perd 100 po

#### Scenario: Or insuffisant
- **WHEN** il a moins de po que le coût
- **THEN** le sort ne peut pas être recopié

### Requirement: Savoir rituel
Un sort à rituel du grimoire SHALL se lancer en rituel sans être préparé.

#### Scenario: Grimoire
- **WHEN** Brannoc n'a pas préparé Détection de la magie
- **THEN** il peut la lancer en rituel, et d'aucune autre façon

### Requirement: Lancers gratuits
Un sort accordé avec des lancers gratuits SHALL se lancer sans emplacement tant qu'il en reste.

#### Scenario: Lignage
- **WHEN** Thalia lance Détection de la magie
- **THEN** son lancer gratuit est décompté

#### Scenario: Initié à la magie
- **WHEN** un personnage a pris Initié à la magie
- **THEN** son sort du 1er niveau a 1 lancer gratuit
