-- Spec sync-backend : « Rejoindre une table », « Retrait d'un joueur »
-- (US-14, EF-TAB-05, EF-TAB-06, EF-TAB-08).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(14);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000d1', 'mj@test.local'),
  ('00000000-0000-0000-0000-0000000000d2', 'joueur@test.local'),
  ('00000000-0000-0000-0000-0000000000d3', 'curieux@test.local');
insert into game_table (id, gm_user_id, name, stat_method, long_rest_rule,
  hp_on_level_rule, progression_mode, archived)
values
  ('tj', '00000000-0000-0000-0000-0000000000d1', 'Brumeval',
    'pointBuy', 'fullHitPoints', 'average', 'xp', false),
  ('tz', '00000000-0000-0000-0000-0000000000d1', 'Archivée',
    'pointBuy', 'fullHitPoints', 'average', 'xp', false);
insert into table_member (id, table_id, user_id, role) values
  ('mj', 'tj', '00000000-0000-0000-0000-0000000000d1', 'gm'),
  ('mz', 'tz', '00000000-0000-0000-0000-0000000000d1', 'gm');
insert into table_invite (id, table_id, code, expires_at, revoked) values
  ('i1', 'tj', 'K7Q4ZP', now() + interval '7 days', false),
  ('i2', 'tj', 'EXP1RE', now() - interval '1 minute', false),
  ('i3', 'tj', 'REVOKE', now() + interval '7 days', true),
  ('i4', 'tz', 'ARCH1V', now() + interval '7 days', false);
update game_table set archived = true where id = 'tz';

create function pg_temp.as_user(u text) returns void
language plpgsql as $$
begin
  execute 'set local role authenticated';
  perform set_config('request.jwt.claims',
    json_build_object('sub', u, 'role', 'authenticated')::text, true);
end
$$;

create function pg_temp.error_of(code text) returns text
language sql as $$ select public.join_table(code) ->> 'error' $$;

-- Rejoindre ---------------------------------------------------------------------

select pg_temp.as_user('00000000-0000-0000-0000-0000000000d2');
select is(public.join_table('k7q4zp') ->> 'table_id', 'tj',
  'un code valide, en minuscules, rend la table');
select is(
  (select role from table_member
   where table_id = 'tj' and user_id = auth.uid())::text, 'player',
  'le joueur est membre de la table');
select is(public.join_table('K7Q4ZP') ->> 'table_id', 'tj',
  'déjà membre : la table est rendue');
select is(
  (select count(*) from table_member where table_id = 'tj')::int, 2,
  'déjà membre : rien ne change');
select is(pg_temp.error_of('ZZZZZZ'), 'invalid_code', 'code inconnu');
select is(pg_temp.error_of('EXP1RE'), 'expired_code', 'invitation expirée');
select is(pg_temp.error_of('REVOKE'), 'expired_code', 'invitation révoquée');
select is(pg_temp.error_of('ARCH1V'), 'archived_table', 'table archivée');
select is(
  (select count(*) from table_invite)::int, 0,
  'un joueur ne lit pas les invitations');
reset role;

-- Recherche au hasard : freinée après 10 échecs dans l'heure.
select pg_temp.as_user('00000000-0000-0000-0000-0000000000d3');
do $$
begin
  for n in 1..10 loop
    perform public.join_table('AAAAA' || n);
  end loop;
end
$$;
select is(pg_temp.error_of('K7Q4ZP'), 'too_many_attempts',
  'après 10 échecs, même un bon code est refusé');
reset role;

-- Retrait d'un joueur -----------------------------------------------------------

insert into character (id, table_id, owner_user_id, kind, name, species_id,
  background_id, status)
values ('chj', 'tj', '00000000-0000-0000-0000-0000000000d2', 'pc', 'Mira',
  'srd:species:elf', 'srd:background:sage', 'draft');

select pg_temp.as_user('00000000-0000-0000-0000-0000000000d1');
select lives_ok(
  $$ delete from table_member
     where table_id = 'tj' and user_id = '00000000-0000-0000-0000-0000000000d2' $$,
  'le MJ retire le joueur');
reset role;

select pg_temp.as_user('00000000-0000-0000-0000-0000000000d2');
select is(
  (select status from character where id = 'chj')::text, 'archived',
  'sa fiche est archivée, pas supprimée, et il la lit encore');
update character set name = 'Mira la Sage' where id = 'chj';
select is(
  (select name from character where id = 'chj')::text, 'Mira',
  'une fiche archivée est en lecture seule');
select is(
  (select count(*) from table_member where table_id = 'tj'
     and user_id = auth.uid())::int, 0,
  'il n''est plus membre');
reset role;

select * from finish();
rollback;
