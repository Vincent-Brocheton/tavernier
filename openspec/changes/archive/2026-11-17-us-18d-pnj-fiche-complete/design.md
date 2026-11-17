## Context

L'assistant (`CreationPage`) se lance hors table, ou depuis un emplacement de PJ (`?table=…&slot=…`), qui impose la méthode de la table. `CreationNotifier._write` enregistre la fiche (`kind = 'pc'` par `toCharacterInput`), puis remplit l'emplacement. Une fiche de table passe par deux chemins :
- `sheetProgressionProvider` pour la montée de niveau ;
- `summaryPublisher` pour le résumé du groupe.

## Decisions

- **Route** : `/characters/new?pnj=<table>&dossier=…&attitude=…&nom=…`. `CreationPage(npcTableId, npcFolder, npcAttitude, npcName)` pose sur le notifier une cible `NpcTarget`, hors du brouillon, et préremplit le nom. Aucune `TableConstraint` n'est posée : la méthode reste libre ([G5]).
- **Enregistrement** (`_write` avec une cible PNJ) :
  - la fiche est enregistrée avec `kind: 'npc_full'` et `tableId` ;
  - puis le PNJ est créé avec `NpcStore.create(characterId:)`, le nom de la fiche, le dossier et l'attitude ;
  - à la sortie, l'assistant revient à l'écran précédent (onglet PNJ), car « Nouveau PNJ » l'ouvre en remplacement de lui-même.
- **Hors progression** : `access` lit `CASE WHEN c.kind = 'pc' THEN g.progression_mode END`. Ce seul point suffit, car `sheetProgressionProvider` rend déjà `null` sans mode, ce qui laisse la montée libre et masque la dérogation du MJ.
- **Hors liste et hors résumé** : `list` filtre `kind = 'pc'`, et la requête de `summaryPublisher` aussi.
- **Liste des PNJ** : « Fiche complète · niveau n ». Le niveau est lu par un provider sur `CharacterStore.load` du PNJ, qui calcule `computeSheet(...).level`.
- **Fiche du PNJ** : sans monstre, elle affiche « Fiche complète », puis « Ouvrir la fiche » (`/characters/<id>`). « Dupliquer » est masqué quand `characterId` est présent.

## Risks / Trade-offs

- **Nom désynchronisé** : le nom du PNJ et celui de sa fiche peuvent diverger si l'un est renommé. Le PNJ garde son nom d'affichage, et la fiche son identité de personnage.
- **Statut de la fiche** : elle reste `draft`. Pour le MJ propriétaire, cela ne bloque ni la fiche ni la montée de niveau.
