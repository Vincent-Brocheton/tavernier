## ADDED Requirements

### Requirement: Emplacements et fiches de table
`TableStore` SHALL créer, remplir et supprimer les emplacements de PJ, et les rendre avec le nom, le statut et le niveau de leur fiche, à jour à chaque changement. `CharacterStore` SHALL rattacher une fiche neuve à une table sans jamais effacer ce rattachement, changer son statut, et ne lister que les fiches de l'utilisateur et celles pas encore envoyées.

#### Scenario: Emplacement rempli
- **WHEN** une fiche de niveau 3 remplit un emplacement
- **THEN** l'emplacement rend son nom, son statut et le niveau 3

#### Scenario: Fiches d'un autre
- **WHEN** le MJ a reçu la fiche d'un joueur
- **THEN** elle n'apparaît pas dans sa liste de personnages

### Requirement: Identifiants ordonnés
Les identifiants UUID v7 créés par un même processus SHALL croître strictement, même dans la même milliseconde.

#### Scenario: Mille identifiants
- **WHEN** mille identifiants sont créés d'affilée
- **THEN** ils sont triés et tous différents
