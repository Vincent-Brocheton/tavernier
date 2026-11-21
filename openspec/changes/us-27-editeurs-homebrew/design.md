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

## Lots suivants

Leur design se précise à leur tour, dans ce change :
- **b2** : Espèce, opérations imbriquées ;
- **c** : Classe et Sous-classe ;
- **d** : Monstre.

## Choix

- **Le brouillon garde le pack entier** : ni table par type ni migration par champ. Un brouillon est un `.dndpack` qui n'est pas encore signé.
- **Le DSL ne change pas** : l'éditeur ne propose que ce que le moteur sait appliquer.
- **Arme magique** : les champs s'ajoutent à l'arme, plutôt qu'un objet magique qui la cite. La variante garde ainsi ses dégâts, ses propriétés et sa botte, comme sur [H05] (décision du 21 novembre).
