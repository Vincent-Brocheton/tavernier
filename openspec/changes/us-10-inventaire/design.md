# Design

## Contexte

`CharacterInput.items` porte quantité, équipé, harmonisé, et `coins` la monnaie. `computeSheet` lit déjà l'armure et le bouclier équipés. Le pack n'a aucun effet d'objet magique.

## Décisions

1. **`inventory.dart`.** Fonctions pures sur `CharacterInput` : l'écran n'applique aucune règle.
2. **Une armure, un bouclier.** Équiper remplace le précédent de même sorte. Armes et objets s'équipent librement.
3. **Limite d'harmonisation.** `ComputedSheet.attunementSlots` vaut 3, ou la valeur de `modify_attunement_slots` si elle est plus haute. Un dépassement donne une erreur d'intégrité.
4. **Effets d'objet.** `_activeEffects` lit un objet magique équipé, harmonisé s'il l'exige. Le DSL existant suffit.
5. **Retrait.** Déséquiper garde l'harmonisation : le SRD lie sa fin à d'autres causes.
6. **Monnaie.** Saisie directe de chaque pièce, sans conversion.

## Risques

- **Cape de protection :** seul objet magique avec des effets pour l'instant.
