-- Envoi PowerSync (T-05) : une transaction locale entière en une seule
-- transaction Postgres, pour que les autres appareils ne reçoivent jamais une
-- fiche à moitié écrite. Les droits (RLS) de l'appelant s'appliquent
-- (security invoker). Chaque opération est dans un point de sauvegarde : un
-- refus définitif (droits, donnée invalide, contrainte) l'écarte seule, et
-- elle est rendue dans la liste des écritures écartées.
--
-- ops : [{op: PUT|PATCH|DELETE, table, id, data}], data sans id.
create function public.apply_crud(ops jsonb) returns jsonb
language plpgsql security invoker set search_path = ''
as $$
declare
  o jsonb;
  t text;
  row_data jsonb;
  cols text;
  sets text;
  discarded jsonb := '[]';
begin
  for o in select value from jsonb_array_elements(ops) loop
    t := o->>'table';
    row_data := coalesce(o->'data', '{}') || jsonb_build_object('id', o->>'id');
    begin
      -- Seules les tables synchronisées s'écrivent par ici.
      if not exists (
        select 1 from pg_catalog.pg_publication_tables
        where pubname = 'powersync' and schemaname = 'public'
          and tablename = t
      ) then
        raise insufficient_privilege using message = 'table non synchronisée : ' || t;
      end if;
      case o->>'op'
        when 'PUT' then
          select string_agg(format('%I', k), ', '),
                 string_agg(format('%I = excluded.%I', k, k), ', ')
            into cols, sets
            from jsonb_object_keys(row_data) k;
          execute format(
            'insert into public.%I (%s) select %s '
            'from jsonb_populate_record(null::public.%I, $1) '
            'on conflict (id) do update set %s',
            t, cols, cols, t, sets
          ) using row_data;
        when 'PATCH' then
          select string_agg(format('%I = r.%I', k, k), ', ')
            into sets
            from jsonb_object_keys(row_data) k
            where k <> 'id';
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

revoke execute on function public.apply_crud(jsonb) from public, anon;
grant execute on function public.apply_crud(jsonb) to authenticated;
