-- Spec sync-backend : « Séances au serveur » et « PX et déverrouillage tenus
-- par le MJ » (US-35, EF-SEA-01, EF-SEA-02, EF-SEA-05).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(20);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000d1', 'camille@test.local'),
  ('00000000-0000-0000-0000-0000000000d2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000d3', 'ines@test.local'),
  ('00000000-0000-0000-0000-0000000000d4', 'zoe@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values
  ('ts', '00000000-0000-0000-0000-0000000000d1', 'Brumeval',
   'pointBuy', 'fullHitPoints', 'average', 'xp'),
  ('tz', '00000000-0000-0000-0000-0000000000d4', 'Ailleurs',
   'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('sm1', 'ts', '00000000-0000-0000-0000-0000000000d1', 'gm'),
  ('sm2', 'ts', '00000000-0000-0000-0000-0000000000d2', 'player'),
  ('sm3', 'ts', '00000000-0000-0000-0000-0000000000d3', 'player'),
  ('sm4', 'tz', '00000000-0000-0000-0000-0000000000d4', 'gm');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status, xp)
values
  ('aldric', 'ts', '00000000-0000-0000-0000-0000000000d2', 'pc', 'Aldric',
   'srd:species:human', 'srd:background:soldier', 'validated', 7475),
  ('libre', null, '00000000-0000-0000-0000-0000000000d2', 'pc', 'Libre',
   'srd:species:human', 'srd:background:soldier', 'draft', 0),
  ('autre', 'tz', '00000000-0000-0000-0000-0000000000d4', 'pc', 'Autre',
   'srd:species:human', 'srd:background:soldier', 'validated', 0);

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Le MJ crée la séance et coche les présences.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d1');
select lives_ok(
  $$ insert into session (id, table_id, title, date)
     values ('s12', 'ts', 'Le relais du Sel', '2026-10-30') $$,
  'Camille crée une séance');
select is((select status from session where id = 's12'), 'planned',
  'une séance naît préparée');
select throws_ok(
  $$ insert into session (id, table_id, title, date)
     values ('s0', 'ts', '  ', '2026-10-30') $$,
  '23514', null, 'titre obligatoire');
select lives_ok(
  $$ insert into session_attendance (id, session_id, character_id, table_id)
     values ('s12:aldric', 's12', 'aldric', 'ts') $$,
  'Camille marque Aldric présent');
select throws_ok(
  $$ insert into session_attendance (id, session_id, character_id, table_id)
     values ('s12:autre', 's12', 'autre', 'ts') $$,
  '42501', null, 'un personnage d''une autre table');
select throws_ok(
  $$ update session set table_id = 'tz' where id = 's12' $$,
  '42501', null, 'une séance ne change pas de table');
select lives_ok(
  $$ update character set level_unlock = '{"level":6,"origin":"milestone"}'
     where id = 'aldric' $$,
  'Camille accorde un niveau');
select lives_ok(
  $$ update character set xp = 8300 where id = 'aldric' $$,
  'Camille change les PX');
reset role;

-- Un joueur lit, mais n'écrit pas.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d2');
select is((select title from session where id = 's12'), 'Le relais du Sel',
  'Hugo lit la séance');
select is((select count(*)::int from session_attendance where session_id = 's12'),
  1, 'Hugo voit qu''Aldric est attendu');
select throws_ok(
  $$ insert into session (id, table_id, title, date)
     values ('s13', 'ts', 'Hugo', '2026-11-13') $$,
  '42501', null, 'un joueur ne crée pas de séance');
delete from session_attendance where id = 's12:aldric';
select is((select count(*)::int from session_attendance where session_id = 's12'),
  1, 'Hugo ne retire pas une présence');
select throws_ok(
  $$ update character set level_unlock = '{"level":20,"origin":"override"}'
     where id = 'aldric' $$,
  '42501', null, 'Hugo ne s''accorde pas de niveau');
select throws_ok(
  $$ update character set xp = 14000 where id = 'aldric' $$,
  '42501', null, 'Hugo ne change pas ses PX');
select lives_ok(
  $$ update character set name = 'Aldric Varenne' where id = 'aldric' $$,
  'Hugo modifie le reste de sa fiche');
select lives_ok(
  $$ update character set xp = 300 where id = 'libre' $$,
  'les PX d''une fiche libre restent libres');
select throws_ok(
  $$ insert into character (id, owner_user_id, kind, name, species_id,
       background_id, status, level_unlock)
     values ('neuve', auth.uid(), 'pc', 'Neuve', 'srd:species:human',
       'srd:background:soldier', 'draft', '{"level":2,"origin":"override"}') $$,
  '42501', null, 'une fiche naît sans déverrouillage');
reset role;

-- Hors de la table : rien.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d4');
select is((select count(*)::int from session), 0,
  'Zoé ne voit pas les séances de Brumeval');
reset role;

-- Table archivée : séances figées ; suppression en cascade.
update game_table set archived = true where id = 'ts';
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d1');
update session set title = 'Autre' where id = 's12';
select is((select title from session where id = 's12'), 'Le relais du Sel',
  'table archivée : séance inchangée');
reset role;
update game_table set archived = false where id = 'ts';
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d1');
delete from session where id = 's12';
reset role;
select is((select count(*)::int from session_attendance), 0,
  'supprimer la séance supprime ses présences');

select * from finish();
rollback;
