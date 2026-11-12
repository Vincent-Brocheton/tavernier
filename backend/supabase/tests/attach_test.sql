-- Spec sync-backend : « Une table à la fois » (US-15, cahier §4.3).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(5);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000a1', 'mj@test.local'),
  ('00000000-0000-0000-0000-0000000000a2', 'leo@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values
  ('ta1', '00000000-0000-0000-0000-0000000000a1', 'Brumeval',
    'pointBuy', 'fullHitPoints', 'average', 'xp'),
  ('ta2', '00000000-0000-0000-0000-0000000000a1', 'Autre',
    'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('m1', 'ta1', '00000000-0000-0000-0000-0000000000a1', 'gm'),
  ('m2', 'ta1', '00000000-0000-0000-0000-0000000000a2', 'player'),
  ('m3', 'ta2', '00000000-0000-0000-0000-0000000000a1', 'gm'),
  ('m4', 'ta2', '00000000-0000-0000-0000-0000000000a2', 'player');
insert into character (id, owner_user_id, kind, name, species_id,
  background_id, status)
values ('kael', '00000000-0000-0000-0000-0000000000a2', 'pc', 'Kael',
  'srd:species:elf', 'srd:background:sage', 'draft');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000a2');
select lives_ok(
  $$ update character set table_id = 'ta1', status = 'submitted'
     where id = 'kael' $$,
  'Léo rattache son personnage libre et l''envoie');
select throws_ok(
  $$ update character set table_id = 'ta2' where id = 'kael' $$,
  '42501', null, 'une seule table à la fois');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000a1');
select lives_ok(
  $$ insert into character_change_log (id, character_id, author_user_id, diff)
     values ('d1', 'kael', auth.uid(),
       '{"kind": "derogation", "check": "level", "table": "1", "sheet": "3"}') $$,
  'le MJ inscrit une dérogation');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000a2');
select is((select count(*) from character_change_log where id = 'd1')::int, 1,
  'Léo la lit dans l''historique');
select throws_ok(
  $$ update character set table_id = null where id = 'kael' $$,
  '42501', null, 'pas de détachement non plus');
reset role;

select * from finish();
rollback;
