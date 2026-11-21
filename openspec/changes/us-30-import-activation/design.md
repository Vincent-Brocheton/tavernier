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

### Supabase (`20261203000000_packs.sql`)

- **`table_pack.file_sha256`** : `text`, nul ou `^[0-9a-f]{64}$`.
- **Bucket `packs`** : privé, `file_size_limit` 20 Mo, `allowed_mime_types` `application/zip`.
- **Droits sur `storage.objects`** :
  - **`packs_insert`** : bucket `packs`, nom `^[0-9a-f]{64}\.dndpack$`, et l'utilisateur est MJ d'au moins une table.
  - **`packs_read`** : il existe un `table_pack` dont l'empreinte suivie de `.dndpack` donne ce nom, et l'utilisateur est membre ou MJ de sa table.
  - Pas de droit de modification ni de suppression : un fichier est immuable.
- **Un dépôt qui ne correspond pas à son nom** ne trompe personne : le client vérifie l'empreinte de ce qu'il télécharge.
- **Tests pgTAP** : `packs_test.sql`.

### Base v11 (`dnd_data`)

- **`TablePacks.fileSha256`** : sous PowerSync, la colonne entre seule dans le schéma dérivé ; sinon, `addColumn`.
- **`TableStore`** :
  - `setPack(tableId, packId, version, fileSha256)` : insère, ou met à jour la ligne de ce pack (unique par table) ;
  - `removePack(tableId, packId)` ;
  - `watchActivePacks()` : les lignes de toutes mes tables, en flux.
- **`PackLibrary.file(packId, version)`** : les octets gardés de cette version.

### App

- **`PackStorage`** (`lib/homebrew/pack_storage.dart`) : `upload(sha, bytes)` et `download(sha)`, sur `Supabase.instance.client.storage.from('packs')`. Le fournisseur est nul sans comptes configurés. Les tests le remplacent par un stockage en mémoire.
- **`activePacksProvider`** : le flux de `watchActivePacks`.
- **`contentProvider`** : le SRD embarqué, plus, pour chaque pack actif sur une de mes tables, sa version figée lue dans la bibliothèque.
  - Si deux tables figent deux versions du même pack, la plus récente est prise. La fiche figée par version (EF-PJ-14) relève du lot c.
  - Le fournisseur se recalcule quand `table_pack` ou `pack_file` change.
- **`packDownloaderProvider`** (écouté à la racine, comme les résumés de fiches) : pour chaque pack actif avec une empreinte et dont la version manque à l'appareil :
  1. télécharge le fichier ;
  2. vérifie son sha256, puis le lit et vérifie sa signature ;
  3. l'installe par `PackLibrary.install`.

  Un échec, réseau ou fichier refusé, est réessayé au prochain changement. Il ne bloque rien.
- **Configuration de la table**, carte « Packs » :
  - le SRD, verrouillé ;
  - chaque pack actif avec sa version et un menu des versions installées ;
  - « Retirer » et « Activer un pack », pour le MJ seulement.

  « Activer » envoie le fichier de la version choisie (sans stockage, en mode local, l'envoi est sauté), puis appelle `setPack`. Une erreur d'envoi laisse la table inchangée et l'affiche.
- **Publication** : la version publiée est installée par `PackLibrary.install(writeDndpack(signed))`, qui met aussi les tables de contenu à jour. Elle devient activable comme un pack importé.

### Choix

- **Un contenu pour l'appareil, pas par table**, au lot b : les 53 lecteurs de `contentProvider` en profitent sans changer. La limite (deux versions d'un même pack sur deux tables) est levée par le contenu figé par fiche du lot c.
