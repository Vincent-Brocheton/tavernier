-- Une fiche n'est rattachée qu'à une table à la fois (US-15, cahier §4.3) :
-- sa table se fixe une fois, d'aucune table vers une table dont on est
-- membre. Garde des fiches de us-15c, plus cette règle.
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
    return new;
  end if;
  is_owner := old.owner_user_id = auth.uid();
  is_gm := new.table_id is not null and public.is_table_gm(new.table_id);

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
