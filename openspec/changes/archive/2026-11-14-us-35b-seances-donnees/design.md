## Context

Plusieurs choses sont déjà en place :
- les tables synchronisées sont des vues PowerSync, et Drift ne fait que les décrire ;
- la publication `powersync` décide ce que `apply_crud` accepte d'écrire ;
- la garde `guard_character` règle déjà le statut, la revue, le transfert et la table unique.

Le lot a écrit `level_unlock` du côté du MJ, avec `CharacterStore.grantLevel`. Le joueur n'écrit jamais `xp` depuis l'app : l'assistant de montée garde les PX de la fiche, et rien d'autre ne les change.

## Decisions

- **Schéma** :

  ```sql
  create table public.session (
    id text primary key,
    table_id text not null references public.game_table (id) on delete cascade,
    title text not null check (length(btrim(title)) > 0),
    date date not null,
    status text not null default 'planned'
      check (status in ('planned', 'in_progress', 'closed')),
    created_at timestamptz not null default now()
  );

  create table public.session_attendance (
    id text primary key,                  -- '<session>:<personnage>'
    session_id text not null references public.session (id) on delete cascade,
    character_id text not null references public.character (id) on delete cascade,
    table_id text not null references public.game_table (id) on delete cascade,
    unique (session_id, character_id)
  );
  ```

- **Présence par ligne** : une ligne veut dire « présent » ; décocher la supprime. On évite ainsi un booléen à fusionner. L'identifiant déterministe `<session>:<personnage>` empêche les doublons quand deux appareils du MJ cochent hors ligne.
- **`table_id` recopié dans la présence** : c'est le même procédé que `character_proposal`, et il garde des requêtes de synchronisation simples (`table_id IN mes_tables`). Une garde vérifie que la séance et la fiche sont de cette table.
- **Numéro non stocké** : « Séance n » vient de `row_number()` sur `(date, created_at)`. Deux appareils hors ligne ne peuvent donc pas donner le même numéro. Déplacer une séance renumérote, comme le dit la planche ([S1] montre le rang chronologique).
- **Droits** :
  - lecture par `is_table_member`, qui inclut le MJ, car il est membre de sa table ;
  - écriture par une nouvelle fonction `can_manage_table(t)` : MJ de la table, ni archivée ni sans MJ.
- **Garde des PX et du déverrouillage** : deux ajouts à `guard_character` (`create or replace`, qui reprend la dernière version) :
  - à la création, `level_unlock` doit être nul ;
  - en mise à jour, sur une fiche avec `table_id`, un changement de `xp` ou de `level_unlock` exige `is_gm`.

  Les écritures de service (`current_user <> 'authenticated'`) passent, comme pour le reste de la garde.
- **Synchronisation** : deux requêtes de plus dans le flux `tables`, sur `mes_tables`, à côté des emplacements et des résumés. Rien n'est caché aux joueurs, car le cahier dit « Membres de la table ».
- **`SessionStore`** (nouveau fichier, sur le modèle de `TableStore`) : `create`, `update`, `delete`, `watchList(tableId)` (numéro calculé en SQL), `watchAttendance(sessionId)` et `setPresent(sessionId, characterId, present)`. La suppression d'une séance supprime aussi ses présences en local, car les vues PowerSync n'ont pas de clés étrangères.

## Risks / Trade-offs

- **Garde en tout ou rien** : `apply_crud` écarte toute l'opération refusée. Un client modifié qui envoie des PX avec d'autres colonnes perd tout le lot. L'app n'envoie jamais de PX côté joueur (`ignoreEmptyUpdates`, et `xp` inchangé), donc aucun cas normal n'est touché.
- **Fiche libre rattachée** : ses PX arrivent tels quels à la table. Le MJ les voit à la revue du rattachement (US-15), comme le niveau.
- **Séance supprimée par le MJ pendant qu'un autre appareil coche une présence** : la présence orpheline est refusée par la clé étrangère, puis écartée par `apply_crud`.
