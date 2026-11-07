# Proposal

## Why

Carte Trello [US-31](https://trello.com/c/AuAzls8S), partie jouable sans table. Une potion ne peut pas se boire et l'Inspiration héroïque n'est pas suivie (EF-PJ-18).

## What Changes

- **Consommables [J7] :** « Utiliser » sur une potion de guérison : action rappelée, soin saisi ou lancé, PV appliqués, quantité décomptée.
- **Effet `consumable_heal` :** nouvelle opération du DSL, portée par l'objet.
- **Inspiration héroïque :** suivie sur l'onglet Principal, « Recevoir » et « Utiliser ». Une seule à la fois. Un humain en obtient une à chaque Repos long.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : consommables et Inspiration.
- `effect-dsl` : `consumable_heal`.
- `local-database` : Inspiration dans l'état de jeu.

## Impact

- `packages/dnd_content/lib/src/dsl/op_schemas.dart`, `docs/dsl/DSL_V1.md`.
- `packages/dnd_rules` : `inventory.dart`, `rest.dart`, `spell_play.dart`.
- `packages/dnd_data/lib/src/character_store.dart`, sans changement de schéma.
- `tools/srd_builder/sources/item/potion-of-healing.json`, pack SRD.
- `apps/game_table/lib/sheet/` : inventaire, repos, onglet Principal.

**Hors périmètre :**
- **Effets reçus (EF-PJ-17, [J4]) :** ils sont posés par d'autres personnages en combat. Sans table ni combat, aucune source ne les produit : à reprendre en M2 ou M3.
- **« Donner à… » une Inspiration ([J8]) :** il faut un groupe, M2.
- **Historique (EF-PJ-13) :** l'entrée « Inscrit dans l'historique » attend son écran.
- **Potions supérieures :** elles partagent une seule entrée de pack, à séparer d'abord.
