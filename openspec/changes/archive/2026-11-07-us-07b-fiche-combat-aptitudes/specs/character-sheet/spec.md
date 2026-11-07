## ADDED Requirements

### Requirement: Décomposition d'une attaque
Le bonus d'une attaque SHALL porter ses contributions, dont la somme égale le bonus.

#### Scenario: Épée longue d'Aldric
- **WHEN** l'attaque à l'épée longue d'Aldric est calculée
- **THEN** sa décomposition est « Force +3 » et « maîtrise +2 »

#### Scenario: Archerie
- **WHEN** un personnage avec Archerie attaque à l'arc
- **THEN** sa décomposition compte le don

### Requirement: Onglet Combat
L'onglet Combat SHALL lister les attaques, les ressources et les bottes d'arme. Une botte choisie SHALL afficher son effet.

#### Scenario: Botte sur l'arme
- **WHEN** Aldric a choisi la botte de l'épée longue
- **THEN** la carte de l'arme montre Sape et son effet

#### Scenario: Décomposition du toucher
- **WHEN** le joueur touche le bonus d'attaque
- **THEN** la décomposition s'ouvre

### Requirement: Onglet Aptitudes
L'onglet Aptitudes SHALL grouper les aptitudes atteintes par origine, avec un filtre sur celles qui ont des utilisations et sur les dons.

#### Scenario: Groupes
- **WHEN** l'onglet s'ouvre pour un Guerrier humain
- **THEN** il voit Guerrier 1, Humain et Dons

#### Scenario: Aptitude d'un niveau supérieur
- **WHEN** le personnage est niveau 1
- **THEN** les aptitudes des niveaux suivants sont absentes

#### Scenario: Filtre
- **WHEN** le joueur choisit « Avec utilisations »
- **THEN** seules les aptitudes à ressource restent
