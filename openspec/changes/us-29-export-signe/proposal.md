# Proposal

## Why

Carte Trello US-29 : « En tant que créateur, j'exporte un pack signé. » Critère (cahier §13) : le fichier `.dndpack` est partagé via la feuille système, sans réseau. Exigences **EF-HB-04**, **EF-HB-05**, **EF-HB-11** ; cahier §7.2, §11.1 ; planche [H06].

Un brouillon d'US-27 se vérifie et se teste (US-28), mais il ne sort pas encore de l'appareil. Pour qu'un autre MJ puisse l'importer et ne le mettre à jour que s'il vient du même auteur (EF-HB-07, US-30), le fichier doit être signé.

Décisions du porteur de projet du 21 novembre 2026 :
- **Clé par appareil** : la paire Ed25519 de l'auteur est créée à la première publication. Elle est gardée dans une table locale, non synchronisée. Un auteur qui publie depuis deux appareils apparaît comme deux auteurs ; l'export et l'import de la clé viendront plus tard.
- **« Publier la version »** :
  - fige la version (correctif, mineure ou majeure) ;
  - signe le pack ;
  - l'importe dans le contenu de l'appareil, d'origine `local`. Il devient utilisable sur les tables du MJ (activation : US-30) et sert de base aux « Changements depuis » de la version suivante.
  - « Exporter le .dndpack signé » partage ce fichier.

## What Changes

- **Format `.dndpack`** (ajouts facultatifs, un pack existant se lit sans eux) :
  - `description` dans le manifeste (EF-HB-04) ;
  - `author_public_key` : la clé publique Ed25519 de l'auteur ;
  - `signature` : la signature Ed25519 du manifeste sans ce champ. `checksum` couvre déjà les entités, donc la signature couvre tout le pack.
- **`dnd_content`** :
  - `signPack` et `verifyPackSignature` ;
  - `nextVersion` : correctif, mineure ou majeure ;
  - `packChanges` : entités ajoutées, modifiées et retirées depuis la version publiée.
- **Base v9** :
  - table locale `author_key` (clé de l'appareil) ;
  - colonnes `description` et `author_public_key` de `content_pack`, relues par l'export ;
  - `AuthorKeyStore`.
- **App ([H06])**, page « Publier une version » ouverte depuis la page d'un pack :
  - nom et version (actuelle → suivante), description, licence, auteur et signature ;
  - type de version, avec la version qui en résulte ;
  - changements depuis la version publiée ;
  - attestation obligatoire (cahier §15, risque « contenu protégé ») ;
  - contrôles : taille sur 20 Mo, entités sur 10 000, règles validées, dépendance ;
  - « Publier la version N », grisé tant qu'un problème reste ou que l'attestation manque ;
  - « Exporter le .dndpack signé » : la feuille de partage, aussi hors ligne.

## Capabilities

### New Capabilities

### Modified Capabilities
- `content-pack` : description, signature et clé publique de l'auteur.
- `local-database` : clé de l'appareil, colonnes du pack, schéma v9.
- `homebrew` : publication d'une version et export signé.

## Impact

- `packages/dnd_content` : `manifest.dart`, `dndpack_archive.dart`, `homebrew.dart`, et la dépendance `cryptography` (Ed25519 en pur Dart, Web compris).
- `packages/dnd_data` : `content_tables.dart`, `author_key_store.dart`, `pack_store.dart`, migration v9.
- `apps/game_table` : `lib/homebrew/publish_page.dart`, la page d'un pack, ARB.
- `docs/packs/FORMAT_DNDPACK.md`.

## Hors périmètre

- Import, contrôle de la signature à l'import, mise à jour d'un pack du même auteur, activation sur une table (US-30).
- « 3 tables utilisent la 2.1.0 » de [H06] : cela dépend de l'activation sur une table (US-30).
- Export et import de la clé de l'auteur.
