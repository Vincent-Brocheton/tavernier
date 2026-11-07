# Proposal

## Why

Carte Trello [US-09](https://trello.com/c/3JJk0p7h), premier change. L'onglet Sorts de la fiche est vide : le moteur ne calcule ni DD, ni attaque de sort, ni emplacements (EF-PJ-07, EF-PJ-08).

## What Changes

- **Moteur :** caractéristique, DD, attaque, sorts mineurs et préparés par classe, emplacements de la classe ou de la table du multiclassage, magie de pacte.
- **Sorts d'un personnage :** liste unique des sorts de classe, accordés et de dons, chacun rattaché à une classe.
- **Onglet Sorts [P14], [P17], [F5a], [F5b] :** valeurs décomposées, emplacements, filtres, sections par niveau.
- **Fiche de sort :** niveau, école, incantation, portée, composantes, durée, description.
- **Fixtures [D1] :** Mira et Brannoc passent en test actif autant que le moteur le permet.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : sorts de la fiche.
- `content-pack` : poids de lanceur d'une classe.

## Impact

- `packages/dnd_rules` : `compute_sheet.dart`, `computed_sheet.dart`, `level_up.dart`, nouveau `sheet_spells.dart`.
- `packages/dnd_data` : colonne `class_id` de `character_spell` (schéma v1, non publié).
- `packages/dnd_content`, `tools/srd_builder/sources/class/*.json` : `caster_divisor`.
- `apps/game_table/lib/sheet/` : nouvel onglet, ARB.

**Hors périmètre :**
- **Lancer un sort, emplacements dépensés, concentration :** change suivant.
- **Modifier les sorts préparés, grimoire [G3], rituels sans préparation :** troisième change.
- **Dégâts et soins calculés dans la liste (« 2d8 + 6 PV ») :** les effets de sort n'ont pas encore ces données.
