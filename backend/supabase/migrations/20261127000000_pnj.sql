-- PNJ du MJ (US-18, EF-PNJ-01 à 03, EF-ACT-06, cahier §11) : bloc de stats
-- (monstre de départ, bloc JSON) ou fiche complète liée, attitude et
-- informations cachées. Le MJ seul les voit.

create table public.npc_statblock (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  name text not null check (length(btrim(name)) > 0),
  folder text,
  monster_id text,
  -- Bloc de stats en JSON : monstre modifié ou bloc vide rempli.
  stat_block text,
  character_id text references public.character (id) on delete cascade,
  attitude text not null default 'indifferent'
    check (attitude in ('friendly', 'indifferent', 'hostile')),
  -- [{"dc": 10, "text": "…", "revealed": false}], dans l'ordre des paliers.
  hidden_info text not null default '[]',
  created_at timestamptz not null default now()
);

alter table public.npc_statblock enable row level security;

create policy npc_statblock_read on public.npc_statblock for select
to authenticated using (public.is_table_gm(table_id));
create policy npc_statblock_write on public.npc_statblock for all
to authenticated
using (public.can_manage_table(table_id))
with check (public.can_manage_table(table_id));

-- Une fiche liée est de la table du PNJ.
create function public.guard_npc_statblock() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if new.character_id is not null and not exists (
    select 1 from public.character c
    where c.id = new.character_id and c.table_id = new.table_id
  ) then
    raise insufficient_privilege using message = 'PNJ : fiche d''une autre table';
  end if;
  if tg_op = 'UPDATE' and new.table_id is distinct from old.table_id then
    raise insufficient_privilege using message = 'PNJ : autre table';
  end if;
  return new;
end
$$;

create trigger guard_npc_statblock
before insert or update on public.npc_statblock
for each row execute function public.guard_npc_statblock();

alter publication powersync add table public.npc_statblock;

-- Fiches complètes ouvertes aux membres : celles des PJ seulement, jamais
-- celles des PNJ du MJ.
create or replace function public.can_read_character(c text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.character ch
    left join public.game_table g on g.id = ch.table_id
    where ch.id = c and (
      ch.owner_user_id = auth.uid()
      or g.gm_user_id = auth.uid()
      or (g.full_sheets_visible and ch.kind = 'pc'
          and public.is_table_member(g.id))
    )
  );
$$;
