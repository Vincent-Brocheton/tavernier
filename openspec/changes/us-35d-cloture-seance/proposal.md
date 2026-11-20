# Proposal

## Why

Carte Trello [US-35](https://trello.com/c/ClnskrIq), **lot d**. Exigences : **EF-SEA-03** et **EF-SEA-04** ; planches [S3], [S4] et [S7].

Les lots a à c ont livré le déverrouillage de la montée de niveau (`grantLevel`), les séances (données et écrans) et la préparation. La clôture d'une rencontre (US-25) inscrit déjà les PX de chaque PJ présent, dans l'événement `encounter_finished`. Il manque :
- la séance en cours, avec ses rencontres ;
- sa clôture, qui ajoute les PX aux fiches ou accorde le jalon.

## What Changes

- **Moteur** : `sessionXp(awarded)`, la somme par fiche des PX accordés à la clôture de chaque rencontre jouée de la séance.
- **Données** : `CharacterStore.addXp`, qui ajoute des PX à une fiche et l'inscrit dans son historique (`kind: xp`, montant, avant, après, séance).
- **Séance en cours ([S3])** : la page s'intitule « Séance en cours ». Elle liste les rencontres de la séance, avec leur état, et porte « Clore la séance ».
- **Clôture ([S4], table en PX)** :
  - les rencontres jouées, avec leurs rounds et PX, et le total ;
  - pour chaque rencontre non jouée : « Reporter à la séance n » (la prochaine séance prévue), « Garder sans séance » ou « Supprimer » ;
  - pour chaque PJ : « +825 » et « 6 650 → 7 475 / 14 000 (niv. 6) ». Un absent gagne 0.
  - « Clore la séance n » ajoute les PX aux fiches, applique le sort des rencontres non jouées et clôt la séance.
- **Clôture ([S7], table en jalons)** :
  - un motif visible des joueurs ;
  - « Proposer la montée de niveau à » : les présents sont cochés, les absents non ; un PJ déjà servi pendant la séance est coché et grisé ;
  - à la clôture, chaque PJ coché reçoit `grantLevel` (niveau + 1, jalon, motif, séance).
- **Historique de la fiche** : « +825 PX (6 650 → 7 475) ».

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `encounters` : `sessionXp`.
- `local-database` : `addXp`.
- `tables` : séance en cours et clôture.

## Impact

- **`dnd_rules`** : `encounter_summary.dart`.
- **`dnd_data`** : `character_store.dart`.
- **App** :
  - `sessions/session_close.dart` (nouveau) ;
  - `session_page.dart` ;
  - `history_page.dart`.

## Hors périmètre

- **PV du groupe et « Notes (3) » de [S3]** : la page de la séance garde le repos de groupe (US-38). Les notes ont leur onglet (US-26).
- **« PNJ à suivre »** de [S4] et [S7].
- **Vue du joueur après la clôture ([S5], EF-SEA-07)** : lot e.
