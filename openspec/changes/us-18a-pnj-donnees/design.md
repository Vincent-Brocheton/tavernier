## Context

Plusieurs pièces existent déjà :
- **Table locale `npc_statblock`** : elle existe depuis M1, sans écran ni données.
- **Fiches** : `character.kind` vaut `pc` ou `npc_full` (cahier §11). Le droit `can_read_character` ouvre toutes les fiches d'une table à ses membres quand elle montre les fiches complètes, et le flux PowerSync `fiches` reprend la même règle.
- **Droits d'écriture** : le lot b d'US-35 a posé `can_manage_table`, qui désigne le MJ d'une table ni archivée ni sans MJ.

## Decisions

- **Schéma** (validé par le porteur de projet) :

  ```sql
  create table public.npc_statblock (
    id text primary key,
    table_id text not null references public.game_table (id) on delete cascade,
    name text not null check (length(btrim(name)) > 0),
    folder text,
    monster_id text,
    stat_block text,
    character_id text references public.character (id) on delete cascade,
    attitude text not null default 'indifferent'
      check (attitude in ('friendly', 'indifferent', 'hostile')),
    hidden_info text not null default '[]',
    created_at timestamptz not null default now()
  );
  ```

- **Un seul PNJ pour les deux formes** : un bloc de stats a `monster_id` et/ou `stat_block` ; une fiche complète a `character_id`. La liste, l'attitude et les informations cachées valent pour les deux. Aucune contrainte « l'un ou l'autre » au serveur : un bloc vide est un PNJ valide ([G5], « bloc vide »).
- **Droits** :
  - lecture par `is_table_gm` ;
  - écriture par `can_manage_table` ;
  - une garde vérifie que la fiche liée est de la même table.
- **Fiches de PNJ cachées** :
  - `can_read_character` ne donne aux membres que `kind = 'pc'` ;
  - le flux `fiches` reçoit la même condition dans `fiches_lues`, que `sync_test.sh` vérifie avec une fiche `npc_full`.
- **Synchronisation** : un flux `pnj` (`auto_subscribe`) pour le MJ seul, sur le modèle des propositions.
- **Informations cachées** : JSON `[{"dc": 10, "text": "…", "revealed": false}]`. Le DD est un entier, et l'ordre est celui de la liste. La révélation (US-22) mettra `revealed` à vrai.
- **`NpcStore`** :
  - type `Npc` (champs décodés) et `HiddenInfo(dc, text, revealed)` ;
  - `create`, `update` (champs facultatifs, avec `folder` effaçable), `duplicate`, `delete` et `watchList(tableId)`.

  Le tri se fait en SQL : `ORDER BY folder IS NULL, folder COLLATE NOCASE, name COLLATE NOCASE`.
- **Export des données** : la table passe des tables locales de jeu aux tables synchronisées.

## Risks / Trade-offs

- **Résumé d'une fiche de PNJ** : rien ne l'empêche d'être publié à la table. Le lot d l'écartera de `summary_publisher`, puisqu'aucune fiche de PNJ n'existe avant lui.
- **Changement de droit des fiches** : il ne retire rien d'utile. Aucune fiche `npc_full` n'existe encore.
