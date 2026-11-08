-- Tables répliquées par PowerSync (T-05). Ce qu'en reçoit chaque appareil est
-- décidé par backend/powersync/sync-config.yaml.
create publication powersync for table
  public.profile,
  public.game_table, public.table_member, public.table_invite,
  public.table_pack, public.table_banned_entity,
  public.character,
  public.character_base_scores, public.character_background_choice,
  public.character_class_level, public.character_feat,
  public.character_weapon_mastery, public.character_spell,
  public.character_item, public.character_state,
  public.character_content_ref, public.character_change_log,
  public.character_language, public.character_choice;
