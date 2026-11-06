## ADDED Requirements

### Requirement: Caractéristique principale au choix en base
La base locale SHALL conserver `primary_abilities_any` à l'import et le restituer à l'export.

#### Scenario: Aller-retour
- **WHEN** on importe puis exporte le pack SRD
- **THEN** le Guerrier garde `primary_abilities_any` à vrai
