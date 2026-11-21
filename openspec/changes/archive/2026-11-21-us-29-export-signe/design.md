# Design

## Format et signature (`dnd_content`)

- **`PackManifest`** reçoit `description`, `authorPublicKey` (`author_public_key`) et `signature`, tous facultatifs.
  - Contrôles de forme : base64 de 32 octets pour la clé, de 64 octets pour la signature.
  - `copyWith(version, licence, description, origin, authorPublicKey, signature, clearSignature)`.
- **`signedMessage(manifest)`** : le JSON du manifeste sans `signature`, encodé comme `manifest.json` (indenté de 2 espaces, UTF-8).
- **`signPack(pack, keys)`** :
  1. calcule `entity_count` et `checksum` comme `writeDndpack` ;
  2. pose `author_public_key` ;
  3. signe `signedMessage` en Ed25519.

  `writeDndpack` garde la signature : les mêmes entités redonnent le même `checksum`.
- **`verifyPackSignature(manifest)`** : vrai si la signature vaut pour la clé citée. Une signature absente, mal formée, faite par une autre clé, ou un manifeste modifié depuis : faux. Les entités sont couvertes par `checksum`, déjà vérifié par `readDndpack`.
- **`authorKeyPair(seed)`** et **`newAuthorSeed()`** : la paire se tire d'une graine de 32 octets.
- **Bibliothèque `cryptography`** : Ed25519 en pur Dart, donc sur le Web aussi, sans greffon natif.
- **`nextVersion(version, VersionBump)`** et **`packChanges(previous, next)`** dans `homebrew.dart` :
  - une entité est modifiée si son JSON diffère ;
  - l'ordre suit la nouvelle version, puis l'ancienne pour les retraits.

## Base v9 (`dnd_data`)

- **`author_key`** (`AuthorKeys`) : `id`, `seed` et `public_key`, en base64.
  - La table est locale, même sous PowerSync : `createTable` dans la migration, hors de `syncedTables`.
  - Elle n'entre pas dans l'export des données de l'utilisateur, comme `author_identity`.
- **`AuthorKeyStore.seed()`** : la graine de l'appareil, créée dans une transaction à la première demande.
- **`content_pack`** : colonnes `description` et `author_public_key`, ajoutées par `addColumn`. `signature` existait déjà.
  - `PackStore` les écrit à l'import et les relit à l'export.
  - L'aller-retour d'un pack signé garde une signature valide.
- **`author_identity`** (cahier §11.1, publique) n'est pas touchée : elle recevra les clés des auteurs connus à l'import (US-30).

## App (`lib/homebrew/publish_page.dart`, [H06])

- « Publier une version », depuis la page d'un pack.
- **Version publiée** : `PackStore.exportPack(manifest.id)` (`publishedPackProvider`).
  - Sans version publiée, la première publication garde la version du brouillon, et le type de version n'est pas proposé.
  - Sinon, `nextVersion` selon le type choisi (mineure par défaut).
- **Changements depuis** : `packChanges` entre la version publiée et les entités du brouillon qui se lisent.
- **Contrôles** :
  - taille : l'archive écrite, sur `maxPackBytes` ;
  - entités : sur `maxPackEntities` ;
  - règles validées : entités sans problème de `checkDraft`, sur le total ;
  - dépendance : nom des packs cités.
- **« Publier la version N »** : actif si `checkDraft` est vide, l'attestation cochée, la licence remplie et la version différente de la version publiée. Publier :
  1. lit la graine de l'appareil et signe le pack ;
  2. l'importe par `PackStore` (origine `local`) ;
  3. enregistre dans le brouillon la version, la licence et la description ;
  4. décoche l'attestation, qui se redonne à chaque version.
- **« Exporter le .dndpack signé »** : `writeDndpack` de la version publiée, passé à `saveFileProvider` (la feuille de partage, ou un téléchargement sur le Web). Nom du fichier : `{namespace}-{version}.dndpack`.

## Choix

- **Pas d'activation ici** : le contenu actif de l'app reste le SRD embarqué. La version publiée vit dans la base de l'appareil, et son activation sur une table relève d'US-30.
- **Attestation non stockée** : elle se coche à chaque publication (cahier §15).
