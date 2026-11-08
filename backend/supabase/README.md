# backend/supabase

Schéma Postgres, règles d'accès par ligne (RLS) et, plus tard, règles de synchronisation PowerSync (cahier §10.2, §11.2).

- `migrations/` : schéma des données de jeu, miroir des tables locales de `dnd_data`. Les migrations ne sont appliquées que par la CI (§12.2).
- `tests/` : tests pgTAP des droits, un MJ, deux joueurs et un inconnu.
- `config.toml` : Supabase local, pour la CI. Aucun secret dans le dépôt.

## Projet hébergé

Projet `mtreifjwfadiyvatldux` (https://mtreifjwfadiyvatldux.supabase.co). Le job « Migrations Supabase (projet hébergé) » y applique les migrations à chaque fusion sur `main`, après leur passage sur base vierge. Il attend deux secrets du dépôt, ajoutés par le porteur de projet :

- `SUPABASE_ACCESS_TOKEN` : jeton d'accès personnel Supabase ;
- `SUPABASE_DB_PASSWORD` : mot de passe de la base du projet.

Sans eux, le job s'arrête sur une simple note.

## En local

Il faut Docker et la CLI Supabase :

```
cd backend
supabase start
supabase db reset
supabase test db
```

Sans Docker sur la machine, ces étapes tournent dans le job « Base Supabase » de la CI.
