# Proposal

## Why

Carte Trello [US-33](https://trello.com/c/sO8h2X6b). Chaque écran qui attend un jet a son propre bricolage : un champ, un bouton « Lancer », sans détail ni Avantage (EF-DES-01 à 05).

## What Changes

- **Moteur :** `DiceFormula` (dés, bonus, Avantage ou Désavantage) et `rollDice`, avec un hasard injecté.
- **`SimpleRoll` [J6] :** « Saisir mon jet » et « Lancer » côte à côte, détail du jet (« d20 8 + 3 = 11 »), dé écarté barré, résultat modifiable avant validation.
- **Écrans du MVP déjà présents :** dés de vie du repos court et soins d'un consommable.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : jet simple.

## Impact

- `packages/dnd_rules` : nouveau `dice.dart`.
- `apps/game_table/lib/sheet/` : nouveau `simple_roll.dart`, repos, inventaire, ARB.

**Hors périmètre :**
- **Initiative, jets contre la mort, jets de sauvegarde demandés, jets des monstres :** leurs écrans arrivent avec le combat (M3). `SimpleRoll` est prêt pour eux.
- **PV à la montée de niveau en mode jet :** ce réglage de table arrive en M2.
- **Effets reçus dans la formule (+1d4 Béni) :** ils attendent US-31.
- **Lanceur libre, historique, jets partagés :** V2 (EF-DES-05).
