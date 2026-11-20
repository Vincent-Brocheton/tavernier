## ADDED Requirements

### Requirement: Mes packs
L'onglet Homebrew ([H01]) SHALL lister les brouillons de l'utilisateur, avec leur version, leur contenu et l'état de leur vérification, et le pack SRD 5.2.1, verrouillé. « Nouveau pack » SHALL créer un brouillon avec un nom, un espace de noms, la version 0.1.0, une licence et un auteur. « Créer une entité » SHALL proposer les 8 types d'entités.

#### Scenario: Nouveau pack
- **WHEN** Inès crée le pack « Gardiens des Marches »
- **THEN** il apparaît dans « Mes packs » en version 0.1.0, brouillon, et reste après un redémarrage de l'app

### Requirement: Vérification d'un pack
La page d'un pack SHALL montrer ses entités par type et le panneau « Vérification ». Ce panneau porte les problèmes de `validatePack` et les contraintes 2024 de chaque type (cahier §7.1). Un problème SHALL bloquer la publication sans bloquer l'enregistrement : un brouillon peut rester incomplet.

#### Scenario: Historique incomplet
- **WHEN** un Historique n'a que 2 caractéristiques
- **THEN** le brouillon s'enregistre, et la vérification indique « Exactement 3 caractéristiques »

### Requirement: Éditeur d'effets
L'éditeur d'effets ([H03]) SHALL ne proposer que les opérations du DSL v1, chacune par un formulaire guidé, sans formule libre ni code (EF-HB-01). Il SHALL montrer « Ce que le joueur lira ». Un effet enregistré SHALL passer `validateEffect`.

#### Scenario: Bonus de CA avec bouclier
- **WHEN** l'auteur ajoute « Modifier la CA » de +1, tant qu'il porte un bouclier
- **THEN** l'effet enregistré est `modify_ac` de valeur 1, avec sa condition, et il passe `validateEffect`

### Requirement: Éditeur de Don
L'éditeur de Don SHALL exiger une catégorie (origine, général, style de combat ou faveur épique), et proposer les prérequis, « Répétable » et les effets.

#### Scenario: Don sans catégorie
- **WHEN** un Don est enregistré sans catégorie
- **THEN** la vérification signale la catégorie manquante

### Requirement: Éditeur d'Historique
L'éditeur d'Historique SHALL exiger exactement 3 caractéristiques, un don de catégorie origine, 2 compétences et un outil (ou une catégorie d'outil). Il SHALL proposer l'équipement et l'or des options A et B.

#### Scenario: Don d'une autre catégorie
- **WHEN** l'auteur choisit un don de catégorie générale comme don d'origine
- **THEN** le choix est refusé : seuls les dons d'origine sont proposés

### Requirement: Éditeur de Sort
L'éditeur de Sort SHALL proposer :
- le niveau (0 à 9) et l'école ;
- le temps d'incantation et le rituel ;
- la portée et les composantes ;
- la durée et la concentration ;
- les listes de classes, parmi les seules classes qui ont une liste de sorts.

Un sort qui cite une classe SHALL entrer dans la liste de cette classe quand son pack est actif, sans modifier la classe.

#### Scenario: Sort du Magicien
- **WHEN** l'auteur crée « Lanterne de brume », sort d'Illusion de 1er niveau, pour le Magicien
- **THEN** le sort cite `srd:class:wizard`, et la liste du Magicien est celle du SRD suivie de ce sort

### Requirement: Éditeur d'Objet
L'éditeur d'Objet ([H05]) SHALL proposer une arme, une armure, un objet magique ou un objet courant.
- Une arme SHALL avoir une botte d'arme ; sans elle, la vérification le signale.
- Une rareté SHALL rendre magique une arme ou une armure. Ses effets s'appliquent quand elle est équipée, et harmonisée si elle le demande.

#### Scenario: Arme sans botte
- **WHEN** une arme est enregistrée sans botte d'arme
- **THEN** le brouillon s'enregistre, et la vérification indique « une arme a toujours une botte d'arme »

#### Scenario: Bouclier magique harmonisé
- **WHEN** Aldric remplace son bouclier par un bouclier peu courant qui demande l'harmonisation et porte « +1 à la CA »
- **THEN** sa CA passe de 19 à 20 une fois le bouclier harmonisé, et reste à 19 sans harmonisation

### Requirement: Variante d'une entité du SRD
« Dériver d'une entité du SRD » SHALL copier dans le pack un Don, un Historique, un Sort ou un objet du SRD. La copie reçoit un nouvel identifiant, avec `extends_id` vers l'original. L'original SHALL rester inchangé (EF-HB-02).

#### Scenario: Hache d'armes peu courante
- **WHEN** l'auteur dérive la Hache d'armes, la nomme « Hache des Marches », la rend peu courante et demande l'harmonisation
- **THEN** l'entité `…:weapon:hache-des-marches` garde la botte Renversement et cite `srd:weapon:battleaxe`, et la Hache d'armes du SRD n'a toujours pas de rareté
