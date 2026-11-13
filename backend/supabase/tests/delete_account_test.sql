-- Spec sync-backend : « Suppression du compte », « Table sans MJ en lecture
-- seule » (US-17, EF-CPT-04, ENF-10).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(15);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000f1', 'mj@test.local'),
  ('00000000-0000-0000-0000-0000000000f2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000f3', 'ines@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode, archived)
values
  ('tf', '00000000-0000-0000-0000-0000000000f1', 'Brumeval',
   'pointBuy', 'fullHitPoints', 'average', 'xp', false),
  ('ta', '00000000-0000-0000-0000-0000000000f1', 'Ancienne campagne',
   'pointBuy', 'fullHitPoints', 'average', 'xp', true);
insert into table_member (id, table_id, user_id, role) values
  ('m1', 'tf', '00000000-0000-0000-0000-0000000000f1', 'gm'),
  ('m2', 'tf', '00000000-0000-0000-0000-0000000000f2', 'player'),
  ('m3', 'tf', '00000000-0000-0000-0000-0000000000f3', 'player');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values
  ('hugo', 'tf', '00000000-0000-0000-0000-0000000000f2', 'pc', 'Aldric',
   'srd:species:human', 'srd:background:soldier', 'validated'),
  ('mira', 'tf', '00000000-0000-0000-0000-0000000000f3', 'pc', 'Mira',
   'srd:species:elf', 'srd:background:sage', 'validated');
insert into pc_slot (id, table_id, player_user_id, character_id) values
  ('s1', 'tf', '00000000-0000-0000-0000-0000000000f2', 'hugo'),
  ('s2', 'tf', '00000000-0000-0000-0000-0000000000f3', 'mira');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Sans session ------------------------------------------------------------------

set local role anon;
select throws_ok($$ select delete_my_account() $$, '42501', null,
  'un appelant anonyme ne supprime rien');
reset role;
set local role authenticated;
select set_config('request.jwt.claims', '{"role": "authenticated"}', true);
select throws_ok($$ select delete_my_account() $$, '42501', null,
  'pas sans identité');
reset role;

-- Joueuse -----------------------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000f3');
select lives_ok($$ select delete_my_account() $$, 'Inès supprime son compte');
reset role;
select is((select count(*) from auth.users
  where id = '00000000-0000-0000-0000-0000000000f3')::int, 0,
  'le compte n''existe plus');
select is((select count(*) from profile
  where id = '00000000-0000-0000-0000-0000000000f3')::int, 0, 'ni son profil');
select is((select count(*) from table_member where id = 'm3')::int, 0,
  'ni son appartenance');
select is((select count(*) from character where id = 'mira')::int, 0,
  'Mira est retirée de la table');
select is((select count(*) from pc_slot where id = 's2')::int, 0,
  'ni son emplacement');
select is((select gm_user_id::text from game_table where id = 'tf'),
  '00000000-0000-0000-0000-0000000000f1', 'Brumeval garde son MJ');

-- MJ ----------------------------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
select lives_ok($$ select delete_my_account() $$,
  'le MJ supprime son compte, table archivée comprise');
reset role;
select is((select count(*) from game_table
  where id in ('tf', 'ta') and gm_user_id is null)::int, 2,
  'ses tables restent, sans MJ');
select is((select character_id from pc_slot where id = 's1'), 'hugo',
  'Hugo garde son emplacement et sa fiche');

-- Table sans MJ -----------------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000f2');
update character set name = 'Aldric le Brave' where id = 'hugo';
select is((select name from character where id = 'hugo'), 'Aldric',
  'la fiche d''une table sans MJ ne se modifie plus');
select is((select count(*) from character where id = 'hugo')::int, 1,
  'Hugo lit toujours sa fiche');
select throws_ok(
  $$ update pc_slot set character_id = null where id = 's1' $$,
  '42501', null, 'Hugo ne retire pas son PJ de la table');
reset role;

select * from finish();
rollback;
