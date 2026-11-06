## ADDED Requirements

### Requirement: Objets magiques en base
La base locale SHALL stocker chaque objet magique importé et SHALL le restituer à l'export du pack à l'identique.

#### Scenario: Aller-retour
- **WHEN** on importe un pack qui contient un objet magique puis qu'on l'exporte
- **THEN** l'objet exporté est identique à l'objet importé
