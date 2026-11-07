# Design

## Contexte

`Attack` porte des entiers et `ComputedSheet.resources` le maximum de chaque ressource. Les ressources ne sont pas des entités : leur nom est celui de l'aptitude qui les accorde.

## Décisions

1. **Aptitudes actives dans l'app.** `sheet_features.dart` liste les aptitudes atteintes (niveau de classe), les traits et les dons, groupés par origine. C'est de l'affichage : le calcul reste dans `computeSheet`.
2. **Ressource d'une aptitude.** Lue dans son effet `grant_resource`, avec sa recharge, puis croisée avec `sheet.resources`.
3. **Résumé d'une aptitude.** `firstSentence`, déjà utilisé par la création.
4. **Dégâts.** `1d8+3` s'affiche `1d8 + 3`, comme sur [F1].
5. **Pips pleins.** Sans état de jeu, tous les pips sont pleins. `ResourcePips` prend déjà `available` pour la suite.

## Risques

- **Filtres :** l'état du filtre vit dans l'onglet et se perd en changeant d'onglet. Sans conséquence.
