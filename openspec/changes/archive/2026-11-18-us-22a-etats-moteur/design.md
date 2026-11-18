# Design

## Données d'un état

`condition_added` :

```
{ combatant, instance (UUID v7),
  condition?: 'srd:condition:restrained',   // absent : effet libellé
  label?: 'En feu',
  duration: { kind: 'rounds', rounds: 2 }
          | { kind: 'turn_start', combatant }
          | { kind: 'turn_end', combatant }
          | { kind: 'save', dc: 13, ability: 'str' }
          | { kind: 'indefinite' },
  levels?: 1,                                // Épuisement
  recurring?: { dice: '1d4', type: 'srd:damage-type:fire', at: 'start'|'end' } }
```

- `condition_removed { combatant, instance, levels? }`.
- `condition_save { combatant, instance, success }`.

La projection garde une `ConditionInstance` par instance :
- l'**unité d'ancrage** : l'unité active au moment de la pose, ou celle du porteur hors combat ;
- le **round de pose**, au moins 1, pour qu'un état posé avant le combat dure le round 1.

## Expiration

Elle se décide dans `projectCombat`, autour de `startTurn` :

- **Avant de passer au tour suivant** (`turnAdvanced`, ou retrait du combattant actif) : sont retirés les états `turn_end` dont l'unité de X est l'unité active. Si plusieurs fins de tour sont possibles, c'est la prochaine qui compte, celle en cours comprise.
- **Au début d'un tour d'unité U** sont retirés :
  - les états `turn_start` de X, si l'unité de X est U et que le tour de X a commencé après la pose. Un état posé pendant le tour de X attend donc le tour suivant ;
  - les états `rounds`, si U est l'unité d'ancrage et que le round atteint le round de pose plus N. Si l'unité d'ancrage a quitté le combat, le premier début de tour qui atteint ce round suffit.

  Ces instances sont gardées dans `CombatState.justExpired`, pour le rappel de début de tour.
- **Unité introuvable** : un état `turn_start` ou `turn_end` dont X a quitté le combat ne prend pas fin seul. Le MJ le retire à la main.
- **Fin du porteur** : un combattant retiré emporte ses états.

Pour savoir si un début de tour est postérieur à la pose, la projection compte les débuts de tour (`turnSerial`). Chaque instance retient le numéro du début de tour en cours à sa pose.

## Rappels

`turnReminders(CombatState state, TurnPhase phase)` renvoie une liste de `TurnReminder(kind, combatant, instance)`, avec `kind` parmi `expired`, `expires` (à la fin de ce tour), `save` et `recurring`. Ils portent sur les membres de l'unité active :

- **au début** :
  - `expired`, tiré de `justExpired` ;
  - `expires`, pour les `turn_end` dont X est dans l'unité active ;
  - `recurring`, pour les dégâts récurrents « au début » ;
- **à la fin** :
  - `expires` ;
  - `save`, pour chaque état à sauvegarde d'un porteur de l'unité active ;
  - `recurring`, pour les dégâts récurrents « à la fin ».

Un état `turn_end` peut viser X alors qu'un autre combattant le porte (« Effrayé jusqu'à la fin du tour de Mira »). Son rappel suit alors le tour de X, pas celui du porteur.

## Sauvegardes et immunités

- **`Combatant.saves`** : `Map<String,int>` par code (`str`…`cha`), lu depuis `saves` dans `combatant_added`. Il est vide si inconnu ; l'écran propose alors seulement Échec et Réussite.
- **Sources** : `MonsterData.savingThrows` pour un monstre, et `ComputedSheet.savingThrows` pour un PJ ou un PNJ à fiche.
- **`Combatant.conditionImmunities`** : lu depuis `condition_immunities`, et rempli par `MonsterData.conditionImmunities`. Un `condition_added` d'un état immunisé est ignoré.

## Épuisement

Il a une seule instance par porteur. Un nouvel ajout ajoute ses niveaux, jusqu'à 6. Un retrait avec `levels` en ôte autant, et l'état disparaît à 0. Sa durée est toujours indéfinie : il se dissipe au Repos long, hors combat.
