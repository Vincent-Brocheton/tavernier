## ADDED Requirements

### Requirement: Bac à sable d'une entité
L'éditeur d'un Don, d'un Historique, d'une Espèce, d'une Classe, d'une Sous-classe, d'une arme, d'une armure ou d'un objet magique SHALL proposer « Tester sur un personnage » ([H04], EF-HB-03). Le test SHALL porter sur l'entité telle qu'elle est à l'écran, avec les autres entités du brouillon, sans rien enregistrer. Aucune fiche réelle n'est lue ni modifiée.

#### Scenario: Gardien du rempart au niveau 7
- **WHEN** l'auteur teste la sous-classe « Gardien du rempart », dont l'aptitude de niveau 3 donne +1 CA avec un bouclier, sur le Guerrier prétiré au niveau 7, bouclier porté
- **THEN** la ligne « Classe d'armure » montre la CA sans la sous-classe, puis 1 de plus avec, et a pour source « Rempart vivant »

#### Scenario: Bouclier retiré
- **WHEN** l'auteur décoche « Porte un bouclier »
- **THEN** la CA avec la sous-classe est égale à la CA sans elle

### Requirement: Personnage de test
Le panneau « Personnage de test » SHALL proposer une base prétirée par classe du contenu et du brouillon, un niveau de 1 à 20 et « Porte un bouclier ». Pour une sous-classe, la base SHALL être sa classe parente et le niveau SHALL commencer au niveau de sous-classe. Pour une classe, la base SHALL être cette classe.

#### Scenario: Niveau d'une sous-classe
- **WHEN** l'auteur teste une sous-classe du Guerrier
- **THEN** la base est « Guerrier prétiré (Humain, Soldat) » et le niveau va de 3 à 20

### Requirement: Résultat du test
Le panneau « Résultat du test » SHALL indiquer :
- que toutes les valeurs se calculent sans erreur au niveau choisi ;
- ou les règles enfreintes que l'entité ajoute à la fiche, et un calcul qui échoue.

Il SHALL aussi lister les problèmes de la vérification du brouillon qui concernent l'entité ou ses aptitudes, à corriger avant de publier, sans empêcher le test (EF-HB-11).

#### Scenario: Progression incomplète
- **WHEN** l'auteur teste une sous-classe à laquelle il manque les aptitudes des niveaux 10, 15 et 18
- **THEN** le test se calcule, et le résultat cite « progression incomplète : aucune aptitude aux niveaux 10, 15, 18 » dans ce qui reste à corriger

### Requirement: Aperçu d'un monstre
« Tester » SHALL montrer, pour un monstre, son profil tel que le MJ le verra en jeu, avec le bloc de stats de [C2].

#### Scenario: Profil d'un monstre homebrew
- **WHEN** l'auteur teste le monstre « Loup des brumes »
- **THEN** le bloc de stats affiche son nom, sa CA et ses actions
