-- Spec sync-backend : « PNJ au serveur » et « Fiches de PNJ cachées aux
-- membres » (US-18, EF-PNJ-01 à 03, EF-ACT-06).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(12);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000e1', 'camille@test.local'),
  ('00000000-0000-0000-0000-0000000000e2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000e3', 'ines@test.local'),
  ('00000000-0000-0000-0000-0000000000e4', 'zoe@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode, full_sheets_visible)
values
  ('tn', '00000000-0000-0000-0000-0000000000e1', 'Brumeval',
   'pointBuy', 'fullHitPoints', 'average', 'xp', true),
  ('tz', '00000000-0000-0000-0000-0000000000e4', 'Ailleurs',
   'pointBuy', 'fullHitPoints', 'average', 'xp', false);
insert into table_member (id, table_id, user_id, role) values
  ('nm1', 'tn', '00000000-0000-0000-0000-0000000000e1', 'gm'),
  ('nm2', 'tn', '00000000-0000-0000-0000-0000000000e2', 'player'),
  ('nm3', 'tn', '00000000-0000-0000-0000-0000000000e3', 'player'),
  ('nm4', 'tz', '00000000-0000-0000-0000-0000000000e4', 'gm');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values
  ('aldric', 'tn', '00000000-0000-0000-0000-0000000000e2', 'pc', 'Aldric',
   'srd:species:human', 'srd:background:soldier', 'validated'),
  ('odran', 'tn', '00000000-0000-0000-0000-0000000000e1', 'npc_full',
   'Odran', 'srd:species:human', 'srd:background:soldier', 'draft'),
  ('autre', 'tz', '00000000-0000-0000-0000-0000000000e4', 'npc_full',
   'Autre', 'srd:species:human', 'srd:background:soldier', 'draft');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Le MJ crée et modifie ses PNJ.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
select lives_ok(
  $$ insert into npc_statblock (id, table_id, name, folder, monster_id)
     values ('varga', 'tn', 'Varga la Balafrée', 'Guilde du Sel',
       'srd:monster:bandit-captain') $$,
  'Camille crée un PNJ en bloc de stats');
select is((select attitude from npc_statblock where id = 'varga'),
  'indifferent', 'Indifférent par défaut');
select lives_ok(
  $$ insert into npc_statblock (id, table_id, name, character_id)
     values ('n-odran', 'tn', 'Maître Odran', 'odran') $$,
  'Camille lie la fiche complète d''Odran');
select throws_ok(
  $$ update npc_statblock set attitude = 'mefiant' where id = 'varga' $$,
  '23514', null, 'attitude inconnue');
select throws_ok(
  $$ insert into npc_statblock (id, table_id, name) values ('vide', 'tn', ' ') $$,
  '23514', null, 'nom obligatoire');
select throws_ok(
  $$ insert into npc_statblock (id, table_id, name, character_id)
     values ('x', 'tn', 'X', 'autre') $$,
  '42501', null, 'fiche d''une autre table');
select is((select count(*)::int from character where id = 'odran'), 1,
  'Camille lit la fiche de son PNJ');
reset role;

-- Un joueur ne voit ni les PNJ ni leurs fiches.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e3');
select is((select count(*)::int from npc_statblock), 0,
  'Inès ne voit aucun PNJ');
select throws_ok(
  $$ insert into npc_statblock (id, table_id, name) values ('h', 'tn', 'H') $$,
  '42501', null, 'un joueur ne crée pas de PNJ');
select is((select count(*)::int from character where id = 'aldric'), 1,
  'fiches visibles : Inès lit la fiche d''Aldric');
select is((select count(*)::int from character where id = 'odran'), 0,
  'mais pas la fiche d''Odran');
reset role;

-- Table archivée : PNJ figés.
update game_table set archived = true where id = 'tn';
select pg_temp.as_user('00000000-0000-0000-0000-0000000000e1');
update npc_statblock set name = 'Autre' where id = 'varga';
select is((select name from npc_statblock where id = 'varga'),
  'Varga la Balafrée', 'table archivée : PNJ inchangé');
reset role;

select * from finish();
rollback;
