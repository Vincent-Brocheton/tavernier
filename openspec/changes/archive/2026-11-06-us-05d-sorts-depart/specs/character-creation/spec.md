## ADDED Requirements

### Requirement: Sorts de départ
L'étape Sous-choix SHALL demander à un lanceur de sorts ses sorts de niveau 1, en nombre donné par sa table de classe, dans la liste de sa classe. L'étape SHALL rester bloquée tant que le compte n'y est pas.

#### Scenario: Clerc
- **WHEN** le personnage est Clerc
- **THEN** il choisit 3 sorts mineurs et 4 sorts préparés du 1er niveau

#### Scenario: Paladin
- **WHEN** le personnage est Paladin
- **THEN** il choisit 2 sorts préparés et aucun sort mineur

#### Scenario: Sort mineur supplémentaire
- **WHEN** un Clerc choisit l'Ordre divin Thaumaturge
- **THEN** il choisit 4 sorts mineurs

#### Scenario: Grimoire du Magicien
- **WHEN** le personnage est Magicien
- **THEN** il choisit 6 sorts du 1er niveau pour son grimoire, puis 4 sorts préparés parmi eux

#### Scenario: Sort retiré du grimoire
- **WHEN** un Magicien retire de son grimoire un sort préparé
- **THEN** ce sort n'est plus préparé

#### Scenario: Changement de classe
- **WHEN** le joueur change de classe
- **THEN** ses sorts de classe sont effacés

### Requirement: Un sort ne se prend pas deux fois
L'étape Sous-choix SHALL griser, avec la règle, un sort déjà choisi dans une autre section ou accordé au niveau 1 par la classe, l'espèce ou un lignage. Le grimoire et les sorts préparés du Magicien SHALL rester exemptés entre eux.

#### Scenario: Sort d'espèce
- **WHEN** un Clerc Tieffelin choisit ses sorts mineurs
- **THEN** Thaumaturgie est grisée avec la règle

#### Scenario: Sort pris par l'Initié à la magie
- **WHEN** un Clerc Acolyte a choisi Assistance comme sort mineur de classe
- **THEN** Assistance est grisée dans les sorts mineurs de l'Initié à la magie

#### Scenario: Sort accordé par la classe
- **WHEN** un Rôdeur choisit ses sorts préparés
- **THEN** Marque du chasseur est grisée avec la règle

#### Scenario: Sort devenu connu
- **WHEN** un Magicien a choisi Prestidigitation, puis choisit le lignage Haut-elfe
- **THEN** Prestidigitation est signalée « À refaire »

### Requirement: Initié à la magie
L'étape Sous-choix SHALL demander, pour chaque Initié à la magie, la caractéristique d'incantation, 2 sorts mineurs et 1 sort du 1er niveau de sa liste. Un Historique SHALL imposer sa liste. Pris par Polyvalent, le don SHALL proposer le Clerc, le Druide et le Magicien.

#### Scenario: Acolyte
- **WHEN** l'Historique est Acolyte
- **THEN** les sorts viennent de la liste du Clerc, sans choix de liste

#### Scenario: Polyvalent
- **WHEN** un Humain Soldat prend Initié à la magie
- **THEN** il choisit sa liste, puis ses sorts dans cette liste

#### Scenario: Seconde prise du don
- **WHEN** un Humain Acolyte prend Initié à la magie
- **THEN** la liste du Clerc est grisée avec la règle

#### Scenario: Changement de liste
- **WHEN** le joueur change de liste
- **THEN** les sorts choisis dans l'ancienne liste sont effacés

### Requirement: Caractéristique d'incantation d'un lignage
L'étape Sous-choix SHALL demander la caractéristique d'incantation du Lignage elfique, du Lignage gnome et de l'Héritage fiélon.

#### Scenario: Elfe
- **WHEN** l'espèce est Elfe
- **THEN** il choisit entre Intelligence, Sagesse et Charisme
