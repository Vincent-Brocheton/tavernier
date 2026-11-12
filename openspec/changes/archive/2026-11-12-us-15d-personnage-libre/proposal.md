# Proposal

## Why

Carte Trello [US-15](https://trello.com/c/UMRG1bPS), lot d. Cahier §4.3, « Personnage libre » :
- un joueur rattache un personnage créé hors table à une table qu'il a rejointe ;
- le personnage est revalidé contre la configuration de la table ;
- les écarts sont listés au MJ, qui accepte avec dérogation ou demande une correction ;
- une dérogation n'envoie pas de notification : elle est inscrite dans l'historique de la fiche, que le joueur peut consulter ;
- un personnage n'est rattaché qu'à une table à la fois.

Écrans [T14] (écarts, MJ) et, pour l'historique, une partie de [N2]. La revue existe depuis us-15c.

## What Changes

- **Rattacher** : sur un emplacement vide, « Rattacher un personnage libre » liste les personnages du joueur qui n'ont pas de table. Le personnage choisi est rattaché à la table, remplit l'emplacement et part au MJ, avec un message facultatif.
- **Écarts dans le panneau de revue** : chaque contrôle en échec (méthode, niveau de départ, règles) propose « Dérogation » ou « Correction », comme [T14].
  - Si au moins un écart est en correction, le bouton devient « Demander des corrections (N) », avec un message obligatoire.
  - Sinon, « Valider ».
  - Une note annonce le nombre de dérogations inscrites à l'historique.
- **Historique** : chaque dérogation devient une entrée de `character_change_log` : auteur, date, écart, valeurs de la table et de la fiche, message du MJ. Une page « Historique » de la fiche, ouverte depuis la fiche, liste ces entrées, les plus récentes d'abord. Sans notification.
- **Une table à la fois (serveur)** : la table d'une fiche ne se fixe qu'une fois, d'aucune table vers une table dont on est membre.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `tables` : rattachement d'un personnage libre, écarts et dérogations.
- `sync-backend` : une table à la fois.
- `local-database` : personnages libres, rattachement, dérogations, historique.
- `character-sheet` : page « Historique ».

## Impact

- `backend/supabase/migrations/`, `backend/supabase/tests/`.
- `packages/dnd_data` : `CharacterStore`.
- `apps/game_table` : « Mon personnage », panneau de revue, page « Historique » ; ARB ; tests.

**Hors périmètre :**
- **Entités bannies et packs non actifs** : il faudra pouvoir bannir et activer des packs (M4). Les contrôles s'ajouteront alors.
- **Écran [N2] complet** : filtres, progression, combat, synchronisation. Ici, seulement la liste des entrées.
- **Détacher** un personnage d'une table : non demandé par le cahier.
