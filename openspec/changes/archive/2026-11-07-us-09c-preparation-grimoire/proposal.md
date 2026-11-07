# Proposal

## Why

Carte Trello [US-09](https://trello.com/c/3JJk0p7h), dernier change. Une fois créé, un personnage ne peut plus changer ses sorts ni enrichir son grimoire, et un sort de lignage ou de don ne se lance pas sans emplacement (EF-PJ-07).

## What Changes

- **Modifier ses sorts :** sorts préparés et sorts mineurs d'une classe, dans les limites du SRD.
- **Grimoire [G3] :** nombre de sorts, recopie d'un sort à 2 heures et 50 po par niveau, or décompté.
- **Savoir rituel :** un Magicien lance en rituel un sort de son grimoire sans le préparer.
- **Lancers gratuits :** un sort accordé avec `free_casts`, et le sort du 1er niveau d'Initié à la magie, se lancent sans emplacement.
- **Données :** `prepared_change` dit comment chaque classe change ses sorts.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : préparation, grimoire, rituels, lancers gratuits.
- `content-pack` : `prepared_change`.

## Impact

- `packages/dnd_content`, `tools/srd_builder/sources/class/*.json`, `docs/packs/FORMAT_DNDPACK.md`.
- `packages/dnd_data` : colonne `prepared_change` (schéma v1, non publié).
- `packages/dnd_rules` : `compute_sheet.dart`, `spell_play.dart`, nouveau `spell_changes.dart`.
- `apps/game_table/lib/sheet/` : onglet Sorts, ARB.

**Hors périmètre :**
- **Moment du changement :** les repos arrivent avec US-11. L'écran rappelle la règle (repos long ou gain de niveau) sans la vérifier.
- **Récupérer les lancers gratuits :** US-11, avec les emplacements.
- **Copier tout le grimoire dans un autre :** aucun écran ne gère de second grimoire.
