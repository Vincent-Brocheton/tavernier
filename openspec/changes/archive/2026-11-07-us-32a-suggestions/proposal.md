# Proposal

## Why

Carte Trello [US-32](https://trello.com/c/opHlqNgq), premier change. Un débutant doit décider seul de ses valeurs, compétences, bottes et améliorations (EF-PJ-15).

## What Changes

- **Caractéristiques [J11] :** « Suggérer » pose les valeurs de la table du SRD pour la classe, et les bonus d'Historique sur les meilleures valeurs.
- **Compétences :** celles de la caractéristique principale d'abord.
- **Bottes :** les armes de l'équipement de départ d'abord.
- **Montée de niveau [P10] :** l'Amélioration de caractéristique sur la caractéristique principale.
- **Raison :** une ligne sous le bouton. Rien ne s'applique sans le geste du joueur, tout reste modifiable.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : suggestions.

## Impact

- `packages/dnd_rules` : nouveau `suggestions.dart`.
- `apps/game_table/lib/creation/`, `apps/game_table/lib/sheet/level_up_page.dart`, ARB.

**Hors périmètre :**
- **Termes cliquables (EF-PJ-21) :** change suivant.
- **Don et sorts suggérés :** seuls les choix cités par EF-PJ-15 sont couverts, plus les bottes.
- **Étapes sans choix chiffré (espèce, Historique, équipement, détails) :** rien à calculer.
