-- Invitations : rejoindre une table, retrait d'un joueur (US-14, EF-TAB-05,
-- EF-TAB-06, EF-TAB-08).

-- Échecs pour rejoindre, par compte : freine la recherche de codes au hasard.
-- Aucune règle d'accès : seule join_table y touche.
create table public.join_attempt (
  user_id uuid not null references auth.users (id) on delete cascade,
  at timestamptz not null default now()
);
create index join_attempt_user_at on public.join_attempt (user_id, at);
alter table public.join_attempt enable row level security;

-- Rejoint, comme joueur, la table d'une invitation valide. Rend
-- {"table_id": …} ou {"error": motif} : une exception annulerait aussi
-- l'échec noté.
create function public.join_table(code text) returns jsonb
language plpgsql security definer set search_path = ''
as $$
declare
  me uuid := auth.uid();
  invite public.table_invite;
  is_archived boolean;
  motif text;
begin
  if me is null then
    return jsonb_build_object('error', 'not_signed_in');
  end if;
  -- ponytail: freinage par compte ; un attaquant à plusieurs comptes passe
  -- au travers, à compléter par une limite par adresse IP si besoin.
  if (select count(*) from public.join_attempt
      where user_id = me and at > now() - interval '1 hour') >= 10 then
    return jsonb_build_object('error', 'too_many_attempts');
  end if;

  select * into invite from public.table_invite i
  where i.code = upper(trim(join_table.code));
  select g.archived into is_archived from public.game_table g
  where g.id = invite.table_id;

  motif := case
    when invite.id is null then 'invalid_code'
    when invite.revoked or invite.expires_at <= now() then 'expired_code'
    when coalesce(is_archived, false) then 'archived_table'
  end;
  if motif is not null then
    insert into public.join_attempt (user_id) values (me);
    return jsonb_build_object('error', motif);
  end if;

  insert into public.table_member (id, table_id, user_id, role)
  values (gen_random_uuid()::text, invite.table_id, me, 'player')
  on conflict (table_id, user_id) do nothing;
  return jsonb_build_object('table_id', invite.table_id);
end
$$;
revoke execute on function public.join_table(text) from public, anon;
grant execute on function public.join_table(text) to authenticated;

-- Retrait d'un joueur (ou départ) : ses fiches de la table sont archivées,
-- pas supprimées.
create function public.archive_member_characters() returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  update public.character set status = 'archived'
  where table_id = old.table_id and owner_user_id = old.user_id;
  return old;
end
$$;

create trigger archive_member_characters
after delete on public.table_member
for each row execute function public.archive_member_characters();

-- Fiche archivée : lecture seule, comme celle d'une table archivée.
create or replace function public.can_write_character(c text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.character ch
    left join public.game_table g on g.id = ch.table_id
    where ch.id = c
      and (ch.owner_user_id = auth.uid() or g.gm_user_id = auth.uid())
      and not coalesce(g.archived, false)
      and ch.status <> 'archived'
  );
$$;
