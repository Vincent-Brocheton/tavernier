## ADDED Requirements

### Requirement: Inventaire
L'onglet Inventaire SHALL lister les objets équipés et le sac, et permettre d'ajouter, retirer, équiper et changer la quantité.

#### Scenario: Ajout
- **WHEN** Aldric ajoute une dague
- **THEN** elle rejoint son sac, et une seconde dague fait passer la quantité à 2

#### Scenario: Quantité nulle
- **WHEN** la quantité d'un objet passe à 0
- **THEN** l'objet est retiré

### Requirement: Équipement
La CA et les attaques SHALL suivre l'équipement porté, avec une seule armure et un seul bouclier.

#### Scenario: Armure
- **WHEN** Aldric retire sa cotte de mailles
- **THEN** sa CA est recalculée

#### Scenario: Seconde armure
- **WHEN** il équipe une autre armure
- **THEN** la première retourne au sac

### Requirement: Harmonisation
Un personnage SHALL s'harmoniser avec 3 objets au maximum.

#### Scenario: Limite
- **WHEN** 3 objets sont harmonisés
- **THEN** un quatrième ne peut pas l'être

#### Scenario: Dépassement
- **WHEN** une fiche compte 4 objets harmonisés
- **THEN** une erreur d'intégrité est signalée

#### Scenario: Cape de protection
- **WHEN** Aldric niveau 5 porte sa cape et s'y harmonise
- **THEN** sa CA passe de 19 à 20 et ses jets de sauvegarde gagnent +1

#### Scenario: Cape non harmonisée
- **WHEN** il la porte sans s'y harmoniser
- **THEN** sa CA reste à 19

### Requirement: Monnaie
L'onglet SHALL montrer et modifier les cinq pièces.

#### Scenario: Modification
- **WHEN** Aldric passe ses po de 46 à 40
- **THEN** la fiche enregistre 40 po, sans toucher aux autres pièces
