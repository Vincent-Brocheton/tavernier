# Design

## Lot a : import et duplication

### `dnd_content` (`pack/import.dart`)

- **`InstalledVersion`** : `({String packId, String sourceId, String? authorKey, String version, ContentPack pack})`. C'est une version gardée par l'appareil, avec :
  - son identifiant local (celui de la bibliothèque) ;
  - son identifiant source (celui du fichier) ;
  - la clé de son auteur.
- **`inspectImport(incoming, signatureValid:, installed:, available:)`** rend un `ImportPreview` :
  - **`kind`** :
    - aucune version de même identifiant source : `newPack` ;
    - une version de la même clé et de même version : `alreadyInstalled` ;
    - une version de la même clé, mais pas celle-ci : `update` (`target` est l'identifiant local de ce pack) ;
    - seulement d'autres clés : `distinct`.
  - **`previous`** : la plus récente version de la même clé (ordre semver), et `changes`, le `packChanges` depuis elle.
  - **`missingDependencies`** : dépendances dont l'identifiant n'est dans aucun pack disponible (SRD de l'appareil et packs installés). La plage de versions n'est pas encore contrôlée : les packs du MVP dépendent du SRD 5.2.1 seul.
  - **`issues`** : `validatePack` avec les entités disponibles.
  - **`conflicts`** : entités nouvelles dont le nom, sans accents ni casse, est celui d'une entité d'un autre pack disponible.
  - **`blocked`** : `alreadyInstalled`, signature invalide, dépendance manquante ou problème de validation.
- **La signature** se vérifie avant, avec `verifyPackSignature` (asynchrone). Un pack sans signature est refusé comme un pack mal signé.
- **`rebrandPack(pack, id:, namespace:, name:, author:, version:, origin:)`** :
  - réécrit en profondeur chaque chaîne `{ancien}:…` du JSON des entités en `{nouveau}:…`, puis les relit ;
  - le manifeste prend le nouvel identifiant, l'espace de noms et le nom, et perd sa signature, sa clé, `entity_count` et `checksum` ;
  - `author`, `version` et `origin` sont facultatifs (duplication : moi, 0.1.0, `local`).

### Base v10 (`dnd_data`)

- **`pack_file`** (`PackFiles`, locale même sous PowerSync, hors export utilisateur) :
  - `id`, `pack_id` (local), `source_id`, `version`, `namespace`, `name`, `author_public_key?`, `checksum`, `bytes` (blob), `renames` (JSON id → nom), `imported_at` ;
  - unique (`pack_id`, `version`).
- **`PackLibrary`** :
  - **`installed()`** : chaque version, relue depuis son fichier. Elle est renommée selon `pack_id`, `namespace` et `name` si c'est un pack distinct, puis reçoit ses renommages.
  - **`install(bytes, {packId, namespace, name, renames})`** : écrit la version. Si c'est la plus récente de `pack_id`, elle remplace le pack dans les tables de contenu (`PackStore.importPack`, origine `imported`).
  - **`version(packId, version)`** : une version donnée, pour le lot b.
- **Comparaison semver** : numérique, nombre par nombre.

### App

- **`lib/homebrew/import_page.dart`** :
  - `openPackFileProvider` : sélecteur `.dndpack`, qui rend le nom et les octets du fichier.
  - `ImportPage(fileName, bytes)` lit le fichier (`DndpackException` devient « Fichier refusé : … »), vérifie la signature, lit la bibliothèque, puis appelle `inspectImport`.
  - **Pack distinct** ([H09]) :
    - nom proposé : « {nom} ({auteur}) » ;
    - espace de noms : `{espace}-{auteur}`, unique parmi les packs installés ;
    - nouvel identifiant UUID v7.
  - **Conflits** : « Garder les deux » par défaut, ou « Renommer le nouveau… » avec un champ. Les renommages vont dans `pack_file.renames`.
  - **Bouton** : « Importer », « Importer la mise à jour » ou « Importer comme pack distinct ». Il est absent si l'import est bloqué.
- **Onglet Homebrew** :
  - « Importer un pack » ;
  - section « Packs importés » : la dernière version de chaque pack, son auteur et ses versions gardées, avec « Dupliquer pour modifier ».
- **Duplication** : `rebrandPack` vers un brouillon `HomebrewStore`.
  - Nom : « {nom} (copie) » ; espace de noms tiré de ce nom ; auteur : le pseudonyme ; version 0.1.0 ; origine `local`.
  - Dépendances gardées.

## Lot b : activation et diffusion

Son design se précise à son tour, dans ce change.
