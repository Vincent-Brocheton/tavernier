# Proposal

## Why

Carte Trello [US-08](https://trello.com/c/LOQ88tIY), deuxième change. Un lanceur de sorts monte aujourd'hui sans gagner ses sorts, l'Initié à la magie n'est pas proposé comme don, et Combattant béni ou druidique ne demande pas ses sorts mineurs (EF-PJ-06).

## What Changes

- **Étape Sorts de la montée de niveau :** sorts mineurs et sorts préparés gagnés selon la table de classe, 2 sorts au grimoire pour le Magicien, dans les niveaux de sort atteints.
- **Sort déjà connu :** grisé avec la règle, y compris un sort accordé par une aptitude ou un lignage.
- **Initié à la magie :** proposé comme don, avec une liste autre que celles déjà prises.
- **Combattant béni et Combattant druidique :** leurs 2 sorts mineurs se choisissent dans la liste du Clerc ou du Druide.
- **Moteur :** `spellGain`, `LevelChoices.spells`, `grantedSpells` et `ChoiceOption.cantripListId`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `character-sheet` : sorts à la montée de niveau.

## Impact

- `packages/dnd_rules` : `level_up.dart`, `creation_choices.dart`.
- `apps/game_table/lib/sheet/` : brouillon et assistant, ARB.

**Hors périmètre :**
- **Multiclassage :** change suivant.
- **Remplacer un sort connu :** les sorts mineurs et préparés se remplacent au repos ou à la montée selon la classe. US-09, avec l'écran des sorts.
- **Emplacements et préparation au quotidien :** US-09.
