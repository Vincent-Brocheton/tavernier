-- Spec sync-backend : « Emplacements au serveur », « Statut d'une fiche de
-- table » (US-15, cahier §4.3).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(16);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000e1', 'mj@test.local'),
  ('00000000-0000-0000-0000-0000000000e2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000e3', 'ines@test.local'),
  ('00000000-0000-0000-0000-0000000000e4', 'inconnu@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values ('ts', '00000000-0000-0000-0000-0000000000e1', 'Brumeval',
  'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('m1', 'ts', '00000000-0000-0000-0000-0000000000e1', 'gm'),
  ('m2', 'ts', '00000000-0000-0000-0000-0000000000e2', 'player'),
  ('m3', 'ts', '00000000-0000-0000-0000-0000000000e3', 'player');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values ('ines', 'ts', '00000000-0000-0000-0000-0000000000e3', 'pc', 'Mira',
  'srd:species:elf', 'srd:background:sage', 'draft');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Emplacements ------------------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e2');
select throws_ok(
  $$ insert into pc_slot (id, table_id, player_user_id)
     values ('s0', 'ts', '00000000-0000-0000-0000-0000000000e2') $$,
  '42501', null, 'un joueur ne crée pas d''emplacement');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select lives_ok(
  $$ insert into pc_slot (id, table_id, player_user_id) values
     ('s1', 'ts', '00000000-0000-0000-0000-0000000000e2'),
     ('s2', 'ts', '00000000-0000-0000-0000-0000000000e2') $$,
  'le MJ attribue deux emplacements à Hugo');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e3');
select is((select count(*) from pc_slot)::int, 2,
  'un membre lit les emplacements de sa table');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e4');
select is((select count(*) from pc_slot)::int, 0, 'un inconnu ne les voit pas');
select throws_ok(
  $$ insert into character (id, table_id, owner_user_id, kind, name,
       species_id, background_id, status)
     values ('x', 'ts', auth.uid(), 'pc', 'Intrus', 'srd:species:elf',
       'srd:background:sage', 'draft') $$,
  '42501', null, 'une fiche ne se rattache pas à une table étrangère');
reset role;

-- Hugo crée sa fiche dans la table, puis remplit son emplacement.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e2');
select throws_ok(
  $$ insert into character (id, table_id, owner_user_id, kind, name,
       species_id, background_id, status)
     values ('triche', 'ts', auth.uid(), 'pc', 'Triche', 'srd:species:elf',
       'srd:background:sage', 'validated') $$,
  '42501', null, 'une fiche naît en création');
select lives_ok(
  $$ insert into character (id, table_id, owner_user_id, kind, name,
       species_id, background_id, status)
     values ('aldric', 'ts', auth.uid(), 'pc', 'Aldric', 'srd:species:human',
       'srd:background:soldier', 'draft') $$,
  'Hugo crée sa fiche dans la table');
select lives_ok(
  $$ update pc_slot set character_id = 'aldric' where id = 's1' $$,
  'il remplit son emplacement');
select throws_ok(
  $$ update pc_slot set character_id = 'ines' where id = 's2' $$,
  '42501', null, 'pas avec la fiche d''une autre');
select throws_ok(
  $$ update pc_slot set player_user_id = '00000000-0000-0000-0000-0000000000e3'
     where id = 's2' $$,
  '42501', null, 'il ne change que la fiche de l''emplacement');

-- Statuts.
select throws_ok(
  $$ update character set status = 'validated' where id = 'aldric' $$,
  '42501', null, 'le joueur ne valide pas sa propre fiche');
select lives_ok(
  $$ update character set status = 'submitted' where id = 'aldric' $$,
  'le joueur envoie sa fiche');
select lives_ok(
  $$ update character set status = 'draft' where id = 'aldric' $$,
  'et la reprend');
update character set status = 'submitted' where id = 'aldric';
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select throws_ok(
  $$ update character set status = 'validated' where id = 'ines' $$,
  '42501', null, 'le MJ ne valide qu''une fiche envoyée');
select lives_ok(
  $$ update character set status = 'changes_requested' where id = 'aldric' $$,
  'le MJ demande des corrections sur une fiche envoyée');
reset role;

-- Retrait : l'archivage passe la garde des statuts.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
delete from table_member where id = 'm3';
reset role;
select is((select status from character where id = 'ines')::text, 'archived',
  'au retrait, la fiche est archivée malgré la garde');

select * from finish();
rollback;
