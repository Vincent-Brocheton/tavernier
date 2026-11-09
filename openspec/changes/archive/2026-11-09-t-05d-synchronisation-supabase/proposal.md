# Proposal

## Why

Carte Trello [T-05](https://trello.com/c/DouzMTWV), quatrième et dernier change. L'app tourne sur PowerSync (t-05c), et le service et ses règles sont testés (t-05b). Il manque le lien entre les deux : envoyer à Supabase les écritures en attente, recevoir celles des autres appareils, et fusionner sans perte. Ce change porte les critères restants de la carte : fusion sans perte sur 3 appareils et coût estimé pour 1 000 utilisateurs.

## What Changes

- **Connecteur Supabase** (`dnd_data`) : jeton de la session Supabase pour PowerSync, envoi de la file `ps_crud` par l'API de Supabase (insertion, modification des seules colonnes changées, suppression), booléens convertis.
- **Propriétaire à l'envoi :** un personnage créé sans compte n'a pas de propriétaire. À l'envoi, le connecteur lui donne l'utilisateur connecté, sinon le serveur le refuserait.
- **Erreurs définitives** (droits refusés, contrainte violée) : l'écriture est écartée et journalisée, pour ne pas bloquer la file. Les erreurs réseau sont réessayées.
- **Enregistrement par différence :** `CharacterStore.save` ne réécrit plus tout le contenu d'une fiche. Il insère, modifie ou supprime seulement les lignes qui changent, et PowerSync n'envoie que les colonnes changées. Un appareil n'écrase plus ce qu'un autre a modifié ailleurs : c'est le « dernier écrit gagnant champ par champ » d'ENF-03.
- **Test de fusion en CI :** trois appareils d'un même compte modifient la même fiche hors ligne, chacun sur un point différent, puis se reconnectent. Les trois finissent avec les trois modifications, et le serveur aussi.
- **Estimation du coût** pour 1 000 utilisateurs (Supabase et PowerSync), dans `docs/spikes/T-05-cout.md`.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `local-database` : enregistrement par différence.
- `sync-backend` : envoi des écritures et fusion.

## Impact

- `packages/dnd_data` : connecteur, `CharacterStore`, schéma PowerSync (`ignoreEmptyUpdates`), tests.
- `.github/workflows/ci.yml` : test de fusion dans le job « Base Supabase ».
- `docs/spikes/T-05-cout.md`.

**Hors périmètre :**
- **Connexion dans l'app** (écrans, session, bascule en ligne) : US-39, US-40, US-12.
- **Notification d'un écrasement** (ENF-03) : avec US-16.
- **Synchronisation testée dans un navigateur :** le protocole est le même code que sur natif, et la base Web est déjà vérifiée (t-05c). On l'ajoutera avec la connexion dans l'app.
