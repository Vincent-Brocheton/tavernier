## Context

Toutes les données de l'utilisateur sont dans la base locale : les tables synchronisées (vues PowerSync), y compris sans compte, et les tables locales de M3 (PNJ, séances, rencontres, notes). Le contenu de règles vient des packs, réimportables à part.

## Decisions

- **Format** : `{format: "tavernier-export", version: 1, exported_at, packs: [{id, version}], tables: {<table>: [lignes]}}`. Chaque ligne est celle de la base, colonne par colonne. Les colonnes JSON restent du texte, comme en base : l'import du lot b les réécrit telles quelles.
- **Rappel, données présentes** : lues une fois au lancement (une requête observée bloquait les tests de l'app entière) ; un premier personnage créé ne déclenche le rappel qu'au lancement suivant, sans effet sur un seuil de 30 jours.
- **Tables exportées** : `syncedTables` et les tables locales de jeu de M3, données par la base (`actualTableName`). Pas de liste recopiée à la main. `author_identity` est exclue, car elle porte des clés de pack (M4).
- **Fichier** : sur le Web, un lien de téléchargement (`package:web`, déjà là). Ailleurs, `share_plus` avec `XFile.fromData` (« Enregistrer dans Fichiers », e-mail…). Les deux sont dans un fichier à import conditionnel, sur le modèle de `persistent_storage`.
- **Dates** (`shared_preferences`) :
  - `last_export_at` : date du dernier export ;
  - `first_launch_at` : posée au premier lancement, elle sert de point de départ quand rien n'a jamais été sauvegardé.

  La dernière synchronisation vient de PowerSync (`SyncStatus.lastSyncedAt`, gardé par PowerSync entre deux lancements).
- **Rappel** : un `Provider` calcule le nombre de jours depuis la plus récente de ces dates. « Plus tard » est un état en mémoire, remis à zéro au lancement suivant. Le rappel ne harcèle donc pas pendant une séance, mais revient tant que rien n'est sauvegardé.

## Risks / Trade-offs

- Un export contient aussi ce que l'utilisateur voit des autres membres de ses tables : pseudonymes, avatars, résumés. Ce sont les données de ses tables, telles que l'appareil les a reçues.
- `navigator.share` existe aussi sur Chrome pour ordinateur : le lien de téléchargement est préféré sur le Web pour garder un vrai téléchargement.
