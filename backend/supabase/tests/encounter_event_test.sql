-- Spec sync-backend : « Journal du combat au serveur » (US-20).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(8);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000a1', 'camille@test.local'),
  ('00000000-0000-0000-0000-0000000000a2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000a4', 'zoe@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values
  ('tj', '00000000-0000-0000-0000-0000000000a1', 'Brumeval',
   'pointBuy', 'fullHitPoints', 'average', 'xp'),
  ('tz', '00000000-0000-0000-0000-0000000000a4', 'Ailleurs',
   'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('jm1', 'tj', '00000000-0000-0000-0000-0000000000a1', 'gm'),
  ('jm2', 'tj', '00000000-0000-0000-0000-0000000000a2', 'player'),
  ('jm4', 'tz', '00000000-0000-0000-0000-0000000000a4', 'gm');
insert into encounter (id, table_id, title) values
  ('relais', 'tj', 'Le relais du Sel'),
  ('autre', 'tz', 'Ailleurs');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select lives_ok(
  $$ insert into encounter_event (id, encounter_id, table_id, author_user_id,
       type, payload)
     values ('e1', 'relais', 'tj', auth.uid(), 'combat_started', '{}') $$,
  'Camille ajoute un événement');
select throws_ok(
  $$ insert into encounter_event (id, encounter_id, table_id, author_user_id,
       type)
     values ('e2', 'relais', 'tj', '00000000-0000-0000-0000-0000000000a2',
       'turn_advanced') $$,
  '42501', null, 'en son nom seulement');
select throws_ok(
  $$ insert into encounter_event (id, encounter_id, table_id, author_user_id,
       type)
     values ('e3', 'autre', 'tj', auth.uid(), 'turn_advanced') $$,
  '42501', null, 'rencontre d''une autre table');
update encounter_event set type = 'undo' where id = 'e1';
delete from encounter_event where id = 'e1';
select is((select type from encounter_event where id = 'e1'),
  'combat_started', 'ajout seul : ni modifié ni supprimé');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000a2');
select is((select count(*)::int from encounter_event), 0,
  'Hugo ne voit pas le journal');
select throws_ok(
  $$ insert into encounter_event (id, encounter_id, table_id, author_user_id,
       type)
     values ('h', 'relais', 'tj', auth.uid(), 'turn_advanced') $$,
  '42501', null, 'un joueur n''ajoute pas');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
delete from encounter where id = 'relais';
reset role;
select is((select count(*)::int from encounter_event), 0,
  'la rencontre supprimée emporte son journal');

update game_table set archived = true where id = 'tj';
insert into encounter (id, table_id, title) values ('r2', 'tj', 'R2');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select throws_ok(
  $$ insert into encounter_event (id, encounter_id, table_id, author_user_id,
       type)
     values ('a', 'r2', 'tj', auth.uid(), 'combat_started') $$,
  '42501', null, 'table archivée');
reset role;

select * from finish();
rollback;
