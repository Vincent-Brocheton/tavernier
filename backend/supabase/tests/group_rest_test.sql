-- Spec sync-backend : « Repos de groupe au serveur » (US-38, EF-PJ-19).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(12);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000d1', 'camille@test.local'),
  ('00000000-0000-0000-0000-0000000000d2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000d3', 'ines@test.local'),
  ('00000000-0000-0000-0000-0000000000d4', 'zoe@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values
  ('tr', '00000000-0000-0000-0000-0000000000d1', 'Brumeval',
   'pointBuy', 'fullHitPoints', 'average', 'xp'),
  ('ts', '00000000-0000-0000-0000-0000000000d4', 'Ailleurs',
   'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('r1', 'tr', '00000000-0000-0000-0000-0000000000d1', 'gm'),
  ('r2', 'tr', '00000000-0000-0000-0000-0000000000d2', 'player'),
  ('r3', 'tr', '00000000-0000-0000-0000-0000000000d3', 'player'),
  ('s1', 'ts', '00000000-0000-0000-0000-0000000000d4', 'gm');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status) values
  ('aldric', 'tr', '00000000-0000-0000-0000-0000000000d2', 'pc', 'Aldric',
   'srd:species:human', 'srd:background:soldier', 'active'),
  ('mira', 'tr', '00000000-0000-0000-0000-0000000000d3', 'pc', 'Mira',
   'srd:species:human', 'srd:background:acolyte', 'active'),
  ('brannoc', 'tr', '00000000-0000-0000-0000-0000000000d3', 'pc', 'Brannoc',
   'srd:species:dwarf', 'srd:background:soldier', 'active');
insert into session (id, table_id, title, date) values
  ('s12', 'tr', 'Le relais du Sel', '2026-10-30'),
  ('autre', 'ts', 'Ailleurs', '2026-10-30');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Le MJ déclenche le repos ; les membres le lisent.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d1');
select lives_ok(
  $$ insert into group_rest (id, table_id, session_id, kind, characters)
     values ('g1', 'tr', 's12', 'short', '["aldric","mira"]') $$,
  'Camille déclenche un repos court');
select throws_ok(
  $$ insert into group_rest (id, table_id, session_id, kind)
     values ('g2', 'tr', 'autre', 'long') $$,
  '42501', null, 'séance d''une autre table');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000d2');
select is((select kind from group_rest where id = 'g1'), 'short',
  'Hugo, joueur, lit le repos');
select throws_ok(
  $$ insert into group_rest (id, table_id, kind) values ('g3', 'tr', 'long') $$,
  '42501', null, 'un joueur ne déclenche pas de repos');
-- Le joueur signale sa fin pour son PJ.
select lives_ok(
  $$ insert into group_rest_done (id, rest_id, table_id, character_id,
       author_user_id, summary)
     values ('d1', 'g1', 'tr', 'aldric', auth.uid(), '{"hit_dice":2}') $$,
  'Hugo a terminé pour Aldric');
select throws_ok(
  $$ insert into group_rest_done (id, rest_id, table_id, character_id,
       author_user_id)
     values ('d2', 'g1', 'tr', 'mira', auth.uid()) $$,
  '42501', null, 'pas pour le PJ d''un autre');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000d3');
select throws_ok(
  $$ insert into group_rest_done (id, rest_id, table_id, character_id,
       author_user_id)
     values ('d3', 'g1', 'tr', 'brannoc', auth.uid()) $$,
  '42501', null, 'PJ non visé par le repos');
select is((select count(*)::int from group_rest_done), 1,
  'Inès voit qui a terminé');
reset role;

-- Le MJ le fait pour un joueur hors-ligne, puis clôt.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d1');
select lives_ok(
  $$ insert into group_rest_done (id, rest_id, table_id, character_id,
       author_user_id)
     values ('d4', 'g1', 'tr', 'mira', auth.uid()) $$,
  'Camille le fait pour Mira');
update group_rest set closed_at = now() where id = 'g1';
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000d2');
select throws_ok(
  $$ insert into group_rest_done (id, rest_id, table_id, character_id,
       author_user_id)
     values ('d5', 'g1', 'tr', 'aldric', auth.uid()) $$,
  '42501', null, 'repos clos');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000d4');
select is((select count(*)::int from group_rest), 0,
  'Zoé, hors de la table, ne voit pas le repos');
select is((select count(*)::int from group_rest_done), 0,
  'ni qui a terminé');
reset role;

select * from finish();
rollback;
