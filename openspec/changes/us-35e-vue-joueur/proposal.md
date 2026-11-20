# Proposal

## Why

Carte Trello [US-35](https://trello.com/c/ClnskrIq), **lot e**, le dernier. Exigences : **EF-SEA-07** et **EF-TAB-10** ; planche [S5].

Après la clôture (lot d), le joueur doit voir ce que la séance a apporté à son PJ, ses PX ou le jalon, ainsi que les notes de la séance. Il ne voit pas le résumé des rencontres.

## What Changes

- **Données** : `CharacterStore.watchSessionGains(sessionId)` suit les PX ajoutés et les niveaux accordés à la clôture d'une séance, d'après l'historique des fiches que l'appareil reçoit.
- **Carte d'une séance close (joueur)** :
  - pour chacun de ses PJ : « +825 PX pour Aldric Varenne » et « 7 475 / 14 000 PX · niveau 6 à 14 000 » ;
  - en jalons : « Niveau 6 accordé à Aldric Varenne » et son motif, sans aucun PX (EF-TAB-10).
- **Page d'une séance close (joueur)** : ses gains, puis « Notes de cette séance » : les siennes et celles partagées, avec « Nouvelle note », qui se rattache à la séance.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `local-database` : `watchSessionGains`.
- `tables` : séance close vue par le joueur.

## Impact

- **`dnd_data`** : `character_store.dart`.
- **App** : `sessions_tab.dart` et `notes_view.dart` (filtre par séance).

## Hors périmètre

- **« Séances précédentes (11) »** de [S5], en pli : les séances closes restent listées.
