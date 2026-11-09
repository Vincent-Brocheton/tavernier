-- Spec sync-backend : « Inscription côté serveur » (US-12, EF-CPT-01).
-- Comptes créés comme par Supabase Auth pour une inscription par e-mail.
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(6);

-- Quinze ans révolus aujourd'hui.
select lives_ok(
  format(
    $$ insert into auth.users (id, email, raw_app_meta_data, raw_user_meta_data)
       values ('00000000-0000-0000-0000-0000000000e1', 'hugo@test.local',
         '{"provider": "email"}',
         jsonb_build_object('pseudonym', 'Hugo', 'birth_date', %L)) $$,
    (current_date - interval '15 years')::date
  ),
  'inscription à 15 ans révolus'
);
select is(
  (select pseudonym from profile
   where id = '00000000-0000-0000-0000-0000000000e1')::text,
  'Hugo',
  'le profil est créé avec le pseudonyme'
);
select ok(
  (select not (raw_user_meta_data ? 'birth_date')
      and raw_user_meta_data ? 'age_checked_at'
   from auth.users where id = '00000000-0000-0000-0000-0000000000e1'),
  'la date de naissance n''est pas conservée, la vérification l''est'
);

-- Un jour de moins.
select throws_ok(
  format(
    $$ insert into auth.users (id, email, raw_app_meta_data, raw_user_meta_data)
       values ('00000000-0000-0000-0000-0000000000e2', 'jeune@test.local',
         '{"provider": "email"}',
         jsonb_build_object('pseudonym', 'Jeune', 'birth_date', %L)) $$,
    (current_date - interval '15 years' + interval '1 day')::date
  ),
  '23514',
  null,
  'inscription refusée à un jour des 15 ans'
);
select throws_ok(
  $$ insert into auth.users (id, email, raw_app_meta_data, raw_user_meta_data)
     values ('00000000-0000-0000-0000-0000000000e3', 'sansdate@test.local',
       '{"provider": "email"}', '{"pseudonym": "Sans date"}') $$,
  '23514',
  null,
  'inscription refusée sans date de naissance'
);

-- Sans pseudonyme : celui-ci vient de l'adresse.
insert into auth.users (id, email, raw_app_meta_data, raw_user_meta_data)
values ('00000000-0000-0000-0000-0000000000e4', 'camille@test.local',
  '{"provider": "email"}', '{"birth_date": "1990-05-01"}');
select is(
  (select pseudonym from profile
   where id = '00000000-0000-0000-0000-0000000000e4')::text,
  'camille',
  'sans pseudonyme, le profil prend le début de l''adresse'
);

select * from finish();
rollback;
