# backend/supabase

Schéma Postgres, règles d'accès par ligne (RLS) et, plus tard, règles de synchronisation PowerSync (cahier §10.2, §11.2).

- `migrations/` : schéma des données de jeu, miroir des tables locales de `dnd_data`. Les migrations ne sont appliquées que par la CI (§12.2).
- `tests/` : tests pgTAP des droits, un MJ, deux joueurs et un inconnu.
- `config.toml` : Supabase local, pour la CI. Aucun secret dans le dépôt.

## En local

Il faut Docker et la CLI Supabase :

```
cd backend
supabase start
supabase db reset
supabase test db
```

Sans Docker sur la machine, ces étapes tournent dans le job « Base Supabase » de la CI.
