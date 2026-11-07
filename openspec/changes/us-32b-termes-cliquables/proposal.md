# Proposal

## Why

Carte Trello [US-32](https://trello.com/c/opHlqNgq), dernier change. Un débutant qui lit « Désavantage » ou « Agrippé » doit quitter sa fiche pour comprendre (EF-PJ-21).

## What Changes

- **Entités `rule` :** six termes du glossaire du SRD, en français officiel : action Bonus, Avantage, Désavantage, Concentration, Réaction, Terrain difficile.
- **`RuleText` :** repère ces termes et les états dans un texte, soulignés en pointillé, avec le rôle lien.
- **Feuille de terme [J13] :** définition, sans quitter la fiche.
- **Écrans :** onglet Aptitudes et fiche de sort.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `content-pack` : type `rule`.
- `character-sheet` : termes cliquables.

## Impact

- `packages/dnd_content`, `packages/dnd_data` : type `rule`, table `rule_term` (schéma v1, non publié).
- `tools/srd_builder/sources/rule/`, `docs/packs/FORMAT_DNDPACK.md`, pack SRD.
- `apps/game_table/lib/sheet/` : nouveau `rule_text.dart`, ARB.

**Hors périmètre :**
- **« Ouvrir dans le compendium » :** le compendium n'existe pas encore.
- **Glossaire complet :** six termes demandés par le cahier et [J13], les états en plus.
- **Effets reçus :** ils attendent US-31.
