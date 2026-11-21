## ADDED Requirements

### Requirement: Importer un pack
« Importer un pack » SHALL ouvrir un fichier `.dndpack` et montrer son aperçu ([H08]) avant toute écriture :
- nom, auteur, licence, dépendances, version importée et version installée ;
- contenu : entités nouvelles et modifiées, et le nombre d'entités inchangées ;
- vérifications : taille, signature, format et contenu, dépendances.

Un fichier illisible, trop gros, non signé, mal signé, ou dont une dépendance manque SHALL être refusé, avec la raison. Rien n'est importé avant la confirmation (EF-HB-06).

#### Scenario: Nouveau pack
- **WHEN** Camille importe « Gardiens des Marches » 0.1.0, signé par Inès, qu'elle n'a pas
- **THEN** l'aperçu montre ses entités en « Nouveau », la signature d'Inès et la dépendance au SRD 5.2.1, et « Importer » l'installe

#### Scenario: Fichier refusé
- **WHEN** le fichier n'est pas un `.dndpack` lisible, ou sa signature ne correspond pas
- **THEN** l'aperçu indique pourquoi, et aucun bouton d'import n'est proposé

### Requirement: Mise à jour du même auteur
Un pack de même identifiant SHALL être une mise à jour seulement s'il est signé par la même clé que la version installée (EF-HB-07). L'aperçu indique alors « Même auteur que la version installée, donc c'est une mise à jour », avec les entités modifiées. Les versions précédentes restent sur l'appareil : une table garde la sienne. Une version déjà installée SHALL être refusée.

#### Scenario: Mise à jour
- **WHEN** Camille, qui a la 0.1.0 d'Inès, importe la 0.2.0 signée par Inès
- **THEN** l'aperçu indique « installée : 0.1.0 », liste les entités nouvelles et modifiées, et « Importer la mise à jour » installe la 0.2.0 sans effacer la 0.1.0

### Requirement: Pack d'un autre auteur
Un pack de même identifiant signé par une autre clé SHALL être importé comme un pack distinct ([H09]), sans toucher au pack installé. Son nom dans la bibliothèque est proposé avec le nom de son auteur entre parenthèses, et il reçoit un autre identifiant et un autre espace de noms.

#### Scenario: Signé par Karl
- **WHEN** Camille, qui a « Gardiens des Marches » d'Inès, importe un pack de même identifiant signé par Karl
- **THEN** l'aperçu indique « Ce n'est pas une mise à jour », propose « Gardiens des Marches (Karl) », et « Importer comme pack distinct » l'installe à côté du pack d'Inès, qui ne change pas

### Requirement: Conflits de noms
L'aperçu SHALL signaler une entité nouvelle qui porte le nom d'une entité d'un autre pack installé. Il propose « Garder les deux » (par défaut, chacune avec le badge de son pack) ou « Renommer le nouveau… ». Un renommage ne vaut que dans la bibliothèque de l'appareil : le fichier n'est pas modifié.

#### Scenario: Renommer
- **WHEN** le pack importé apporte un Don « Veilleur » alors que la bibliothèque en a déjà un, et que Camille le renomme « Veilleur des Marches »
- **THEN** la bibliothèque montre « Veilleur des Marches », et le fichier gardé reste celui de l'auteur

### Requirement: Dupliquer un pack importé
« Dupliquer pour modifier » SHALL créer un brouillon à partir d'un pack importé, sous le nom de l'utilisateur (EF-HB-08). Il est à son nom d'auteur, dans un espace de noms tiré de son nom, avec un nouvel identifiant, en version 0.1.0, et les références entre ses entités suivent.

#### Scenario: Duplication
- **WHEN** Camille duplique « Gardiens des Marches » d'Inès
- **THEN** un brouillon « Gardiens des Marches (copie) » apparaît dans « Mes packs », d'auteur Camille, dont les entités ont l'espace de noms du brouillon
