# Proposal

## Why

Correctif relevé à la relecture d'[US-10](https://trello.com/c/Z3Io9oCL). Les jets de sauvegarde ne lisent que la classe de départ : les maîtrises accordées par une aptitude sont perdues (EF-PJ-02).

## What Changes

- **`grant_proficiency` de sorte `saving_throw` :** appliqué, avec `all` pour les six caractéristiques.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : maîtrises de jets de sauvegarde.

## Impact

- `packages/dnd_rules/lib/src/compute_sheet.dart`.

**Hors périmètre :**
- **Avantage aux jets de sauvegarde (`grant_advantage`) :** il dépend du type de jet et s'affichera avec le combat.
