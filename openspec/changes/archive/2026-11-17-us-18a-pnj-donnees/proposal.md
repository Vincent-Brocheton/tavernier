# Proposal

## Why

Carte Trello [US-18](https://trello.com/c/0XIAKPIF), lot a : les PNJ du MJ (**EF-PNJ-01** à **03**, **EF-ACT-06**, cahier §5.3 et §11). Ce lot pose le stockage, les droits et la synchronisation des PNJ. Les écrans viennent aux lots b (bloc de stats), c (informations cachées) et d (fiche complète). Le découpage et le schéma sont validés par le porteur de projet.

## What Changes

- **Table `npc_statblock`** (nom du cahier §11) :
  - table, nom (obligatoire) et dossier libre ;
  - monstre de départ et bloc de stats (JSON) pour un bloc de stats ;
  - fiche liée (`character_id`) pour une fiche complète ;
  - attitude (`friendly`, `indifferent` par défaut, `hostile`), informations cachées (JSON) et date de création.
- **Droits** :
  - Seul le MJ de la table lit et reçoit les PNJ.
  - Il les écrit sur une table ni archivée ni sans MJ.
  - Une fiche liée appartient à la même table.
- **Fiches complètes de PNJ cachées aux joueurs** : quand la table montre les fiches complètes, un membre ne lit et ne reçoit que les fiches de PJ (`kind = 'pc'`). Ce changement touche `can_read_character` et le flux `fiches`.
- **Base locale** :
  - la table locale `npc_statblock` (M1) devient synchronisée, avec les nouvelles colonnes ;
  - un `NpcStore` crée, modifie, duplique et supprime un PNJ, et suit les PNJ d'une table, triés par dossier puis par nom.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : PNJ au serveur ; fiches de PNJ cachées aux membres.
- `local-database` : PNJ stockés, `NpcStore`.

## Impact

- `backend/supabase/migrations/20261127000000_pnj.sql`, `backend/supabase/tests/npc_test.sql` (nouveaux).
- `backend/powersync/sync-config.yaml` et `tests/sync_test.sh`.
- `packages/dnd_data/` :
  - `game_tables.dart`, `powersync.dart`, `user_data.dart` ;
  - `npc_store.dart` (nouveau) ;
  - code généré et instantané du schéma ;
  - tests.

**Hors périmètre :**
- Écrans (lots b à d).
- Publication du résumé d'une fiche de PNJ (`character_summary`) : le lot d l'écartera, car aucune fiche de PNJ n'existe avant lui.
- Révélation par l'Étude (US-22) et ajout à une rencontre (US-19).
