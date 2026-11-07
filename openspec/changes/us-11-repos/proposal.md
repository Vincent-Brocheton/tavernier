# Proposal

## Why

Carte Trello [US-11](https://trello.com/c/igW0lbVp). Les emplacements, les lancers gratuits et les ressources se dépensent sans jamais revenir, et la fiche ne suit pas les PV actuels (EF-PJ-11, EF-PJ-12, EF-TAB-03).

## What Changes

- **Repos court [P12] :** dépense de dés de vie, en saisissant son jet ou en lançant, puis récupération selon le type de ressource.
- **Repos long [P13] :** PV, dés de vie, emplacements, ressources, un niveau d'Épuisement. La règle de la table est prise en paramètre.
- **PV actuels :** suivis sur l'onglet Principal, avec un bouton pour en perdre ou en regagner.
- **Ressources :** chaque ressource de classe se dépense depuis l'onglet Aptitudes ou Combat.
- **Dés de vie par type :** dépensés séparément, comme le demande le multiclassage.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : repos et suivi de jeu.
- `local-database` : PV actuels et Épuisement dans l'état de jeu.

## Impact

- `packages/dnd_rules` : `spell_play.dart`, `compute_sheet.dart`, `computed_sheet.dart`, nouveau `rest.dart`.
- `packages/dnd_data` : `character_store.dart`, sans changement de schéma.
- `apps/game_table/lib/sheet/` : `sheet_page.dart`, `sheet_features.dart`, onglets, nouveau `rest_sheet.dart`, ARB.

**Hors périmètre :**
- **Règle de la table à l'écran :** les tables arrivent en M2. L'application emploie la récupération totale, et le moteur accepte déjà l'autre règle.
- **Attente de 16 heures :** le temps de jeu n'est pas le temps réel, l'écran la rappelle sans la vérifier.
- **Moment du changement de sorts :** la limite reste par ouverture de la feuille, rien ne relie encore un repos à un changement.
- **Revoir ses bottes après un repos long :** EF-PJ-04, à part.
- **Jet avec avantage, historique :** US-33.
- **PV temporaires, jets contre la mort, états :** M3, avec le combat.
- **Récupération arcanique et aptitudes actives pendant un repos.**
