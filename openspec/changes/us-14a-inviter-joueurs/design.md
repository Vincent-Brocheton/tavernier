# Design

## Invitation

`table_invite` existe déjà (id, table_id, code unique, expires_at, revoked), écrite par le MJ seul et synchronisée vers lui seul. Le MJ la crée hors ligne comme toute écriture ; elle ne sert qu'une fois envoyée, ce que la carte dit (« Le joueur a besoin du réseau pour rejoindre »).

- **Invitation en cours** : la plus récente, ni révoquée ni expirée. Créer une invitation révoque celle en cours, dans la même transaction : un seul code actif par table.
- **Code** : 6 caractères parmi `ABCDEFGHJKMNPQRSTUVWXYZ23456789` (31), tirés par `Random.secure`. Il y a 31⁶ ≈ 887 millions de codes. Une collision est refusée par l'index unique du serveur à l'envoi (23505, écartée) ; elle est assez rare pour ne pas la gérer autrement.
- **Lien** : sur le Web, `Uri.base` donne l'origine. Ailleurs, sans adresse publique de l'app, seul le code se partage.

## Rejoindre (serveur)

`join_table(code text) returns text`, `security definer` :
1. compte les échecs de l'appelant dans l'heure (`join_attempt`) : 10 ou plus → `too_many_attempts` ;
2. cherche l'invitation par code (en majuscules) : absente → `invalid_code`, révoquée ou expirée → `expired_code`, table archivée → `archived_table`. Chaque échec est noté ;
3. ajoute `table_member` (rôle `player`) s'il n'y est pas déjà, et rend `table_id`.

Les motifs passent par `raise exception … using errcode = 'P0001', hint = '<motif>'` : l'app les lit dans le `hint`.

`join_attempt(user_id, at)` n'a aucune règle de lecture ni d'écriture : seule la fonction y touche.

## Retrait d'un joueur

Le MJ supprime la ligne `table_member` (règle existante). Un trigger `after delete` passe à `archived` les fiches de ce joueur dans la table, et `can_write_character` refuse une fiche archivée. Le trigger couvre aussi le joueur qui quitte la table.

Côté app, le MJ supprime la ligne localement. Ses fiches locales sont archivées au retour du serveur par la synchronisation.

## Listes réactives

`TableStore.watchList`, `watch`, `watchMembers`, `watchInvite` reposent sur `customSelect(…, readsFrom: …).watch()`. Avec PowerSync, drift_sqlite_async relaie les mises à jour de PowerSync, synchronisation comprise. Les fournisseurs passent de `FutureProvider` à `StreamProvider`, et les invalidations manuelles disparaissent.

## Membres

`watchMembers(tableId)` joint `table_member` et `profile` (pseudonyme ; profils des partenaires déjà synchronisés). Tri : MJ d'abord, puis par pseudonyme.
