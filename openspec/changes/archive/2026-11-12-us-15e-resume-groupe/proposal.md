# Proposal

## Why

Carte Trello [US-15](https://trello.com/c/UMRG1bPS), lot e, dernier. Exigence EF-TAB-09 : chaque joueur voit un résumé des autres PJ (nom, portrait, espèce, classe, niveau, état de santé qualitatif), sans PV chiffrés. L'état qualitatif est :
- **indemne** : PV au maximum ;
- **blessé** : plus de la moitié des PV max ;
- **gravement blessé** : la moitié ou moins.

Si le MJ ouvre les fiches complètes, elles se lisent sans être modifiables. Écran [T13], section « Le groupe ».

Un joueur ne reçoit pas les fiches des autres tant que le MJ ne les ouvre pas : le résumé doit donc voyager seul. Les PV max se calculent avec le moteur, sur l'appareil.

## What Changes

- **Résumé publié** : table `character_summary`, une ligne par fiche de table. Elle porte la table, le propriétaire, le nom, l'espèce, les classes et niveaux, et l'état de santé qualitatif. Les membres de la table la lisent ; seuls le propriétaire et le MJ l'écrivent.
- **Publication** : l'appareil du propriétaire recalcule le résumé de ses fiches de table à chaque changement : création, montée de niveau, PV, repos. Il ne l'écrit que s'il a changé. Les PV chiffrés ne quittent pas la fiche.
- **« Le groupe »** dans la vue d'ensemble de la table : les autres PJ avec leur initiale (pas encore de portrait), leur nom, « Espèce · Classe N », et leur état avec icône et libellé. Sous la liste : « Les PV exacts des autres joueurs restent visibles du MJ seulement. »
- **Fiches complètes** : quand le MJ les a ouvertes, toucher un PJ du groupe ouvre sa fiche en lecture seule. Ni montée de niveau, ni repos, ni changement d'inventaire ou de sorts. Une fiche archivée s'ouvre aussi en lecture seule.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : résumé du groupe.
- `sync-backend` : `character_summary`.
- `local-database` : résumés, publication.
- `character-sheet` : lecture seule.

## Impact

- `backend/supabase/migrations/`, `backend/supabase/tests/`, `backend/powersync/sync-config.yaml` et son test.
- `packages/dnd_data` : table `character_summary` (instantané Drift v1 régénéré), `CharacterStore`, `TableStore`.
- `apps/game_table` : publication à la racine, vue d'ensemble, fiche en lecture seule ; ARB ; tests.

**À faire par le porteur de projet** : redéployer les règles PowerSync (nouveau flux `character_summary`).

**Hors périmètre :**
- **Portrait** : l'avatar arrive avec US-40 lot c ; l'initiale le remplace en attendant.
- **Vue joueur [T13] complète** (en-tête de séance, notes, packs) : M3.
