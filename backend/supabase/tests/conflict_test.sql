-- Spec sync-backend : « Conflits détectés et tracés » (US-16, ENF-03,
-- EF-PJ-13).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(14);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000c7', 'mj@test.local'),
  ('00000000-0000-0000-0000-0000000000c8', 'hugo@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values ('tc', '00000000-0000-0000-0000-0000000000c7', 'Brumeval',
  'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('m1', 'tc', '00000000-0000-0000-0000-0000000000c7', 'gm'),
  ('m2', 'tc', '00000000-0000-0000-0000-0000000000c8', 'player');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values ('aldric', 'tc', '00000000-0000-0000-0000-0000000000c8', 'pc', 'Aldric',
  'srd:species:human', 'srd:background:soldier', 'validated');
insert into character_state (id, character_id, hp_current, exhaustion)
values ('aldric', 'aldric', 29, 0);

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

create function pg_temp.patch(t text, data jsonb, old jsonb) returns jsonb
language sql as $$
  select public.apply_crud(jsonb_build_array(jsonb_build_object(
    'op', 'PATCH', 'table', t, 'id', 'aldric', 'data', data, 'old', old)))
$$;

create function pg_temp.conflicts() returns setof jsonb
language sql as $$
  select diff::jsonb from public.character_change_log
  where character_id = 'aldric' and diff::jsonb ->> 'kind' = 'conflict'
  order by timestamp, id
$$;

-- Le MJ règle les PV en combat : 29 → 34, sans conflit.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c7');
select is(pg_temp.patch('character_state', '{"hp_current": 34}',
  '{"hp_current": 29}'), '[]'::jsonb, 'le MJ règle les PV');
reset role;
select is((select count(*) from pg_temp.conflicts())::int, 0,
  'pas de conflit sans écriture concurrente');

-- Hors ligne, le joueur passait de 29 à 39 : la version du MJ prime.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c8');
select is(pg_temp.patch('character_state', '{"hp_current": 39, "exhaustion": 1}',
  '{"hp_current": 29, "exhaustion": 0}'), '[]'::jsonb, 'écriture acceptée');
reset role;
select is((select hp_current from character_state where id = 'aldric'), 34,
  'en combat, la version du MJ prime');
select is((select exhaustion from character_state where id = 'aldric'), 1,
  'le reste de l''écriture du joueur passe');
select is(
  (select c - 'kind' from pg_temp.conflicts() c),
  jsonb_build_object(
    'table', 'character_state', 'field', 'hp_current',
    'kept', 34, 'kept_by', '00000000-0000-0000-0000-0000000000c7',
    'replaced', 39, 'replaced_by', '00000000-0000-0000-0000-0000000000c8'),
  'le conflit est tracé : 39 remplacé par 34');
select is(
  (select author_user_id from character_change_log
   where diff::jsonb ->> 'kind' = 'conflict')::text,
  '00000000-0000-0000-0000-0000000000c8',
  'l''entrée est inscrite par l''appareil qui envoie');

-- Sur la fiche, le dernier écrit gagne.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c7');
select is(pg_temp.patch('character', '{"name": "Aldric le MJ"}',
  '{"name": "Aldric"}'), '[]'::jsonb, 'écriture acceptée');
reset role;
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c8');
select is(pg_temp.patch('character', '{"name": "Aldric le Brave"}',
  '{"name": "Aldric"}'), '[]'::jsonb, 'écriture acceptée');
reset role;
select is((select name from character where id = 'aldric'), 'Aldric le Brave',
  'sur la fiche, le dernier écrit gagne');
select is(
  (select c ->> 'replaced' from pg_temp.conflicts() c
   where c ->> 'field' = 'name'),
  'Aldric le MJ', 'le nom remplacé est tracé');

-- Une écriture à jour ne crée pas de conflit.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c8');
select is(pg_temp.patch('character_state', '{"exhaustion": 2}',
  '{"exhaustion": 1}'), '[]'::jsonb, 'écriture acceptée');
reset role;
select is((select count(*) from pg_temp.conflicts())::int, 2,
  'une écriture à jour ne crée pas de conflit');
select is((select exhaustion from character_state where id = 'aldric'), 2,
  'et elle s''écrit');

select * from finish();
rollback;
