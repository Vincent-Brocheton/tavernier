# Proposal

## Why

Carte Trello [US-15](https://trello.com/c/UMRG1bPS), lot c. Cahier §4.3 :
- point 3 : le MJ valide la fiche finale, ou demande des corrections avec un commentaire ;
- point 5 : il transfère un PJ d'un joueur à un autre, par exemple quand un joueur quitte le groupe.

Écran [T10], panneau « Fiche à valider ». Les emplacements et l'envoi au MJ existent (us-15b).

## What Changes

- **Message du joueur** : « Envoyer au MJ » ouvre une boîte de dialogue avec un message facultatif pour le MJ (« Message de Hugo : … » sur [T10]).
- **Panneau « Fiche à valider »** dans l'onglet Membres du MJ, une carte par fiche envoyée :
  - nom, classe et niveau, historique, « par » le joueur ;
  - contrôles, chacun avec son icône : méthode de la table respectée, niveau de départ, intégrité des règles (erreurs du moteur) ;
  - message du joueur ;
  - champ « Commentaire (requis pour des corrections) » ;
  - « Demander des corrections » (actif seulement avec un commentaire) et « Valider » ;
  - « Ouvrir la fiche complète ».
- **Côté joueur** : une fiche à corriger affiche le commentaire du MJ dans « Mon personnage », au-dessus de « Envoyer au MJ ».
- **Transfert d'un PJ** : sur un emplacement rempli, le MJ choisit « Transférer à… » puis un autre membre. L'emplacement et la fiche changent de joueur.
- **Retrait d'un joueur** : ses emplacements sont supprimés avec lui. Sa fiche, archivée, reste en base (EF-TAB-06). Le MJ transfère d'abord un PJ qu'il veut garder.
- **Serveur** : colonnes `submit_message` (écrite par le propriétaire) et `review_comment` (écrite par le MJ). Le changement de propriétaire est réservé au MJ, vers un membre de la table, sur une fiche non archivée.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : validation, corrections, message, transfert.
- `sync-backend` : colonnes de revue, transfert, emplacements supprimés au retrait.
- `local-database` : message, commentaire, transfert.

## Impact

- `backend/supabase/migrations/`, `backend/supabase/tests/`.
- `packages/dnd_data` : colonnes de `character` (instantané Drift v1 régénéré), `CharacterStore`, `TableStore`.
- `apps/game_table/lib/tables/` : panneau de revue, « Mon personnage », transfert ; ARB ; tests.

**Hors périmètre :**
- **Notification** au joueur : V1.5.
- **Dérogations** inscrites à l'historique : lot d, avec le rattachement d'un personnage libre.
- **Alerte métier** de [T10] (« botte sur une arme absente ») : le panneau montre les erreurs d'intégrité du moteur. Les avertissements de cohérence d'inventaire n'existent pas encore dans `dnd_rules`.
