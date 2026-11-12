-- Spec sync-backend : « Revue et transfert au serveur » (US-15, cahier §4.3).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(9);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000f1', 'mj@test.local'),
  ('00000000-0000-0000-0000-0000000000f2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000f3', 'ines@test.local'),
  ('00000000-0000-0000-0000-0000000000f4', 'inconnu@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values ('tr', '00000000-0000-0000-0000-0000000000f1', 'Brumeval',
  'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('m1', 'tr', '00000000-0000-0000-0000-0000000000f1', 'gm'),
  ('m2', 'tr', '00000000-0000-0000-0000-0000000000f2', 'player'),
  ('m3', 'tr', '00000000-0000-0000-0000-0000000000f3', 'player');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values ('aldric', 'tr', '00000000-0000-0000-0000-0000000000f2', 'pc', 'Aldric',
  'srd:species:human', 'srd:background:soldier', 'draft');
insert into pc_slot (id, table_id, player_user_id, character_id) values
  ('s1', 'tr', '00000000-0000-0000-0000-0000000000f2', 'aldric'),
  ('s2', 'tr', '00000000-0000-0000-0000-0000000000f2', null);

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Message et commentaire ----------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000f2');
select lives_ok(
  $$ update character set status = 'submitted',
       submit_message = 'Je garde l''épée longue.' where id = 'aldric' $$,
  'le joueur envoie sa fiche avec un message');
select throws_ok(
  $$ update character set review_comment = 'Parfait' where id = 'aldric' $$,
  '42501', null, 'le joueur n''écrit pas le commentaire de revue');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
select throws_ok(
  $$ update character set submit_message = 'Autre' where id = 'aldric' $$,
  '42501', null, 'le MJ n''écrit pas le message du joueur');
select lives_ok(
  $$ update character set status = 'changes_requested',
       review_comment = 'Remplace la botte.' where id = 'aldric' $$,
  'le MJ demande des corrections avec un commentaire');

-- Transfert ----------------------------------------------------------------------

select throws_ok(
  $$ update character set owner_user_id = '00000000-0000-0000-0000-0000000000f4'
     where id = 'aldric' $$,
  '42501', null, 'pas de transfert hors de la table');
select lives_ok(
  $$ update character set owner_user_id = '00000000-0000-0000-0000-0000000000f3'
     where id = 'aldric';
     update pc_slot set player_user_id = '00000000-0000-0000-0000-0000000000f3'
     where id = 's1' $$,
  'le MJ transfère la fiche et son emplacement à Inès');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000f3');
select throws_ok(
  $$ update character set owner_user_id = '00000000-0000-0000-0000-0000000000f2'
     where id = 'aldric' $$,
  '42501', null, 'un joueur ne transfère pas sa fiche');
reset role;

-- Retrait --------------------------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
delete from table_member where id = 'm2';
select is((select count(*) from pc_slot where id = 's2')::int, 0,
  'les emplacements du joueur retiré disparaissent');
select is((select count(*) from pc_slot where id = 's1')::int, 1,
  'l''emplacement transféré reste');
reset role;

select * from finish();
rollback;
