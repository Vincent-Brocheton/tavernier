-- Spec sync-backend : « Stockage des packs » (US-30 lot b, EF-HB-09).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(8);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000f1', 'camille@packs.test'),
  ('00000000-0000-0000-0000-0000000000f2', 'hugo@packs.test'),
  ('00000000-0000-0000-0000-0000000000f3', 'zoe@packs.test');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode, full_sheets_visible)
values ('tp', '00000000-0000-0000-0000-0000000000f1', 'Brumeval',
  'pointBuy', 'fullHitPoints', 'average', 'xp', false);
insert into table_member (id, table_id, user_id, role) values
  ('pm1', 'tp', '00000000-0000-0000-0000-0000000000f1', 'gm'),
  ('pm2', 'tp', '00000000-0000-0000-0000-0000000000f2', 'player');

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

select ok(
  (select not public from storage.buckets where id = 'packs'),
  'le bucket packs est privé');

-- Camille, MJ, dépose le fichier et l'active sur sa table.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f1');
select lives_ok(
  $$ insert into storage.objects (bucket_id, name, owner)
     values ('packs', repeat('a', 64) || '.dndpack',
       '00000000-0000-0000-0000-0000000000f1') $$,
  'un MJ dépose un fichier nommé par son empreinte');
select throws_ok(
  $$ insert into storage.objects (bucket_id, name)
     values ('packs', 'gardiens.dndpack') $$,
  '42501', null, 'un autre nom est refusé');
select lives_ok(
  $$ insert into table_pack (id, table_id, pack_id, pinned_version,
       file_sha256)
     values ('tpk', 'tp', '0193a000-0000-7000-8000-000000000030', '0.1.0',
       repeat('a', 64)) $$,
  'le MJ active le pack sur sa table');
select throws_ok(
  $$ update table_pack set file_sha256 = 'abc' where id = 'tpk' $$,
  '23514', null, 'une empreinte mal formée est refusée');

-- Hugo, membre, le lit ; Zoé, étrangère à la table, ne le voit pas.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f2');
select is(
  (select count(*)::int from storage.objects where bucket_id = 'packs'),
  1, 'un membre de la table lit le fichier');
select throws_ok(
  $$ insert into storage.objects (bucket_id, name)
     values ('packs', repeat('b', 64) || '.dndpack') $$,
  '42501', null, 'un joueur sans table à lui ne dépose rien');
select pg_temp.as_user('00000000-0000-0000-0000-0000000000f3');
select is(
  (select count(*)::int from storage.objects where bucket_id = 'packs'),
  0, 'une étrangère à la table ne le voit pas');

select * from finish();
rollback;
