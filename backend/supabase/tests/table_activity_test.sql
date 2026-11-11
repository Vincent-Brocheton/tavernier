-- Spec sync-backend : « Activité d'une table au serveur », « Table archivée en
-- lecture seule » (US-13, EF-TAB-07, EF-TAB-11).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(10);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000c1', 'mj@test.local'),
  ('00000000-0000-0000-0000-0000000000c2', 'joueur@test.local'),
  ('00000000-0000-0000-0000-0000000000c3', 'inconnu@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode)
values ('ta', '00000000-0000-0000-0000-0000000000c1', 'Brumeval',
  'pointBuy', 'fullHitPoints', 'average', 'xp');
insert into table_member (id, table_id, user_id, role) values
  ('ma', 'ta', '00000000-0000-0000-0000-0000000000c1', 'gm'),
  ('mb', 'ta', '00000000-0000-0000-0000-0000000000c2', 'player');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values ('cha', 'ta', '00000000-0000-0000-0000-0000000000c2', 'pc', 'Mira',
  'srd:species:elf', 'srd:background:sage', 'active');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Activité ----------------------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select lives_ok(
  $$ insert into table_activity (id, table_id, author_user_id, kind, detail)
     values ('a1', 'ta', '00000000-0000-0000-0000-0000000000c1', 'config',
       '{"field": "statMethod", "from": "pointBuy", "to": "standardArray"}') $$,
  'le MJ date un changement dans l''activité'
);
update table_activity set kind = 'falsifié' where id = 'a1';
select is(
  (select kind from table_activity where id = 'a1')::text, 'config',
  'une entrée d''activité ne se corrige pas'
);
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c2');
select throws_ok(
  $$ insert into table_activity (id, table_id, author_user_id, kind)
     values ('a2', 'ta', '00000000-0000-0000-0000-0000000000c2', 'config') $$,
  '42501', null,
  'un joueur n''écrit pas dans l''activité'
);
select is(
  (select count(*) from table_activity)::int, 1,
  'un membre lit l''activité de sa table'
);
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c3');
select is(
  (select count(*) from table_activity)::int, 0,
  'un inconnu ne la voit pas'
);
reset role;

-- Archivage ---------------------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select lives_ok(
  $$ update game_table set archived = true where id = 'ta' $$,
  'le MJ archive la table'
);
select throws_ok(
  $$ update game_table set name = 'Renommée' where id = 'ta' $$,
  '42501', null,
  'une table archivée ne se modifie pas'
);
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c2');
update character set name = 'Mira la Sage' where id = 'cha';
select is(
  (select name from character where id = 'cha')::text, 'Mira',
  'la fiche d''une table archivée est en lecture seule'
);
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select lives_ok(
  $$ update game_table set archived = false where id = 'ta' $$,
  'le MJ restaure la table'
);
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c2');
update character set name = 'Mira la Sage' where id = 'cha';
select is(
  (select name from character where id = 'cha')::text, 'Mira la Sage',
  'restaurée, la fiche redevient modifiable'
);
reset role;

select * from finish();
rollback;
