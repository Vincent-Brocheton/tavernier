# Proposal

## Why

Carte Trello [US-19](https://trello.com/c/IlyBQSQV), lot a : le moteur et les données des rencontres préparées (**EF-REN-01** à **05**, cahier §6.1 et §11, SRD « Budget de PX par personnage »). Les écrans viennent aux lots b (liste [F5]) et c (préparation [C1]). Le découpage et le schéma sont validés par le porteur de projet.

## What Changes

- **Moteur (`dnd_rules`)** :
  - la table « Budget de PX par personnage » du SRD, niveaux 1 à 20, avec les seuils Faible, Modérée et Élevée ;
  - `encounterBudget(levels)` : la somme des seuils de chaque PJ présent ;
  - `encounterDifficulty(xp, budget)` : sous le budget faible, Faible, Modérée ou Élevée. C'est le plus haut seuil atteint.
- **Tables `encounter` et `encounter_group`** :
  - une rencontre a sa table, sa séance (vide pour une rencontre en réserve), son titre, son état (`draft`, `ready`, `running`, `finished`), son mode de PV (`average`, `roll`), sa position dans la séance et sa date de création ;
  - un groupe d'adversaires préparé a sa sorte (`monster`, `npc`), sa référence, sa quantité (1 à 30), son initiative commune et sa position.
- **Droits** : seul le MJ de la table lit et reçoit les rencontres. Il les écrit sur une table ni archivée ni sans MJ. La séance d'une rencontre est de sa table.
- **Synchronisation** : un flux `rencontres`, réservé au MJ.
- **Base locale** :
  - la table locale `encounter` (M1) devient synchronisée ;
  - `encounter_group` est nouvelle.
- **`EncounterStore`** :
  - créer, modifier (titre, séance, état, mode de PV, position), dupliquer (titre « (copie) », groupes recopiés, brouillon) et supprimer une rencontre ;
  - suivre les rencontres d'une table avec leurs groupes ;
  - ajouter un groupe (ou augmenter la quantité d'un groupe existant de même référence), changer sa quantité ou son initiative commune, et le retirer.

## Capabilities

### New Capabilities

- `encounters` : règles de préparation des rencontres (budget de PX 2024, difficulté).

### Modified Capabilities

- `sync-backend` : rencontres et groupes au serveur.
- `local-database` : rencontres stockées, `EncounterStore`.

## Impact

- `packages/dnd_rules/lib/src/encounter_budget.dart` (nouveau) et son test.
- `backend/supabase/migrations/20261128000000_rencontres.sql`, `backend/supabase/tests/encounter_test.sql` (nouveaux) ; `backend/powersync/sync-config.yaml` et `tests/sync_test.sh`.
- `packages/dnd_data/` :
  - tables ;
  - `syncedTables` et export ;
  - `encounter_store.dart` (nouveau) ;
  - code généré et instantané du schéma ;
  - tests.

**Hors périmètre :**
- **Écrans** : lots b et c.
- **Combattants** (`combatant`) et **journal** (`encounter_event`) : ils naissent au lancement (US-20). Ces tables restent locales et inchangées.
- **Difficulté stockée** : elle se calcule à l'affichage, car les PJ présents peuvent changer.
