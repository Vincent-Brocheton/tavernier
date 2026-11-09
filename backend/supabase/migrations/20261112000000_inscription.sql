-- Inscription (US-12, EF-CPT-01) : 15 ans au moins, vérifiés par le serveur,
-- sans conserver la date de naissance ; puis le profil, avec le pseudonyme.

-- Avant la création : une inscription par e-mail doit porter une date de
-- naissance de 15 ans révolus. La date est remplacée par celle de la
-- vérification : celle d'un utilisateur parfois mineur n'est jamais stockée.
-- Les autres fournisseurs (Google, US-40) vérifient l'âge après coup.
create function public.check_signup_age() returns trigger
language plpgsql security definer set search_path = ''
as $$
declare
  birth date;
begin
  if coalesce(new.raw_app_meta_data->>'provider', '') <> 'email' then
    return new;
  end if;
  begin
    birth := (new.raw_user_meta_data->>'birth_date')::date;
  exception when others then
    birth := null;
  end;
  if birth is null or birth > (current_date - interval '15 years')::date then
    raise check_violation
      using message = 'Il faut avoir au moins 15 ans pour créer un compte.';
  end if;
  new.raw_user_meta_data := (new.raw_user_meta_data - 'birth_date')
    || jsonb_build_object('age_checked_at', now());
  return new;
end
$$;

create trigger check_signup_age
before insert on auth.users
for each row execute function public.check_signup_age();

-- Après la création : le profil, synchronisé ensuite vers l'appareil.
create function public.create_profile() returns trigger
language plpgsql security definer set search_path = ''
as $$
begin
  insert into public.profile (id, pseudonym)
  values (
    new.id,
    coalesce(
      nullif(trim(new.raw_user_meta_data->>'pseudonym'), ''),
      split_part(new.email, '@', 1)
    )
  )
  on conflict (id) do nothing;
  return new;
end
$$;

create trigger create_profile
after insert on auth.users
for each row execute function public.create_profile();
