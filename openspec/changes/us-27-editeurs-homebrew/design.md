# Design

## Lot a

### Données

- **`HomebrewDrafts`** (`homebrew_draft`) : `id`, `pack` (JSON du manifeste et des entités, comme dans un `.dndpack`), `updated_at`. La table est locale : elle n'entre pas dans `syncedTables`.
- **Schéma v6** : `createTable` dans la migration, avec l'instantané et les tests de montée. La table est locale même sous PowerSync, donc elle est créée dans les deux cas.
- **`HomebrewStore`** : `create(manifest)`, `save(id, pack)`, `watchAll()`, `load(id)` et `delete(id)`.

### Vérification

`checkDraft(manifest, entities, dependencies)` (`dnd_content`, `pack/homebrew.dart`) rend la liste des problèmes :
- ceux de la lecture du manifeste et de chaque entité (`parseEntity`) ;
- ceux de `validatePack`, avec le contenu de l'appareil en dépendance : c'est la règle de publication ;
- les contraintes 2024 de l'éditeur, lues sur le JSON brut (3 caractéristiques et 2 compétences pour un Historique). Ainsi un brouillon incomplet, qui ne se lit pas encore, les montre déjà.

Les doublons sont retirés.

Un problème ne bloque que la publication (US-29).

### App (`lib/homebrew/`)

