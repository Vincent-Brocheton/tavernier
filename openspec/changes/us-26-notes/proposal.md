# Proposal

## Why

Carte Trello [US-26](https://trello.com/c/zzhUcrDW) : les notes privées et partagées. Exigences : **EF-NOT-01** à **EF-NOT-06** ; cahier §6.6 et §11.2 ; planches [N3] à [N7].

La table locale `note` existe depuis le schéma v1, mais aucun écran ne l'utilise et elle ne se synchronise pas. Or une note privée du MJ doit le suivre sur tous ses appareils ([N3]), et une note partagée doit aller à toute la table (EF-NOT-04).

Décisions du porteur de projet du 20 novembre 2026 :
- **Table serveur `note`** : celle du cahier §11.2, plus un titre, une date de mise à jour et l'autre version d'un conflit. L'auteur la lit, et toute la table aussi si elle est partagée ; seul l'auteur l'écrit.
- **Texte en Markdown réduit** :
  - `**gras**` ;
  - des lignes `- ` pour les listes ;
  - des liens `[Varga](npc:<id>)` et `[Le relais](encounter:<id>)`.
- **Conflits détectés au serveur**, comme pour les fiches (US-16). L'appareil envoie le texte qu'il remplaçait. Si le serveur en a un autre, il garde cette autre version dans la note, et l'auteur fusionne (EF-NOT-06).

La carte est livrée en deux lots.

## What Changes

### Lot a : données

- **Serveur** :
  - la table `note` : `id`, `owner_user_id`, `table_id`, `scope` (`table`, `session`, `npc`, `encounter`), `ref_id`, `title`, `content`, `private` (vrai par défaut), `updated_at`, `conflict` ;
  - ses droits (RLS) ;
  - `apply_crud`, qui garde l'autre version d'une note dans `conflict` ;
  - le flux PowerSync `notes` et les tests (pgTAP, flux).
- **Base locale** :
  - `note` devient synchronisée, au schéma v5 (titre, date, conflit) ;
  - sous PowerSync, l'ancienne table locale cède la place à sa vue à l'ouverture ;
  - les valeurs remplacées d'une note partent avec chaque modification.
- **Dépôt** `NoteStore` : écrire, modifier, partager, fusionner un conflit, supprimer, et suivre les notes visibles d'un utilisateur.

### Lot b : écrans

- **Table, onglet Notes ([N3])** : les notes du MJ, ses filtres par rattachement, une note partagée par un joueur, l'éditeur et le conflit.
- **Fiche, onglet Notes ([N4], [N7])** : les notes du joueur, groupées par rattachement, et celles partagées par d'autres, en lecture seule.
- **Éditeur ([N5])** : gras, listes, insertion d'un lien vers un PNJ ou une rencontre, partage.
- **Recherche hors-ligne ([N6])** : sans accents ni casse.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `sync-backend` : `note`, conflits des notes.
- `local-database` : schéma v5, notes synchronisées.
- `tables`, `character-sheet` : onglets Notes (lot b).

## Impact

- **Serveur** : une migration (dont `apply_crud`), un test pgTAP, `sync-config.yaml` et `sync_test.sh`.
- **`dnd_data`** : table, migration v5, ouverture de PowerSync, dépôt.
- **App** : lot b.

## Hors périmètre

- **Notes sans table** : le schéma les permet (`table_id` nul), mais aucun écran n'en crée.
