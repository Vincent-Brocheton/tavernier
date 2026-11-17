## Context

`dnd_rules` est du Dart pur. Plusieurs pièces y existent déjà : `RollMode`, `DiceFormula`, `rollDice` (dice.dart) et `MonsterUses`, avec `recharge` (« 5-6 ») et `perDay` (le contenu). Le cahier (§10) impose le combat en journal. Les événements auront des identifiants UUID v7 (lot b), dont l'ordre est celui du journal.

## Decisions

- **`CombatEvent(id, type, payload)`** : `type` est un `CombatEventType` (enum à noms snake_case), et `payload` un `Map<String, Object?>` (JSON). `CombatEvent.fromJson` refuse un type inconnu.
- **Projection en deux temps** :
  1. retirer les événements visés par un `undo` (un `undo` annulé par un autre `undo` est retiré aussi, du plus récent au plus ancien) ;
  2. appliquer les autres dans l'ordre.

  C'est une fonction pure et rejouée en entier, pour quelques centaines d'événements par rencontre.
- **Combattant** (`combatant_added`) : `id`, `kind` (`pc`, `monster`, `npc`), `ref_id`, `label`, `group_id` (initiative commune), `owner` (joueur d'un PJ), `bonus`, `ac`, `hp`, `hp_max`, et `counters` (`{"legendary_actions": 3, "legendary_resistance": 3, "recharge:Souffle d'acide": 1}`).
- **Unité du tour** : un groupe à initiative commune (`group_id`), sinon le combattant seul. Son initiative est celle de son jet (`initiative_rolled` vise `unit` : un `group_id` ou un `id`).
- **Ordre** :
  - par défaut : total décroissant, bonus décroissant, puis ordre d'ajout ;
  - `order_set` : liste d'unités, et les unités absentes de la liste s'insèrent selon l'ordre par défaut, avant la première unité de total inférieur ;
  - une unité sans jet va à la fin.
- **Égalités** : `InitiativeTie(total, units, decider)`. `decider` vaut soit `gm`, soit l'ensemble des joueurs des PJ concernés. Une égalité est signalée tant que le MJ n'a pas fixé l'ordre (`order_set` après le dernier jet) ; c'est l'ordre par défaut qui est alors proposé.
- **Tours** :
  - l'état tient `round` (0 avant le début) et `active` (clé d'unité) ;
  - `turn_advanced` choisit l'unité suivante dans l'ordre courant ; après la dernière, il passe au round suivant sur la première ;
  - au début d'un tour, chaque membre de l'unité retrouve sa réaction (`reaction` utilisée = 0) et ses `legendary_actions`.
- **Compteurs** : `counter_used {combatant, counter, amount?}` et `counter_restored {combatant, counter}`. La réaction est un compteur implicite de maximum 1. Un compteur ne descend pas sous 0.
- **Aides** :
  - `combineRollModes(advantage, disadvantage)` : la surprise ajoute le Désavantage, et deux modes opposés s'annulent ;
  - `rollInitiative(bonus, mode, random)` ;
  - `numberedLabels(name, quantity)` ;
  - `rollHitPoints(hitDice, random)` : « 8d8 + 16 » est lu avec `DiceFormula.parse` ;
  - `rechargeSucceeds(range, roll)` : « 5-6 » ou « 6 ».

## Risks / Trade-offs

- **Projection rejouée en entier** à chaque événement. Elle reste en O(n) pour un journal de quelques centaines d'événements ; il faudra un instantané si les rencontres s'allongent beaucoup.
- **Ordre après fusion de deux appareils du MJ** : l'ordre des identifiants UUID v7 range les événements hors ligne par horodatage. Un `order_set` concurrent : le plus récent l'emporte.
