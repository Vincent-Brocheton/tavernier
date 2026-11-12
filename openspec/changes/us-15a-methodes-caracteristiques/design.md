# Design

## Brouillon

`CreationDraft` gagne `method` (`ScoreMethod`, acquisition par points par défaut) et `rolls` (`List<int>?`). `scores` garde la valeur de chaque caractéristique, quelle que soit la méthode.

- `withMethod(m)` :
  - points : toutes les valeurs à 8 ;
  - standard : 15, 14, 13, 12, 10, 8 dans l'ordre des caractéristiques ;
  - aléatoire : sans jets, les valeurs restent ; les jets les remplacent quand ils arrivent.
- `withRolls(rolls)` : garde les jets et les répartit du plus haut au plus bas, de la Force au Charisme.
- `assign(code, value)` : donne `value` à `code`. La caractéristique qui l'avait reprend l'ancienne valeur de `code` : c'est un échange, et les valeurs restent celles du tableau ou des jets.
- **Choix manquant** : en acquisition par points, les points restants (inchangé) ; en génération aléatoire sans jets, `MissingChoice.rolls`. Les valeurs standard sont toujours complètes.

## Jets

`roll4d6DropLowest(Random)` : quatre d6, sans le plus faible. Six tirages. Le `Random` est injectable pour les tests.

La saisie manuelle passe par une boîte de dialogue à six champs numériques (3 à 18), validée seulement quand les six sont bons.

## Suggestion

`suggestedScores` rend la table du SRD par classe : elle vaut pour les points (27 points tout juste) et pour les valeurs standard. Pour les jets, on trie les caractéristiques selon cette suggestion et on y place les jets triés.

## Interface

Un `SegmentedButton` choisit la méthode, avec le rappel de la méthode choisie dessous. En points, la grille actuelle ne change pas. En valeurs standard ou aléatoire, une grille de tuiles reprend la même largeur minimale, avec le nom de la caractéristique et une liste déroulante des valeurs disponibles.
