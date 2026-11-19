# Design

## Lot a

### Moteur (`combat.dart`)

- **`JournalEntry`** porte :
  - `event` et `round` ;
  - `undone` ;
  - `hp` : `Map<String, HpChange>`, où `HpChange` est `({int? before, int? after, bool unconscious, bool outOfCombat, bool dead})`, pour les cibles des dégâts et des soins.
- **`combatJournal(events)`** :
  - **Projection** : la même boucle que `projectCombat`, sans la dupliquer, grâce à un paramètre interne `onApplied`. Le paramètre est appelé avant et après chaque événement effectif.
  - **Événements annulés et annulations** : ils ont leur entrée, avec le round courant.
- **`combatantLabels(events)`** : nom de chaque combattant ajouté, même retiré depuis.
- **`undoableCount(events)`** : les événements effectifs, hors annulations. Chacun peut être annulé à son tour, en remontant le journal.

### Données (`CombatStore`)

`watchLog(encounterId)` rend `({DateTime at, CombatEvent event})`, dans l'ordre des ids.

### Écran (`combat_journal.dart`)

- **Ouverture** : une icône « Journal » (`Icons.receipt_long`) dans la barre du combat ouvre une feuille.
- **Contenu** :
  - les filtres en `ChoiceChip` : Tout, PV, États, Étude ;
  - « n actions annulables » ;
  - une `ListTile` par entrée, la plus récente d'abord, avec la phrase en titre et « R3 · 21:42 » (heure locale) en sous-titre. Une entrée annulée est barrée, avec la mention « annulé ».
- **Phrases** : une clé ARB par type d'événement. Les dégâts s'écrivent « Mira Solen : 12 tranchants (22 → 10) », avec « , Inconscient », « , hors de combat » ou « , mort » à la chute.
- **Catégories** :
  - PV : `damage`, `heal`, `temp_hp`, `death_save` ;
  - États : `condition_*`, `concentration_*` ;
  - Étude : `study`, `influence`, `observation`.

## Choix

- **Projection unique** : le journal réutilise la boucle de `projectCombat`, pour que les PV affichés soient exactement ceux de l'état.
- **Feuille plutôt qu'onglet** : [TB1] montre un onglet sur tablette, mais une feuille couvre toutes les largeurs sans réorganiser l'écran de combat.
