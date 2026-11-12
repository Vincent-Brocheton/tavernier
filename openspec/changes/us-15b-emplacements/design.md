# Design

## Serveur

`pc_slot(id text, table_id, player_user_id uuid, character_id text null, created_at)` :
- **RLS** : les membres et le MJ lisent ; le MJ crée et supprime ; le MJ ou le joueur de l'emplacement le modifie.
- **Trigger `guard_pc_slot`** : le joueur ne change que `character_id`, et seulement vers une fiche à lui, de la même table.
- **Diffusion** : publication `powersync`, et flux `tables` des règles de synchronisation.

`character` :
- **Insertion et mise à jour** : `table_id` doit être une table dont l'utilisateur est membre (ou nul), en plus des règles existantes.
- **Trigger `guard_character_status`** : seuls ces passages de statut sont permis.

| De | Vers | Qui |
|---|---|---|
| `draft`, `changes_requested` | `submitted` | propriétaire |
| `submitted` | `draft` | propriétaire |
| `submitted` | `validated`, `changes_requested` | MJ de la table |
| tout | `archived` | trigger de retrait (us-14a), `security definer` |

Le trigger de retrait passe par une fonction `security definer` : le garde laisse passer `archived` quand l'utilisateur courant n'est ni propriétaire ni MJ, c'est-à-dire quand le serveur agit lui-même. Les autres refus lèvent `insufficient_privilege` (42501). `apply_crud` écarte alors l'écriture, avec un journal.

## Base locale

- Nouvelle table Drift `PcSlots` (`pc_slot`), synchronisée, sans clé étrangère (vue PowerSync). Le schéma passe en v2, avec un instantané et sa migration (`make-migrations`).
- `TableStore` :
  - `createSlot(tableId, playerUserId)`, `deleteSlot(id)` ;
  - `watchSlots(tableId)` : emplacements avec le nom et le statut de leur fiche (jointure) ;
  - `fillSlot(slotId, characterId)`.
- `CharacterStore` :
  - `save(id, input, tableId:)` écrit `table_id` à la création seulement, sans jamais l'effacer ;
  - `setStatus(id, status)` ;
  - `list(ownerUserId:)` garde les fiches sans propriétaire (pas encore envoyées) et celles de l'utilisateur.

## App

- **Création** : la route `/characters/new?slot=<id>` passe l'emplacement à `CreationPage`.
  - Le notifier lit la table de l'emplacement, impose `withMethod(table.statMethod)` et note le contexte (`TableConstraint` : nom, méthode, niveau de départ).
  - Les puces de méthode laissent place à « Méthode imposée par la table : … ».
  - En génération aléatoire, « Lancer » disparaît une fois les jets faits.
  - À l'enregistrement, `save(…, tableId)` puis `fillSlot`.
- **« Mon personnage »** :
  - le niveau vient de la somme des niveaux de classe de la fiche, relue localement ;
  - « Envoyer au MJ » n'est actif qu'au niveau de départ, sinon un rappel : « Montez la fiche au niveau N avant de l'envoyer » ;
  - une fiche envoyée peut être reprise (« Reprendre »).
- **Membres** :
  - le menu d'un joueur gagne « Attribuer un emplacement » ;
  - chaque emplacement s'affiche sous le joueur, avec « Retirer l'emplacement » s'il est vide ;
  - le MJ peut aussi s'attribuer un emplacement : un MJ joueur n'est pas exclu par le cahier.
