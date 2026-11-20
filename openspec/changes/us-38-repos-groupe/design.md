# Design

## Lot a

### Serveur (`20261201000000_repos_groupe.sql`)

- **`group_rest`** :
  - lecture par `is_table_member` (le MJ en est membre) ;
  - écriture par `can_manage_table` ;
  - le déclencheur `guard_group_rest` vérifie que la séance est de la table.
- **`group_rest_done`** :
  - insertion si `author_user_id = auth.uid()` et (`can_request_for` ou `can_manage_table`) ;
  - lecture par les membres, suppression par le MJ ;
  - le déclencheur `guard_group_rest_done`, en `security definer`, vérifie que le repos est de la table, ouvert, et vise ce PJ (`characters::jsonb ? character_id`) ;
  - une fin par PJ et par repos (`unique`).
- **PowerSync** : le flux `tables` envoie les deux tables à `mes_tables`.

### Base locale

- **Tables** : `GroupRests` et `GroupRestDones`, synchronisées, sans clé étrangère.
- **Schéma v4** : `createTable` dans la migration, sauf sous PowerSync. Avec l'instantané `drift_schema_v4.json` et les tests de montée v1 → v4 et v3 → v4.
- **`GroupRestStore`** : `start`, `close`, `markDone`, `watchOpen`, `watchForCharacter` (avec `json_each`) et `watchDone`.

## Lot b

- **`RestSheet`** prend `origin` (en tête) et `onFinished`, appelé après « Terminer » avec `hit_dice`, `hp_before` et `hp_after`.
- **`sessions/group_rest.dart`** :
  - `GroupRestPanel`, sur la page d'une séance en cours ;
  - `GroupRestBanner`, sur la fiche, pour qui peut la modifier ;
  - `openGroupRest` attend la fiche et l'état de jeu, puis ouvre l'écran de repos et signale la fin au nom de l'utilisateur (le joueur, ou le MJ pour « Faire pour… »).
- **Nom du MJ** : celui du membre MJ de la table, ou « Le MJ ».

## Choix

- **Les PJ visés en JSON** dans le repos : le MJ les coche une fois, sans table de liaison.
- **La fin porte le récapitulatif** : le MJ le lit sans accès à l'état de jeu de la fiche.
- **Le MJ fait le repos sur la fiche** pour un joueur absent : même écran, mêmes règles ; la fiche se synchronise comme toute modification du MJ.
