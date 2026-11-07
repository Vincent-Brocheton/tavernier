## ADDED Requirements

### Requirement: Expertise
L'Expertise SHALL doubler le bonus de maîtrise de la compétence concernée, qu'elle vienne d'un effet `grant_expertise` ou de `class_levels[].expertise`.

#### Scenario: Roublard
- **WHEN** un Roublard niveau 1 de Dextérité 15 a l'Expertise en Discrétion, qu'il maîtrise
- **THEN** son bonus de Discrétion vaut +2 + 2 + 2 = +6

### Requirement: Décomposition des compétences et des sauvegardes
Chaque compétence, chaque jet de sauvegarde et la Vitesse SHALL porter leurs contributions, dont la somme égale la valeur.

#### Scenario: Athlétisme d'Aldric
- **WHEN** l'Athlétisme d'Aldric est calculée
- **THEN** sa décomposition est « Force +3 » et « maîtrise +2 »

#### Scenario: Compétence bonifiée par un effet
- **WHEN** un Clerc Thaumaturge de Sagesse 15 calcule Religion
- **THEN** sa décomposition compte le bonus de l'Ordre divin

### Requirement: Fiche du personnage
La page d'un personnage enregistré SHALL afficher son en-tête et ses 7 onglets. Principal et Compétences SHALL afficher les valeurs calculées, et toucher une valeur SHALL ouvrir sa décomposition.

#### Scenario: Ouverture
- **WHEN** le joueur touche un personnage de la liste
- **THEN** sa fiche s'ouvre sur l'onglet Principal

#### Scenario: Décomposition d'une caractéristique
- **WHEN** le joueur touche sa Force
- **THEN** il voit la base, le bonus d'Historique, le total, la règle du modificateur et ce qui l'utilise

#### Scenario: Personnage introuvable
- **WHEN** l'identifiant de l'adresse n'existe pas
- **THEN** la page le dit et propose de revenir
