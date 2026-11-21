## ADDED Requirements

### Requirement: Entités bannies dans le contenu
`ActiveContent.withBanned(ids)` SHALL rendre le même contenu, dont les entités [ids] sont absentes des énumérations (`entities`, `spellList`). `entity(id)` les rend toujours, et `isBanned(id)` les signale.

#### Scenario: Sort banni
- **WHEN** Sommeil est banni, et qu'un Magicien le connaît déjà
- **THEN** la liste de sorts du Magicien ne contient plus Sommeil, et sa fiche se calcule comme sans bannissement

### Requirement: Contenu figé d'une fiche
`freezeContent(refs, content)` SHALL rendre, à partir des références de contenu d'une fiche (entité, pack, version, instantané) :
- les entités figées : l'instantané de chaque référence dont la version diffère de celle du contenu ;
- les changements : les références figées dont l'instantané diffère de l'entité actuelle, et dont la version actuelle n'a pas été gardée.

`ActiveContent.withOverrides(entities)` SHALL rendre le même contenu, où ces entités remplacent celles de même identifiant. `contentRefsToRecord(character, content, refs)` SHALL rendre les références à créer (entités homebrew utilisées sans référence), à suivre sans rien demander (instantané identique, version différente), et à retirer (entités plus utilisées).

#### Scenario: Entité modifiée
- **WHEN** une fiche a figé une aptitude en 0.1.0 et que le contenu porte la 0.2.0, qui la modifie
- **THEN** la fiche se calcule avec l'aptitude de 0.1.0, et un changement de 0.1.0 à 0.2.0 est rendu
