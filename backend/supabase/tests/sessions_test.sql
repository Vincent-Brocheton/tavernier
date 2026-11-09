-- Spec sync-backend : « Sessions du compte » (US-12, EF-CPT-05).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(7);

insert into auth.users (id, email) values
  ('00000000-0000-0000-0000-0000000000f1', 'hugo@test.local'),
  ('00000000-0000-0000-0000-0000000000f2', 'camille@test.local');

-- Hugo : ce navigateur (s1) et son téléphone (s2) ; Camille : s3.
insert into auth.sessions (id, user_id, created_at, updated_at, refreshed_at,
  user_agent) values
  ('00000000-0000-0000-0000-0000000005a1',
   '00000000-0000-0000-0000-0000000000f1', now() - interval '3 days',
   now() - interval '1 minute', null,
   'Mozilla/5.0 (Windows NT 10.0; Win64; x64) Chrome/131.0 Safari/537.36'),
  ('00000000-0000-0000-0000-0000000005a2',
   '00000000-0000-0000-0000-0000000000f1', now() - interval '20 days',
   now() - interval '2 days', (now() - interval '2 days') at time zone 'UTC',
   'Tavernier (android)'),
  ('00000000-0000-0000-0000-0000000005a3',
   '00000000-0000-0000-0000-0000000000f2', now(), now(), null, 'Tavernier (ios)');

-- Hugo, depuis ce navigateur.
set local role authenticated;
select set_config('request.jwt.claims', json_build_object(
  'sub', '00000000-0000-0000-0000-0000000000f1', 'role', 'authenticated',
  'session_id', '00000000-0000-0000-0000-0000000005a1')::text, true);

select is(
  (select array_agg(id::text order by id) from list_my_sessions()),
  array['00000000-0000-0000-0000-0000000005a1',
        '00000000-0000-0000-0000-0000000005a2'],
  'on ne voit que ses sessions'
);
select is(
  (select array_agg(is_current order by id) from list_my_sessions()),
  array[true, false],
  'la session en cours est signalée'
);
select ok(
  (select last_active_at < now() - interval '1 day' from list_my_sessions()
   where id = '00000000-0000-0000-0000-0000000005a2'),
  'dernière activité : le dernier rafraîchissement'
);

select is(
  revoke_my_session('00000000-0000-0000-0000-0000000005a3'), false,
  'la session d''un autre ne se révoque pas'
);
select is(
  revoke_my_session('00000000-0000-0000-0000-0000000005a1'), false,
  'la session en cours ne se révoque pas ainsi'
);
select is(
  revoke_my_session('00000000-0000-0000-0000-0000000005a2'), true,
  'une autre de ses sessions se révoque'
);

reset role;
select is(
  (select array_agg(id::text order by id) from auth.sessions
   where id::text like '00000000-0000-0000-0000-0000000005a%'),
  array['00000000-0000-0000-0000-0000000005a1',
        '00000000-0000-0000-0000-0000000005a3'],
  'seule la session révoquée a disparu'
);

select * from finish();
rollback;
