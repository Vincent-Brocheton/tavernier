-- Avatar du profil (US-40, EF-CPT-03) : une image en data URI base64, compressée
-- sur l'appareil sous 200 Ko (≈ 273 100 caractères encodés). Une écriture hors
-- de ces bornes est refusée, donc écartée par apply_crud.
alter table public.profile add constraint profile_avatar_check check (
  avatar is null or (
    avatar ~ '^data:image/(jpeg|png|webp);base64,[A-Za-z0-9+/]+=*$'
    and length(avatar) <= 273100
  )
);
