## 1. Serveur

- [x] 1.1 Tests SQL (`encounter_event_test.sql`) puis migration `20261129000000_journal_combat.sql` : table, droits, garde, publication
- [x] 1.2 Journal dans le flux `rencontres`, vérifié par `sync_test.sh`

## 2. Base locale

- [x] 2.1 `EncounterEvents` au schéma du serveur, synchronisée ; `Combatants` retirée ; export ; code généré
- [x] 2.2 Tests puis `CombatStore` : ajout, journal ordonné, projection, lancement, fin

## 3. Vérification

- [x] 3.1 Suite complète, revue, PR
