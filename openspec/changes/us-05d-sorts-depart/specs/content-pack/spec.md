## ADDED Requirements

### Requirement: Titre d'un choix
Un effet `choice` SHALL pouvoir porter un titre, qui le distingue d'un autre choix de la même entité.

#### Scenario: Lignage elfique
- **WHEN** on lit les effets de `srd:feature:elf-elven-lineage`
- **THEN** un second choix, titré « Caractéristique d'incantation », propose Intelligence, Sagesse et Charisme
