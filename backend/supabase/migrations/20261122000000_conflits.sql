-- Conflits de synchronisation (US-16, ENF-03, EF-PJ-13) : détectés grâce
-- aux valeurs que l'appareil remplaçait, résolus champ par champ (le MJ prime
-- sur l'état de jeu), tracés dans l'historique de la fiche.

-- Auteur de la dernière écriture de chaque champ, tenu par le serveur seul.
alter table public.character
  add column field_authors jsonb not null default '{}';
alter table public.character_state
  add column field_authors jsonb not null default '{}';

create function public.track_field_authors() returns trigger
language plpgsql set search_path = ''
as $$
declare
  n jsonb := to_jsonb(new);
  o jsonb := case when tg_op = 'UPDATE' then to_jsonb(old) else '{}' end;
  authors jsonb := case when tg_op = 'UPDATE' then old.field_authors
    else '{}' end;
  k text;
begin
  if current_user <> 'authenticated' then
    return new;
  end if;
  for k in select jsonb_object_keys(n) loop
    if k <> 'field_authors' and (n -> k) is distinct from (o -> k) then
      authors := authors || jsonb_build_object(k, auth.uid());
    end if;
  end loop;
  new.field_authors := authors;
  return new;
end
$$;

create trigger track_field_authors
before insert or update on public.character
for each row execute function public.track_field_authors();
create trigger track_field_authors
before insert or update on public.character_state
for each row execute function public.track_field_authors();

-- ops : [{op: PUT|PATCH|DELETE, table, id, data, old?}], data sans id ; old :
-- valeurs que l'appareil remplaçait (fiche et état de jeu).
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
                  values (gen_random_uuid()::text, sheet, holder,
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
