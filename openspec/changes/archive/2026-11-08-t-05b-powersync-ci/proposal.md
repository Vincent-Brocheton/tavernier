# Proposal

## Why

Carte Trello [T-05](https://trello.com/c/DouzMTWV), deuxième change. Le schéma et les droits Supabase sont en place (t-05a). Il faut maintenant le service PowerSync et ses règles de synchronisation : ce que chaque appareil reçoit. Aucune instance PowerSync n'existe encore et la machine de développement n'a pas Docker : le service tourne dans la CI, auto-hébergé, à côté de Supabase local.

## What Changes

- **Publication Postgres `powersync`** : les tables de jeu répliquées, par migration (locale et hébergée).
- **Configuration du service** : `backend/powersync/service.yaml`, réplication depuis Postgres, stockage des buckets dans Postgres, authentification par les jetons Supabase.
- **Règles de synchronisation** (`sync-config.yaml`, Sync Streams) : les mêmes droits de lecture que les règles RLS. Le joueur reçoit sa fiche, ses tables et leurs membres. Le MJ reçoit en plus les fiches et les invitations de ses tables. Les autres membres ne reçoivent les fiches que si la table les montre.
- **Test en CI** : un MJ, deux joueurs et un inconnu, connectés avec de vrais comptes Supabase Auth. Chacun lit son flux de synchronisation, et le test compare ce flux à ce que ce rôle doit recevoir.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : règles de synchronisation alignées sur les droits.

## Impact

- `backend/supabase/migrations/` : nouvelle migration.
- `backend/powersync/` : configuration, règles, test.
- `.github/workflows/ci.yml` : PowerSync dans le job « Base Supabase ».

**Hors périmètre :**
- **Client Flutter** (PowerSync et Drift, Web d'abord) : change suivant.
- **Instance PowerSync hébergée** (UE) : créée par le porteur de projet au change suivant.
- **Résumé et état de santé aux autres joueurs** : avec US-15.
- **Fusion sur 3 appareils, coût à 1 000 utilisateurs** : critères de T-05 vérifiés avec le client.
