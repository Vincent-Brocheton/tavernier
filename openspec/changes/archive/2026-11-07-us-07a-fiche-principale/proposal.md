# Proposal

## Why

Carte Trello [US-07](https://trello.com/c/QS1ZRttv). Un personnage enregistré ne s'ouvre pas encore : il n'existe que dans la liste. Le joueur doit voir sa fiche et comprendre chaque valeur en la touchant (EF-PJ-02, EF-PJ-03).

La carte est livrée en deux changes :
1. **Celui-ci :** la fiche, ses onglets, Principal, Compétences et la décomposition.
2. **Le suivant :** les onglets Combat et Aptitudes.

Sorts, Inventaire et Notes appartiennent à US-09, US-10 et US-26 : leurs onglets existent, vides.

## What Changes

- **Fiche [2a], [2c] :** route `/characters/:id`, en-tête, 7 onglets, ouverte depuis la page Personnages.
- **Onglet Principal :** CA, Initiative, Vitesse, Maîtrise, Perception passive, PV max, et les 6 caractéristiques.
- **Onglet Compétences [P16] :** les 18 compétences groupées par caractéristique, avec maîtrise et Expertise.
- **Décomposition [2b] :** toucher une valeur ouvre ses lignes, son total, sa règle et, pour une caractéristique, ce qui l'utilise.
- **Moteur :**
  - **Correction de règle :** l'Expertise n'était pas calculée, elle double le bonus de maîtrise (SRD, Glossaire). `modify_check` s'applique aux compétences.
  - `skillBreakdown`, `saveBreakdown` et `speed` portent leurs contributions.
- **Kit :** `AbilityTile`, `StatTile`, `ValueBreakdown` et `showAdaptiveSheet`.
- **Correction du Récapitulatif :** Dressage et Escamotage, dont l'identifiant porte un tiret, n'y apparaissaient pas.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : Expertise, décomposition complète, écran de la fiche.
- `ui-kit` : tuiles de valeur et décomposition.
- `character-creation` : compétences du Récapitulatif.

## Impact

- `packages/dnd_rules` : `compute_sheet.dart`, `computed_sheet.dart`.
- `packages/dnd_ui_kit` : `sheet_kit.dart`.
- `apps/game_table/lib/sheet/`, `main.dart`, ARB.

**Hors périmètre :**
- **Onglets Combat et Aptitudes :** change suivant.
- **État de jeu (PV actuels, Inspiration, dés de vie), historique, repos :** cartes US-11 et US-31.
- **Avantage sur une compétence, statut MJ et synchronisation :** à reprendre avec leurs cartes.
- **Infobulle ancrée sur grand écran :** [2c] la demande ; le grand écran ouvre une boîte de dialogue, plus simple et accessible au clavier.
