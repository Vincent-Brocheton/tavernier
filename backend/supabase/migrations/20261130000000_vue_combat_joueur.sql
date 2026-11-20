-- Vue du combat pour les joueurs (US-36, EF-VJ-01 à 06). Le journal reste
-- au MJ seul : son appareil publie une vue filtrée (combat_view), sans
-- journal, ni Étude, ni PV ou CA des adversaires, ni adversaires cachés. Le
-- joueur envoie ce qu'il fait pour son PJ (combat_request) ; l'appareil du MJ
-- l'applique au journal, et la version du MJ prime (EF-VJ-06).

create table public.combat_view (
  -- Une vue par rencontre : son identifiant est celui de la rencontre.
  id text primary key references public.encounter (id) on delete cascade,
  table_id text not null references public.game_table (id) on delete cascade,
  payload text not null default '{}',
  updated_at timestamptz not null default now()
);

alter table public.combat_view enable row level security;

create policy combat_view_read on public.combat_view for select
to authenticated
using (public.is_table_member(table_id) or public.is_table_gm(table_id));
create policy combat_view_insert on public.combat_view for insert
to authenticated with check (public.can_manage_table(table_id));
create policy combat_view_update on public.combat_view for update
to authenticated
using (public.can_manage_table(table_id))
with check (public.can_manage_table(table_id));
create policy combat_view_delete on public.combat_view for delete
to authenticated using (public.can_manage_table(table_id));

-- La vue est celle d'une rencontre de sa table.
create function public.guard_combat_view() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.encounter e
    where e.id = new.id and e.table_id = new.table_id
  ) then
    raise insufficient_privilege using message = 'vue du combat : autre table';
  end if;
  return new;
end
$$;

create trigger guard_combat_view before insert or update
on public.combat_view
for each row execute function public.guard_combat_view();

create table public.combat_request (
  id text primary key,
  encounter_id text not null references public.encounter (id) on delete cascade,
  table_id text not null references public.game_table (id) on delete cascade,
  character_id text not null references public.character (id) on delete cascade,
  author_user_id uuid references auth.users (id) on delete set null,
  type text not null check (length(type) > 0),
  payload text not null default '{}',
  created_at timestamptz not null default now()
);

alter table public.combat_request enable row level security;

-- Le propriétaire d'un PJ de la table, en son nom, sur une table active.
create function public.can_request_for(c text, t text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.character ch
    join public.game_table g on g.id = ch.table_id
    where ch.id = c and ch.table_id = t and ch.kind = 'pc'
      and ch.owner_user_id = auth.uid() and not g.archived
  );
$$;

create policy combat_request_read on public.combat_request for select
to authenticated
using (public.is_table_gm(table_id) or author_user_id = auth.uid());
create policy combat_request_insert on public.combat_request for insert
to authenticated with check (
  author_user_id = auth.uid() and public.can_request_for(character_id, table_id)
);
-- Ni mise à jour ni suppression pour le joueur ; le MJ fait le ménage.
create policy combat_request_delete on public.combat_request for delete
to authenticated using (public.is_table_gm(table_id));

-- La demande vise une rencontre de sa table.
-- En `security definer` : le joueur ne lit pas les rencontres (RLS du MJ).
create function public.guard_combat_request() returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.encounter e
    where e.id = new.encounter_id and e.table_id = new.table_id
  ) then
    raise insufficient_privilege using message = 'demande : autre table';
  end if;
  return new;
end
$$;

create trigger guard_combat_request before insert on public.combat_request
for each row execute function public.guard_combat_request();

alter publication powersync add table public.combat_view;
alter publication powersync add table public.combat_request;
