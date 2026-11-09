# Proposal

## Why

Carte Trello [US-12](https://trello.com/c/U3VFXUL3), troisième et dernier lot. Exigence EF-CPT-05 : « Gestion des appareils connectés : liste et déconnexion à distance. » Écrans [T5] et [A7], section « Appareils connectés ».

## What Changes

- **Fonctions serveur** (migration) :
  - `list_my_sessions()` : les sessions de l'utilisateur, avec l'appareil, la dernière activité et l'indication « cet appareil » ;
  - `revoke_my_session(id)` : déconnecte une autre de ses sessions. Celle de l'appareil courant ne se révoque pas ainsi : il a « Se déconnecter ».
- **Section « Appareils connectés »** du profil : chaque appareil avec son icône, son libellé (« Chrome sur Windows », « Téléphone Android », « iPhone »…) et sa dernière activité (« Cet appareil · actif maintenant », « Il y a 2 jours »), plus « Déconnecter » sur les autres. Sans réseau, un message le dit.
- **Applications natives :** elles annoncent leur plateforme (`User-Agent: Tavernier (android)`…), puisqu'un navigateur donne la sienne et qu'une app Dart ne la donne pas.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `account` : appareils connectés.
- `sync-backend` : sessions listées et révoquées par leur propriétaire.

## Impact

- `backend/supabase/migrations/`, `backend/supabase/tests/`.
- `apps/game_table/lib/account/` : libellé d'appareil, `SessionActions`, section du profil ; ARB ; tests.

**Hors périmètre :**
- **Effet immédiat :** l'appareil déconnecté garde son jeton d'accès jusqu'à son expiration (1 heure au plus). Il ne peut plus le renouveler, donc ne se resynchronise pas au-delà.
- **Nom d'appareil choisi par l'utilisateur.**