- **`homebrew_page.dart`** : « Mes packs », « Inclus », « Nouveau pack » et « Créer une entité ».
- **`pack_page.dart`** : les entités du brouillon et le panneau « Vérification ».
- **`effect_editor.dart`** : une feuille par opération, qui écrit son JSON (validé par `validateEffect` avant « Enregistrer l'effet »), et `describeEffect`, l'aperçu en français. Les schémas du DSL sont des fonctions de contrôle, pas des descriptions : les formulaires sont donc écrits à la main.
- **`entity_editor.dart`** : l'enveloppe (nom, texte, effets) et les formulaires du Don et de l'Historique. Pour l'Historique, il ne propose que les dons d'origine, du SRD comme du brouillon.

### Identifiants

Une entité homebrew reçoit l'identifiant `{namespace}:{type}:{slug}`, où le slug vient du nom (sans accents, en minuscules, avec des tirets) et reste unique dans le pack.

## Lot b1 : Sort, Objet, variantes

### Format et moteur

- **`WeaponData` et `ArmorData`** : `rarity?` et `attunement?`. Sans eux, l'arme est ordinaire, et un pack existant se lit sans changement.
- **`SpellData.classes?`** : des références de type `class`, contrôlées par `validatePack`.
- **`requiresAttunement(data)`** (`dnd_content`) : vrai pour l'objet magique, l'arme ou l'armure qui demande l'harmonisation. L'inventaire s'en sert aussi.
- **`computeSheet`** : applique les effets d'un objet magique équipé (`isMagicItem` : objet magique, ou arme et armure avec une rareté), s'il ne demande pas l'harmonisation ou s'il est harmonisé. Une arme ordinaire n'applique jamais d'effet.
- **`ActiveContent.spellList(classId)`** : la liste de la classe, puis les sorts qui la citent, dans l'ordre du contenu. La création et la montée de niveau la lisent, à la place de `ClassData.spellList`.
- **Base v7** :
  - colonnes ajoutées par `addColumn` : `weapon.rarity`, `weapon.attunement`, `armor.rarity`, `armor.attunement`, `spell.classes` (JSON) ;
  - l'export d'un pack les relit ;
  - `spell_class` reste la liste portée par la classe : un sort homebrew ne modifie donc pas la classe du SRD à l'aller-retour.

### Vérification

`checkDraft` ajoute la règle « une arme a toujours une botte d'arme ». Comme celles de l'Historique, elle se lit sur le JSON brut.

### App

- **Types de [H01]** : « Objet » regroupe `weapon`, `armor`, `magic-item` et `item` (`uiTypeOf`). Un objet neuf s'ouvre en arme ; son genre se change tant qu'il n'est ni enregistré ni une variante.
- **`entity_editor.dart`** : formulaires du Sort et des quatre genres d'objet. Les distances se saisissent en pieds, comme dans l'éditeur d'effets ; les prix se saisissent en po et sont stockés en pc.
- **Effets** :
  - proposés pour un Don et un objet magique ;
  - pour une arme ou une armure, dès qu'elle a une rareté ;
  - jamais pour un Sort, un Historique ou un objet courant.
- **Variante** :
  - « Dériver d'une entité du SRD » cherche par nom parmi les Dons, Historiques, Sorts et objets du SRD ;
  - la copie s'ouvre sans identifiant et avec `extends_id` ; elle reçoit un identifiant du pack à l'enregistrement ;
  - l'éditeur rappelle que l'original n'est pas modifié ;
  - une arme dérivée sans botte propose de reprendre celle de l'original.

## Lot b2 : Espèce, opérations imbriquées

### Espèce

- **Formulaire** : type de créature, tailles (P, M), Vitesse en pieds, et les traits. Pas de bonus de caractéristique : il vient de l'Historique.
- **Traits** : chacun est une entité `feature` du brouillon, de `source` l'espèce et de `level` 1. L'éditeur d'Espèce les garde avec lui, dans une feuille par trait (nom, texte, effets), et les enregistre avec l'espèce :
  - identifiant `{namespace}:feature:{espèce}-{trait}`, comme `srd:feature:elf-darkvision` ;
  - un trait retiré quitte le brouillon ; supprimer l'espèce retire ses traits.
- **Variante** : une espèce dérivée du SRD garde la liste de ses traits SRD, affichés par leur nom ; l'auteur peut en retirer et en ajouter.
- **Sous-lignée** : un trait à choix (`choice`), comme le Lignage elfique. La création de personnage sait déjà le proposer.
- **`checkDraft`** : « une espèce a au moins une taille ».
- Les traits ne sont pas listés à part dans la page du pack : ils vivent dans leur espèce.

### Éditeur d'effets

Toutes les opérations du DSL v1 deviennent éditables. Les douze nouvelles :
- `grant_feat` (un don précis ou une catégorie), `ac_formula`, `consumable_heal`, `modify_check`, `set_attacks_per_action`, `set_crit_range`, `grant_mastery_slots`, `modify_damage`, `grant_spell_list_access`, `modify_attunement_slots` ;
- `grant_resource` : maximum, recharges (`on`, `amount`, `up_to`), dé facultatif. Son identifiant `{namespace}:resource:{slug}` vient du nom de l'entité ;
- `grant_spell` : sort, toujours préparé, lancers gratuits (nombre et recharges), caractéristique ;
- `choice` : titre, nombre, remplaçable, et des options nommées qui ont chacune leur liste d'effets, éditée par le même éditeur. Son identifiant est `choix-N`, unique dans la liste.

Deux champs communs :
- **Valeur** : un nombre, le bonus de maîtrise, le niveau du personnage, un niveau de classe, un modificateur de caractéristique (avec minimum), ou une table par niveau. Les références acceptent un multiplicateur. Elle sert partout où le DSL accepte une expression.
- **« À partir du niveau »** : `when.level`, sur toute opération.

Non proposés, car facultatifs et rares au SRD : le plafond `up_to` d'une récupération, et les portées `cantrip:` et `spell_school:` de `modify_damage`.

## Lot c : Classe et Sous-classe

### Format et base

- **`ClassData.subclassFeatureLevels`** (`subclass_feature_levels`, liste d'entiers, vide par défaut) : les niveaux où la sous-classe accorde ses aptitudes, en commençant par `subclass_level`.
- **Extracteur** : il ajoute `subclass_level`, puis chaque niveau dont la table porte « Aptitude de sous-classe ». Le Guerrier, saisi à la main, reçoit les siens, relus dans la table du SRD. Un test vérifie que les aptitudes de chaque sous-classe du SRD tombent exactement à ces niveaux.
- **Base v8** : `player_class.subclass_feature_levels` (JSON, `[]` par défaut), ajoutée par `addColumn`, et relue par l'export.
- Le moteur ne change pas : il lit le `level` de chaque aptitude de sous-classe.

### Vérification (EF-HB-11)

`checkDraft` ajoute :
- **Classe**, sur le JSON brut :
  - « progression incomplète : une classe a ses 20 niveaux » ;
  - « les aptitudes de sous-classe commencent au niveau où on la choisit » ;
  - « les niveaux de sous-classe vont croissant, jusqu’au niveau 20 ».
- **Sous-classe**, sur les entités lues et les dépendances : la classe parente vient du contenu ou du brouillon.
  - Pour chaque aptitude hors des niveaux du parent : « la classe parente n’accorde pas d’aptitude de sous-classe au niveau N ».
  - Pour les niveaux sans aptitude : « progression incomplète : aucune aptitude aux niveaux … ».
  - Un parent sans `subclass_feature_levels` (pack antérieur) n'est pas contrôlé.

### App

- **Aptitudes possédées** : les traits d'une espèce et les aptitudes d'une classe ou d'une sous-classe suivent un seul modèle dans `entity_editor.dart`.
  - Chacune a un niveau. Elle est soit une aptitude du brouillon, modifiable dans sa feuille, soit une aptitude d'un autre pack, gardée par une variante.
  - À l'enregistrement, chaque aptitude du brouillon devient une entité `feature` de source son propriétaire et de `level` son niveau, avec l'identifiant `{namespace}:feature:{propriétaire}-{aptitude}`.
- **`class_editor.dart`** (partie d'`entity_editor.dart`) : les formulaires de la Classe et de la Sous-classe.
  - **Classe** :
    - traits de base ;
    - niveaux de sous-classe, en puces 3 à 20 ;
    - incantation :
      - « Reprendre les emplacements et sorts connus de… » copie les colonnes d'incantation d'une classe du contenu (sorts mineurs, sorts préparés, emplacements, pacte), sa part en multiclassage et son changement de sorts préparés ;
      - « Reprendre la liste de sorts de… » copie sa liste.
    - colonnes de la table, chacune éditée niveau par niveau ;
    - les 20 niveaux, avec leurs aptitudes.
  - **Le bonus de maîtrise** de chaque niveau vient de la table d'une classe du contenu, et non d'une valeur écrite dans l'app.
  - **Sous-classe** : classe parente (du contenu ou du brouillon) et ses niveaux, une section par niveau avec « Ajouter une aptitude au niveau N ».
    - Une aptitude mal placée, par exemple après un changement de parent, montre le message de [H02], « Déplacer au niveau » (le niveau suivant réservé) et « Autre niveau… ».
- Les effets se posent sur les aptitudes, pas sur la classe ni la sous-classe.
- « Dériver d'une entité du SRD » accepte une classe et une sous-classe. Leurs aptitudes du SRD sont gardées par identifiant.

Non proposés :
- l'équipement de départ à objets, réduit à l'or ;
- les outils à choisir dans une catégorie (Barde).

Une variante garde ces deux champs de l'original.

## Lots suivants

Son design se précise à son tour, dans ce change :
- **d** : Monstre.

## Choix

- **Le brouillon garde le pack entier** : ni table par type ni migration par champ. Un brouillon est un `.dndpack` qui n'est pas encore signé.
- **Le DSL ne change pas** : l'éditeur ne propose que ce que le moteur sait appliquer.
- **Arme magique** : les champs s'ajoutent à l'arme, plutôt qu'un objet magique qui la cite. La variante garde ainsi ses dégâts, ses propriétés et sa botte, comme sur [H05] (décision du 21 novembre).
