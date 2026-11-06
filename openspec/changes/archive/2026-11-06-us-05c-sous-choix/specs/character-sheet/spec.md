## ADDED Requirements

### Requirement: Option nommée d'un choix
Une sélection SHALL pouvoir désigner une option de `choice` par son nom. Les effets de l'option deviennent alors actifs.

#### Scenario: Protecteur (SRD p. 38)
- **WHEN** un Clerc choisit « Protecteur »
- **THEN** il maîtrise les armes de guerre

### Requirement: Bottes de corps à corps
Une classe dont les bottes sont réservées au corps à corps SHALL refuser une arme à distance.

#### Scenario: Barbare (SRD p. 31)
- **WHEN** un Barbare prend une botte sur un arc long
- **THEN** une erreur de botte est signalée
