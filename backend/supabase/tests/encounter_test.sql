-- Spec sync-backend : « Rencontres au serveur » (US-19, EF-REN-01 à 05).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(13);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000f1', 'camille@test.local'),
  ('00000000-0000-0000-0000-0000000000f2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000f4', 'zoe@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values
  ('tr', '00000000-0000-0000-0000-0000000000f1', 'Brumeval',
   'pointBuy', 'fullHitPoints', 'average', 'xp'),
  ('tz', '00000000-0000-0000-0000-0000000000f4', 'Ailleurs',
   'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('rm1', 'tr', '00000000-0000-0000-0000-0000000000f1', 'gm'),
  ('rm2', 'tr', '00000000-0000-0000-0000-0000000000f2', 'player'),
  ('rm4', 'tz', '00000000-0000-0000-0000-0000000000f4', 'gm');
insert into session (id, table_id, title, date) values
  ('s12', 'tr', 'Le relais du Sel', '2026-10-30'),
  ('sz', 'tz', 'Ailleurs', '2026-10-30');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Le MJ prépare sa rencontre.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
select lives_ok(
  $$ insert into encounter (id, table_id, session_id, title)
     values ('relais', 'tr', 's12', 'Le relais du Sel') $$,
  'Camille crée une rencontre dans la séance 12');
select is(
  (select (status, hp_mode)::text from encounter where id = 'relais'),
  '(draft,average)', 'brouillon, PV moyens par défaut');
select lives_ok(
  $$ insert into encounter_group (id, encounter_id, table_id, kind, ref_id,
       quantity)
     values ('g1', 'relais', 'tr', 'monster', 'srd:monster:veteran', 2) $$,
  'deux vétérans');
select throws_ok(
  $$ insert into encounter_group (id, encounter_id, table_id, kind, ref_id,
       quantity)
     values ('g0', 'relais', 'tr', 'monster', 'srd:monster:wolf', 0) $$,
  '23514', null, 'quantité 0 refusée');
select throws_ok(
  $$ update encounter_group set quantity = 31 where id = 'g1' $$,
  '23514', null, 'quantité 31 refusée');
select throws_ok(
  $$ update encounter set session_id = 'sz' where id = 'relais' $$,
  '42501', null, 'séance d''une autre table');
select throws_ok(
  $$ insert into encounter (id, table_id, title) values ('vide', 'tr', ' ') $$,
  '23514', null, 'titre obligatoire');
reset role;

-- Un joueur ne voit ni ne crée de rencontre.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f2');
select is((select count(*)::int from encounter), 0,
  'Hugo ne voit aucune rencontre');
select is((select count(*)::int from encounter_group), 0,
  'ni aucun groupe');
select throws_ok(
  $$ insert into encounter (id, table_id, title) values ('h', 'tr', 'H') $$,
  '42501', null, 'un joueur ne crée pas de rencontre');
reset role;

-- Séance supprimée : la rencontre reste en réserve ; rencontre supprimée :
-- ses groupes partent avec elle.
delete from session where id = 's12';
select is((select session_id from encounter where id = 'relais'), null,
  'la rencontre reste, sans séance');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
delete from encounter where id = 'relais';
reset role;
select is((select count(*)::int from encounter_group), 0,
  'ses groupes sont supprimés');

-- Table archivée : rien ne s'écrit.
update game_table set archived = true where id = 'tr';
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
select throws_ok(
  $$ insert into encounter (id, table_id, title) values ('a', 'tr', 'A') $$,
  '42501', null, 'table archivée');
reset role;

select * from finish();
rollback;
