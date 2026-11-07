# Proposal

## Why

Carte Trello [US-10](https://trello.com/c/Z3Io9oCL). L'onglet Inventaire est vide : la fiche sait calculer la CA et les attaques selon l'équipement, mais rien ne permet de le changer (EF-PJ-10).

## What Changes

- **Onglet Inventaire [P15] :** monnaie, harmonisation, objets équipés et sac.
- **Objets :** ajouter, retirer, changer la quantité, équiper.
- **Armure et bouclier :** en équiper un retire le précédent, le moteur n'en lit qu'un.
- **Harmonisation :** 3 objets au maximum, avec une règle d'intégrité.
- **Objets magiques :** leurs effets s'appliquent une fois équipés, et harmonisés s'ils le demandent. La Cape de protection de [P15] reçoit les siens.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : inventaire, monnaie et harmonisation.

## Impact

- `packages/dnd_rules` : `compute_sheet.dart`, `computed_sheet.dart`, nouveau `inventory.dart`.
- `tools/srd_builder/sources/magic-item/cloak-of-protection.json`, pack SRD.
- `apps/game_table/lib/sheet/` : nouvel onglet, ARB.

**Hors périmètre :**
- **« Utiliser » un consommable [J7] :** il agit sur les PV courants, avec le suivi de jeu d'US-11.
- **Poids :** pas au MVP (EF-PJ-10).
- **Effets des 257 autres objets magiques :** aucun n'en a encore, à saisir au fil des besoins.
- **Temps d'harmonisation :** le Repos court exigé n'est pas vérifié, les repos arrivent avec US-11.
