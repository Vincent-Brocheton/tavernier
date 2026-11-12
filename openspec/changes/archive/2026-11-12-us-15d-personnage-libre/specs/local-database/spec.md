## ADDED Requirements

### Requirement: Personnages libres et historique
`CharacterStore` SHALL lister les personnages libres d'un utilisateur, en rattacher un à une table en l'envoyant au MJ, inscrire des dérogations dans l'historique et rendre l'historique, le plus récent d'abord.

#### Scenario: Rattachement
- **WHEN** un personnage libre est rattaché
- **THEN** il n'est plus libre, et son statut est `submitted`

#### Scenario: Historique
- **WHEN** deux dérogations sont inscrites
- **THEN** l'historique les rend, la dernière d'abord
