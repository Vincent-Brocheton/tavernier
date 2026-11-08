# PowerSync

Service de synchronisation auto-hébergé (T-05), branché sur la base Supabase.

- `service.yaml` : réplication, stockage des buckets (Postgres), authentification par Supabase Auth. Les adresses et secrets viennent de l'environnement (liste en tête du fichier).
- `sync-config.yaml` : ce que chaque appareil reçoit (Sync Streams). Mêmes droits de lecture que les règles RLS de `../supabase/migrations` : un changement de l'un se reporte sur l'autre.
- `tests/sync_test.sh` : un MJ, deux joueurs et un inconnu lisent leur flux, comparé à ce que leur rôle doit recevoir.

## En CI

Le job « Base Supabase » démarre Supabase local, crée le rôle de réplication `powersync_role` et la base `powersync_storage`, lance l'image `journeyapps/powersync-service` sur le réseau Docker de Supabase, puis le test.

## En local (Docker requis)

Depuis `backend/`, `supabase start`, puis les commandes de l'étape « Démarrer PowerSync » de `.github/workflows/ci.yml`, puis `bash powersync/tests/sync_test.sh`.
