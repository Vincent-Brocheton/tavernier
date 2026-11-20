-- Notes (US-26, EF-NOT-01 à 06, cahier §11.2) : rattachées à une table, une
-- séance, un PNJ ou une rencontre ; privées par défaut, partageables avec la
-- table en lecture seule ; texte en Markdown réduit (gras, listes, liens
-- [Nom](npc:<id>) et [Nom](encounter:<id>)).

create table public.note (
  id text primary key,
  owner_user_id uuid not null references auth.users (id) on delete cascade,
  table_id text references public.game_table (id) on delete cascade,
  scope text not null check (scope in ('table', 'session', 'npc', 'encounter')),
  ref_id text,
  title text not null default '',
  content text not null default '',
  private boolean not null default true,
  updated_at timestamptz,
  -- L'autre version d'une note modifiée sur deux appareils, à fusionner.
  conflict text
);

alter table public.note enable row level security;

-- L'auteur ; une note partagée, toute la table.
create policy note_read on public.note for select to authenticated
using (
  owner_user_id = auth.uid()
  or (not private and table_id is not null
      and public.is_table_member(table_id))
);
create policy note_insert on public.note for insert to authenticated
with check (
  owner_user_id = auth.uid()
  and (table_id is null or public.is_table_member(table_id))
);
-- Modifiable par son seul auteur (EF-NOT-04).
create policy note_update on public.note for update to authenticated
using (owner_user_id = auth.uid())
with check (
  owner_user_id = auth.uid()
  and (table_id is null or public.is_table_member(table_id))
);
create policy note_delete on public.note for delete to authenticated
using (owner_user_id = auth.uid());

alter publication powersync add table public.note;

-- Envoi PowerSync : en plus des fiches (US-16), les conflits des notes.
create or replace function public.apply_crud(ops jsonb) returns jsonb
language plpgsql security invoker set search_path = ''
as $$
declare
  o jsonb;
  t text;
  row_data jsonb;
  cols text;
  sets text;
  discarded jsonb := '[]';
  cur jsonb;
  k text;
  gm uuid;
  writer uuid := auth.uid();
  holder uuid;
  sheet text;
begin
  for o in select value from jsonb_array_elements(ops) loop
    t := o->>'table';
    row_data := coalesce(o->'data', '{}') || jsonb_build_object('id', o->>'id');
    begin
      if not exists (
        select 1 from pg_catalog.pg_publication_tables
        where pubname = 'powersync' and schemaname = 'public'
          and tablename = t
      ) then
        raise insufficient_privilege using message = 'table non synchronisée : ' || t;
      end if;
      case o->>'op'
        when 'PUT' then
          select string_agg(format('%I', k2), ', '),
                 string_agg(format('%I = excluded.%I', k2, k2), ', ')
            into cols, sets
            from jsonb_object_keys(row_data) k2;
          execute format(
            'insert into public.%I (%s) select %s '
            'from jsonb_populate_record(null::public.%I, $1) '
            'on conflict (id) do update set %s',
            t, cols, cols, t, sets
          ) using row_data;
        when 'PATCH' then
          -- Conflits : une valeur en place différente de celle que
          -- l'appareil remplaçait a été écrite par quelqu'un d'autre.
          if t in ('character', 'character_state') and o ? 'old' then
            execute format(
              'select to_jsonb(d) from public.%I d where d.id = $1', t
            ) into cur using o->>'id';
            if cur is not null then
              sheet := case when t = 'character' then cur->>'id'
                else cur->>'character_id' end;
              select g.gm_user_id into gm
                from public.character c
                join public.game_table g on g.id = c.table_id
                where c.id = sheet;
              for k in select jsonb_object_keys(coalesce(o->'data', '{}')) loop
                continue when not (o->'old') ? k
                  or (cur->k) is not distinct from (o->'old'->k);
                holder := (cur->'field_authors'->>k)::uuid;
                if t = 'character_state' and gm is not null
                   and holder = gm and writer is distinct from gm then
                  -- En combat, la version du MJ prime.
                  row_data := row_data - k;
                  insert into public.character_change_log
                    (id, character_id, author_user_id, diff)
                  -- Inscrite par celui qui envoie (règle de l'historique) ;
                  -- le MJ figure dans kept_by.
                  values (gen_random_uuid()::text, sheet, writer,
                    jsonb_build_object('kind', 'conflict', 'table', t,
                      'field', k, 'kept', cur->k, 'kept_by', holder,
                      'replaced', o->'data'->k, 'replaced_by', writer)::text);
                else
                  -- Dernier écrit gagnant, tracé.
                  insert into public.character_change_log
                    (id, character_id, author_user_id, diff)
                  values (gen_random_uuid()::text, sheet, writer,
                    jsonb_build_object('kind', 'conflict', 'table', t,
                      'field', k, 'kept', o->'data'->k, 'kept_by', writer,
                      'replaced', cur->k, 'replaced_by', holder)::text);
                end if;
              end loop;
            end if;
          end if;
          -- Note modifiée sur deux appareils (EF-NOT-06) : le texte en place
          -- n'est pas celui que l'appareil remplaçait. La nouvelle version
          -- s'écrit, l'autre est gardée pour que l'auteur fusionne.
          if t = 'note' and (o->'old') ? 'content' then
            select to_jsonb(n) into cur from public.note n where n.id = o->>'id';
            if cur is not null
               and (cur->'content') is distinct from (o->'old'->'content')
               and (o->'data') ? 'content' then
              row_data := row_data
                || jsonb_build_object('conflict', cur->>'content');
            end if;
          end if;
          select string_agg(format('%I = r.%I', k2, k2), ', ')
            into sets
            from jsonb_object_keys(row_data) k2
            where k2 <> 'id';
          if sets is not null then
            execute format(
              'update public.%I as d set %s '
              'from jsonb_populate_record(null::public.%I, $1) as r '
              'where d.id = r.id',
              t, sets, t
            ) using row_data;
          end if;
        when 'DELETE' then
          execute format(
            'delete from public.%I as d '
            'using jsonb_populate_record(null::public.%I, $1) as r '
            'where d.id = r.id',
            t, t
          ) using row_data;
        else
          raise invalid_parameter_value using message = 'opération inconnue';
      end case;
    exception
      when insufficient_privilege or data_exception
        or integrity_constraint_violation then
        discarded := discarded || jsonb_build_object(
          'op', o->>'op', 'table', t, 'id', o->>'id',
          'code', sqlstate, 'message', sqlerrm
        );
    end;
  end loop;
  return discarded;
end
$$;
