# Proposal

## Why

Carte Trello [US-18](https://trello.com/c/0XIAKPIF), lot d, le dernier. Le MJ crée un PNJ en **fiche complète** avec le même assistant que les PJ, sans contrainte de méthode de caractéristiques (**EF-PNJ-01**, planche [G5]). C'est le cas d'un allié récurrent ou d'un PNJ qui progresse. Le lot a a posé la fiche liée (`character_id`, `kind = 'npc_full'`) ; ce lot ajoute la création et l'affichage.

## What Changes

- **Nouveau PNJ** ([G5]) : deux formes au choix, « Bloc de stats » ou « Fiche complète ».
  - La fiche complète liste ses atouts : « Classe, espèce, historique, niveau libre », « Aucune contrainte de méthode de caractéristiques », « Montée de niveau et repos comme un PJ ».
  - Elle demande le nom, le dossier et l'attitude initiale. « Créer le PNJ » ouvre l'assistant de création.
- **Assistant pour un PNJ** :
  - nom prérempli ;
  - méthode de caractéristiques libre, comme pour un personnage hors table ;
  - l'enregistrement crée la fiche `npc_full` rattachée à la table, puis le PNJ lié, avec son dossier et son attitude.
- **Fiche d'un PNJ en fiche complète** ([C2]) :
  - « Fiche complète » sous le nom, et « Ouvrir la fiche », qui ouvre la fiche de personnage ;
  - attitude et informations cachées, comme pour un bloc de stats ;
  - « Dupliquer » est masqué, car une copie sans fiche serait un PNJ vide.
- **La fiche d'un PNJ n'est pas une fiche de joueur** :
  - montée de niveau libre, sans seuil ni accord (pas de progression de table) ;
  - pas de résumé publié au groupe ;
  - absente de « Mes personnages ».
- **Liste des PNJ** : « Fiche complète · niveau 3 » à la place du monstre.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : nouveau PNJ en fiche complète, fiche du PNJ.
- `local-database` : fiches de PNJ hors progression, hors résumés et hors liste des personnages.

## Impact

- `packages/dnd_data/` :
  - `character_store.dart` : `access` sans progression pour un PNJ, `list` sans les PNJ ;
  - tests.
- `apps/game_table/` :
  - `npcs/new_npc_page.dart`, `npc_page.dart`, `npcs_tab.dart` ;
  - `creation/creation_providers.dart` et `creation_page.dart` (cible PNJ) ;
  - `tables/summary_publisher.dart` ;
  - route ;
  - ARB ;
  - tests.

**Hors périmètre :**
- **Renommer la fiche depuis le PNJ** : « Modifier » change le nom du PNJ, pas celui de la fiche, qui se change depuis la fiche.
- **Statut de validation** : la fiche reste en création, ce qui n'a pas d'effet pour le MJ propriétaire.
