# Proposal

## Why

Carte Trello [US-09](https://trello.com/c/3JJk0p7h), travail intercalé avant le lancement des sorts. Les fixtures [D1] d'Aldric niveau 5, de Thalia et de Kael n'étaient toujours pas testées (cahier §12.1).

## What Changes

- **Attaques par action :** la fiche expose Attaque supplémentaire. Deux classes qui l'accordent ne se cumulent pas (SRD p. 27).
- **Avantage aux compétences :** Athlète accompli du Champion.
- **Attaque sournoise :** dés lus dans la table du Roublard.
- **Objets harmonisés :** nombre exposé.
- **Fixtures :** les trois deviennent actives, au format actuel de `CharacterInput`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : attaques par action, avantages, Attaque sournoise.

## Impact

- `packages/dnd_rules` : `compute_sheet.dart`, `computed_sheet.dart`, fixtures et leurs tests.

**Hors périmètre :**
- **PX du prochain niveau et état de jeu d'Aldric :** ces clés restent en attente, le personnage ne porte encore ni PX ni état dans `CharacterInput`.
- **Affichage de ces valeurs :** elles viendront avec l'écran qui les emploie.
