# Design

- **Source des gains** : l'historique des fiches (`character_change_log`), où la clôture inscrit `xp` et `level_grant` avec la séance. Le joueur le reçoit pour ses fiches : aucune table nouvelle.
- **`watchSessionGains`** filtre par `json_extract(diff, '$.session')` et par le type.
- **`SessionGains`** (`sessions_tab.dart`) ne garde que les PJ du joueur. La progression se calcule par `nextXpThreshold` sur le niveau du résumé de la fiche.
- **`PlayerSessionPage`** : les gains, puis `NotesView(sessionId:)`, qui ne garde que les notes rattachées à la séance et y rattache une note neuve.
