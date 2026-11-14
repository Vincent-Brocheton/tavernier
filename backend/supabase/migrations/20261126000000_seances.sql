-- Séances d'une table et présences prévues (US-35, EF-SEA-01, EF-SEA-02) ;
-- PX et déverrouillage de niveau tenus par le MJ (EF-SEA-05).

-- MJ d'une table ni archivée ni sans MJ.
create function public.can_manage_table(t text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.game_table g
    where g.id = t and g.gm_user_id = auth.uid() and not g.archived
  );
$$;

create table public.session (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  title text not null check (length(btrim(title)) > 0),
  date date not null,
  status text not null default 'planned'
    check (status in ('planned', 'in_progress', 'closed')),
  created_at timestamptz not null default now()
);

-- Une ligne par personnage présent ; décocher la supprime.
create table public.session_attendance (
  id text primary key,
  session_id text not null references public.session (id) on delete cascade,
  character_id text not null references public.character (id) on delete cascade,
  table_id text not null references public.game_table (id) on delete cascade,
  unique (session_id, character_id)
);

alter table public.session enable row level security;
alter table public.session_attendance enable row level security;

create policy session_read on public.session for select to authenticated
using (public.is_table_member(table_id));
create policy session_write on public.session for all to authenticated
using (public.can_manage_table(table_id))
with check (public.can_manage_table(table_id));

create policy session_attendance_read on public.session_attendance
for select to authenticated using (public.is_table_member(table_id));
create policy session_attendance_write on public.session_attendance
for all to authenticated
using (public.can_manage_table(table_id))
with check (public.can_manage_table(table_id));

-- La séance et la fiche sont de la table de la présence.
create function public.guard_session_attendance() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if not exists (
       select 1 from public.session s
       where s.id = new.session_id and s.table_id = new.table_id
     )
     or not exists (
       select 1 from public.character c
       where c.id = new.character_id and c.table_id = new.table_id
     ) then
    raise insufficient_privilege using message = 'présence : autre table';
  end if;
  return new;
end
$$;

create trigger guard_session_attendance
before insert or update on public.session_attendance
for each row execute function public.guard_session_attendance();

-- Une séance ne change pas de table.
create function public.guard_session() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if new.table_id is distinct from old.table_id then
    raise insufficient_privilege using message = 'séance : autre table';
  end if;
  return new;
end
$$;

create trigger guard_session before update on public.session
for each row execute function public.guard_session();

alter publication powersync add table public.session;
alter publication powersync add table public.session_attendance;

-- Garde des fiches (us-15) : en plus, une fiche naît sans déverrouillage, et
-- sur une fiche de table seul le MJ change les PX et le déverrouillage.
create or replace function public.guard_character() returns trigger
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
  if tg_op = 'UPDATE' and old.table_id is not null
     and new.table_id is distinct from old.table_id then
    raise insufficient_privilege using message = 'une table à la fois';
  end if;
  if tg_op = 'INSERT' then
    if new.status <> 'draft' or new.review_comment is not null then
      raise insufficient_privilege using message = 'une fiche naît en création';
    end if;
    if new.level_unlock is not null then
      raise insufficient_privilege using message = 'une fiche naît sans déverrouillage';
    end if;
    return new;
  end if;
  is_owner := old.owner_user_id = auth.uid();
  is_gm := new.table_id is not null and public.is_table_gm(new.table_id);

  if old.table_id is not null and not is_gm
     and (new.xp is distinct from old.xp
          or new.level_unlock is distinct from old.level_unlock) then
    raise insufficient_privilege using message = 'PX et déverrouillage : MJ seul';
  end if;
  if new.submit_message is distinct from old.submit_message and not is_owner then
    raise insufficient_privilege using message = 'message : propriétaire seul';
  end if;
  if new.review_comment is distinct from old.review_comment and not is_gm then
    raise insufficient_privilege using message = 'commentaire : MJ seul';
  end if;
  if new.owner_user_id is distinct from old.owner_user_id
     and not (is_gm and old.status <> 'archived' and exists (
       select 1 from public.table_member m
       where m.table_id = new.table_id and m.user_id = new.owner_user_id
     )) then
    raise insufficient_privilege using message = 'transfert : MJ seul, vers un membre';
  end if;

  if new.status is not distinct from old.status then
    return new;
  end if;
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
