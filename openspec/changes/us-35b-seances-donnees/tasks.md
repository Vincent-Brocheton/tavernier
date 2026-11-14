## 1. Serveur

- [x] 1.1 Tests SQL (`backend/supabase/tests/session_test.sql`) puis migration `20261126000000_seances.sql` : tables, `can_manage_table`, politiques, garde des présences, publication
- [x] 1.2 Tests SQL puis garde des PX et de `level_unlock` dans `guard_character`
- [x] 1.3 Flux `seances` dans `sync-config.yaml`, et sa vérification dans `sync_test.sh`

## 2. Base locale

- [x] 2.1 Tables Drift `Sessions` et `SessionAttendances`, `syncedTables`, code généré
- [x] 2.2 Tests puis `SessionStore` : création, modification, suppression avec présences, liste numérotée, présences

## 3. Vérification

- [x] 3.1 Suite complète (format, analyse, tests, couverture), puis tests SQL dans la CI
