-- Activité d'une table et archivage (US-13, EF-TAB-07, EF-TAB-11).

-- Chaque changement de configuration, archivage compris, y est daté avec son
-- auteur. On ajoute, on ne corrige pas (comme l'historique d'une fiche).
create table public.table_activity (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  author_user_id uuid references auth.users (id) on delete set null,
  at timestamptz not null default now(),
  kind text not null,
  detail text not null default '{}'
);

alter table public.table_activity enable row level security;
create policy table_activity_read on public.table_activity for select
to authenticated
using (public.is_table_member(table_id) or public.is_table_gm(table_id));
create policy table_activity_insert on public.table_activity for insert
to authenticated
with check (public.is_table_gm(table_id) and author_user_id = auth.uid());

alter publication powersync add table public.table_activity;

-- Table archivée : lecture seule pour ses fiches.
create or replace function public.can_write_character(c text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.character ch
    left join public.game_table g on g.id = ch.table_id
    where ch.id = c
      and (ch.owner_user_id = auth.uid() or g.gm_user_id = auth.uid())
      and not coalesce(g.archived, false)
  );
$$;

-- Table archivée : seule sa restauration la modifie.
create function public.guard_archived_table() returns trigger
language plpgsql
as $$
begin
  if old.archived and new.archived then
    raise insufficient_privilege using message = 'table archivée';
  end if;
  return new;
end
$$;

create trigger guard_archived_table
before update on public.game_table
for each row execute function public.guard_archived_table();
