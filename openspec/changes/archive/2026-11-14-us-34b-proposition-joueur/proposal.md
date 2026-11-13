# Proposal

## Why

Carte Trello [US-34](https://trello.com/c/p0kavJYL), deuxième lot sur trois : le joueur reçoit une proposition structurelle du MJ, et l'accepte ou la refuse (**EF-PJ-16**, écran [F4b], composant `ProposalBanner` §2.44). Le cahier (§4.3) le pose ainsi : hors combat, une modification structurelle par le MJ (niveau, don, Historique) passe par une proposition que le joueur accepte.

Le lot c ajoutera l'envoi par le MJ ([F4a]). Ce lot pose le stockage, les droits et la réception.

## What Changes

- **Serveur — table `character_proposal`** : fiche, table, auteur (le MJ), type, modification proposée, motif obligatoire, statut (`pending`, `accepted`, `refused`), réponse du joueur.
  - Lue par le propriétaire de la fiche et le MJ de la table, jamais par les autres membres, même quand la table montre les fiches complètes.
  - Créée par le MJ, en son nom, en attente, pour une fiche non archivée de sa table.
  - Seul le propriétaire y répond, une fois, sans changer la proposition.
- **Synchronisation** : un flux `propositions` avec les mêmes droits ; le test de synchronisation le vérifie.
- **Base locale** : table `character_proposal` ; `CharacterStore.propose`, `watchPendingProposals`, `acceptProposal`, `refuseProposal`.
  - **Modification proposée** : des champs de premier niveau de la fiche (`CharacterInput`), au format JSON. Au MVP, le type `feat` : la liste des dons.
  - **Acceptation** : la fiche prend ces champs, garde son état de jeu, et l'historique reçoit une entrée « Proposition acceptée », avec les dons retirés et ajoutés, l'auteur et le motif.
- **App — encadré [F4b]** en tête de la fiche de son propriétaire :
  - « Camille propose : remplacer le don Vigilant par Doué » et « Motif : « … » » ;
  - aperçu avant et après des valeurs touchées (don, caractéristiques, Initiative, CA, PV max, Vitesse, maîtrises de compétences), calculé par le moteur ;
  - « Message si vous refusez », « Refuser » et « Accepter ».
- **App — historique** : « Proposition acceptée : remplacer le don Vigilant par Doué », puis « Proposée par Camille · Motif : « … » ».

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : propositions du MJ au serveur.
- `local-database` : propositions stockées, acceptées ou refusées.
- `character-sheet` : proposition reçue, historique.

## Impact

- `backend/supabase/migrations/20261125000000_propositions.sql`, `backend/supabase/tests/proposal_test.sql`.
- `backend/powersync/sync-config.yaml`, `backend/powersync/tests/sync_test.sh`.
- `packages/dnd_data/` : table Drift, schéma PowerSync, `CharacterStore`, instantané du schéma.
- `apps/game_table/` : `sheet/proposal_banner.dart`, fiche, historique, ARB, tests.

**Hors périmètre :**
- **Envoi par le MJ** ([F4a]) : lot c.
- **Autres types** (niveau, Historique) : le format de la modification les permet ; les écrans du MJ viennent avec eux. Un niveau accordé suit la clôture de séance (M3).
- **Choix du joueur en acceptant** ([F4b] : « Vous choisirez les vôtres en acceptant ») : le joueur accepte les choix du MJ tels quels.
- **Notification** de la proposition et de la réponse : la proposition apparaît sur la fiche à la synchronisation. Les notifications viennent avec leur carte.
