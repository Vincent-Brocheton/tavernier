# Design

## `turn_reminders.dart`

- **`nextTurn(context, ref, encounter, combat)`** : calcule `turnReminders(combat, TurnPhase.end)`.
  - S'il n'y a aucun rappel, il écrit `turn_advanced`.
  - Sinon, il ouvre `_EndOfTurnDialog`, qui garde la liste fixée à l'ouverture et les résultats saisis.
    - **Sauvegarde** : « Lancer » utilise `rollDice(DiceFormula(1, 20))` et ajoute `saveBonus`. Il écrit `condition_save {success: total ≥ DD, roll: {dice, bonus}}`. « Échec » et « Réussite » écrivent `condition_save` sans jet. La carte affiche ensuite « Réussite · 17 » ou « Échec ».
    - **Expire** : un badge « Retiré ». Le retrait se fait au passage du tour, par la projection.
    - **Dégâts récurrents** : « Lancer et appliquer » tire `DiceFormula.parse(dice)` et écrit `damage {targets: [porteur], amount, type}`. La carte affiche ensuite « 3 dégâts appliqués ».
    - « Plus tard » ferme le dialogue. « Tour suivant : <unité> » écrit `turn_advanced` et ferme.
- **`unitLabel(combat, unit)`** : le nom du groupe, sans son numéro, pour un groupe de plusieurs membres. Sinon, le nom du combattant. La même règle que l'en-tête de groupe de la liste.
- **`TurnStartBanner(encounter, combat)`** (ConsumerStatefulWidget) :
  - il affiche `turnReminders(combat, TurnPhase.start)` ;
  - il est masqué si la liste est vide, ou si « OK » a été touché pour la clé de tour `round:active` ;
  - les dégâts récurrents se lancent et s'appliquent comme en fin de tour, et une ligne déjà appliquée l'indique ;
  - la carte est en `alertContainer`, avec une icône d'alerte.

## Puce « expire »

`shortDuration` reçoit le combat. Un état `turn_end` dont X est dans l'unité active renvoie « expire ».
