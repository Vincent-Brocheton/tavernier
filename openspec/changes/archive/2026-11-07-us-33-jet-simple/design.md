# Design

## Contexte

Le repos court et la potion tirent leurs dés dans l'écran, chacun à sa façon.

## Décisions

1. **`DiceFormula` dans `dnd_rules`.** Le moteur dit ce qu'est un jet valide. Le hasard est passé en paramètre : les tests restent déterministes.
2. **Avantage et Désavantage.** Deux d20, le meilleur ou le pire gardé, l'autre rendu dans `dropped` pour être barré.
3. **Le champ porte le résultat des dés, pas le total.** Comme [J6] (« Résultat du d20 »), le joueur saisit ce que montrent ses dés physiques. Le bonus s'ajoute à l'affichage.
4. **Validation par l'écran parent.** `SimpleRoll` rend le résultat des dés quand il est possible, sinon rien. Le parent garde son bouton d'action.
5. **Remise à zéro.** Une clé de widget neuve après chaque dé de vie dépensé.

## Risques

- **Comportement modifié :** dépenser un dé de vie passe par un résultat validé, en deux gestes au lieu d'un.
