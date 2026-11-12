# Design

## Serveur

`guard_character` refuse un changement de `table_id` quand l'ancienne valeur n'est pas nulle : une fiche n'est rattachée qu'une fois. Le serveur lui-même n'est pas concerné.

Les dérogations vont dans `character_change_log` (`diff` en JSON), déjà synchronisée, que le MJ peut écrire (mêmes droits que la fiche).

## Données

`CharacterStore` :
- `freeCharacters(ownerUserId)` : fiches sans table, non archivées, de l'utilisateur ou pas encore envoyées.
- `attach(id, tableId, message)` : `table_id`, statut `submitted` et message, en une écriture. L'emplacement se remplit ensuite par `TableStore.fillSlot`, dans la même transaction.
- `addDerogations(id, authorUserId, derogations)` : une entrée par dérogation, de la forme `{"kind": "derogation", "check": "level", "table": "1", "sheet": "3", "message": "…"}`.
- `history(id)` : entrées de la plus récente à la plus ancienne (`timestamp DESC, id DESC`).

## Revue

Chaque contrôle de us-15c devient un `ReviewCheck` (`key`, libellé, `ok`, valeurs de la table et de la fiche). Pour un contrôle en échec, un `SegmentedButton` propose « Dérogation » ou « Correction » :
- méthode et niveau : dérogation par défaut ;
- erreur de règles : correction par défaut.

À l'action, les dérogations choisies sont inscrites, puis la revue est enregistrée. Avec au moins une correction : `changes_requested` et le message. Sans correction : `validated`.

## Historique

Route `/characters/:id/historique`. Une liste : titre (« Dérogation : niveau 3 accepté »), date et auteur (pseudonyme si connu), valeurs de la table et de la fiche, message. Un lien « Historique » se trouve dans l'en-tête de la fiche.
