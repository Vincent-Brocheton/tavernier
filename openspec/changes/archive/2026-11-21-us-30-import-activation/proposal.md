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

Décision du porteur de projet du 21 novembre 2026 : **l'activation d'abord**. Le lot b livre le critère de sortie de M4. Le bannissement d'une entité du SRD (EF-HB-10), le compendium (EF-CMP-01), le contenu figé par fiche et sa migration (EF-PJ-14) suivent au lot c.

- **Supabase** :
  - `table_pack.file_sha256` ;
  - bucket privé `packs` (20 Mo, `application/zip`), dont chaque objet s'appelle `{sha256}.dndpack` ;
  - droits :
    - un MJ dépose un fichier ;
    - seuls les membres et le MJ d'une table dont un `table_pack` cite ce fichier le lisent ;
    - personne ne le modifie ni ne le supprime.
- **Base v11** : la colonne `file_sha256` de `table_pack` (PowerSync la reçoit seule).
- **`TableStore`** : activer, changer de version, retirer un pack ; suivre les packs actifs de mes tables.
- **`PackLibrary`** : le fichier d'une version, pour l'envoyer.
- **Publication (US-29)** : la version publiée entre aussi dans la bibliothèque, pour s'activer comme un pack importé.
- **App** :
  - onglet Configuration d'une table, carte « Packs » : le SRD, verrouillé, et chaque pack actif avec sa version.
  - Le MJ active un pack de sa bibliothèque, change sa version figée ou le retire. Activer envoie le fichier, puis écrit `table_pack`.
  - Chez chaque membre, un pack actif absent de l'appareil est téléchargé, vérifié par son empreinte et sa signature, puis installé, sans action de sa part.
  - **Contenu actif** de l'appareil : le SRD, plus les packs actifs sur mes tables, à leur version figée. Fiches, création, montée de niveau et rencontres en profitent.

### Lot c : bannissement, compendium, contenu figé par fiche

Livré en deux PR :
- **c1** : bannissement d'une entité par table (EF-HB-10, [H9]) et compendium (EF-CMP-01, [K1], [K2], [K5]) ;
- **c2** : contenu figé par fiche, alerte « contenu modifié » et passage de version d'une table (EF-PJ-14, [H9], [H10]).

c1 :
- **Bannir une entité** : le MJ bannit une entité du SRD pour sa table, depuis la carte « Packs » de sa configuration, et peut la rétablir. La table `table_banned_entity` existe déjà, synchronisée, avec ses droits.
- **Le contenu sait ce qui est banni** : une entité bannie n'apparaît plus dans les listes de choix (création, montée de niveau, sorts) d'un personnage de la table. Elle reste lisible par son identifiant : une fiche qui l'a déjà se calcule comme avant.
- **Compendium** : l'onglet Compendium cherche hors ligne parmi les packs actifs d'une table (par défaut), ou parmi tous mes packs.
  - Filtres par type, badge de source, « BANNI ».
  - Résultats d'un pack inactif signalés.
  - Aucun résultat : « Vouliez-vous dire », l'entité bannie, « Chercher dans tous mes packs ».
  - Fiche de l'entité, avec le bloc de stats d'un monstre.

c2 :
- **Contenu figé par fiche** (EF-PJ-14) : une fiche garde, dans `character_content_ref` (cahier §11, déjà synchronisée), la version et l'instantané de chaque entité homebrew qu'elle utilise, avec ses aptitudes.
  - Quand la table passe à une autre version, la fiche se calcule toujours avec son instantané.
  - Si l'entité a changé, le joueur voit l'alerte « contenu modifié » ([H10]), avec l'ancienne et la nouvelle version, et choisit de migrer ou de garder. Le choix est inscrit dans l'historique de la fiche.
  - Seul le propriétaire de la fiche décide : le MJ ne peut pas imposer la migration.
- **Passage de version d'une table** ([H9]) : sur la carte « Packs », une version plus récente installée est annoncée (« Version 0.2.0 importée : 1 ajout, 1 modification »), avec « Passer en 0.2.0 » et le nombre de fiches touchées.

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
