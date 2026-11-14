# Proposal

## Why

Carte Trello [US-35](https://trello.com/c/ClnskrIq), lot b. Le lot a a livré la montée de niveau déverrouillée. Il manque deux choses :

- les séances elles-mêmes (**EF-SEA-01**, **EF-SEA-02**) ;
- une garde serveur : aujourd'hui, un joueur peut écrire lui-même `level_unlock` ou ses PX sur une fiche de table.

Ce lot pose le stockage, les droits et la synchronisation des séances et de leurs présences, puis cette garde. Les écrans viennent au lot c.

## What Changes

- **Table `session`** (cahier §11) : table, titre, date, état (`planned` « Préparée », `in_progress` « En cours », `closed` « Close »), date de création. Le numéro « Séance n » n'est pas stocké : il se déduit de l'ordre des dates.
- **Table `session_attendance`** : un personnage prévu à une séance. Une ligne veut dire « présent » ; sans ligne, il est absent.
- **Droits** : les membres de la table lisent les séances et leurs présences, parce que le joueur voit « Personnage attendu : Aldric Varenne » ([S5]). Seul le MJ les crée, les modifie et les supprime, et jamais sur une table archivée ou sans MJ.
- **Synchronisation** : les deux tables vont aux membres de la table.
- **Garde des fiches** : sur une fiche de table, seul le MJ de la table change `xp` et `level_unlock`. Une fiche naît sans `level_unlock`. Une fiche libre garde ses PX libres.
- **Base locale** : tables Drift synchronisées, et un `SessionStore` qui crée, modifie et supprime une séance, liste celles d'une table avec leur numéro, et coche les présences.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : séances et présences au serveur, garde des PX et du déverrouillage.
- `local-database` : séances et présences locales, `SessionStore`.

## Impact

- `backend/supabase/migrations/20261126000000_seances.sql` (nouveau), `backend/supabase/tests/session_test.sql` (nouveau).
- `backend/powersync/sync-config.yaml` : flux des séances ; `backend/powersync/tests/sync_test.sh` si la vérification liste les tables.
- `packages/dnd_data/` :
  - `game_tables.dart` : `Sessions`, `SessionAttendances` ;
  - `powersync.dart` : `syncedTables` ;
  - `session_store.dart` (nouveau) et son export ;
  - code généré ;
  - tests.

**Hors périmètre :**
- **Écrans** (lot c) : liste des séances, création, « Jouer tout de suite », préparation, présences.
- **Rencontres** (`encounter`) : elles viennent avec leurs cartes (US-19 et suivantes), et la préparation les listera.
- **Clôture et PX par séance** (lot d, après US-19).
- **Notes de séance** : elles viennent avec la carte des notes.
- **Assistant de montée ouvert par une adresse directe** : le contrôle côté app reste à faire. La garde serveur empêche seulement de s'accorder un niveau.
