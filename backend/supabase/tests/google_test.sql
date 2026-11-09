-- Spec sync-backend : « Âge des comptes sans date à l'inscription », « Mot de
-- passe défini » (US-40, EF-CPT-01, EF-CPT-10).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(8);

-- Comptes créés par Google : pas de date de naissance à l'inscription.
insert into auth.users (id, email, raw_app_meta_data, raw_user_meta_data)
values
  ('00000000-0000-0000-0000-0000000000b1', 'ines@gmail.test',
   '{"provider": "google"}', '{"full_name": "Inès"}'),
  ('00000000-0000-0000-0000-0000000000b2', 'jeune@gmail.test',
   '{"provider": "google"}', '{}');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

select ok(
  (select not (raw_user_meta_data ? 'age_checked_at') from auth.users
   where id = '00000000-0000-0000-0000-0000000000b1'),
  'un compte Google naît sans vérification d''âge'
);

select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select is(has_password(), false, 'un compte Google n''a pas de mot de passe');
select is(
  confirm_age((current_date - interval '15 years')::date), true,
  '15 ans révolus : âge vérifié'
);
reset role;
select ok(
  (select raw_user_meta_data ? 'age_checked_at'
      and not (raw_user_meta_data ? 'birth_date')
   from auth.users where id = '00000000-0000-0000-0000-0000000000b1'),
  'la vérification est gardée, pas la date'
);

-- Déjà vérifié : une seconde déclaration ne change rien.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select is(
  confirm_age(current_date), true,
  'un compte déjà vérifié ne peut pas se faire supprimer ainsi'
);
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000b2');
select is(
  confirm_age((current_date - interval '10 years')::date), false,
  'moins de 15 ans : refusé'
);
reset role;
select is(
  (select count(*) from auth.users
   where id = '00000000-0000-0000-0000-0000000000b2')::int, 0,
  'le compte trop jeune est supprimé'
);

update auth.users set encrypted_password = 'empreinte'
where id = '00000000-0000-0000-0000-0000000000b1';
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
select is(has_password(), true, 'une fois défini, le mot de passe est vu');
reset role;

select * from finish();
rollback;
