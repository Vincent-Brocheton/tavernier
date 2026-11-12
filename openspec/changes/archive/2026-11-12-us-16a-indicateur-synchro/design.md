# Design

## Composant

```dart
enum SyncIndicatorState { synced, pending, offline, conflict }

SyncIndicator({required state, required label, bool compact = false})
```

Les libellés viennent de l'app (ARB) : le kit ne contient aucune chaîne. En `compact`, seule l'icône s'affiche, avec un `Tooltip` et une `Semantics` qui portent le libellé. Les couleurs viennent de `GameColors` (soins, PV temporaires, alerte) et du `ColorScheme` (neutre).

## État

- `powerSyncStatusProvider` : `StreamProvider<SyncStatus?>`, flux `statusStream` de la base PowerSync, ou `null` sans PowerSync.
- `pendingUploadsCountProvider` : `StreamProvider<int>`, `powerSync.watch('SELECT count(*) AS n FROM ps_crud', triggerOnTables: {'ps_crud'})`.
- `syncIndicatorProvider` : `Provider<({SyncIndicatorState state, int pending})?>`, `null` sans compte connecté. Il vaut :
  - hors ligne, si l'appareil n'a pas de réseau, ou si PowerSync n'est ni connecté ni en connexion ;
  - en attente, si des écritures attendent ;
  - synchronisé, sinon.

Les tests remplacent les deux flux.

## Emplacement

`AdaptiveNavigationScaffold.account` reçoit une rangée (indicateur, avatar). Sur téléphone, l'indicateur est compact.

## Scénario à trois comptes

`test/sync/merge_test.dart`, sauté sans backend :
1. le MJ crée la table et l'invitation, puis les envoie ;
2. les joueurs appellent `join_table`, attendent la table, créent leur fiche dans la table et l'envoient ;
3. tout le monde se déconnecte, puis :
   - le MJ change le niveau de départ ;
   - le joueur 1 renomme sa fiche ;
   - le joueur 2 change ses PV ;
4. tout le monde se reconnecte ;
5. on attend que :
   - le serveur ait les trois changements ;
   - chaque joueur ait le nouveau niveau de départ ;
   - le MJ ait les deux fiches à jour ;
   - aucune écriture n'ait été écartée.
