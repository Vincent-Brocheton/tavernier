-- Repos de groupe (US-38, EF-PJ-19). Le MJ déclenche un repos court ou long
-- pour les PJ présents (group_rest) ; chaque joueur le fait sur sa fiche, puis
-- signale qu'il a terminé (group_rest_done). Le MJ peut le faire pour un
-- joueur hors-ligne, sur sa fiche.

create table public.group_rest (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  session_id text references public.session (id) on delete set null,
  kind text not null check (kind in ('short', 'long')),
  -- Les PJ visés, en JSON : ["c1", "c2"].
  characters text not null default '[]',
  created_at timestamptz not null default now(),
  closed_at timestamptz
);

alter table public.group_rest enable row level security;

create policy group_rest_read on public.group_rest for select
to authenticated using (public.is_table_member(table_id));
create policy group_rest_insert on public.group_rest for insert
to authenticated with check (public.can_manage_table(table_id));
create policy group_rest_update on public.group_rest for update
to authenticated
using (public.can_manage_table(table_id))
with check (public.can_manage_table(table_id));
create policy group_rest_delete on public.group_rest for delete
to authenticated using (public.can_manage_table(table_id));

-- La séance, s'il y en a une, est de la table.
create function public.guard_group_rest() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if new.session_id is not null and not exists (
    select 1 from public.session s
    where s.id = new.session_id and s.table_id = new.table_id
  ) then
    raise insufficient_privilege using message = 'repos : autre table';
  end if;
  return new;
end
$$;

create trigger guard_group_rest before insert or update on public.group_rest
for each row execute function public.guard_group_rest();

create table public.group_rest_done (
  id text primary key,
  rest_id text not null references public.group_rest (id) on delete cascade,
  table_id text not null references public.game_table (id) on delete cascade,
  character_id text not null references public.character (id) on delete cascade,
  author_user_id uuid references auth.users (id) on delete set null,
  -- Récapitulatif en JSON : {"hit_dice": 2, "hp_before": 34, "hp_after": 41}.
  summary text not null default '{}',
  created_at timestamptz not null default now(),
  unique (rest_id, character_id)
);

alter table public.group_rest_done enable row level security;

create policy group_rest_done_read on public.group_rest_done for select
to authenticated using (public.is_table_member(table_id));
-- Le joueur pour son PJ, ou le MJ à sa place, en son nom.
create policy group_rest_done_insert on public.group_rest_done for insert
to authenticated with check (
  author_user_id = auth.uid() and (
    public.can_request_for(character_id, table_id)
    or public.can_manage_table(table_id)
  )
);
create policy group_rest_done_delete on public.group_rest_done for delete
to authenticated using (public.can_manage_table(table_id));

-- Le repos est de la table, ouvert, et vise ce PJ. En `security definer` :
-- la lecture du repos ne dépend pas des droits de l'auteur.
create function public.guard_group_rest_done() returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.group_rest r
    where r.id = new.rest_id and r.table_id = new.table_id
      and r.closed_at is null
      and r.characters::jsonb ? new.character_id
  ) then
    raise insufficient_privilege using message = 'repos : non visé';
  end if;
  return new;
end
$$;

create trigger guard_group_rest_done before insert
on public.group_rest_done
for each row execute function public.guard_group_rest_done();

alter publication powersync add table public.group_rest;
alter publication powersync add table public.group_rest_done;
