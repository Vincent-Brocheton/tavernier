## ADDED Requirements

### Requirement: Choix de la classe à la montée de niveau
L'assistant SHALL proposer les classes actuelles et les autres classes, avec le prérequis de 13 dans la caractéristique principale de la nouvelle classe et des classes existantes.

#### Scenario: Prérequis rempli
- **WHEN** Aldric, DEX 13, monte de niveau
- **THEN** Roublard est proposé avec « Dextérité 13 requise · Dextérité 13 ✓ »

#### Scenario: Prérequis manquant
- **WHEN** Aldric, SAG 12, monte de niveau
- **THEN** Clerc est grisé avec « Sagesse 12 : il manque 1 »

### Requirement: Premier niveau d'une nouvelle classe
Une nouvelle classe SHALL n'accorder que les traits de son multiclassage, ses aptitudes de niveau 1 et les PV de ses niveaux suivants.

#### Scenario: Points de vie
- **WHEN** un personnage de CON +2 prend un niveau de Roublard
- **THEN** il gagne 5 + 2 PV, pas le maximum du dé

#### Scenario: Armes
- **WHEN** un Magicien prend un niveau de Roublard
- **THEN** il ne maîtrise pas la rapière

#### Scenario: Compétence
- **WHEN** un personnage prend un niveau de Barde, de Rôdeur ou de Roublard
- **THEN** il choisit 1 compétence de cette classe, hors celles qu'il maîtrise

#### Scenario: Magicien
- **WHEN** un personnage prend un niveau de Magicien
- **THEN** il inscrit 6 sorts dans son grimoire

### Requirement: Dés de vie par type
Les dés de vie SHALL se regrouper par type.

#### Scenario: Clerc et Paladin
- **WHEN** un personnage est Clerc 5 / Paladin 5
- **THEN** il a 5 d8 et 5 d10

#### Scenario: Paladin et Guerrier
- **WHEN** un personnage est Paladin 5 / Guerrier 5
- **THEN** il a 10 d10

### Requirement: Une seule formule de classe d'armure
Une formule `ac_formula` valide SHALL remplacer 10 + DEX, et une seule SHALL s'appliquer.

#### Scenario: Barbare
- **WHEN** un Barbare de DEX +1 et CON +2 ne porte pas d'armure
- **THEN** sa CA vaut 13

#### Scenario: Barbare et Moine
- **WHEN** ce Barbare a aussi un niveau de Moine et SAG +1
- **THEN** sa CA vaut toujours 13
