## ADDED Requirements

### Requirement: Sorts à la montée de niveau
`spellGain` SHALL rendre les sorts gagnés au niveau suivant et l'assistant SHALL les demander. Un sort déjà connu SHALL être grisé avec la règle.

#### Scenario: Clerc niveau 4
- **WHEN** un Clerc passe du niveau 3 au niveau 4
- **THEN** il gagne 1 sort mineur et 1 sort préparé

#### Scenario: Magicien niveau 2
- **WHEN** un Magicien passe au niveau 2
- **THEN** il ajoute 2 sorts à son grimoire et prépare 1 sort de plus

#### Scenario: Niveau de sort atteint
- **WHEN** un Clerc passe au niveau 3
- **THEN** on lui propose des sorts jusqu'au 2e niveau

#### Scenario: Occultiste
- **WHEN** un Occultiste passe au niveau 3
- **THEN** le niveau de sort atteint vient de son niveau de pacte, soit le 2e

#### Scenario: Toute classe au niveau 20
- **WHEN** un lanceur monte jusqu'au niveau 20
- **THEN** ses sorts mineurs et préparés valent ceux de sa table

### Requirement: Initié à la magie à la montée de niveau
L'Initié à la magie SHALL être proposé comme don, avec une liste autre que celles déjà prises.

#### Scenario: Seconde prise
- **WHEN** un Acolyte prend le don au niveau 4
- **THEN** la liste du Clerc est grisée

### Requirement: Sorts mineurs d'un Combattant béni
Une option qui donne accès à des sorts mineurs d'une autre liste SHALL les demander dans cette liste.

#### Scenario: Paladin
- **WHEN** un Paladin choisit Combattant béni au niveau 2
- **THEN** il choisit 2 sorts mineurs de Clerc
