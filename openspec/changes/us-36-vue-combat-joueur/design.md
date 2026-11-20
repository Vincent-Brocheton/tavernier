# Design

## Lot a

### Serveur (`20261130000000_vue_combat_joueur.sql`)

- **`combat_view`** :
  - la clé est l'id de la rencontre ;
  - lecture par `is_table_member` ou `is_table_gm` ;
  - écriture (insertion, mise à jour, suppression) par `can_manage_table` : le MJ d'une table active ;
  - le déclencheur `guard_combat_view` vérifie que la rencontre est de sa table.
- **`combat_request`** :
  - insertion si `author_user_id = auth.uid()` et `can_request_for(character, table)` : un PJ de la table, à soi, sur une table non archivée ;
  - lecture par le MJ ou l'auteur ;
  - suppression par le MJ ;
  - le déclencheur `guard_combat_request` vérifie que la rencontre est de sa table.
- **PowerSync** : un flux `combat_joueur` envoie la vue aux membres, et les demandes au MJ de la table et à leur auteur.
- **Tests** :
  - `combat_view_test.sql` (14 cas) ;
  - `sync_test.sh` : la vue chez tous les membres, la demande chez le MJ et l'auteur.

### Base locale

- **Tables** : `CombatViews` et `CombatRequests`, synchronisées, sans clé étrangère, car les tables visées sont des vues PowerSync.
- **Schéma v3** : `createTable` dans la migration, sauf sous PowerSync, qui crée lui-même ses vues. Avec l'instantané `drift_schema_v3.json` et les tests de montée v1 → v3 et v2 → v3.
- **`CombatViewStore`** : `publish` (sans écriture si rien ne change), `watch`, `watchTable` et `remove`.
- **`CombatRequestStore`** : `send` (UUID v7), `watch` et `remove`.

### Moteur

- **`combatant_hidden`** met à jour `Combatant.hidden`, faux par défaut.
- **`playerCombatView(state)`** (`player_view.dart`) :
  - `order` porte `{id, unit, label, kind: pc|foe, active}`, et en plus, pour un PJ, `character`, `owner` et `health` (`unhurt`, `wounded`, `badly`, `down` ou `dead`) ;
  - `pcs` est indexé par l'id de la fiche du PJ.
- **`turnsUntil`** compte les unités distinctes de l'ordre visible.

## Choix

- **La vue est calculée par le MJ** : rien de caché n'atteint le téléphone du joueur. C'est le motif de `character_summary`.
- **Un JSON plutôt que des colonnes** : la vue suit le moteur, sans migration pour chaque champ.
- **Les demandes sont retirées une fois appliquées** : le journal du MJ en garde la trace, avec l'id de la demande (lot b).
