# Design

## Moteur et données

- **`sessionXp`** (`encounter_summary.dart`) additionne les `awarded` des résumés des rencontres jouées.
- **`CharacterStore.addXp`** lit les PX par `access`, écrit `xp + amount` et inscrit l'ajout dans l'historique, en une transaction.

## App

- **`sessions/session_close.dart`** :
  - `playedEncountersProvider` : les rencontres terminées de la séance, résumées par `summarizeEncounter` à partir de leur journal. Les PX comptés sont ceux accordés à la clôture du combat ; le profil des adversaires n'est pas relu.
  - `CloseSessionPage` : la clôture en PX ([S4]) ou en jalons ([S7]), selon `TableSettings.progression`.
  - La prochaine séance prévue (le plus petit numéro après celui de la séance) reçoit les rencontres reportées. Sans elle, le choix par défaut est « Garder sans séance ».
  - En jalons, un PJ dont le `level_unlock` dépasse déjà son niveau est « déjà accordé ».
- **`session_page.dart`** : le titre, les rencontres de la séance et « Clore la séance » sur une séance en cours.
- **`history_page.dart`** : l'entrée `xp`.

## Choix

- **Les PX accordés à la clôture du combat font foi** : le MJ les a déjà vérifiés et modifiés (US-25). La clôture de la séance ne fait que les additionner.
- **« PX par personnage présent »** affiche le plus grand gain de la séance : sur [S4], tous les présents gagnent autant.
