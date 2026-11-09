-- Comptes Google (US-40, EF-CPT-01, EF-CPT-10).

-- L'inscription par Google ne porte pas de date de naissance : l'app la
-- demande à la première connexion. À 15 ans révolus, seule la date de la
-- vérification est gardée ; sinon, le compte (jamais valide) est supprimé.
-- Un compte déjà vérifié n'est jamais touché.
create function public.confirm_age(birth_date date) returns boolean
language plpgsql security definer set search_path = ''
as $$
begin
  if auth.uid() is null then
    raise insufficient_privilege;
  end if;
  if exists (
    select 1 from auth.users
    where id = auth.uid() and raw_user_meta_data ? 'age_checked_at'
  ) then
    return true;
  end if;
  if birth_date is null
     or birth_date > (current_date - interval '15 years')::date then
    delete from auth.users where id = auth.uid();
    return false;
  end if;
  update auth.users
  set raw_user_meta_data = coalesce(raw_user_meta_data, '{}'::jsonb)
    || jsonb_build_object('age_checked_at', now())
  where id = auth.uid();
  return true;
end
$$;

-- Vrai si le compte a un mot de passe : un compte Google qui en ajoute un ne
-- reçoit pas d'identité « email », seul le mot de passe chiffré le dit.
create function public.has_password() returns boolean
language sql stable security definer set search_path = ''
as $$
  select coalesce(encrypted_password, '') <> ''
  from auth.users where id = auth.uid();
$$;

revoke execute on function public.confirm_age(date) from public, anon;
revoke execute on function public.has_password() from public, anon;
grant execute on function public.confirm_age(date) to authenticated;
grant execute on function public.has_password() to authenticated;
