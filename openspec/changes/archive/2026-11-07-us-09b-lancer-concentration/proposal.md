# Proposal

## Why

Carte Trello [US-09](https://trello.com/c/3JJk0p7h), deuxième change. L'onglet Sorts montre les emplacements sans qu'on puisse les dépenser, et la concentration n'est pas suivie (EF-PJ-07, EF-PJ-09).

## What Changes

- **Lancer un sort [P14], [F5a] :** choix de l'emplacement, sort mineur sans dépense, rituel sans emplacement.
- **Concentration :** carte « Concentration en cours » avec « Mettre fin ». Un second sort à concentration demande confirmation et met fin au premier.
- **État de jeu :** emplacements dépensés et concentration écrits dans `character_state`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : lancer un sort et concentration.
- `local-database` : état de jeu d'un personnage.

## Impact

- `packages/dnd_rules` : nouveau `spell_play.dart`.
- `packages/dnd_data` : `character_store.dart`, sans changement de schéma.
- `apps/game_table/lib/sheet/` : onglet Sorts, fournisseur d'état, ARB.

**Hors périmètre :**
- **Récupérer les emplacements :** US-10, avec les repos.
- **Lancers gratuits d'un trait ou d'un don (`free_casts`) :** un sort accordé dépense un emplacement s'il en reste, sinon il attend ce suivi.
- **Durée restante et cibles de la concentration, tests de concentration :** M3, avec le combat.
- **Rituel d'un sort du grimoire non préparé :** troisième change.
