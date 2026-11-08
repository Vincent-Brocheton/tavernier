-- Spec sync-backend : « Droits par table et par rôle ». Un MJ, deux joueurs et
-- un inconnu ; chaque règle est vérifiée sous l'identité concernée.
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(22);

-- Identités ------------------------------------------------------------------

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-00000000000a', 'mj@test.local'),
  ('00000000-0000-0000-0000-00000000000b', 'joueur1@test.local'),
  ('00000000-0000-0000-0000-00000000000c', 'joueur2@test.local'),
  ('00000000-0000-0000-0000-00000000000d', 'inconnu@test.local');

-- Hors de pg_temp : le rôle authenticated doit pouvoir les appeler.
create schema tests;
grant usage on schema tests to authenticated;

create function tests.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claim.sub', u, true);
  perform set_config(
    'request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text,
    true
  );
end
$$;

create function tests.as_admin() returns void
language plpgsql as $$
begin
  execute 'reset role';
end
$$;

grant execute on all functions in schema tests to authenticated;

-- Le MJ crée sa table et y ajoute le premier joueur --------------------------

select tests.as_user('00000000-0000-0000-0000-00000000000a');

select lives_ok(
  $$ insert into game_table (id, gm_user_id, name, stat_method,
       long_rest_rule, hp_on_level_rule, progression_mode)
     values ('t1', '00000000-0000-0000-0000-00000000000a', 'Brumeval',
       'point_buy', 'full', 'average', 'xp') $$,
  'le MJ crée sa table'
);
select throws_ok(
  $$ insert into game_table (id, gm_user_id, name, stat_method,
       long_rest_rule, hp_on_level_rule, progression_mode)
     values ('t2', '00000000-0000-0000-0000-00000000000b', 'Usurpée',
       'point_buy', 'full', 'average', 'xp') $$,
  '42501',
  null,
  'personne ne crée une table au nom d''un autre'
);
select lives_ok(
  $$ insert into table_member (id, table_id, user_id, role) values
       ('m0', 't1', '00000000-0000-0000-0000-00000000000a', 'gm'),
       ('m1', 't1', '00000000-0000-0000-0000-00000000000b', 'player') $$,
  'le MJ ajoute ses membres'
);
select lives_ok(
  $$ insert into table_invite (id, table_id, code, expires_at)
     values ('i1', 't1', 'ABC123', now() + interval '7 days') $$,
  'le MJ crée une invitation'
);

-- Joueur 1 : membre ----------------------------------------------------------

select tests.as_user('00000000-0000-0000-0000-00000000000b');

select is((select count(*) from game_table)::int, 1, 'un membre voit sa table');
select is(
  (select count(*) from table_member)::int, 2,
  'un membre voit les membres'
);
select is(
  (select count(*) from table_invite)::int, 0,
  'un joueur ne voit pas les invitations'
);
select throws_ok(
  $$ insert into table_member (id, table_id, user_id, role) values
       ('m2', 't1', '00000000-0000-0000-0000-00000000000c', 'player') $$,
  '42501',
  null,
  'un joueur n''ajoute pas de membre'
);
select lives_ok(
  $$ insert into character (id, table_id, owner_user_id, kind, name,
       species_id, background_id, status)
     values ('c1', 't1', '00000000-0000-0000-0000-00000000000b', 'pc',
       'Thalia', 'srd:species:elf', 'srd:background:criminal', 'draft');
     insert into character_state (id, character_id, hp_current)
     values ('s1', 'c1', 33) $$,
  'un joueur crée sa fiche et son état'
);
select throws_ok(
  $$ insert into character (id, owner_user_id, kind, name, species_id,
       background_id, status)
     values ('c9', '00000000-0000-0000-0000-00000000000c', 'pc', 'Volée',
       'srd:species:elf', 'srd:background:criminal', 'draft') $$,
  '42501',
  null,
  'personne ne crée une fiche au nom d''un autre'
);
update game_table set name = 'Prise' where id = 't1';

-- Le MJ ajoute le second joueur ----------------------------------------------

select tests.as_user('00000000-0000-0000-0000-00000000000a');

select is(
  (select name from game_table where id = 't1'), 'Brumeval',
  'un joueur ne modifie pas la table'
);
insert into table_member (id, table_id, user_id, role) values
  ('m2', 't1', '00000000-0000-0000-0000-00000000000c', 'player');
select is(
  (select count(*) from character where id = 'c1')::int, 1,
  'le MJ voit la fiche de son joueur'
);
update character_state set hp_current = 20 where character_id = 'c1';
select is(
  (select hp_current from character_state where character_id = 'c1'), 20,
  'le MJ modifie l''état de la fiche'
);

-- Joueur 2 : fiches masquées, puis visibles en lecture -----------------------

select tests.as_user('00000000-0000-0000-0000-00000000000c');

select is(
  (select count(*) from character)::int, 0,
  'fiches masquées : un autre joueur ne voit pas la fiche'
);

select tests.as_user('00000000-0000-0000-0000-00000000000a');
update game_table set full_sheets_visible = true where id = 't1';

select tests.as_user('00000000-0000-0000-0000-00000000000c');

select is(
  (select count(*) from character_state)::int, 1,
  'fiches visibles : un autre joueur lit la fiche'
);
update character_state set hp_current = 1 where character_id = 'c1';
delete from character where id = 'c1';

select tests.as_user('00000000-0000-0000-0000-00000000000b');

select is(
  (select hp_current from character_state where character_id = 'c1'), 20,
  'un autre joueur ne modifie pas la fiche'
);
select is(
  (select count(*) from character where id = 'c1')::int, 1,
  'un autre joueur ne supprime pas la fiche'
);
select lives_ok(
  $$ insert into character_change_log (id, character_id, author_user_id, diff)
     values ('l1', 'c1', '00000000-0000-0000-0000-00000000000b', '{}') $$,
  'le propriétaire inscrit une modification'
);
update character_change_log set diff = '{"x":1}' where id = 'l1';
select is(
  (select diff from character_change_log where id = 'l1'), '{}',
  'l''historique ne se corrige pas'
);

-- Inconnu --------------------------------------------------------------------

select tests.as_user('00000000-0000-0000-0000-00000000000d');

select is(
  (select count(*) from game_table)::int
    + (select count(*) from character)::int
    + (select count(*) from table_member)::int,
  0,
  'un inconnu ne voit rien'
);

-- Profils --------------------------------------------------------------------

select tests.as_admin();
insert into profile (id, pseudonym) values
  ('00000000-0000-0000-0000-00000000000a', 'Camille'),
  ('00000000-0000-0000-0000-00000000000d', 'Inconnu');

select tests.as_user('00000000-0000-0000-0000-00000000000b');

select is(
  (select pseudonym from profile)::text, 'Camille',
  'un joueur voit le profil de son MJ, pas celui d''un inconnu'
);

-- Départ ---------------------------------------------------------------------

delete from table_member where id = 'm1';
select is(
  (select count(*) from game_table)::int, 0,
  'un joueur parti ne voit plus la table'
);

select * from finish();
rollback;
