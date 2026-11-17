## 1. Moteur

- [x] 1.1 Tests ([D1], SRD) puis budget de PX par niveau, budget d'une rencontre et difficulté

## 2. Serveur

- [x] 2.1 Tests SQL (`encounter_test.sql`) puis migration `20261128000000_rencontres.sql` : tables, droits, gardes, publication
- [x] 2.2 Flux `rencontres` dans `sync-config.yaml`, vérifié par `sync_test.sh`

## 3. Base locale

- [x] 3.1 Tables `Encounters` et `EncounterGroups` synchronisées, export, code généré
- [x] 3.2 Tests puis `EncounterStore` : création, modification, duplication, suppression, liste, groupes

## 4. Vérification

- [x] 4.1 Suite complète, revue, PR
