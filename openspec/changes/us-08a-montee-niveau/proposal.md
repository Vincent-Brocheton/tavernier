# Proposal

## Why

Carte Trello [US-08](https://trello.com/c/LOQ88tIY). Un personnage créé reste au niveau 1 : le joueur ne peut pas le faire progresser (EF-PJ-01, EF-PJ-06, maquettes [P10], [P11]).

La carte est livrée en deux changes :
1. **Celui-ci :** monter dans sa classe, du niveau 2 au niveau 20.
2. **Le suivant :** multiclassage, nouveaux sorts et Initié à la magie.

## What Changes

- **Assistant de montée de niveau :** PV, aptitudes, don, récapitulatif, avec le panneau « Ce qui change ».
- **Aptitudes :** celles du nouveau niveau, la sous-classe au niveau prévu, les choix ouverts (Expertise) et les bottes gagnées.
- **Don :** Amélioration de caractéristique ou autre don éligible, style de combat ou faveur épique selon ce que le niveau accorde. Les dons impossibles restent visibles avec leur raison.
- **Moteur :**
  - **Correction de règle :** `ability_bonus` n'était pas appliqué, une Amélioration de caractéristique n'avait aucun effet.
  - **Correction de règle :** une aptitude qui accorde un don général accepte tout don éligible (SRD, Amélioration de caractéristique). Le moteur refusait un don d'origines.
  - **Correction de règle :** le contrôle du bonus d'Historique lisait la valeur finale, et se déclenchait à tort au-delà de 20.
  - **Correction de règle :** les aptitudes de sous-classe n'étaient pas appliquées.
  - `levelGain`, `featBlock`, `featsForCategory`, `raisedOneLevel`, `applyLevelUp`.
- **Pack :** noms d'options pour Style de combat (Paladin, Rôdeur), Impacts bénis et Fureur élémentaire, sans lesquels ces choix n'apparaissaient pas.
- **Fiche :** bouton « Monter au niveau n ».

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : bonus de caractéristique, dons accordés, montée de niveau.

## Impact

- `packages/dnd_rules` : `compute_sheet.dart`, `level_up.dart`.
- `apps/game_table/lib/sheet/` : assistant, bouton, ARB.

**Hors périmètre :**
- **Multiclassage, nouveaux sorts et Initié à la magie :** change suivant. Les lanceurs de sorts montent sans choisir leurs sorts d'ici là, et l'Initié n'est pas proposé.
- **Déverrouillage par PX ou jalon :** tables et séances, M3. Un personnage libre monte quand il veut.
- **PV par jet :** dépend du réglage de table (EF-TAB-03). Moyenne fixe en attendant.
- **Bouton « Suggérer » :** US-32.
- **Trace dans l'historique de la fiche :** la carte de l'historique.
