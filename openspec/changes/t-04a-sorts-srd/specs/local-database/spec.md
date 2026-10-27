## ADDED Requirements

### Requirement: Sorts dans la base
La base SHALL stocker les sorts d'un pack dans la table `spell` (cahier §11.1) et les restituer à l'identique à l'export. La recherche plein texte SHALL trouver un sort par son nom ou son texte.

#### Scenario: Aller-retour
- **WHEN** le pack SRD complet est importé puis exporté
- **THEN** chaque sort exporté est égal au sort d'origine

#### Scenario: Recherche
- **WHEN** on cherche « boule de feu »
- **THEN** le premier résultat est `srd:spell:fireball`, de type `spell`
