## ADDED Requirements

### Requirement: Noms des options de choix
Un effet `choice` SHALL pouvoir nommer ses options. Le pack SRD SHALL nommer les options qui ne se déduisent pas d'une entité citée.

#### Scenario: Ordre divin
- **WHEN** on lit l'effet de `srd:feature:cleric-divine-order`
- **THEN** ses options se nomment Protecteur et Thaumaturge

#### Scenario: Lignage elfique
- **WHEN** on lit l'effet de `srd:feature:elf-elven-lineage`
- **THEN** ses options se nomment Drow, Elfe sylvestre et Haut-elfe
