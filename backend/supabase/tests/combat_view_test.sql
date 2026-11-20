-- Spec sync-backend : « Vue du combat au serveur », « Demandes des joueurs
-- au serveur » (US-36, EF-VJ-03, 05, 06).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(14);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000c1', 'camille@test.local'),
  ('00000000-0000-0000-0000-0000000000c2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000c3', 'ines@test.local'),
  ('00000000-0000-0000-0000-0000000000c4', 'zoe@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values
  ('tv', '00000000-0000-0000-0000-0000000000c1', 'Brumeval',
   'pointBuy', 'fullHitPoints', 'average', 'xp'),
  ('tw', '00000000-0000-0000-0000-0000000000c4', 'Ailleurs',
   'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('v1', 'tv', '00000000-0000-0000-0000-0000000000c1', 'gm'),
  ('v2', 'tv', '00000000-0000-0000-0000-0000000000c2', 'player'),
  ('v3', 'tv', '00000000-0000-0000-0000-0000000000c3', 'player'),
  ('w1', 'tw', '00000000-0000-0000-0000-0000000000c4', 'gm');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status) values
  ('aldric', 'tv', '00000000-0000-0000-0000-0000000000c2', 'pc', 'Aldric',
   'srd:species:human', 'srd:background:soldier', 'active'),
  ('mira', 'tv', '00000000-0000-0000-0000-0000000000c3', 'pc', 'Mira',
   'srd:species:human', 'srd:background:acolyte', 'active');
insert into encounter (id, table_id, title, status) values
  ('relais', 'tv', 'Le relais du Sel', 'running'),
  ('ailleurs', 'tw', 'Ailleurs', 'running');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Vue : publiée par le MJ, lue par les membres.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select lives_ok(
  $$ insert into combat_view (id, table_id, payload)
     values ('relais', 'tv', '{"round":3}') $$,
  'Camille publie la vue');
select lives_ok(
  $$ update combat_view set payload = '{"round":4}' where id = 'relais' $$,
  'et la met à jour');
select throws_ok(
  $$ insert into combat_view (id, table_id) values ('ailleurs', 'tv') $$,
  '42501', null, 'vue d''une rencontre d''une autre table');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c2');
select is((select payload from combat_view where id = 'relais'),
  '{"round":4}', 'Hugo, joueur, lit la vue');
select throws_ok(
  $$ insert into combat_view (id, table_id) values ('relais', 'tv') $$,
  '42501', null, 'un joueur ne publie pas');
update combat_view set payload = '{}' where id = 'relais';
reset role;
select is((select payload from combat_view where id = 'relais'),
  '{"round":4}', 'ni ne la modifie');

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c4');
select is((select count(*)::int from combat_view), 0,
  'Zoé, hors de la table, ne la voit pas');
reset role;

-- Demandes : le propriétaire pour son PJ ; lues par le MJ et l'auteur.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c2');
select lives_ok(
  $$ insert into combat_request (id, encounter_id, table_id, character_id,
       author_user_id, type, payload)
     values ('q1', 'relais', 'tv', 'aldric', auth.uid(), 'damage',
       '{"amount":8}') $$,
  'Hugo envoie une demande pour Aldric');
select throws_ok(
  $$ insert into combat_request (id, encounter_id, table_id, character_id,
       author_user_id, type)
     values ('q2', 'relais', 'tv', 'mira', auth.uid(), 'heal') $$,
  '42501', null, 'pas pour le PJ d''un autre');
select throws_ok(
  $$ insert into combat_request (id, encounter_id, table_id, character_id,
       author_user_id, type)
     values ('q3', 'ailleurs', 'tv', 'aldric', auth.uid(), 'heal') $$,
  '42501', null, 'rencontre d''une autre table');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c3');
select is((select count(*)::int from combat_request), 0,
  'Inès ne voit pas la demande de Hugo');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select is((select type from combat_request where id = 'q1'), 'damage',
  'Camille lit la demande');
delete from combat_request where id = 'q1';
select is((select count(*)::int from combat_request), 0,
  'et la supprime une fois appliquée');
reset role;

update game_table set archived = true where id = 'tv';
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c2');
select throws_ok(
  $$ insert into combat_request (id, encounter_id, table_id, character_id,
       author_user_id, type)
     values ('q4', 'relais', 'tv', 'aldric', auth.uid(), 'heal') $$,
  '42501', null, 'table archivée : plus de demande');
reset role;

select * from finish();
rollback;
