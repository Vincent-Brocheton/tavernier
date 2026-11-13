-- Proposition structurelle du MJ (US-34, EF-PJ-16, cahier §4.3) : le MJ
-- propose une modification de la fiche d'un PJ, avec un motif ; le joueur
-- l'accepte ou la refuse avec un message. L'appareil du joueur applique la
-- modification acceptée à sa fiche (le moteur de règles est dans l'app).

create table public.character_proposal (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  table_id text not null references public.game_table (id) on delete cascade,
  author_user_id uuid references auth.users (id) on delete set null,
  kind text not null check (kind in ('feat')),
  -- Champs de premier niveau de la fiche (CharacterInput) remplacés, en JSON.
  change text not null,
  reason text not null check (length(btrim(reason)) > 0),
  status text not null default 'pending'
    check (status in ('pending', 'accepted', 'refused')),
  reply text,
  created_at timestamptz not null default now(),
  decided_at timestamptz
);

alter table public.character_proposal enable row level security;

-- Le propriétaire de la fiche et le MJ de la table, seuls.
create function public.can_read_proposal(c text, t text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select public.is_table_gm(t) or exists (
    select 1 from public.character ch
    where ch.id = c and ch.owner_user_id = auth.uid()
  );
$$;

create policy character_proposal_read on public.character_proposal
for select to authenticated using (public.can_read_proposal(character_id, table_id));

-- Le MJ propose, en son nom, pour une fiche de sa table non archivée.
create policy character_proposal_insert on public.character_proposal
for insert to authenticated with check (
  public.is_table_gm(table_id)
  and author_user_id = auth.uid()
  and status = 'pending'
  and reply is null
  and decided_at is null
  and exists (
    select 1 from public.character ch
    where ch.id = character_proposal.character_id
      and ch.table_id = character_proposal.table_id
      and ch.status <> 'archived'
  )
);

-- Le joueur répond ; la garde ci-dessous dit quoi.
create policy character_proposal_update on public.character_proposal
for update to authenticated
using (public.can_read_proposal(character_id, table_id))
with check (public.can_read_proposal(character_id, table_id));

-- Réponse du propriétaire seulement, une fois, sans toucher à la proposition.
create function public.guard_character_proposal() returns trigger
language plpgsql set search_path = ''
as $$
begin
  if current_user <> 'authenticated' then
    return new;
  end if;
  if not exists (
       select 1 from public.character ch
       where ch.id = old.character_id and ch.owner_user_id = auth.uid()
     )
     or old.status <> 'pending'
     or new.status not in ('accepted', 'refused')
     or (new.character_id, new.table_id, new.author_user_id, new.kind,
         new.change, new.reason, new.created_at)
        is distinct from
        (old.character_id, old.table_id, old.author_user_id, old.kind,
         old.change, old.reason, old.created_at) then
    raise insufficient_privilege using message = 'proposition : réponse du joueur seule';
  end if;
  return new;
end
$$;

create trigger guard_character_proposal before update on public.character_proposal
for each row execute function public.guard_character_proposal();

alter publication powersync add table public.character_proposal;
