# Proposal

## Why

Carte Trello [T-05](https://trello.com/c/DouzMTWV), premier change. M2 synchronise les fiches et les tables via Supabase et PowerSync. Ni le projet Supabase (région UE) ni l'instance PowerSync n'existent encore, et la machine de développement n'a pas Docker : le backend démarre dans la CI.

## What Changes

- **Schéma Postgres :** données de jeu du cahier §11.2 (profil, tables, membres, invitations, packs, fiches et leur contenu), miroir des tables locales de `dnd_data`.
- **Droits (RLS) :** par table et par rôle. Membres, MJ, propriétaire d'une fiche, fiches visibles des membres si la table le permet, historique sans correction.
- **Tests pgTAP :** un MJ, deux joueurs et un inconnu, chacun vérifié sous son identité.
- **CI :** job « Base Supabase » : Supabase local dans Docker, migrations sur base vierge, tests des droits.

## Capabilities

### New Capabilities

- `sync-backend` : schéma et droits du backend de synchronisation.

### Modified Capabilities

Aucune.

## Impact

- `backend/supabase/` : `config.toml`, `migrations/`, `tests/`, README.
- `.github/workflows/ci.yml` : nouveau job.

**Hors périmètre :**
- **PowerSync :** service et règles de synchronisation, puis client Flutter, aux changes suivants.
- **Rencontres, PNJ, séances, notes :** M3.
- **Rejoindre une table par invitation :** fonction dédiée avec US-14.
- **Résumé et état de santé qualitatif aux autres joueurs :** vue dédiée avec US-15.
- **Projet Supabase hébergé :** créé par le porteur de projet.
