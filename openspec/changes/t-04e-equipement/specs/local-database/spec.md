## ADDED Requirements

### Requirement: Équipement de départ des classes en base
La base locale SHALL stocker les options d'équipement de départ de chaque classe importée, et SHALL les restituer à l'export du pack à l'identique.

#### Scenario: Aller-retour d'un pack
- **WHEN** on importe le pack SRD puis qu'on relit le Guerrier
- **THEN** ses trois options d'équipement de départ sont identiques à celles du pack
