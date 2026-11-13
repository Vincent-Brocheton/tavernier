-- Spec sync-backend : « Propositions du MJ au serveur » (US-34, EF-PJ-16).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(11);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000c1', 'camille@test.local'),
  ('00000000-0000-0000-0000-0000000000c2', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000c3', 'ines@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode, full_sheets_visible)
values ('tp', '00000000-0000-0000-0000-0000000000c1', 'Brumeval',
  'pointBuy', 'fullHitPoints', 'average', 'xp', true);
insert into table_member (id, table_id, user_id, role) values
  ('pm1', 'tp', '00000000-0000-0000-0000-0000000000c1', 'gm'),
  ('pm2', 'tp', '00000000-0000-0000-0000-0000000000c2', 'player'),
  ('pm3', 'tp', '00000000-0000-0000-0000-0000000000c3', 'player');
insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values ('aldric', 'tp', '00000000-0000-0000-0000-0000000000c2', 'pc',
  'Aldric', 'srd:species:human', 'srd:background:soldier', 'validated');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

-- Le MJ propose.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select lives_ok(
  $$ insert into character_proposal (id, character_id, table_id,
       author_user_id, kind, change, reason)
     values ('p1', 'aldric', 'tp', auth.uid(), 'feat', '{"feats": []}',
       'Ton passé à la garde des Marches.') $$,
  'Camille propose une modification à Hugo');
select throws_ok(
  $$ insert into character_proposal (id, character_id, table_id,
       author_user_id, kind, change, reason)
     values ('p2', 'aldric', 'tp', auth.uid(), 'feat', '{}', '  ') $$,
  '23514', null, 'motif obligatoire');
select throws_ok(
  $$ insert into character_proposal (id, character_id, table_id,
       author_user_id, kind, change, reason, status)
     values ('p3', 'aldric', 'tp', auth.uid(), 'feat', '{}', 'Motif',
       'accepted') $$,
  '42501', null, 'une proposition naît en attente');
select throws_ok(
  $$ update character_proposal set status = 'accepted' where id = 'p1' $$,
  '42501', null, 'le MJ ne répond pas à la place du joueur');
reset role;

-- Un joueur ne propose pas.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c2');
select throws_ok(
  $$ insert into character_proposal (id, character_id, table_id,
       author_user_id, kind, change, reason)
     values ('p4', 'aldric', 'tp', auth.uid(), 'feat', '{}', 'Motif') $$,
  '42501', null, 'un joueur ne propose pas');
select is((select reason from character_proposal where id = 'p1'),
  'Ton passé à la garde des Marches.', 'Hugo lit la proposition');
select throws_ok(
  $$ update character_proposal set status = 'accepted',
       change = '{"feats": [1]}' where id = 'p1' $$,
  '42501', null, 'Hugo ne change pas la proposition');
select lives_ok(
  $$ update character_proposal set status = 'refused',
       reply = 'Je garde Vigilant.', decided_at = now() where id = 'p1' $$,
  'Hugo refuse, avec un message');
select throws_ok(
  $$ update character_proposal set status = 'accepted' where id = 'p1' $$,
  '42501', null, 'une seule réponse');
reset role;

-- Un autre membre ne la voit pas, même avec les fiches complètes ouvertes.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000c3');
select is((select count(*) from character_proposal)::int, 0,
  'Inès ne lit pas la proposition faite à Hugo');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000c1');
select is((select reply from character_proposal where id = 'p1'),
  'Je garde Vigilant.', 'Camille lit la réponse');
reset role;

select * from finish();
rollback;
