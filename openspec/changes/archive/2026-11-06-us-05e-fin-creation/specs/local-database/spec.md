## ADDED Requirements

### Requirement: Sorts, monnaie et détails du personnage
`CharacterStore` SHALL écrire et relire les sorts, la monnaie, l'alignement, l'apparence, la personnalité et l'histoire d'un personnage.

#### Scenario: Aller-retour
- **WHEN** on enregistre puis relit un personnage avec ces champs
- **THEN** l'entrée relue est identique, à l'ordre des sorts près

### Requirement: Liste des personnages
`CharacterStore` SHALL lister les personnages enregistrés, du plus ancien au plus récent.

#### Scenario: Deux personnages
- **WHEN** deux personnages sont enregistrés
- **THEN** la liste les rend avec leur identifiant

### Requirement: Identifiants des données utilisateur
Un identifiant de personnage SHALL être un UUID v7.

#### Scenario: Format
- **WHEN** on génère un identifiant
- **THEN** sa version vaut 7, sa variante RFC 9562, et il est unique

#### Scenario: Ordre chronologique
- **WHEN** on génère un identifiant à deux instants distincts
- **THEN** le plus récent se trie après le premier
