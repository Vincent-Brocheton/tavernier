## Context

Le lot a fournit `CombatEvent` et `projectCombat` ; l'ordre du journal est celui des identifiants. `EncounterStore` (US-19) écrit l'état d'une rencontre. Il existe en local deux tables M1 jamais utilisées : `encounter_event` (`round`, `actor_id`…) et `combatant`.

## Decisions

- **Schéma** (validé) :

  ```sql
  create table public.encounter_event (
    id text primary key,
    encounter_id text not null references public.encounter (id) on delete cascade,
    table_id text not null references public.game_table (id) on delete cascade,
    author_user_id uuid references auth.users (id) on delete set null,
    type text not null check (length(type) > 0),
    payload text not null default '{}',
    created_at timestamptz not null default now()
  );
  ```

  Le serveur ne connaît pas la liste des types : c'est le moteur qui la tient, et un type inconnu est refusé à la projection.
- **Droits** :
  - lecture par `is_table_gm` ;
  - insertion par `can_manage_table`, avec `author_user_id = auth.uid()` et une garde qui exige que la rencontre soit de la même table ;
  - aucune politique de mise à jour ni de suppression : le journal est en ajout seul pour les clients. La suppression passe par la cascade de la rencontre, qui ne dépend pas des droits.
- **Synchronisation** : une troisième requête dans le flux `rencontres` (`table_id IN tables_mj`).
- **Base locale** :
  - `EncounterEvents` prend le schéma du serveur : `table_id`, `author_user_id`, `type`, `payload` et `created_at`, sans `round` ni `actor_id` ;
  - `Combatants` est retirée ;
  - l'instantané v1 est régénéré, puisqu'il n'est pas publié.
- **`CombatStore`** :
  - les identifiants des nouveaux événements sont des `uuidV7()`, croissants dans un même processus, ce qui donne l'ordre du journal ;
  - `watchEvents` trie par `id` ;
  - `watchState` = `watchEvents.map(projectCombat)` ;
  - `launch` écrit `status = 'running'` et les événements dans la même transaction.

## Risks / Trade-offs

- **Deux appareils du MJ hors ligne** : leurs événements se mêlent par ordre d'identifiant, donc par horodatage. Un tour avancé deux fois en parallèle avance deux fois ; le MJ annule l'un. C'est le prix d'un journal sans verrou, et il reste visible et réversible.
- **Journal mal formé** (un type inconnu venu d'une version plus récente) : la projection échoue. `watchState` rend alors une erreur, que l'écran affichera.
