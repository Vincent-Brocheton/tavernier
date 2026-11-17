## ADDED Requirements

### Requirement: Nouveau PNJ en fiche complète
« Nouveau PNJ » SHALL proposer deux formes : « Bloc de stats » et « Fiche complète ». En fiche complète, « Créer le PNJ » SHALL ouvrir l'assistant de création des personnages, avec le nom prérempli et la méthode de caractéristiques libre. L'enregistrement SHALL créer une fiche de PNJ rattachée à la table, puis le PNJ lié, avec son dossier et son attitude.

#### Scenario: Maître Odran
- **WHEN** Camille choisit « Fiche complète », saisit « Maître Odran », le dossier « Relais du Sel » et Amical, puis termine l'assistant en tirant les caractéristiques aux dés
- **THEN** Odran est une fiche de PNJ de Brumeval, et le PNJ « Maître Odran » est rangé dans « Relais du Sel », Amical, lié à cette fiche

### Requirement: Fiche d'un PNJ en fiche complète
La fiche d'un PNJ lié à une fiche complète SHALL montrer « Fiche complète », « Ouvrir la fiche », l'attitude et les informations cachées, sans « Dupliquer ». La liste des PNJ SHALL afficher « Fiche complète · niveau n ».

#### Scenario: Ouvrir la fiche
- **WHEN** Camille touche « Ouvrir la fiche » sur Maître Odran
- **THEN** la fiche de personnage d'Odran s'ouvre

#### Scenario: Liste
- **WHEN** Camille ouvre l'onglet « PNJ »
- **THEN** Maître Odran affiche « Fiche complète · niveau 1 »
