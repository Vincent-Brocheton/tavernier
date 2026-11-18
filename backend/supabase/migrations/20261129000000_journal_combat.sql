-- Journal du combat (US-20, cahier §10 et §11) : l'état d'une rencontre est
-- la projection de ses événements, dans l'ordre de leurs identifiants
-- (UUID v7). Ajout seul ; le MJ seul le voit. La liste des types est tenue
-- par le moteur de l'app.

create table public.encounter_event (
  id text primary key,
  encounter_id text not null references public.encounter (id) on delete cascade,
  table_id text not null references public.game_table (id) on delete cascade,
  author_user_id uuid references auth.users (id) on delete set null,
  type text not null check (length(type) > 0),
  payload text not null default '{}',
  created_at timestamptz not null default now()
);

alter table public.encounter_event enable row level security;

create policy encounter_event_read on public.encounter_event for select
to authenticated using (public.is_table_gm(table_id));

-- Ajout seul : ni mise à jour ni suppression pour les clients ; la
-- rencontre supprimée emporte son journal par cascade.
create policy encounter_event_insert on public.encounter_event for insert
to authenticated with check (
  public.can_manage_table(table_id) and author_user_id = auth.uid()
);

-- L'événement est de la table de sa rencontre.
create function public.guard_encounter_event() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if not exists (
    select 1 from public.encounter e
    where e.id = new.encounter_id and e.table_id = new.table_id
  ) then
    raise insufficient_privilege using message = 'journal : autre table';
  end if;
  return new;
end
$$;

create trigger guard_encounter_event before insert on public.encounter_event
for each row execute function public.guard_encounter_event();

alter publication powersync add table public.encounter_event;
