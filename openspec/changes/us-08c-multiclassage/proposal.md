# Proposal

## Why

Carte Trello [US-08](https://trello.com/c/LOQ88tIY), dernier change. L'assistant de montée de niveau ne propose que la classe de départ : un personnage ne peut pas se multiclasser (EF-PJ-01), et le moteur donne à une seconde classe toutes ses maîtrises de départ.

## What Changes

- **Choix de classe [G2] :** première étape de l'assistant, classes actuelles puis autres classes, avec le prérequis de 13 et la valeur du personnage.
- **Niveau 1 d'une nouvelle classe :** aptitudes, sorts, bottes, plus la compétence et l'instrument que le SRD accorde.
- **Traits de multiclassage :** nouveau bloc `multiclass` de `ClassData`, saisi classe par classe depuis le SRD.
- **Moteur :** armes de la seconde classe limitées, compétences de toutes les classes, dés de vie par type, grimoire de 6 sorts au premier niveau de Magicien.
- **Classe d'armure :** `ac_formula` est enfin calculé, et une seule formule s'applique (SRD, Multiclassage, « Classe d'armure »).

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : multiclassage à la montée de niveau.
- `content-pack` : bloc `multiclass` des classes.

## Impact

- `packages/dnd_content` : `ClassData`, code généré.
- `packages/dnd_data` : colonne `multiclass` (schéma v1, non publié).
- `packages/dnd_rules` : `compute_sheet.dart`, `computed_sheet.dart`, `level_up.dart`.
- `apps/game_table/lib/sheet/` : brouillon, assistant, ARB.
- `tools/srd_builder/sources/class/*.json`, `docs/packs/FORMAT_DNDPACK.md`, pack SRD.

**Hors périmètre :**
- **Emplacements d'un incantateur multiclassé, sorts par classe et leur DD :** US-09 ([F5b]).
- **Dépense des dés de vie par type :** US-10, avec les repos.
- **« Voir les 6 autres classes » de [G2] :** toutes les classes sont listées d'emblée.
