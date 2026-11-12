-- Spec sync-backend : « Avatar borné par le serveur » (US-40, EF-CPT-03).
begin;
create extension if not exists pgtap with schema extensions;
set search_path = public, extensions;

select plan(4);

insert into auth.users (id, email)
values ('00000000-0000-0000-0000-0000000000c1', 'avatar@exemple.test');
-- Le profil peut déjà exister (trigger d'inscription) : on le garantit.
insert into public.profile (id, pseudonym)
values ('00000000-0000-0000-0000-0000000000c1', 'Lou')
on conflict (id) do nothing;

select lives_ok(
  $$update public.profile
    set avatar = 'data:image/jpeg;base64,' || repeat('A', 68000)
    where id = '00000000-0000-0000-0000-0000000000c1'$$,
  'une image JPEG de 50 Ko est acceptée'
);
select throws_ok(
  $$update public.profile
    set avatar = 'data:image/jpeg;base64,' || repeat('A', 280000)
    where id = '00000000-0000-0000-0000-0000000000c1'$$,
  '23514', null, 'une image de plus de 200 Ko est refusée'
);
select throws_ok(
  $$update public.profile set avatar = 'bonjour'
    where id = '00000000-0000-0000-0000-0000000000c1'$$,
  '23514', null, 'un texte quelconque est refusé'
);
select lives_ok(
  $$update public.profile set avatar = null
    where id = '00000000-0000-0000-0000-0000000000c1'$$,
  'l''avatar se retire'
);

select * from finish();
rollback;
