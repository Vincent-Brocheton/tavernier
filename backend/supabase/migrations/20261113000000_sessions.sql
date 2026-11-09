-- Appareils connectés (US-12, EF-CPT-05) : chacun liste ses sessions et en
-- révoque une autre que celle en cours. Le schéma auth reste fermé au
-- client : ces fonctions ne touchent qu'aux sessions de auth.uid().

create function public.list_my_sessions()
returns table (
  id uuid,
  user_agent text,
  last_active_at timestamptz,
  created_at timestamptz,
  is_current boolean
)
language sql stable security definer set search_path = ''
as $$
  select
    s.id,
    s.user_agent,
    coalesce(s.refreshed_at at time zone 'UTC', s.updated_at, s.created_at),
    s.created_at,
    s.id::text = (auth.jwt() ->> 'session_id')
  from auth.sessions s
  where s.user_id = auth.uid()
  order by 5 desc, 3 desc;
$$;

-- Supprimer la session supprime ses jetons de rafraîchissement : l'appareil
-- ne peut plus prolonger sa connexion. Vrai si une session a été révoquée.
create function public.revoke_my_session(target uuid) returns boolean
language plpgsql security definer set search_path = ''
as $$
declare
  removed integer;
begin
  delete from auth.sessions s
  where s.id = target
    and s.user_id = auth.uid()
    and s.id::text is distinct from (auth.jwt() ->> 'session_id');
  get diagnostics removed = row_count;
  return removed > 0;
end
$$;

revoke execute on function public.list_my_sessions() from public, anon;
revoke execute on function public.revoke_my_session(uuid) from public, anon;
grant execute on function public.list_my_sessions() to authenticated;
grant execute on function public.revoke_my_session(uuid) to authenticated;
