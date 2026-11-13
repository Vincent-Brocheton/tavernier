# Proposal

## Why

Carte Trello [US-34](https://trello.com/c/p0kavJYL), premier lot sur trois : une fiche qui attend la validation du MJ reste jouable, et le joueur le sait (**EF-PJ-20**, écran [J12], composant `PendingPlayableBanner` §2.51).

La carte est découpée ainsi :
- **lot a** (ce change) : la fiche en attente, jouable, avec son bandeau ;
- **lot b** : les propositions du MJ, reçues et acceptées ou refusées par le joueur ([F4b], EF-PJ-16) ;
- **lot c** : l'envoi d'une proposition par le MJ ([F4a]).

Une fiche envoyée (`submitted`) ou à corriger (`changes_requested`) se modifie déjà : `can_write_character` et `sheetEditableProvider` ne regardent pas ces statuts. Il manque ce que le joueur voit.

## What Changes

- **Bandeau [J12]** en tête de la fiche de son propriétaire, quand elle est envoyée ou à corriger :
  - « En attente de validation par Camille · utilisable en jeu » ;
  - « Les corrections demandées s'appliqueront après la séance, sans perdre vos PV ni vos emplacements utilisés. »
- **Corrections demandées** : pour une fiche à corriger, le commentaire du MJ s'affiche sous le bandeau, comme dans « Mon personnage ».
- **Fiche jouable** : un test garde qu'une fiche envoyée reste modifiable par son propriétaire.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : fiche en attente de validation, jouable.

## Impact

- `packages/dnd_data/` : `CharacterStore.access` rend aussi le commentaire du MJ.
- `apps/game_table/` :
  - bandeau de la fiche (`sheet_page.dart`) ;
  - ARB ;
  - tests.

**Hors périmètre :**
- **Éléments bannis ou de pack inactif grisés** ([J12] : « Sommeil et Lame d'ombre restent grisés ») : aucune table ne peut encore bannir une entité ni changer ses packs actifs. À faire avec ces réglages.
- **« Faire les corrections »** : il n'existe pas d'assistant pour modifier une fiche déjà créée. Le joueur corrige avec les actions de la fiche (sorts, inventaire, niveau), puis la renvoie depuis « Mon personnage ».
