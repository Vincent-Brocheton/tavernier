# Design

## Contexte

Les valeurs de jeu des trois fixtures concordent déjà. Il manque quatre valeurs au moteur, et les fixtures gardent un ancien format d'entrée.

## Décisions

1. **Attaques par action.** La plus haute valeur de `set_attacks_per_action` : le non-cumul du SRD en découle.
2. **Attaque sournoise.** `'${dés}d6'` depuis la colonne `sneak_attack_dice`.
3. **Liste des attaques.** [D1] n'imprime qu'une sélection : les fixtures comptent désormais toutes les armes portées et les mains nues, comme celle d'Aldric niveau 1. Valeurs ajoutées à la main.
4. **`fixtureInput`.** Il suit `extends`, comme le test de cohérence.
5. **Dérogations de Kael.** Elles ne sont pas dans `CharacterInput` : elles passent à la racine de la fixture.
6. **Sorts d'espèce.** `species_spells` reste en `pending_keys`, testé par `spellcasting_test.dart`.

## Risques

- **Thalia à mains nues :** FOR 8 donne 0 dégât : le SRD écrit 1 + modificateur de Force, sans minimum.
