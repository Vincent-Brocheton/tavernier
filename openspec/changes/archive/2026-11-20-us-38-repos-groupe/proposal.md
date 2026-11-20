# Proposal

## Why

Carte Trello [US-38](https://trello.com/c/eBFnaDR3) : le repos de groupe. Exigence : **EF-PJ-19** ; cahier §5.2 ; planches [J9] et [J10] ; composant `GroupRestPanel` (COMPOSANTS §2.49).

Le repos existe déjà sur la fiche ([P12], [P13]), mais chaque joueur le lance seul. Le MJ ne peut ni le déclencher pour le groupe, ni voir qui a terminé.

Décisions du porteur de projet du 20 novembre 2026 :
- deux tables serveur : `group_rest`, que le MJ écrit, et `group_rest_done`, que le joueur écrit pour son PJ, ou le MJ à sa place ;
- « Faire pour Brannoc » ([J9]) ouvre l'écran de repos sur la fiche du PJ : le MJ le fait pour un joueur hors-ligne.

La carte est livrée en deux lots.

## What Changes

### Lot a : données

- **Serveur** :
  - `group_rest` : `id`, `table_id`, `session_id`, `kind` (`short` ou `long`), `characters` (les PJ visés, en JSON), `created_at`, `closed_at`. Les membres le lisent ; le MJ d'une table active l'écrit.
  - `group_rest_done` : `id`, `rest_id`, `table_id`, `character_id`, `author_user_id`, `summary` (JSON), `created_at`. Le propriétaire du PJ l'insère, ou le MJ, pour un PJ visé d'un repos ouvert ; les membres le lisent.
  - Les règles PowerSync et les tests de droits (pgTAP, flux).
- **Base locale** : les deux tables synchronisées, au schéma v4, avec leur migration.
- **Dépôt** `GroupRestStore` : déclencher, clore, signaler la fin d'un PJ ; suivre les repos ouverts d'une table, celui qui attend un PJ, et qui a terminé.

### Lot b : écrans

- **MJ ([J9])** : sur la page d'une séance en cours, « Repos pour le groupe » (court ou long, PJ présents cochés). Le suivi montre « Terminé », avec le récapitulatif, ou « En attente », puis « Faire pour… » et « Clore le repos ».
- **Joueur ([J10])** : sur la fiche du PJ visé, un bandeau « Camille lance un repos court pour le groupe » ouvre l'écran de repos habituel, avec l'origine en tête. « Terminer » signale la fin et son récapitulatif.

Le repos individuel reste possible hors séance.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : `group_rest`, `group_rest_done`.
- `local-database` : schéma v4.
- `tables` : repos de groupe (lot b).

## Impact

- **Serveur** : une migration, un test pgTAP, `sync-config.yaml` et `sync_test.sh`.
- **`dnd_data`** : tables, migration v4, dépôt.
- **App** : lot b.

## Hors périmètre

- **« En cours »** de [J9] (« choisit ses dés de vie… ») : il faudrait que le joueur signale l'ouverture de l'écran. Le suivi montre « Terminé » ou « En attente ».
- **Notifications** : le bandeau apparaît à l'ouverture de la fiche, ou pendant son usage.
