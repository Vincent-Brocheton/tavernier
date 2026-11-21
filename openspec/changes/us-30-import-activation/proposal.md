# Proposal

## Why

Carte Trello US-30 : « En tant que MJ, j'importe un pack et l'active sur ma table. » Critère (cahier §13) :
- contrôles et aperçu ;
- mise à jour seulement si l'auteur est le même ;
- diffusion aux membres.

Exigences **EF-HB-06**, **EF-HB-07**, **EF-HB-08**, **EF-HB-09** ; cahier §7.2, §10, §11.1 ; planches [H08] et [H09].

US-29 produit un `.dndpack` signé. Un autre MJ doit pouvoir le relire, voir ce qu'il apporte, le mettre à jour sans se faire remplacer son pack par celui d'un autre auteur, puis l'activer sur une table. Le jalon M4 sort quand une sous-classe homebrew créée par un MJ, importée par un autre, est utilisée par un PJ (cahier §3).

Décisions du porteur de projet du 21 novembre 2026 :
- **Deux lots** :
  - **a** : l'import local ([H08], [H09]) et la duplication (EF-HB-06 à 08) ;
  - **b** : l'activation sur une table, avec sa version figée, et la diffusion aux membres (EF-HB-09).
- **Fichiers par version** : chaque version importée est gardée telle quelle dans une table locale `pack_file` (schéma v10).
  - Les tables de contenu portent la dernière version : bibliothèque et recherche.
  - Le contenu d'une table se construit en mémoire à partir du fichier de sa version figée. Une table reste donc sur la 2.0.0 quand la 2.2.0 arrive.
- **Diffusion par Supabase Storage** (lot b, cahier §10) :
  - un bucket privé `packs` ;
  - chaque fichier est nommé par son empreinte sha256, donc immuable et jamais écrasé ;
  - le MJ l'envoie en activant le pack, et `table_pack` reçoit l'empreinte ;
  - seuls les membres d'une table qui la cite peuvent le lire ; ils le gardent ensuite hors ligne.

## What Changes

### Lot a : import et duplication

- **`dnd_content`** : `inspectImport`, l'aperçu d'un import.
  - Contrôles : taille, signature, format, dépendances.
  - Nature de l'import :
    - nouveau pack ;
    - mise à jour, quand l'identifiant et la clé de l'auteur sont les mêmes ;
    - pack distinct, quand l'identifiant est le même mais l'auteur différent ;
    - version déjà installée.
  - Contenu : nouveau, modifié, inchangé.
  - Conflits de noms avec les autres packs installés.
- **`dnd_content`** : `rebrandPack`, qui change l'identifiant, l'espace de noms et le nom d'un pack, références comprises. Il sert à un pack distinct et à la duplication.
- **Base v10** : table locale `pack_file`.
  - Colonnes : identifiant local, identifiant source, version, espace de noms et nom dans la bibliothèque, clé de l'auteur, empreinte, fichier, renommages.
  - `PackLibrary` :
    - installe une version : le fichier, puis les tables de contenu si c'est la plus récente ;
    - liste les packs importés ;
    - lit une version donnée.
- **App** :
  - « Importer un pack » dans l'onglet Homebrew (sélecteur de fichier `.dndpack`).
  - Page d'aperçu [H08] / [H09] : nom, auteur, licence, dépendances, version installée, contenu, conflits (« Garder les deux », « Renommer le nouveau… », seulement dans la bibliothèque), vérifications.
  - Bouton « Importer », « Importer la mise à jour » ou « Importer comme pack distinct », avec le nom donné dans la bibliothèque.
  - « Packs importés » dans l'onglet Homebrew, avec « Dupliquer pour modifier » (EF-HB-08). La duplication devient un brouillon à mon nom, dans mon espace de noms.

### Lot b : activation et diffusion

Ce lot se précise à son tour, dans ce change. Il couvre :
- l'activation d'un pack importé ou publié sur une table, avec sa version figée ;
- l'envoi du fichier au bucket `packs` ;
- l'empreinte dans `table_pack`, avec la migration Supabase et ses droits ;
- le téléchargement par les membres ;
- le contenu de la table, construit avec ses packs ;
- le passage d'une table à une autre version depuis sa configuration.

## Capabilities

### New Capabilities

### Modified Capabilities
- `content-pack` : aperçu d'un import, changement d'identité d'un pack.
- `local-database` : `pack_file` et `PackLibrary` (schéma v10).
- `homebrew` : import, conflits, duplication ; puis activation (lot b).

## Impact

- **Lot a** :
  - `packages/dnd_content` : `pack/import.dart` ;
  - `packages/dnd_data` : `pack_library.dart`, migration v10 ;
  - `apps/game_table` : `lib/homebrew/import_page.dart`, onglet Homebrew, ARB.
- **Lot b** : `backend/supabase` (bucket, colonne de `table_pack`, droits), synchronisation, configuration d'une table.

## Hors périmètre

- Export et import de la clé d'un auteur.
- Bibliothèque publique de packs (V2).
