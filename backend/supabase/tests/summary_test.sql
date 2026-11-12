-- Spec sync-backend : « Résumés des fiches au serveur » (US-15, EF-TAB-09).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(7);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000b1', 'mj@test.local'),
  ('00000000-0000-0000-0000-0000000000b2', 'mira@test.local'),
  ('00000000-0000-0000-0000-0000000000b3', 'thalia@test.local'),
  ('00000000-0000-0000-0000-0000000000b4', 'inconnu@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values ('tg', '00000000-0000-0000-0000-0000000000b1', 'Brumeval',
  'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('m1', 'tg', '00000000-0000-0000-0000-0000000000b1', 'gm'),
  ('m2', 'tg', '00000000-0000-0000-0000-0000000000b2', 'player'),
  ('m3', 'tg', '00000000-0000-0000-0000-0000000000b3', 'player');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values
  ('mira', 'tg', '00000000-0000-0000-0000-0000000000b2', 'pc', 'Mira',
    'srd:species:human', 'srd:background:acolyte', 'validated'),
  ('thalia', 'tg', '00000000-0000-0000-0000-0000000000b3', 'pc', 'Thalia',
    'srd:species:elf', 'srd:background:criminal', 'validated');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000b3');
select lives_ok(
  $$ insert into character_summary (id, table_id, owner_user_id, name,
       species_id, classes, health)
     values ('thalia', 'tg', auth.uid(), 'Thalia', 'srd:species:elf',
       '[{"class_id": "srd:class:rogue", "level": 1}]', 'wounded') $$,
  'Thalia publie le résumé de sa fiche');
select throws_ok(
  $$ insert into character_summary (id, table_id, owner_user_id, name,
       species_id, classes, health)
     values ('mira', 'tg', '00000000-0000-0000-0000-0000000000b2', 'Mira',
       'srd:species:human', '[]', 'badly') $$,
  '42501', null, 'pas celui d''une autre');
select throws_ok(
  $$ update character_summary set table_id = 'ailleurs' where id = 'thalia' $$,
  '42501', null, 'seulement pour la table de la fiche');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000b2');
select is((select health from character_summary where id = 'thalia')::text,
  'wounded', 'Mira lit l''état de Thalia');
select is((select count(*) from character where id = 'thalia')::int, 0,
  'sans lire sa fiche');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000b4');
select is((select count(*) from character_summary)::int, 0,
  'un inconnu ne lit rien');
reset role;

-- Retrait : le résumé quitte le groupe.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000b1');
delete from table_member where id = 'm3';
reset role;
select is((select count(*) from character_summary where id = 'thalia')::int, 0,
  'au retrait, le résumé disparaît');

select * from finish();
rollback;
