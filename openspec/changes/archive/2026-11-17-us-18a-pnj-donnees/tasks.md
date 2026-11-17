## 1. Serveur

- [x] 1.1 Tests SQL (`npc_test.sql`) puis migration `20261127000000_pnj.sql` : table, droits, garde de la fiche liée, publication
- [x] 1.2 Tests SQL puis `can_read_character` limité aux PJ pour les membres
- [x] 1.3 Flux `pnj` et `fiches_lues` dans `sync-config.yaml`, vérifiés par `sync_test.sh`

## 2. Base locale

- [x] 2.1 Table `NpcStatblocks` synchronisée, nouvelles colonnes, export, code généré
- [x] 2.2 Tests puis `NpcStore` : création, modification, duplication, suppression, liste par dossier

## 3. Vérification

- [x] 3.1 Suite complète, revue, PR
