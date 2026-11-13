## Context

Les clés étrangères du schéma ont été posées pour ce cas : `profile`, `table_member`, `pc_slot`, `table_invite` et `character.owner_user_id` partent en cascade avec `auth.users`. `game_table.gm_user_id` et les auteurs d'historique passent à `null`. `confirm_age` supprime déjà un compte depuis une fonction `security definer`.

## Decisions

- **Suppression immédiate** : `delete_my_account()` (`security definer`) supprime la ligne de `auth.users` de l'appelant. ENF-10 demande « sous 30 jours ». Une suppression immédiate le respecte, sans tâche planifiée à maintenir. La page garde le texte de [T15].
- **Gardes du serveur** : comme `guard_character` et `guard_pc_slot`, `guard_archived_table` ne s'applique plus qu'au rôle `authenticated`. Sinon, la cascade qui retire le MJ d'une table archivée serait refusée.
- **Table sans MJ** :
  - `can_write_character` exige qu'une fiche de table ait un MJ ;
  - `guard_pc_slot` refuse au joueur tout changement d'emplacement dans une table sans MJ.

  Une écriture refusée est écartée par `apply_crud`, puis l'appareil retrouve l'état du serveur.
- **App, ordre des opérations** :
  1. appel au serveur (`rpc`) ;
  2. s'il réussit, `disconnectAndClear` de PowerSync, puis fermeture de la session ;
  3. retour à l'accueil.

  Si l'appel échoue (réseau, session expirée), rien n'est effacé et un message s'affiche.
- **Fiche sans MJ côté app** : `CharacterStore.access` lit aussi si la table de la fiche est connue (`g.id`). Sans MJ, elle passe en lecture seule. Une table pas encore synchronisée n'est pas prise pour une table sans MJ.
- **Page** : `/profil/supprimer`, sur le modèle de [T15].
  - Carte d'export : bouton d'`exportMyData` (lot a).
  - Liste à quatre icônes.
  - Champ de confirmation : la comparaison avec « SUPPRIMER » ignore les espaces autour et la casse.

## Risks / Trade-offs

- Une suppression immédiate ne laisse aucun délai pour se raviser. La page le dit, et l'export est proposé juste au-dessus.
- Les données locales de M3 (PNJ, séances, notes) restent sur l'appareil après la suppression, comme après une déconnexion. Elles n'existent pas sur le serveur.
