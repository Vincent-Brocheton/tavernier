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

## Lot b

- **Moteur** (`encounter_summary.dart`, `dnd_rules`) :
  - `summarizeEncounter(events, xpOf:)` rend `EncounterSummary`, avec `rounds`, `foes`, `fallen`, `downedPcs`, `xpTotal`, `moments` et `awarded` (les PX de `encounter_finished`, s'il y en a un) ;
  - `FallenCombatant` porte `{id, label, round, knockedOut, dead, stable}`. Le round d'une chute vient de `combatJournal` : la première entrée de dégâts qui fait passer la cible de plus de 0 à 0 PV, ou à 1 PV avec `knock_out` ;
  - `xpOf` est fourni par l'app (PX du profil du monstre ou du PNJ) : le moteur ne lit pas le contenu ;
  - nouveau type `encounter_finished`, ignoré par la projection.
- **Écran** (`encounter_summary.dart`, app) :
  - la page « Fin de rencontre » [C11] montre le titre, les rounds, les PX au total et les adversaires tombés ;
  - les PX par PJ, avec un champ chacun et « 6 725 → 7 475 PX » quand la fiche est lisible ;
  - les combattants tombés et les moments notés ;
  - « Voir les n événements » ouvre le journal ;
  - « Clore et ranger dans la séance » (ou « Clore la rencontre » sans séance) et « Revenir au combat ».
  - « Terminer la rencontre », dans le menu du combat, ouvre cette page à la place de la confirmation. Une rencontre terminée montre « Résumé de la rencontre », en lecture seule, avec les PX retenus.

### Choix

- **PX par défaut** : ceux des adversaires encore dans le combat à la fin. C'est la seule règle qui donne les deux totaux de [D1] : Bandit 4 « a fui » sans être retiré, alors que Varga en fuite a été retirée. Le MJ corrige avant de clore.
- **Les PX ne vont pas encore sur les fiches** : la clôture de la séance (US-35, lot d) les attribuera à partir de `encounter_finished`.

