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

## Lots suivants

Leur design se précise à leur tour, dans ce change :
- **b** : Espèce, Sort, Objet, variantes ;
- **c** : Classe et Sous-classe ;
- **d** : Monstre.

## Choix

- **Le brouillon garde le pack entier** : ni table par type ni migration par champ. Un brouillon est un `.dndpack` qui n'est pas encore signé.
- **Le DSL ne change pas** : l'éditeur ne propose que ce que le moteur sait appliquer.
