## ADDED Requirements

### Requirement: Entités bannies dans le contenu
`ActiveContent.withBanned(ids)` SHALL rendre le même contenu, dont les entités [ids] sont absentes des énumérations (`entities`, `spellList`). `entity(id)` les rend toujours, et `isBanned(id)` les signale.

#### Scenario: Sort banni
- **WHEN** Sommeil est banni, et qu'un Magicien le connaît déjà
- **THEN** la liste de sorts du Magicien ne contient plus Sommeil, et sa fiche se calcule comme sans bannissement
