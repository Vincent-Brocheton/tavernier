-- Packs activés sur une table (US-30 lot b, EF-HB-09, cahier §10) : le
-- fichier `.dndpack` de la version figée est déposé dans le bucket privé
-- `packs`, sous son empreinte sha256 ; `table_pack` la cite. Les membres et
-- le MJ d'une table qui le cite le lisent ; personne ne le modifie ni ne le
-- supprime.

alter table public.table_pack add column file_sha256 text
  check (file_sha256 is null or file_sha256 ~ '^[0-9a-f]{64}$');

insert into storage.buckets (id, name, public, file_size_limit,
  allowed_mime_types)
values ('packs', 'packs', false, 20971520, array['application/zip'])
on conflict (id) do nothing;

-- Dépôt : un MJ d'au moins une table, sous un nom d'empreinte.
create policy packs_insert on storage.objects for insert to authenticated
with check (
  bucket_id = 'packs'
  and name ~ '^[0-9a-f]{64}\.dndpack$'
  and exists (
    select 1 from public.game_table g where g.gm_user_id = auth.uid()
  )
);

-- Lecture : membres et MJ d'une table dont un pack cite ce fichier.
create policy packs_read on storage.objects for select to authenticated
using (
  bucket_id = 'packs'
  and exists (
    select 1 from public.table_pack p
    where p.file_sha256 || '.dndpack' = storage.objects.name
      and (public.is_table_member(p.table_id) or public.is_table_gm(p.table_id))
  )
);
