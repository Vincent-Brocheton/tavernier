# Design

## Contexte

`character_state` porte `resources` (JSON) et `concentration_spell_id`, et rien ne les écrit. `CharacterStore.save` ne touche pas à l'état de jeu.

## Décisions

1. **`PlayState`.** Dépenses par ressource et sort en concentration : pas de copie de la fiche. Les restes se déduisent des maximums calculés.
2. **Clés `spell-slot:<n>` et `pact-slot` dans `resources`.** La colonne sert déjà aux ressources : pas de changement de schéma.
3. **Emplacements de pacte et communs interchangeables.** SRD p. 27 : les deux servent aux sorts de toutes les classes. Les options viennent donc des deux réserves.
4. **Confirmation.** La fiche annonce le sort remplacé, puis un dialogue confirme, comme le demande [P14].
5. **Même sort.** Le relancer ne demande pas de confirmation.
6. **Rituel.** Proposé en plus des emplacements, sans dépense.
7. **Écriture.** `saveState` passe par le dépôt, seule voie d'écriture (cahier §10).

## Risques

- **Emplacements sans retour :** tant qu'US-10 n'est pas livrée, rien ne les récupère.
