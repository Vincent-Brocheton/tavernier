## ADDED Requirements

### Requirement: Utiliser un consommable
Un consommable SHALL se lancer ou se saisir, soigner, et décompter sa quantité.

#### Scenario: Potion de guérison
- **WHEN** Aldric, à 34 / 49 PV, boit une potion avec 2d4 = 5
- **THEN** il est à 41 / 49 et il lui reste une potion

#### Scenario: Jet impossible
- **WHEN** le joueur saisit 9 pour 2d4
- **THEN** la potion ne peut pas être bue

#### Scenario: Annulation
- **WHEN** il annule
- **THEN** ni ses PV ni ses potions ne changent

### Requirement: Inspiration héroïque
La fiche SHALL suivre l'Inspiration héroïque, une seule à la fois.

#### Scenario: Recevoir puis utiliser
- **WHEN** un personnage en reçoit une puis l'utilise
- **THEN** il n'en a plus

#### Scenario: Repos long d'un humain
- **WHEN** un humain termine un Repos long
- **THEN** il a l'Inspiration héroïque

#### Scenario: Repos long d'un nain
- **WHEN** un nain sans Inspiration termine un Repos long
- **THEN** il n'en a toujours pas

#### Scenario: Conservée
- **WHEN** un nain qui en a une termine un Repos long
- **THEN** il la garde
