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

## Choix

- **Les PJ visés en JSON** dans le repos : le MJ les coche une fois, sans table de liaison.
- **La fin porte le récapitulatif** : le MJ le lit sans accès à l'état de jeu de la fiche.
- **Le MJ fait le repos sur la fiche** pour un joueur absent : même écran, mêmes règles ; la fiche se synchronise comme toute modification du MJ.
