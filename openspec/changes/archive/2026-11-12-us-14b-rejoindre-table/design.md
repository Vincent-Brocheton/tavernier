# Design

## Demande en attente

`pendingJoinProvider` (Notifier) tient `JoinState` : le code en attente et son état (`waiting`, `needsAccount`, `joining`, `joined` avec la table, `failed` avec le motif). Le code est gardé dans `shared_preferences` (`pending_join`), comme les réglages de l'appareil : il survit à la fermeture de l'app.

Une tentative part :
- à la saisie (`submit`) ;
- au retour du réseau (`onlineProvider`) ;
- à la connexion d'un compte (`currentUserProvider`) ;
- à l'ouverture de l'app, s'il reste un code.

La racine de l'app écoute le fournisseur pour qu'il vive hors de la page.

- **Échec réseau** (exception de l'appel) : le code reste, l'état revient à `waiting`.
- **Refus du serveur** (`{"error": …}`) : le code est oublié, le motif est affiché.
- **Réussite** : le code est oublié ; la page ouverte mène à `/tables/<id>`.

## Saisie

Un `TextField` transparent, au-dessus de six cases dessinées (56 dp), porte la saisie, le clavier et l'accessibilité : il garde 6 caractères alphanumériques, mis en majuscules. Un code collé en entier fonctionne.

## Page de la table avant la synchronisation

Juste après avoir rejoint, la table n'est pas encore sur l'appareil. `TablePage` montre un indicateur de chargement tant que la table manque, au lieu d'une page vide ; la table arrive par la synchronisation, et la page, réactive depuis us-14a, s'y met.
