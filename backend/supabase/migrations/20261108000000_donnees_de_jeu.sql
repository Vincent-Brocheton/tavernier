-- Données de jeu (cahier §11.2), miroir des tables locales de dnd_data pour
-- la synchronisation (T-05). Les identifiants restent du texte (UUID v7 générés
-- par l'appareil) ; les utilisateurs sont ceux de Supabase Auth. Colonnes JSON
-- en texte, comme en local : PowerSync les transporte telles quelles.
-- Rencontres, PNJ, séances et notes arrivent avec M3.

-- Profil -------------------------------------------------------------------

create table public.profile (
  id uuid primary key references auth.users (id) on delete cascade,
  pseudonym text not null,
  avatar text,
  locale text not null default 'fr',
  settings text not null default '{}'
);

-- Tables de jeu ------------------------------------------------------------

create table public.game_table (
  id text primary key,
  -- Vide si le MJ a supprimé son compte : la table continue (cahier §14.2).
  gm_user_id uuid references auth.users (id) on delete set null,
  name text not null,
  stat_method text not null,
  long_rest_rule text not null,
  hp_on_level_rule text not null,
  starting_level integer not null default 1,
  progression_mode text not null,
  full_sheets_visible boolean not null default false,
  archived boolean not null default false
);

create table public.table_member (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  user_id uuid not null references auth.users (id) on delete cascade,
  role text not null check (role in ('gm', 'player')),
  joined_at timestamptz not null default now(),
  unique (table_id, user_id)
);

create table public.table_invite (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  code text not null unique,
  expires_at timestamptz not null,
  revoked boolean not null default false
);

create table public.table_pack (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  pack_id text not null,
  pinned_version text,
  unique (table_id, pack_id)
);

create table public.table_banned_entity (
  id text primary key,
  table_id text not null references public.game_table (id) on delete cascade,
  entity_id text not null,
  unique (table_id, entity_id)
);

-- Personnages --------------------------------------------------------------

create table public.character (
  id text primary key,
  -- Vide pour un personnage libre, hors table.
  table_id text references public.game_table (id) on delete set null,
  owner_user_id uuid references auth.users (id) on delete cascade,
  kind text not null,
  name text not null,
  player text,
  species_id text not null,
  species_choices text not null default '{}',
  background_id text not null,
  status text not null,
  xp integer not null default 0,
  level_unlock text,
  score_rolls text,
  coins text not null default '{}',
  alignment text,
  appearance text,
  personality text,
  backstory text
);

create table public.character_base_scores (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  ability_id text not null,
  base integer not null,
  method text not null,
  unique (character_id, ability_id)
);

create table public.character_background_choice (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  distribution text not null,
  bonuses text not null,
  feat_choices text,
  tool_choice text,
  unique (character_id)
);

create table public.character_class_level (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  class_id text not null,
  level integer not null,
  subclass_id text,
  hp_roll text,
  skill_choices text not null default '[]',
  expertise text not null default '[]',
  position integer not null,
  unique (character_id, class_id)
);

create table public.character_feat (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  feat_id text not null,
  source_type text not null,
  source_ref text not null,
  choices text,
  position integer not null
);

create table public.character_weapon_mastery (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  weapon_id text not null,
  slot_index integer not null
);

create table public.character_spell (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  spell_id text not null,
  source text not null,
  prepared boolean not null default false,
  in_spellbook boolean not null default false,
  class_id text
);

create table public.character_item (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  item_id text not null,
  quantity integer not null,
  equipped boolean not null,
  attuned boolean not null,
  position integer not null
);

create table public.character_state (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  hp_current integer,
  hp_temp integer not null default 0,
  hit_dice_used integer not null default 0,
  death_saves text not null default '{}',
  exhaustion integer not null default 0,
  heroic_inspiration boolean not null default false,
  resources text not null default '{}',
  concentration_spell_id text,
  unique (character_id)
);

create table public.character_content_ref (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  entity_id text not null,
  pack_id text not null,
  pack_version text not null,
  snapshot text not null
);

create table public.character_change_log (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  author_user_id uuid references auth.users (id) on delete set null,
  timestamp timestamptz not null default now(),
  diff text not null
);

create table public.character_language (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  language_id text not null,
  position integer not null
);

create table public.character_choice (
  id text primary key,
  character_id text not null references public.character (id) on delete cascade,
  choice_key text not null,
  selections text not null,
  unique (character_id, choice_key)
);

-- Droits ---------------------------------------------------------------------
-- Fonctions en `security definer` : elles lisent les tables de jeu sans
-- repasser par leurs propres règles, ce qui évite la récursion.

create function public.is_table_member(t text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.table_member m
    where m.table_id = t and m.user_id = auth.uid()
  );
$$;

create function public.is_table_gm(t text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.game_table g
    where g.id = t and g.gm_user_id = auth.uid()
  );
$$;

-- Propriétaire, MJ de sa table, ou membre quand la table montre les fiches.
create function public.can_read_character(c text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.character ch
    left join public.game_table g on g.id = ch.table_id
    where ch.id = c and (
      ch.owner_user_id = auth.uid()
      or g.gm_user_id = auth.uid()
      or (g.full_sheets_visible and public.is_table_member(g.id))
    )
  );
$$;

-- Propriétaire ou MJ de sa table (cahier §11.2).
create function public.can_write_character(c text) returns boolean
language sql stable security definer set search_path = ''
as $$
  select exists (
    select 1 from public.character ch
    left join public.game_table g on g.id = ch.table_id
    where ch.id = c
      and (ch.owner_user_id = auth.uid() or g.gm_user_id = auth.uid())
  );
$$;

alter table public.profile enable row level security;
alter table public.game_table enable row level security;
alter table public.table_member enable row level security;
alter table public.table_invite enable row level security;
alter table public.table_pack enable row level security;
alter table public.table_banned_entity enable row level security;
alter table public.character enable row level security;

-- Profil : le sien, et ceux de ses partenaires de table.
create policy profile_read on public.profile for select to authenticated
using (
  id = auth.uid()
  or exists (
    select 1 from public.table_member mine
    join public.table_member theirs on theirs.table_id = mine.table_id
    where mine.user_id = auth.uid() and theirs.user_id = profile.id
  )
);
create policy profile_write on public.profile for all to authenticated
using (id = auth.uid()) with check (id = auth.uid());

-- Table : visible des membres, modifiée par son MJ, créée par son MJ.
create policy game_table_read on public.game_table for select to authenticated
using (gm_user_id = auth.uid() or public.is_table_member(id));
create policy game_table_insert on public.game_table for insert
to authenticated with check (gm_user_id = auth.uid());
create policy game_table_update on public.game_table for update
to authenticated using (gm_user_id = auth.uid())
with check (gm_user_id = auth.uid());
create policy game_table_delete on public.game_table for delete
to authenticated using (gm_user_id = auth.uid());

-- Membres : visibles des membres ; le MJ les gère, un joueur peut partir.
-- Rejoindre par invitation passera par une fonction dédiée (US-14).
create policy table_member_read on public.table_member for select
to authenticated using (public.is_table_member(table_id));
create policy table_member_insert on public.table_member for insert
to authenticated with check (public.is_table_gm(table_id));
create policy table_member_update on public.table_member for update
to authenticated using (public.is_table_gm(table_id))
with check (public.is_table_gm(table_id));
create policy table_member_delete on public.table_member for delete
to authenticated
using (public.is_table_gm(table_id) or user_id = auth.uid());

-- Invitations : le MJ seul.
create policy table_invite_gm on public.table_invite for all to authenticated
using (public.is_table_gm(table_id)) with check (public.is_table_gm(table_id));

-- Packs et contenus interdits : visibles des membres, réglés par le MJ.
create policy table_pack_read on public.table_pack for select
to authenticated using (public.is_table_member(table_id));
create policy table_pack_write on public.table_pack for all to authenticated
using (public.is_table_gm(table_id)) with check (public.is_table_gm(table_id));
create policy table_banned_read on public.table_banned_entity for select
to authenticated using (public.is_table_member(table_id));
create policy table_banned_write on public.table_banned_entity for all
to authenticated using (public.is_table_gm(table_id))
with check (public.is_table_gm(table_id));

-- Personnage : lu par son propriétaire, son MJ, et les membres si la table
-- montre les fiches ; créé par son propriétaire ; modifié par son
-- propriétaire ou son MJ ; supprimé par son propriétaire seul.
create policy character_read on public.character for select to authenticated
using (public.can_read_character(id));
create policy character_insert on public.character for insert
to authenticated with check (owner_user_id = auth.uid());
create policy character_update on public.character for update
to authenticated using (public.can_write_character(id))
with check (public.can_write_character(id));
create policy character_delete on public.character for delete
to authenticated using (owner_user_id = auth.uid());

-- Contenu d'une fiche : mêmes droits que la fiche.
do $$
declare
  t text;
begin
  foreach t in array array[
    'character_base_scores', 'character_background_choice',
    'character_class_level', 'character_feat', 'character_weapon_mastery',
    'character_spell', 'character_item', 'character_state',
    'character_content_ref', 'character_language', 'character_choice'
  ] loop
    execute format('alter table public.%I enable row level security', t);
    execute format(
      'create policy %I on public.%I for select to authenticated '
      'using (public.can_read_character(character_id))', t || '_read', t);
    execute format(
      'create policy %I on public.%I for all to authenticated '
      'using (public.can_write_character(character_id)) '
      'with check (public.can_write_character(character_id))',
      t || '_write', t);
  end loop;
end
$$;

-- Historique : on ajoute, on ne corrige pas (EF-PJ-13).
alter table public.character_change_log enable row level security;
create policy change_log_read on public.character_change_log for select
to authenticated using (public.can_read_character(character_id));
create policy change_log_insert on public.character_change_log for insert
to authenticated with check (
  public.can_write_character(character_id) and author_user_id = auth.uid()
);
