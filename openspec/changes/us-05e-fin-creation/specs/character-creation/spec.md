## ADDED Requirements

### Requirement: Équipement de départ
L'étape Équipement SHALL proposer les lots de la classe et les deux options de l'Historique, et rester bloquée tant qu'ils ne sont pas choisis, ainsi que l'outil d'un lot qui en demande un.

#### Scenario: Guerrier Soldat
- **WHEN** le personnage est Guerrier Soldat
- **THEN** il choisit parmi 3 lots de classe, puis entre le lot de l'Historique avec 14 po et 50 po

#### Scenario: Instrument du Barde
- **WHEN** un Barde choisit le lot qui comprend un instrument
- **THEN** il choisit cet instrument avant de continuer

#### Scenario: Changement de classe
- **WHEN** le joueur change de classe
- **THEN** son lot de classe et son outil sont effacés

### Requirement: Détails du personnage
L'étape Détails SHALL exiger un nom et laisser l'alignement, l'apparence, la personnalité et l'histoire optionnels.

#### Scenario: Nom vide
- **WHEN** le nom est vide ou ne contient que des espaces
- **THEN** l'étape reste bloquée avec la raison

### Requirement: Récapitulatif
L'étape Récapitulatif SHALL afficher la fiche calculée par `computeSheet`. Une erreur d'intégrité SHALL bloquer l'enregistrement. Une alerte SHALL rester sans effet sur l'enregistrement.

#### Scenario: Aldric
- **WHEN** le joueur refait les choix d'Aldric de [D1]
- **THEN** la fiche calculée est celle de la fixture `aldric_n1`, au matériel près

#### Scenario: Botte sur une arme absente
- **WHEN** une botte porte sur une arme absente de l'équipement
- **THEN** une alerte le signale et l'enregistrement reste possible

### Requirement: Enregistrement du personnage créé
L'assistant SHALL enregistrer le personnage sans réseau, puis revenir à la page Personnages, qui le liste.

#### Scenario: Toute combinaison
- **WHEN** un brouillon complet est converti, quelles que soient sa classe, son Historique et son espèce
- **THEN** `computeSheet` ne signale aucune erreur d'intégrité

#### Scenario: Sélection périmée
- **WHEN** une sélection de `choices` n'appartient à aucune section ouverte
- **THEN** elle n'est pas enregistrée

#### Scenario: Échec d'écriture
- **WHEN** l'écriture échoue
- **THEN** l'erreur s'affiche et le brouillon reste ouvert
