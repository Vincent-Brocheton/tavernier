# Design

## Serveur

```
character_summary(id text = id de la fiche, table_id, owner_user_id uuid,
                  name, species_id, classes text (JSON [{class_id, level}]),
                  health text ('unhurt' | 'wounded' | 'badly'), updated_at)
```

- `id` porte une clé étrangère vers `character` (`on delete cascade`). PowerSync exige une colonne `id`.
- **RLS** :
  - lecture : membre ou MJ de `table_id` ;
  - écriture (insertion, mise à jour, suppression) : `can_write_character(id)`, et `table_id` égal à la table de la fiche.
- Publication `powersync`, et flux `tables` des règles de synchronisation.

## Base locale

- Table Drift `CharacterSummaries` (`character_summary`), synchronisée.
- `CharacterStore.publishSummary(summary)` : n'écrit que si la ligne diffère (pas d'envoi inutile au serveur).
- `TableStore.watchGroup(tableId)` : résumés de la table, par nom.
- `CharacterStore.saveState` prévient aussi les requêtes observées (`markTablesUpdated`), comme `save`.

## Publication

`summaryPublisherProvider`, écouté à la racine de l'app :
- observe `SELECT id FROM character WHERE table_id IS NOT NULL AND (owner_user_id IS NULL OR owner_user_id = moi) AND status <> 'archived'`, qui lit `character`, `character_state` et `character_class_level` ;
- à chaque émission, pour chaque fiche, relit l'entrée et l'état, calcule `computeSheet` et publie le résumé.

L'état de santé vient de `healthOf(hpCurrent, hpMax)`, une fonction pure (EF-TAB-09). Sans PV courants enregistrés, la fiche est indemne.

## Lecture seule

`sheetEditableProvider(id)` dit si la fiche est modifiable. Elle l'est si :
- elle n'a pas de propriétaire (pas encore envoyée), ou en a un qui est l'utilisateur, ou l'utilisateur est le MJ de sa table ;
- et elle n'est pas archivée.

`SheetPage` le transmet par un `InheritedWidget` (`SheetAccess`). En lecture seule :
- l'en-tête cache la montée de niveau et les repos, et garde l'historique ;
- l'inventaire et les sorts gardent la consultation, sans actions qui écrivent : ajout, quantité, équiper, harmoniser, préparer, lancer, fin de concentration.
