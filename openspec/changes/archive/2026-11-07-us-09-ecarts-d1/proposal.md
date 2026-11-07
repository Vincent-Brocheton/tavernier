# Proposal

## Why

Carte Trello [US-09](https://trello.com/c/3JJk0p7h), travail intercalé avant le lancement des sorts. Activer les fixtures [D1] de Mira et Brannoc a montré des fiches fausses, sans rapport avec les sorts : le cahier (§12.1) tient tout écart à [D1] pour un défaut.

## What Changes

- **`modify_hp_max` :** l'opération est calculée. Brannoc gagne ses 5 PV de Ténacité naine.
- **Résistance draconique :** le bonus compte 1 par niveau d'Ensorceleur, soit 3 au niveau 3. La source en comptait 6.
- **Vision dans le noir et Expertise :** exposées par `ComputedSheet`.
- **Fixtures :** Mira et Brannoc deviennent actives. Le don Doué de Mira suit le format réel de ses choix.
- **`pending_keys` :** une fixture active peut nommer les valeurs que le moteur ne sait pas encore rendre.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : PV, sens et Expertise.

## Impact

- `packages/dnd_rules` : `compute_sheet.dart`, `computed_sheet.dart`, fixtures et leur test.
- `tools/srd_builder/sources/feature/draconic-draconic-resilience.json`, `docs/dsl/DSL_V1.md`, pack SRD.

**Hors périmètre :**
- **Soins calculés (« 2d8 + 6 ») et CA sous Armure du mage :** les sorts n'ont pas ces données, ces clés restent en attente.
- **Affichage de la vision dans le noir :** le texte du trait la donne déjà dans l'onglet Aptitudes.
- **Thalia et Kael :** leurs fixtures restent à reprendre.
