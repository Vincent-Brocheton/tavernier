# Proposal

## Why

Carte Trello [US-17](https://trello.com/c/VDVUxvnl), troisième et dernier lot : la suppression du compte depuis l'app.
- **EF-CPT-04** (exigence Apple et Google) :
  - l'app propose d'exporter les données avant la suppression ;
  - les PJ du compte sont retirés des tables ;
  - les tables dont il est MJ restent en place sans MJ, et leurs fiches ne sont plus modifiables (décision du 25 octobre 2026, §14.3).
- **ENF-10** : la suppression est effective sous 30 jours.
- **Écrans :** [T15] (« Supprimer le compte »), [T14] et [A7] (entrée dans le profil).

## What Changes

- **Serveur — `delete_my_account()`** supprime tout de suite le compte de l'appelant. C'est plus strict que les 30 jours d'ENF-10. Les clés étrangères font le reste :
  - profil, appartenances, emplacements et invitations du compte supprimés ;
  - ses personnages supprimés, avec tout leur détail, ce qui les retire des tables ;
  - les tables dont il est MJ restent en place, sans MJ ;
  - les historiques gardent leurs lignes, sans auteur.
- **Serveur — table sans MJ en lecture seule** :
  - ses fiches ne se modifient plus (`can_write_character`) ;
  - un joueur ne peut pas retirer son PJ de son emplacement.
- **Serveur — table archivée** : sa garde ne bloque plus le serveur lui-même. Le MJ d'une table archivée peut donc supprimer son compte.
- **App — page [T15]** :
  - « D'abord, gardez une copie » (export), puis « Ce qui va se passer » ;
  - le champ « Tapez SUPPRIMER pour confirmer », puis « Annuler » et « Supprimer définitivement ».

  Une fois le compte supprimé, l'appareil efface les données synchronisées et ferme la session. Sans réseau, rien n'est supprimé et la page le dit.
- **App — entrée dans le profil** : « Supprimer mon compte », réservée à un compte connecté.
- **App — fiche d'une table sans MJ** : elle s'affiche en lecture seule.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : suppression du compte, table sans MJ en lecture seule.
- `account` : page de suppression du compte.
- `character-sheet` : fiche d'une table sans MJ en lecture seule.

## Impact

- `backend/supabase/migrations/20261124000000_suppression_compte.sql`, `backend/supabase/tests/delete_account_test.sql`.
- `packages/dnd_data/` : `CharacterStore.access` dit si la table de la fiche n'a plus de MJ.
- `apps/game_table/` :
  - `AccountGateway.deleteAccount`, `SessionActions.deleteAccount` ;
  - `account/delete_account_page.dart`, route `/profil/supprimer`, entrée du profil ;
  - `sheetEditableProvider` ;
  - ARB ;
  - tests.

**Hors périmètre :**
- **Packs publiés attribués à « auteur supprimé »** : la publication de packs arrive en M4. La page l'annonce déjà, comme [T15].
- **Délai de grâce ou annulation** de la suppression : la page dit « La suppression est définitive. ».
- **Transfert de MJ** : décision du 25 octobre 2026, carte « Plus tard ».
- **Données locales non synchronisées** (tables de M3) : elles restent sur l'appareil, comme à une déconnexion.
