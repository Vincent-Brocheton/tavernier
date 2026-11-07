# Proposal

## Why

Carte Trello [US-07](https://trello.com/c/QS1ZRttv), second change. La fiche s'ouvre sur Principal et Compétences ; il manque les attaques, les ressources et les aptitudes, et le bonus d'attaque n'a pas de décomposition (EF-PJ-02, EF-PJ-03, EF-PJ-04).

## What Changes

- **Onglet Combat [F1] :** attaques avec toucher et dégâts, effet de la botte, ressources, bottes d'arme.
- **Onglet Aptitudes [F2] :** aptitudes par origine, filtres Tout, Avec utilisations et Dons, compteurs.
- **Moteur :** `Attack.sources` décompose le bonus d'attaque.
- **Kit :** `ResourcePips`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : décomposition de l'attaque, onglets Combat et Aptitudes.
- `ui-kit` : pips de ressource.

## Impact

- `packages/dnd_rules` : `compute_sheet.dart`, `computed_sheet.dart`.
- `packages/dnd_ui_kit` : `sheet_kit.dart`.
- `apps/game_table/lib/sheet/`, ARB.

**Hors périmètre :**
- **Bouton « Utiliser », utilisations restantes :** l'état de jeu arrive avec US-11 et US-31. Les pips montrent le maximum.
- **Propriétés d'arme, Attaque supplémentaire, critique élargi :** les maquettes les citent, le moteur ne les expose pas encore.
- **Modifier ses bottes après un repos long :** US-11.
