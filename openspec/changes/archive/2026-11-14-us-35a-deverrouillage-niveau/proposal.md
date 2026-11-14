# Proposal

## Why

Carte Trello [US-35](https://trello.com/c/ClnskrIq), lot a sur trois (EF-SEA-05, EF-SEA-06, EF-TAB-10). Pour une fiche de table, le bouton « Monter au niveau n » s'affiche aujourd'hui sans condition. Le cahier veut qu'il n'apparaisse qu'une fois la montée déverrouillée, et qu'il dise d'où vient ce déverrouillage :
- **seuil de PX atteint** (table en PX) ;
- **niveau accordé par le MJ** (table en jalons) ;
- **dérogation du MJ** (les deux modes).

Ce lot ne demande aucun changement de schéma : les colonnes `character.xp` et `character.level_unlock` existent déjà (cahier §11.2).

Découpage de la carte (choix du porteur de projet, 14 nov. 2026) :
- **lot a** (ce change) : le déverrouillage de la montée de niveau ;
- **lot b** : les données des séances (tables, droits, synchronisation), avec un schéma soumis avant d'être codé ;
- **lot c** : la liste des séances, leur création, « Jouer tout de suite », la préparation et les présences.

La clôture (PX et jalons) et la vue joueur après clôture attendent les rencontres d'US-19 : elles feront les lots d et e.

## What Changes

- **Moteur (`dnd_rules`)** :
  - la table « Évolution du personnage » du SRD (PX par niveau, 300 à 355 000) ;
  - une fonction pure qui, à partir du niveau, des PX, du mode de progression de la table et d'un éventuel niveau accordé, rend le déverrouillage et son origine (seuil, jalon ou dérogation), ou rien.
- **Fiche d'une table** : le bandeau « Niveau accordé » (`LevelGrantBanner`, COMPOSANTS §2.30, planche [S9]) affiche l'origine, puis « Plus tard » et « Monter au niveau n ».
  - « Plus tard » réduit le bandeau en puce dans le bloc d'identité jusqu'à la montée. Ce choix est gardé sur l'appareil.
  - Sans déverrouillage : en PX, l'en-tête montre la progression (« 7 475 / 14 000 PX ») ; en jalons, rien (cahier EF-SEA-05).
  - Une fiche hors table garde la montée libre, comme aujourd'hui.
- **Dérogation du MJ** : sur la fiche d'un joueur de sa table, le MJ peut débloquer le niveau suivant, avec un motif facultatif. Le choix est inscrit dans `level_unlock` et dans l'historique de la fiche.
- **Historique** : une montée de niveau y est inscrite (EF-SEA-06), avec le niveau atteint et l'origine du déverrouillage. Elle ne demande aucune validation du MJ.
- **Base locale** : `CharacterStore.grantLevel` (niveau accordé ou dérogation) et `recordLevelUp`. L'accès à la fiche rend aussi le mode de progression de la table, les PX et `level_unlock`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : déverrouillage de la montée de niveau.
- `local-database` : niveau accordé et montée inscrits dans l'historique.

## Impact

- `packages/dnd_rules/lib/src/level_up.dart` (ou un fichier voisin), et ses tests.
- `packages/dnd_data/lib/src/character_store.dart`, et ses tests.
- `apps/game_table/lib/sheet/` : fiche, assistant de montée, historique ; ARB.

**Hors périmètre :**
- **Accorder un niveau en séance ou à la clôture**, avec la liste des présents : lot d. Ce lot fournit déjà `grantLevel`, qu'il appellera.
- **Empêcher côté serveur un joueur d'écrire lui-même `level_unlock`** : il faut un déclencheur Postgres, proposé avec le schéma du lot b.
- **Ajout des PX** : il vient de la clôture, au lot d.
