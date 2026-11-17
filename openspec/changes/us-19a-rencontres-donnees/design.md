## Context

Plusieurs pièces existent déjà :
- **Tables locales de combat** (M1) : `encounter`, `combatant` et `encounter_event` existent en local, sans données ni écran. `encounter` n'a pas de clé étrangère vers `session`, devenue une vue PowerSync (US-35 lot b).
- **Droits** : `can_manage_table` (US-35) désigne le MJ d'une table ni archivée ni sans MJ.
- **Monstres** : les PX de chaque monstre sont dans le contenu actif (`MonsterData.xp`).

## Decisions

- **Moteur** (`encounter_budget.dart`) :
  - `xpBudgetByLevel` : 20 triplets recopiés du SRD ;
  - `EncounterBudget(low, moderate, high)` ;
  - `encounterBudget(Iterable<int> levels)` ;
  - `enum EncounterDifficulty { belowLow, low, moderate, high }` ;
  - `encounterDifficulty(int xp, EncounterBudget budget)`.

  Pas de multiplicateur de groupe : le SRD 2024 n'en a plus. Un niveau hors de 1 à 20 lève une `ArgumentError`. Les valeurs attendues des tests viennent de [D1] et du SRD.
- **Schéma** (validé) :

  ```sql
  create table public.encounter (
    id text primary key,
    table_id text not null references public.game_table (id) on delete cascade,
    session_id text references public.session (id) on delete set null,
    title text not null check (length(btrim(title)) > 0),
    status text not null default 'draft'
      check (status in ('draft', 'ready', 'running', 'finished')),
    hp_mode text not null default 'average' check (hp_mode in ('average', 'roll')),
    position integer not null default 0,
    created_at timestamptz not null default now()
  );
  create table public.encounter_group (
    id text primary key,
    encounter_id text not null references public.encounter (id) on delete cascade,
    table_id text not null references public.game_table (id) on delete cascade,
    kind text not null check (kind in ('monster', 'npc')),
    ref_id text not null,
    quantity integer not null default 1 check (quantity between 1 and 30),
    shared_initiative boolean not null default true,
    position integer not null default 0
  );
  ```

- **Droits** : lecture par `is_table_gm`, écriture par `can_manage_table`. Deux gardes complètent ces règles :
  - la séance d'une rencontre est de sa table ;
  - un groupe est de la table de sa rencontre, et ni l'un ni l'autre ne change de table.
- **Synchronisation** : un flux `rencontres` pour le MJ, sur le modèle du flux `pnj`.
- **Base locale** :
  - `Encounters` reçoit les colonnes `table_id`, `title`, `position` et `created_at`, avec des défauts pour `status` et `hp_mode` ; `difficulty` est retirée, car elle est calculée ;
  - `EncounterGroups` est nouvelle ;
  - `combatant` garde sa clé étrangère locale vers `encounter`. Les combattants restent locaux jusqu'à US-20, qui tranchera leur synchronisation ;
  - instantané `drift_schema_v1` régénéré, puisque la version 1 n'est pas publiée.
- **`EncounterStore`** :
  - types `Encounter` (avec `groups`) et `EncounterGroup` ;
  - `watchList(tableId)` lit les rencontres et les groupes en deux requêtes observées, puis les assemble ;
  - `addGroup` cherche un groupe de même `kind` et `ref_id` et augmente sa quantité, plafonnée à 30, sinon il crée le groupe en dernière position.

## Risks / Trade-offs

- **Difficulté non stockée** : la liste [F5] la recalcule pour chaque rencontre. C'est un calcul en mémoire sur quelques rencontres.
- **`combatant` local** : sa clé étrangère vise une table devenue vue PowerSync. Aucune donnée n'y est écrite avant US-20.
