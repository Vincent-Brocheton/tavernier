# Proposal

## Why

Carte Trello [US-13](https://trello.com/c/HnddY6eD), second lot. Exigences EF-TAB-11 (changement de configuration en cours de campagne : la nouvelle méthode ne vaut que pour les prochaines créations, chaque changement est daté dans l'activité de la table), EF-TAB-09 (réglage des fiches complètes ouvertes aux autres PJ), EF-TAB-07 (archivage en lecture seule, restaurable) et EF-TAB-03 et 10 modifiables. Écran [F6]. La création existe (us-13a).

## What Changes

- **Page de la table en onglets** : « Vue d'ensemble » pour tous ; « Configuration » pour le MJ.
- **Configuration [F6]** :
  - Création des personnages : méthode et niveau de départ. Un bandeau rappelle que le changement ne touche pas les fiches existantes (EF-TAB-11) ;
  - Règles de jeu : repos long, PV à la montée de niveau, progression. Une note précise que passer aux jalons garde les PX acquis ;
  - Visibilité entre joueurs : « Ouvrir les fiches complètes des autres PJ » ;
  - Packs actifs (lecture : SRD 5.2.1) ;
  - Zone sensible : « Archiver » ou « Restaurer » ;
  - panneau « Modifications non enregistrées », avec Annuler et Enregistrer, et carte « Qui est prévenu ».
- **Activité de la table** : chaque changement enregistré, archivage compris, devient une entrée datée avec son auteur. La « Vue d'ensemble » montre les dernières.
- **Archivage en lecture seule (serveur)** : une table archivée refuse toute écriture sur ses fiches. Seul le MJ peut la restaurer. Dans l'app, la configuration est verrouillée tant qu'elle est archivée.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : configuration, activité, archivage.
- `sync-backend` : table `table_activity`, règles de lecture et de synchronisation, lecture seule d'une table archivée.

## Impact

- `backend/supabase/migrations/`, `backend/supabase/tests/`, `backend/powersync/sync-config.yaml`, `backend/powersync/tests/sync_test.sh`.
- `packages/dnd_data` : table `table_activity`, `TableStore` (mise à jour, archivage, activité).
- `apps/game_table/lib/tables/` : onglets, configuration, activité ; ARB ; tests.

**À faire par le porteur de projet** : redéployer les règles de synchronisation dans le tableau de bord PowerSync (nouveau flux de l'activité), en recollant `backend/powersync/sync-config.yaml`.

**Hors périmètre :**
- **PX figés au passage en jalons** : les PX ne sont pas encore gérés (séances, M3). La note de [F6] le dit déjà.
- **« Gérer les packs »** et bannissement d'entités : M4.
- **Résumé des autres PJ** quand les fiches restent fermées (EF-TAB-09) : US-15.
- **Autres onglets** de [F6] (Séances, Rencontres, PNJ, Notes, Membres) : cartes suivantes.
