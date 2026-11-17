-- Rencontres préparées (US-19, EF-REN-01 à 05, cahier §6.1 et §11) : une
-- rencontre, rangée dans une séance ou en réserve, et ses groupes
-- d'adversaires (monstre ou PNJ, quantité). Le MJ seul les voit. La
-- difficulté se calcule dans l'app, selon les PJ présents.

create table public.encounter (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  session_id text references public.session (id) on delete set null,
  title text not null check (length(btrim(title)) > 0),
  status text not null default 'draft'
    check (status in ('draft', 'ready', 'running', 'finished')),
  hp_mode text not null default 'average'
    check (hp_mode in ('average', 'roll')),
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

alter table public.encounter enable row level security;
alter table public.encounter_group enable row level security;

create policy encounter_read on public.encounter for select
to authenticated using (public.is_table_gm(table_id));
create policy encounter_write on public.encounter for all to authenticated
using (public.can_manage_table(table_id))
with check (public.can_manage_table(table_id));

create policy encounter_group_read on public.encounter_group for select
to authenticated using (public.is_table_gm(table_id));
create policy encounter_group_write on public.encounter_group for all
to authenticated
using (public.can_manage_table(table_id))
with check (public.can_manage_table(table_id));

-- La séance d'une rencontre est de sa table ; une rencontre ne change pas de
-- table.
create function public.guard_encounter() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if tg_op = 'UPDATE' and new.table_id is distinct from old.table_id then
    raise insufficient_privilege using message = 'rencontre : autre table';
  end if;
  if new.session_id is not null and not exists (
    select 1 from public.session s
    where s.id = new.session_id and s.table_id = new.table_id
  ) then
    raise insufficient_privilege using message = 'rencontre : séance d''une autre table';
  end if;
  return new;
end
$$;

create trigger guard_encounter before insert or update on public.encounter
for each row execute function public.guard_encounter();

-- Un groupe est de la table de sa rencontre.
create function public.guard_encounter_group() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.encounter e
    where e.id = new.encounter_id and e.table_id = new.table_id
  ) then
    raise insufficient_privilege using message = 'groupe : autre table';
  end if;
  return new;
end
$$;

create trigger guard_encounter_group
before insert or update on public.encounter_group
for each row execute function public.guard_encounter_group();

alter publication powersync add table public.encounter;
alter publication powersync add table public.encounter_group;
