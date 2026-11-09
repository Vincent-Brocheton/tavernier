-- Envoi PowerSync en upsert (T-05) : INSERT … ON CONFLICT DO UPDATE vérifie
-- aussi la règle de lecture sur la ligne nouvelle. Les fonctions
-- security definer lisent la table telle qu'avant l'instruction, sans cette
-- ligne : la règle de lecture teste donc aussi directement la ligne.

drop policy character_read on public.character;
create policy character_read on public.character for select to authenticated
using (owner_user_id = auth.uid() or public.can_read_character(id));

-- Le MJ lit les lignes de sa table avant d'en être membre (sa propre
-- inscription comprise).
drop policy table_member_read on public.table_member;
create policy table_member_read on public.table_member for select
to authenticated
using (public.is_table_member(table_id) or public.is_table_gm(table_id));

drop policy table_pack_read on public.table_pack;
create policy table_pack_read on public.table_pack for select
to authenticated
using (public.is_table_member(table_id) or public.is_table_gm(table_id));

drop policy table_banned_read on public.table_banned_entity;
create policy table_banned_read on public.table_banned_entity for select
to authenticated
using (public.is_table_member(table_id) or public.is_table_gm(table_id));
