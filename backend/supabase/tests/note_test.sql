-- Spec sync-backend : « Notes au serveur » (US-26, EF-NOT-02, 04, 06).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(13);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000e1', 'camille@test.local'),
  ('00000000-0000-0000-0000-0000000000e2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000e3', 'ines@test.local'),
  ('00000000-0000-0000-0000-0000000000e4', 'zoe@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values
  ('tn', '00000000-0000-0000-0000-0000000000e1', 'Brumeval',
   'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('n1', 'tn', '00000000-0000-0000-0000-0000000000e1', 'gm'),
  ('n2', 'tn', '00000000-0000-0000-0000-0000000000e2', 'player'),
  ('n3', 'tn', '00000000-0000-0000-0000-0000000000e3', 'player');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Camille : une note privée, une partagée.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select lives_ok(
  $$ insert into note (id, owner_user_id, table_id, scope, title, content)
     values ('prep', auth.uid(), 'tn', 'session', 'Préparation',
       'Varga attend au relais.') $$,
  'Camille écrit une note privée');
select lives_ok(
  $$ insert into note (id, owner_user_id, table_id, scope, title, content,
       private)
     values ('cal', auth.uid(), 'tn', 'table', 'Calendrier et factions',
       'La Guilde du Sel…', false) $$,
  'et une note partagée');
select throws_ok(
  $$ insert into note (id, owner_user_id, table_id, scope, content)
     values ('faux', '00000000-0000-0000-0000-0000000000e2', 'tn', 'table',
       'x') $$,
  '42501', null, 'pas au nom d''un autre');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e2');
select is((select count(*)::int from note where id = 'prep'), 0,
  'Hugo ne voit pas la note privée du MJ');
select is((select title from note where id = 'cal'), 'Calendrier et factions',
  'mais lit la note partagée');
update note set content = 'effacé' where id = 'cal';
reset role;
select is((select content from note where id = 'cal'), 'La Guilde du Sel…',
  'sans pouvoir la modifier');

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e2');
select lives_ok(
  $$ insert into note (id, owner_user_id, table_id, scope, title, content)
     values ('loup', auth.uid(), 'tn', 'session', 'Ce que le loup portait',
       'Un collier gravé.') $$,
  'Hugo écrit sa note');
select throws_ok(
  $$ insert into note (id, owner_user_id, table_id, scope, content)
     values ('ailleurs', auth.uid(), 'inconnue', 'table', 'x') $$,
  '42501', null, 'pas sur une table dont il n''est pas membre');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e3');
select is((select count(*)::int from note where id = 'loup'), 0,
  'Inès ne voit pas la note privée de Hugo');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000e4');
select is((select count(*)::int from note), 0,
  'Zoé, hors de la table, ne voit rien');
reset role;

-- Conflit : deux appareils de Hugo, hors-ligne (EF-NOT-06).
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e2');
select is(
  apply_crud($$[{"op": "PATCH", "table": "note", "id": "loup",
    "data": {"content": "Un collier gravé d'un sceau."},
    "old": {"content": "Un collier gravé."}}]$$::jsonb),
  '[]'::jsonb, 'le premier envoi passe');
select is(
  (select conflict from note where id = 'loup'), null,
  'sans conflit : il remplaçait le texte en place');
select apply_crud($$[{"op": "PATCH", "table": "note", "id": "loup",
  "data": {"content": "Demander à Thalia."},
  "old": {"content": "Un collier gravé."}}]$$::jsonb);
select results_eq(
  $$ select content, conflict from note where id = 'loup' $$,
  $$ values ('Demander à Thalia.'::text,
       'Un collier gravé d''un sceau.'::text) $$,
  'le second garde l''autre version à fusionner');
reset role;

select * from finish();
rollback;
