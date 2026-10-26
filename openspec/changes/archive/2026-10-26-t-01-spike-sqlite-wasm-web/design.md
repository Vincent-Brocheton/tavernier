# Design

## Context

La base est ouverte par `openTavernierDatabase()` (`apps/game_table/lib/database.dart`), avec `drift_flutter` et ses fichiers Web `sqlite3.wasm` (3.8.0) et `drift_worker.js` (drift 2.35.3). Drift choisit seul son stockage parmi `opfsShared`, `opfsLocks`, `sharedIndexedDb`, `unsafeIndexedDb` et `inMemory`, selon les fonctions du navigateur. OPFS demande une page isolée (COOP/COEP). Sans isolation, US-04 a obtenu `sharedIndexedDb` sur Chrome. Le test d'intégration `database_test.dart` tourne en CI sur Chrome (`flutter drive`), et en local avec `flutter run -t`. Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Des mesures reproductibles (même test, mêmes données) par navigateur et par stockage, et une recommandation écrite pour M1.
- Garder le test de volume dans la CI, pour qu'une régression de performance ou de compatibilité se voie.

**Non-Goals:**
- Pas de seuil de durée qui fasse échouer la CI : les runners partagés varient trop. Les seuils sont des cibles du rapport.
- Pas d'optimisation de l'import dans ce spike. Si les mesures l'exigent, le rapport propose la piste et une carte M1 la porte.

## Decisions

1. **Stockage remonté par un rappel.** `openTavernierDatabase({onWebResult})` transmet le `WasmDatabaseResult` de drift (stockage choisi, fonctions manquantes) par `DriftWebOptions.onResult`. Sur mobile, le rappel n'est jamais appelé. Alternative écartée : relire le stockage depuis la base, ce que drift n'expose pas.
2. **Stockage persistant par import conditionnel.** `lib/persistent_storage.dart` exporte `requestPersistentStorage()`. L'implémentation Web appelle `navigator.storage.persist()` via le paquet `web` ; celle des autres plateformes renvoie `true`. Alternative écartée : `dart:html`, déprécié et incompatible avec la compilation WASM de Flutter. Constat du spike : Firefox laisse la promesse en suspens tant que l'utilisateur n'a pas répondu à son invite. Le test borne donc la demande à 10 s et note « sans réponse », et l'app ne devra jamais attendre cette réponse au démarrage.
3. **Pack synthétique généré dans le test.** `integration_test/web_storage_test.dart` construit 10 000 entités `feat` valides (noms uniques, textes de longueur réaliste repris en boucle du pack SRD embarqué), dont une au nom repérable (« Aiguille 4242 »). Aucun fichier de 10 000 entités n'est commité, et le test reste indépendant des sources SRD. Le contenu est synthétique : il ne contient aucun texte hors SRD.
4. **Mesures par chronomètre, sortie lisible.** Le test chronomètre l'import, la fermeture puis la réouverture jusqu'à la première requête, une recherche du nom repérable et la relecture d'Aldric niveau 1. Il écrit une ligne `T01 plateforme=… stockage=… import_ms=… reouverture_ms=… recherche_ms=… personnage_ms=…`. Sur le Web, la plateforme est lue dans `navigator.userAgent`.
5. **Stockage attendu passé à la compilation.** Le job où Chrome est isolé passe `--dart-define=T01_EXPECTED_STORAGE=opfs`, et le test vérifie alors que le stockage choisi est un stockage OPFS. Sans la variable, le test n'impose pas de stockage : il vérifie seulement que la base fonctionne. Un même test sert donc tous les navigateurs.
6. **Navigateurs en CI.**
   - **Job Web :** une matrice sur `ubuntu-latest`.
     - Chrome isolé : `flutter drive --web-header=Cross-Origin-Opener-Policy=same-origin --web-header=Cross-Origin-Embedder-Policy=require-corp`.
     - Chrome sans isolation.
     - Firefox : `--browser-name=firefox`, avec le geckodriver du runner.
   - **Job Safari :** sur `macos-latest`, `sudo safaridriver --enable`, puis `--browser-name=safari --no-headless` (Safari n'a pas de mode sans fenêtre).
   - **Edge :** vérifié en local (Windows).
   - Chaque job lance `database_test.dart` puis `web_storage_test.dart`.
7. **Persistance après fermeture, vérifiée à la main.** Elle se vérifie en local sur Chrome, Edge et Firefox. L'app n'a pas encore d'écran pour écrire et relire une valeur, donc le spike utilise un point d'entrée de développement `tool/t01_persistence.dart`, lancé avec `flutter run -t` et un port fixe (`--web-port=8123`). Le port fait partie de l'origine du stockage, d'où le port fixe. Au premier lancement, le point d'entrée écrit un compteur, puis l'incrémente à chaque lancement. On ferme le navigateur, on relance et on lit la valeur. Le protocole et les résultats vont dans le rapport.
8. **Rapport.**
   - **Fichier :** `docs/spikes/T-01-sqlite-wasm-web.md`.
   - **Tableau des mesures :** une ligne par navigateur et par stockage.
   - **Cibles :** import des 10 000 entités ≤ 10 s, réouverture ≤ 1 s, recherche ≤ 100 ms (ENF-04 donne < 100 ms pour une action et < 2 s pour un démarrage à froid sur mobile ; le Web n'a pas de seuil chiffré dans le cahier).
   - **Recommandation :** stockage cible, en-têtes exigés de l'hébergeur, et réponse à donner à un refus de stockage persistant.
   - **Piste si l'import dépasse sa cible :** livrer une base SQLite préremplie via `DriftWebOptions.initializeDatabase`, au lieu d'importer le pack au premier lancement.

## Risks / Trade-offs

- [Isolation COOP/COEP qui bloque des ressources tierces (polices Google, Sentry)] → le rapport liste ce que l'isolation impose (`crossorigin`, en-têtes CORP) ; les polices seront servies en local (T-07).
- [geckodriver ou safaridriver absents ou cassés sur un runner] → le job concerné échoue avec son nom ; le rapport note la version des runners utilisés.
- [Mesures CI bruitées] → elles sont indicatives ; les chiffres de référence du rapport viennent de la machine locale, et la CI sert de garde-fou de compatibilité.
- [Firefox et Safari sans OPFS synchrone dans un worker partagé] → drift bascule seul sur IndexedDB ou `opfsLocks` ; le test vérifie le fonctionnement, pas le stockage, hors Chrome isolé.

## Open Questions

- Les en-têtes exacts et leur mise en place dépendent de l'hébergeur choisi en M2 ; le rapport fixe seulement les valeurs à exiger.
