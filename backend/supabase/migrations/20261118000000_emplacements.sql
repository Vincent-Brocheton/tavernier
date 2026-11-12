-- Emplacements de PJ et statut des fiches de table (US-15, cahier §4.3).

create table public.pc_slot (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  player_user_id uuid not null references auth.users (id) on delete cascade,
  character_id text references public.character (id) on delete set null,
  created_at timestamptz not null default now()
);

alter table public.pc_slot enable row level security;
create policy pc_slot_read on public.pc_slot for select to authenticated
using (public.is_table_member(table_id) or public.is_table_gm(table_id));
create policy pc_slot_insert on public.pc_slot for insert to authenticated
with check (public.is_table_gm(table_id));
create policy pc_slot_delete on public.pc_slot for delete to authenticated
using (public.is_table_gm(table_id));
create policy pc_slot_update on public.pc_slot for update to authenticated
using (public.is_table_gm(table_id) or player_user_id = auth.uid())
with check (public.is_table_gm(table_id) or player_user_id = auth.uid());

alter publication powersync add table public.pc_slot;

-- Le joueur ne change que la fiche de son emplacement, et seulement vers
-- une fiche à lui, de la même table.
create function public.guard_pc_slot() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if current_user <> 'authenticated' or public.is_table_gm(old.table_id) then
    return new;
  end if;
  if new.table_id is distinct from old.table_id
     or new.player_user_id is distinct from old.player_user_id
     or new.created_at is distinct from old.created_at
     or (new.character_id is not null and not exists (
       select 1 from public.character c
       where c.id = new.character_id
         and c.owner_user_id = auth.uid()
         and c.table_id = new.table_id
     )) then
    raise insufficient_privilege using message = 'emplacement : fiche refusée';
  end if;
  return new;
end
$$;

create trigger guard_pc_slot
before update on public.pc_slot
for each row execute function public.guard_pc_slot();

-- Fiche : rattachée seulement à une table dont on est membre ; passages de
-- statut permis seulement. Le serveur lui-même (archivage au retrait,
-- fonctions security definer) n'est pas concerné.
create function public.guard_character() returns trigger
language plpgsql set search_path = ''
as $$
declare
  is_owner boolean;
  is_gm boolean;
begin
  if current_user <> 'authenticated' then
    return new;
  end if;
  if new.table_id is not null
     and (tg_op = 'INSERT' or new.table_id is distinct from old.table_id)
     and not public.is_table_member(new.table_id) then
    raise insufficient_privilege using message = 'table étrangère';
  end if;
  if tg_op = 'INSERT' then
    if new.status <> 'draft' then
      raise insufficient_privilege using message = 'une fiche naît en création';
    end if;
    return new;
  end if;
  if new.status is not distinct from old.status then
    return new;
  end if;
  is_owner := old.owner_user_id = auth.uid();
  is_gm := new.table_id is not null and public.is_table_gm(new.table_id);
  if (is_owner and old.status in ('draft', 'changes_requested')
        and new.status = 'submitted')
     or (is_owner and old.status = 'submitted' and new.status = 'draft')
     or (is_gm and old.status = 'submitted'
        and new.status in ('validated', 'changes_requested')) then
    return new;
  end if;
  raise insufficient_privilege
    using message = format('statut : %s vers %s refusé', old.status, new.status);
end
$$;

create trigger guard_character
before insert or update on public.character
for each row execute function public.guard_character();
