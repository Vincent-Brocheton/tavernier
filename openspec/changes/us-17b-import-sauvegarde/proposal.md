# Proposal

## Why

Carte Trello [US-17](https://trello.com/c/VDVUxvnl), deuxième lot. Il couvre l'import de l'export fait au lot a. ENF-12 demande « export et import manuels de l'ensemble des données locales ». Sans import, l'export n'est pas une sauvegarde : on ne peut rien en refaire si l'appareil est perdu ou si le navigateur efface ses données.

## What Changes

- **Import d'un fichier `tavernier-export`** dans la base de l'appareil.
  - **Ce qui entre :** les lignes qui n'y sont pas encore, table par table.
  - **Ce qui ne change pas :** une ligne déjà présente (même identifiant) est gardée telle quelle. L'import restaure ce qui manque sans écraser un travail plus récent.
- **Fichier contrôlé avant toute écriture :**
  - format `tavernier-export` ;
  - version au plus égale à celle de l'app ;
  - tables et colonnes connues ;
  - valeurs simples.

  Un fichier refusé n'écrit rien. Les tables et les colonnes inconnues sont ignorées.
- **« Importer une sauvegarde »** dans « Mes données » du profil.
  - **Avant :** le choix du fichier, puis une confirmation qui dit ce que fait l'import.
  - **Après :** le nombre d'éléments ajoutés et le nombre de ceux déjà présents.
  - **Fichier refusé :** un message dit pourquoi.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `local-database` : import des données de l'utilisateur.
- `account` : « Importer une sauvegarde » dans « Mes données ».

## Impact

- `packages/dnd_data/` : `importUserData` dans `user_data.dart` ; tests.
- `apps/game_table/` :
  - choix du fichier, avec la dépendance `file_selector` (paquet officiel Flutter, Web compris) ;
  - `DataBackup.import` ;
  - section « Mes données » ;
  - ARB ;
  - tests.

**Hors périmètre :**
- **Remplacement des données de l'appareil** par celles du fichier : écraser un travail plus récent est un risque sans demande identifiée.
- **Réinstallation des packs** cités dans l'export : ils se réimportent à part (`.dndpack`, M4).
- **Suppression du compte** [T15] : lot us-17c.
