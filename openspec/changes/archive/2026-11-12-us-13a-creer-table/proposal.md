# Proposal

## Why

Carte Trello [US-13](https://trello.com/c/HnddY6eD), premier lot : « En tant que MJ, je crée et configure une table. » Exigences EF-TAB-01 (nom, description, niveau de départ), EF-TAB-02 (une méthode de caractéristiques), EF-TAB-03 (repos long, PV à la montée de niveau), EF-TAB-04 (packs actifs) et EF-TAB-10 (progression en PX ou en jalons). Écran [T8]. Les comptes et la synchronisation sont en place : une table créée part au serveur et ira aux joueurs.

## What Changes

- **Onglet Tables**, une fois connecté : la liste de ses tables (MJ ou membre), avec « Nouvelle table ».
- **« Nouvelle table » [T8]** :
  - nom (obligatoire), description, niveau de départ de 1 à 20 ;
  - méthode de caractéristiques : Valeurs standard, Acquisition par points ou Génération aléatoire ;
  - repos long : récupération totale des PV, ou par dés de vie ;
  - PV à la montée de niveau : moyenne fixe ou jet de dé ;
  - progression : points d'expérience ou jalons ;
  - packs actifs : SRD 5.2.1, toujours actif ;
  - aperçu de la carte, sur desktop ;
  - « Créer la table ».
- **À la création** : la table, l'inscription du MJ comme membre et le pack SRD s'écrivent dans une seule transaction locale. Ça marche hors ligne, et tout part au serveur ensemble (envoi par lot, T-05).
- **Page de la table**, première version : « Vous êtes MJ », le nom, et le résumé de la configuration.
- **Schéma** : colonne `description` sur `game_table`, côté Supabase (migration) et côté Drift.

## Capabilities

### New Capabilities

- `tables` : création et liste des tables.

### Modified Capabilities

- `local-database` : description d'une table, dépôt des tables.

## Impact

- `backend/supabase/migrations/` : `description`.
- `packages/dnd_data` : colonne, `TableStore`, tests.
- `apps/game_table` : `lib/tables/` (liste, création, page), routes ; ARB ; tests.

**Hors périmètre :**
- **Configuration après création** [F6], changements en cours de campagne datés dans l'activité (EF-TAB-11), visibilité des fiches, archivage (EF-TAB-07) : lot us-13b.
- **Image de couverture** : avec le stockage des images, comme l'avatar (US-40, lot c).
- **Packs homebrew et bannissement d'entités** : M4 (aucun pack homebrew n'existe encore).
