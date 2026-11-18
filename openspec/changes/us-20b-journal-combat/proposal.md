# Proposal

## Why

Carte Trello [US-20](https://trello.com/c/unGA2o4Y), lot b : le journal du combat est stocké et synchronisé (cahier §10 et §11, **EF-INI-01** à **07**). Le lot a a écrit le moteur (`projectCombat`) ; ce lot lui donne son journal, sur l'appareil du MJ et au serveur, pour qu'une rencontre se joue hors ligne et reprenne sur un autre appareil. Le schéma est validé par le porteur de projet.

## What Changes

- **Table `encounter_event`** : rencontre, table, auteur, type, données JSON et date de création. Son identifiant est un UUID v7, qui donne l'ordre du journal.
- **Droits** :
  - seul le MJ de la table lit, reçoit et ajoute des événements, en son nom, sur une table ni archivée ni sans MJ ;
  - le journal est en ajout seul : aucune modification, et aucune suppression hors celle de la rencontre.
- **Synchronisation** : le journal entre dans le flux `rencontres` du MJ.
- **Base locale** :
  - `encounter_event` devient synchronisée, avec le schéma du serveur ;
  - la table locale `combatant` (M1), jamais utilisée, est retirée, car les combattants se déduisent du journal.
- **`CombatStore`** :
  - `append(encounterId, events, authorUserId)` ajoute des événements en une transaction ;
  - `watchEvents` et `watchState(encounterId)` suivent la projection ;
  - `launch(encounterId, events)` passe la rencontre « En cours » et écrit ses premiers événements ;
  - `finish(encounterId)` la passe « Terminée ».

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : journal du combat au serveur.
- `local-database` : journal local, `CombatStore`, retrait de `combatant`.

## Impact

- `backend/supabase/migrations/20261129000000_journal_combat.sql`, `backend/supabase/tests/encounter_event_test.sql` (nouveaux).
- `backend/powersync/sync-config.yaml` et `tests/sync_test.sh`.
- `packages/dnd_data/` :
  - tables, `syncedTables`, export ;
  - `combat_store.dart` (nouveau) ;
  - code généré et instantané du schéma ;
  - tests.

**Hors périmètre :**
- **Écrans** : lots c et d.
- **Lecture du journal par les joueurs** : US-36, qui ouvrira les droits à la ligne de leur PJ.
