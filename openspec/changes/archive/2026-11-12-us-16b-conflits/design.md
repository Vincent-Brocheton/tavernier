# Design

## Client

- `powerSyncSchema` : `character` et `character_state` déclarent `trackPreviousValues: TrackPreviousValuesOptions(onlyWhenChanged: true)`. Chaque `CrudEntry` de mise à jour porte alors `previousValues`, limité aux colonnes changées.
- `SupabaseConnector` envoie `old` à côté de `data`, avec la même conversion des booléens.

## Serveur

- `character.field_authors` et `character_state.field_authors` (jsonb, champ → uuid) : l'auteur de la dernière écriture de chaque champ, tenu par un trigger avec `auth.uid()`. Par champ et non par ligne : une autre modification de la même ligne ne doit pas effacer l'auteur des PV. Non lus par l'app.
- `apply_crud` : sur un `PATCH` de ces deux tables qui porte `old`, avant d'écrire, il lit la ligne en place (`to_jsonb`). Pour chaque champ de `data` présent dans `old` dont la valeur en place diffère de `old` :
  - sur `character_state`, si l'auteur du champ est le MJ de la table et que l'appelant ne l'est pas, le champ est retiré de l'écriture : la valeur du MJ reste ;
  - sinon, le champ s'écrit (dernier écrit gagnant) ;
  - dans les deux cas, une entrée part dans `character_change_log`. Son auteur est celui qui envoie : la règle de l'historique interdit d'écrire au nom d'un autre. L'auteur de la valeur gardée est dans `kept_by` :

    `{"kind": "conflict", "table", "field", "kept", "kept_by", "replaced", "replaced_by"}`

## Comparaison

Les valeurs se comparent en JSON : les entiers, textes et booléens (convertis par le connecteur) des deux tables suivies sont directs. Les colonnes de date (`character` n'en a pas parmi les champs modifiables) ne sont pas suivies.

## App

- **Conflits non vus** : `unseenConflictsProvider`, pour l'utilisateur.
  - Ce sont les entrées « conflict » des fiches visibles dont `replaced_by` est lui, et dont l'identifiant n'est pas dans la liste des conflits vus (`shared_preferences`, `seen_conflicts`).
  - « OK » les marque vues.
- **Bandeau** : en tête de la fiche, `StatusBanner` d'alerte, pour le conflit non vu le plus récent de cette fiche, avec « Voir l'historique » et « OK ».
- **Indicateur** : « Conflit résolu » s'il y a au moins un conflit non vu. Cet état passe avant les autres.
- **Historique** : titre « Conflit résolu : PV », la valeur remplacée barrée (`TextDecoration.lineThrough`), une flèche, la valeur gardée, et l'auteur de chacune.

Libellés des champs suivis :
- **État de jeu** : PV, Épuisement, Inspiration héroïque, Concentration, Ressources ;
- **Fiche** : Nom, PX, Monnaie, Alignement, Apparence, Personnalité, Histoire.

Un autre champ s'affiche sous son nom technique.
