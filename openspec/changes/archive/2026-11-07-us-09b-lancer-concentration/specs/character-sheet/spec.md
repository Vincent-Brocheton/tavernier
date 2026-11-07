## ADDED Requirements

### Requirement: Lancer un sort
Lancer un sort SHALL proposer les emplacements de son niveau ou plus, et décompter celui choisi. Un sort mineur ne dépense rien, un rituel peut se passer d'emplacement.

#### Scenario: Emplacement choisi
- **WHEN** Mira lance Sanctuaire sur un emplacement du 2e niveau
- **THEN** il lui reste 2 emplacements du 2e niveau sur 3

#### Scenario: Plus d'emplacement
- **WHEN** aucun emplacement n'accepte le sort
- **THEN** le bouton Lancer est désactivé

#### Scenario: Pacte
- **WHEN** Sélène, Occultiste 5, lance Maléfice
- **THEN** le sort se lance au 3e niveau

### Requirement: Concentration
Un seul sort à concentration SHALL être actif. Lancer un second sort à concentration SHALL demander confirmation et mettre fin au premier.

#### Scenario: Second sort
- **WHEN** Mira, concentrée sur Bénédiction, lance Esprits gardiens et confirme
- **THEN** la concentration passe à Esprits gardiens

#### Scenario: Annulation
- **WHEN** elle refuse la confirmation
- **THEN** rien ne change, emplacement compris

#### Scenario: Mettre fin
- **WHEN** elle touche « Mettre fin »
- **THEN** la carte de concentration disparaît
