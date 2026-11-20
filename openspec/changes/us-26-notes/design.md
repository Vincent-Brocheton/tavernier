# Design

## Lot a

### Serveur (`20261202000000_notes.sql`)

- **`note`** :
  - lecture : l'auteur, ou un membre de la table si la note est partagée ;
  - insertion et modification : l'auteur, sur une table dont il est membre ;
  - suppression : l'auteur.
- **`apply_crud`** (redéfinie) : sur un `PATCH` de `note` qui porte `old.content`, si le texte en place diffère, `conflict` reçoit le texte en place et la nouvelle version s'écrit.
- **PowerSync** : flux `notes`, avec ses notes et celles partagées avec ses tables.

### Base locale

- **`Notes`** : ajoute `title`, `updated_at` et `conflict`. La table entre dans `syncedTables` et dans `conflictTrackedTables`, pour que ses valeurs remplacées partent avec chaque modification.
- **Schéma v5** : `addColumn` hors PowerSync. Chaque étape de migration est bornée par la version visée (`to >= n`) : sans cela, une montée vers v2 recevait déjà les colonnes de la v5.
- **Ouverture PowerSync** :
  1. ouvrir sans `note` ;
  2. supprimer `note` si c'est une table ;
  3. passer au schéma complet (`updateSchema`).

  Sans cela, PowerSync refuse de poser sa vue sur l'ancienne table locale. Elle n'a jamais été écrite par l'app.
- **`NoteStore`** : `create` (privée), `update`, `resolve`, `delete` et `watchVisible`.

## Choix

- **Markdown réduit** : lisible tel quel, cherchable par simple texte, exportable.
- **Le conflit est gardé dans la note** plutôt que dans l'historique : c'est l'auteur qui fusionne, sur la note elle-même.
- **La recherche se fait dans l'app** (lot b), sur les notes de l'appareil, en repliant accents et casse : une table FTS ne peut pas suivre une vue PowerSync.
