-- Résumé d'une fiche de table, lu par les autres joueurs (US-15, EF-TAB-09) :
-- nom, espèce, classes et état de santé qualitatif, sans PV chiffrés. Publié
-- par l'appareil du propriétaire (les PV max se calculent avec le moteur).

create table public.character_summary (
  id text primary key references public.character (id) on delete cascade,
  table_id text not null references public.game_table (id) on delete cascade,
  owner_user_id uuid references auth.users (id) on delete set null,
  name text not null,
  species_id text not null,
  classes text not null default '[]',
  health text not null check (health in ('unhurt', 'wounded', 'badly')),
  updated_at timestamptz not null default now()
);

alter table public.character_summary enable row level security;

-- Le résumé suit sa fiche : même table, mêmes auteurs.
create function public.can_write_summary(c text, t text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select public.can_write_character(c) and exists (
    select 1 from public.character ch where ch.id = c and ch.table_id = t
  );
$$;

create policy character_summary_read on public.character_summary for select
to authenticated
using (public.is_table_member(table_id) or public.is_table_gm(table_id));
create policy character_summary_insert on public.character_summary
for insert to authenticated with check (public.can_write_summary(id, table_id));
create policy character_summary_update on public.character_summary
for update to authenticated
using (public.can_write_summary(id, table_id))
with check (public.can_write_summary(id, table_id));
create policy character_summary_delete on public.character_summary
for delete to authenticated using (public.can_write_character(id));

alter publication powersync add table public.character_summary;

-- Retrait d'un joueur : fiches archivées, emplacements et résumés supprimés.
-- Le groupe ne montre plus un PJ parti.
create or replace function public.archive_member_characters() returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  update public.character set status = 'archived'
  where table_id = old.table_id and owner_user_id = old.user_id;
  delete from public.pc_slot
  where table_id = old.table_id and player_user_id = old.user_id;
  delete from public.character_summary
  where table_id = old.table_id and owner_user_id = old.user_id;
  return old;
end
$$;
