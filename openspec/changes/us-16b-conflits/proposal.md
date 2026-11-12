# Proposal

## Why

Carte Trello [US-16](https://trello.com/c/eLEJkqIf), second lot. Exigences :
- **ENF-03** : sur les fiches, le dernier écrit gagne champ par champ, sauf l'état de combat où le MJ prime. Tout conflit qui écrase une donnée du joueur est notifié.
- **EF-PJ-13** : une valeur écrasée à la synchronisation reste visible, barrée, avec un renvoi vers l'entrée « Conflit résolu ».
- **ENF-02** : l'indicateur montre aussi l'état « conflit ».

Écran [P16] (bandeau « Conflit résolu » sur la fiche) ; historique [N2] (pour sa partie conflits).

La fusion champ par champ existe (T-05). Rien ne détecte ni ne signale un écrasement, et la priorité du MJ n'existe pas.

## What Changes

- **Détection (serveur)** : chaque modification de fiche (`character`) ou d'état de jeu (`character_state`) arrive avec les valeurs qu'elle remplace sur l'appareil. Quand le serveur a, pour un champ, une autre valeur que celle-là, quelqu'un a écrit entre-temps : c'est un conflit.
- **Résolution** :
  - le dernier écrit gagne ;
  - sauf sur l'état de jeu, quand la valeur en place vient du MJ de la table et l'écriture d'un autre : la valeur du MJ est gardée (« en combat, la version du MJ prime »).
- **Trace** : chaque conflit inscrit une entrée « Conflit résolu » dans l'historique de la fiche : champ, valeur gardée et son auteur, valeur remplacée et son auteur. Pas de notification push (V1.5).
- **Côté joueur dont la valeur a été remplacée** :
  - **bandeau sur la fiche** [P16] : « Conflit résolu à la synchronisation. Camille a réglé vos PV à 34 ; votre valeur (39) a été remplacée », avec « Voir l'historique » et « OK » ;
  - **indicateur** en état « Conflit résolu » tant qu'un conflit n'a pas été vu.
- **Historique** : une entrée de conflit montre la valeur remplacée barrée, puis la valeur gardée.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : détection, résolution et trace des conflits.
- `local-database` : valeurs précédentes envoyées, conflits non vus.
- `character-sheet` : bandeau de conflit, historique barré.
- `account` : état « conflit » de l'indicateur.

## Impact

- `backend/supabase/migrations/` (`apply_crud`, `field_authors`), `backend/supabase/tests/`.
- `packages/dnd_data` : schéma PowerSync (valeurs précédentes), `SupabaseConnector`, `CharacterStore`.
- `apps/game_table` : fiche, historique, indicateur ; ARB ; tests.

**Hors périmètre :**
- **Journal de combat fusionné par horodatage** (ENF-03, combat) : M3, avec le combat.
- **Contenu des fiches en lignes** (objets, sorts, langues) : un ajout ou un retrait de ligne ne s'écrase pas, il se fusionne déjà. Seuls les champs de la fiche et de son état de jeu sont suivis.
