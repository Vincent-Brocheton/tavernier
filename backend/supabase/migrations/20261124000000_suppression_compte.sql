-- Suppression du compte (US-17, EF-CPT-04, ENF-10) et table sans MJ en
-- lecture seule (décision du 25 octobre 2026).

-- Supprime le compte de l'appelant. Les clés étrangères font le reste :
-- profil, appartenances, emplacements, invitations et personnages partent ;
-- ses tables restent sans MJ ; les historiques gardent leurs lignes, sans
-- auteur.
create function public.delete_my_account() returns void
language plpgsql security definer set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise insufficient_privilege;
  end if;
  delete from auth.users where id = auth.uid();
end
$$;
revoke execute on function public.delete_my_account() from public, anon;
grant execute on function public.delete_my_account() to authenticated;

-- Table archivée : seule sa restauration la modifie, côté utilisateurs. Le
-- serveur, lui, retire le MJ d'une table archivée qui supprime son compte.
create or replace function public.guard_archived_table() returns trigger
language plpgsql
as $$
begin
  if current_user = 'authenticated' and old.archived and new.archived then
    raise insufficient_privilege using message = 'table archivée';
  end if;
  return new;
end
$$;

-- Fiche d'une table sans MJ : lecture seule.
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
      and (ch.table_id is null or g.gm_user_id is not null)
  );
$$;

-- Le joueur ne change que la fiche de son emplacement, vers une fiche à lui
-- de la même table, et jamais dans une table sans MJ.
create or replace function public.guard_pc_slot() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if current_user <> 'authenticated' or public.is_table_gm(old.table_id) then
    return new;
  end if;
  if not exists (
    select 1 from public.game_table g
    where g.id = old.table_id and g.gm_user_id is not null
  ) then
    raise insufficient_privilege using message = 'table sans MJ';
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
