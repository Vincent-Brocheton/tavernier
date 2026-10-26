# Spike T-01 — SQLite WASM sur le Web

Carte Trello : [T-01 · Spike SQLite WASM sur Web](https://trello.com/c/0LH9VODh/21-t-01-spike-sqlite-wasm-sur-web).
Cahier : §10.1 (base locale), §14.1 (risque « SQLite WASM sur Web »), ENF-06, ENF-07, ENF-09.
Change OpenSpec : `t-01-spike-sqlite-wasm-web`.
Date : 26 octobre 2026. Versions : Flutter 3.47.7, drift 2.35.3, sqlite3 3.8.0 (`sqlite3.wasm` officiel), drift_flutter 0.3.1.

## Conclusion

SQLite WASM tient la cible Web. Les 10 000 entités du plafond ENF-09 s'importent en 0,6 à 1,6 s selon le navigateur. La réouverture, la recherche et la relecture d'un personnage prennent moins d'une demi-seconde sur tous les navigateurs testés. Les données survivent à la fermeture du navigateur, en OPFS comme en IndexedDB. Le risque du §14.1 passe de « moyen » à « faible ». Il reste deux points à traiter en M1 et M2 : la demande de stockage persistant (ENF-07), que Chrome, Edge et Safari refusent à un site sans historique d'usage et que Firefox laisse en suspens tant que l'utilisateur n'a pas répondu, et les en-têtes d'isolation à exiger de l'hébergeur.

## Protocole

1. **Test de volume** `apps/game_table/integration_test/web_storage_test.dart`.
   - **Données :** un pack synthétique de 10 000 dons valides. Leurs textes sont repris en boucle du pack SRD embarqué, donc aucun contenu n'est hors SRD. Le don n° 4242 s'appelle « Aiguille 4242 ».
   - **Déroulé :** sur une base neuve, le test importe le pack et enregistre Aldric niveau 1 ([D1]). Il ferme la base, la rouvre, compte les dons (10 000 attendus), cherche « aiguille » (le don 4242 est attendu en tête) et relit Aldric (identique attendu).
   - **Durées :**
     - `import_ms` couvre l'import du pack et l'enregistrement d'Aldric ;
     - `reouverture_ms` va de la réouverture jusqu'au résultat du comptage ;
     - `recherche_ms` est la recherche FTS5 ;
     - `personnage_ms` est la relecture d'Aldric.
   - **Autres tests du même fichier :** le stockage choisi par drift, et la réponse à `navigator.storage.persist()`, bornée à 10 s.
2. **Stockage.** Une page « isolée » reçoit `Cross-Origin-Opener-Policy: same-origin` et `Cross-Origin-Embedder-Policy: require-corp`. Dans le job Chrome isolé, la CI exige OPFS (`T01_EXPECTED_STORAGE=opfs`).
3. **Persistance après fermeture du navigateur.** Le point d'entrée `apps/game_table/tool/t01_persistence.dart` est compilé (`flutter build web`), puis servi en local sur 127.0.0.1, port 8123 avec isolation et 8124 sans.
   - Chaque navigateur est lancé sur un profil dédié et neuf, sans toucher au profil de l'utilisateur.
   - Chaque lancement incrémente un compteur stocké en base et l'affiche dans le titre de la page.
   - Le titre est lu, puis la fenêtre est fermée proprement (le processus du navigateur se termine). Le cycle est répété trois fois par navigateur et par port.
4. **Où tournent les mesures.**
   - En local, sur un poste Windows 11, avec `flutter run` en mode debug : Chrome et Edge. En release, la console n'est pas relayée.
   - En CI, avec `flutter drive --profile` : Chrome sur Ubuntu (isolé et non isolé), Firefox sur Ubuntu, Safari sur macOS (isolé et non isolé). Les mesures CI sont lues dans `build/integration_response_data.json`, affiché par l'étape « Mesures T01 ».
   - Les runners partagés sont bruités : la CI sert de garde-fou de compatibilité, et ses chiffres sont indicatifs.

## Mesures

Cibles proposées (le cahier ne chiffre pas le Web ; repères d'ENF-04) : import ≤ 10 s, réouverture ≤ 1 s, recherche ≤ 100 ms.

| Navigateur | Où | Isolé | Stockage choisi | Import (ms) | Réouverture (ms) | Recherche (ms) | Personnage (ms) |
|---|---|---|---|---|---|---|---|
| Chrome | local, debug | oui | `opfsLocks` | 900 | 199 | 38 | 151 |
| Chrome | local, debug | non | `sharedIndexedDb` | 1 146 | 240 | 6 | 12 |
| Edge | local, debug | oui | `opfsLocks` | 908 | 225 | 50 | 192 |
| Edge | local, debug | non | `sharedIndexedDb` | 1 044 | 241 | 6 | 12 |
| Chrome | CI Ubuntu, profile | oui | `opfsLocks` | 738 | 117 | 12 | 34 |
| Chrome | CI Ubuntu, profile | non | `sharedIndexedDb` | 647 | 178 | 3 | 5 |
| Firefox | CI Ubuntu, profile | non | `opfsShared` | 903 | 100 | 2 | 11 |
| Safari | CI macOS, profile | oui | `opfsLocks` | 1 401 | 447 | 28 | 72 |
| Safari | CI macOS, profile | non | `sharedIndexedDb` | 1 614 | 360 | 11 | 31 |
| iOS (simulateur) | CI macOS, debug | — | SQLite natif | 498 | 9 | 6 | 7 |
| Android 15 (émulateur API 35) | local, debug | — | SQLite natif | 922 | 28 | 10 | 21 |

Toutes les cibles sont tenues, partout, avec une marge d'un facteur dix sur l'import.

Fonctions manquantes signalées par drift :
- `dedicatedWorkersInSharedWorkers` sur Chrome, Edge et Safari, qui ne permettent pas de worker dans un worker partagé ;
- `sharedArrayBuffers` quand la page n'est pas isolée.

Firefox permet le worker dans le worker partagé, et prend donc OPFS (`opfsShared`) même sans isolation.

Les chiffres CI viennent de l'exécution de la PR [Vincent-Brocheton/tavernier#8](https://github.com/Vincent-Brocheton/tavernier/pull/8) sur le commit 917e34f.

## Persistance après fermeture du navigateur

| Navigateur (local) | Isolé | Stockage | Lancements 1, 2, 3 | Résultat |
|---|---|---|---|---|
| Chrome | oui | `opfsLocks` | 1, 2, 3 | conservé |
| Chrome | non | `sharedIndexedDb` | 1, 2, 3 | conservé |
| Edge | oui | `opfsLocks` | 1, 2, 3 | conservé |
| Edge | non | `sharedIndexedDb` | 1, 2, 3 | conservé |
| Firefox | oui | `opfsShared` | 1, 2, 3 | conservé |
| Firefox | non | `opfsShared` | 1, 2, 3 | conservé |

Safari n'a pas été vérifié après fermeture du navigateur : aucun Mac n'est disponible en local. En CI, Safari ne vérifie que la fermeture et la réouverture de la base dans la même page, isolée ou non. Point à refaire sur un Mac avant la mise en production Web.

## Stockage persistant (ENF-07)

| Navigateur | Réponse à `navigator.storage.persist()` |
|---|---|
| Chrome, Edge (local et CI) | `false` sur un profil neuf |
| Firefox (local, avec fenêtre) | `true` |
| Firefox (CI, sans fenêtre) | aucune réponse au bout de 10 s |
| Safari (CI) | `false` |

Chrome et Edge décident sans rien demander, d'après l'usage du site : site installé en application, mis en favori, notifications autorisées… Un site neuf est donc refusé. Firefox affiche une invite à l'utilisateur, et la promesse reste en suspens tant qu'il n'a pas répondu. Sans fenêtre, en CI, elle ne se résout jamais. C'est ce qui a d'abord bloqué le test de volume jusqu'au délai du pilote (20 minutes) ; le test borne maintenant la demande à 10 s.

## Recommandations pour M1 et M2

1. **Stockage cible.** Il faut servir l'app avec les en-têtes d'isolation, pour obtenir OPFS sur Chrome et Edge, et laisser drift basculer seul. Sans isolation, IndexedDB est un repli complet : toutes les fonctions et la persistance tiennent, et les durées restent dans les cibles. L'isolation est donc souhaitée, pas bloquante.
2. **En-têtes à exiger de l'hébergeur (M2).**
   - `Cross-Origin-Opener-Policy: same-origin`
   - `Cross-Origin-Embedder-Policy: require-corp`
   - `.wasm` servi en `application/wasm`.
   - Conséquence : toute ressource d'une autre origine doit envoyer `Cross-Origin-Resource-Policy` ou CORS. Les polices (Cinzel, Roboto Flex) seront donc servies par l'app elle-même (T-07), pas par Google Fonts.
   - Sentry, s'il est activé un jour (après consentement), devra être vérifié sous isolation.
3. **Import du pack SRD au premier lancement (M1).** L'import direct suffit : environ 1 s pour 10 000 entités, et le pack SRD complet en comptera moins. Une base préremplie (`DriftWebOptions.initializeDatabase`) n'est pas nécessaire.
4. **Stockage persistant (M1).**
   - Ne jamais attendre la réponse de `requestPersistentStorage()` au démarrage : Firefox peut la laisser en suspens tant que l'utilisateur ne répond pas.
   - La demander après une action volontaire (création du premier personnage, par exemple).
   - Sur refus, afficher l'alerte d'ENF-07, qui explique que le navigateur peut effacer les données et que la synchronisation (M2) les sauvegarde. Sur Chrome et Edge, proposer d'installer l'app (PWA) : c'est ce qui rend l'accord probable.
5. **CI.** Garder la matrice Web : Chrome isolé, Chrome, Firefox, Safari isolé et non isolé. Elle protège contre une régression de compatibilité à chaque montée de version de drift ou de sqlite3.

## Écarts avec le cahier

- §10.1 dit « OPFS, repli IndexedDB » : c'est vérifié. Précision à apporter : OPFS n'est obtenu sur Chrome, Edge et Safari que si la page est isolée par l'hébergeur. Firefox l'utilise même sans isolation.
- ENF-07 demande une alerte en cas de refus. Sur Chrome et Edge, le refus est la règle pour un site neuf : l'alerte s'afficherait à presque tous les nouveaux utilisateurs. À arbitrer par le porteur de projet en M1 : alerte discrète, ou proposition d'installation de l'app.
