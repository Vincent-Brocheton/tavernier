## 1. Stockage choisi et stockage persistant

- [x] 1.1 Test d'intégration qui échoue : avec `T01_EXPECTED_STORAGE=opfs`, le stockage remonté par l'ouverture est un stockage OPFS ; puis rappel `onWebResult` dans `openTavernierDatabase`. Vérifier sur Chrome isolé (`--web-header` COOP/COEP) que le stockage est OPFS, et sans isolation que la base fonctionne en IndexedDB
- [x] 1.2 Test d'intégration qui échoue : `requestPersistentStorage()` renvoie un booléen sur le Web et `true` sur Android ; puis `lib/persistent_storage.dart` (import conditionnel, paquet `web` en dépendance directe). Vérifier sur Chrome et sur l'émulateur `Tavernier_API_35`

## 2. Volume de 10 000 entités

- [x] 2.1 `integration_test/web_storage_test.dart` : pack synthétique de 10 000 dons valides, import, fermeture, réouverture, comptage (10 000), recherche « Aiguille 4242 » trouvée, relecture d'Aldric n1 ; ligne `T01 …` avec les durées. Vérifier qu'il passe sur Chrome (isolé et non isolé) et Edge en local, et sur Android
- [x] 2.2 Point d'entrée de développement `tool/t01_persistence.dart` (compteur écrit et incrémenté à chaque lancement) ; vérifier à la main sur Chrome, Edge et Firefox, port 8123, que le compteur survit à la fermeture du navigateur

## 3. CI

- [ ] 3.1 Job Web en matrice (Chrome isolé avec `T01_EXPECTED_STORAGE=opfs`, Chrome non isolé, Firefox) et job Safari sur `macos-latest` ; chacun lance `database_test.dart` et `web_storage_test.dart`. Vérifier que tous passent sur la pull request et relever leurs lignes `T01`

## 4. Rapport

- [ ] 4.1 `docs/spikes/T-01-sqlite-wasm-web.md` : protocole, tableau des mesures par navigateur et stockage (local et CI), persistance après fermeture, cibles atteintes ou non, recommandation pour M1 (stockage cible, en-têtes à exiger, refus de stockage persistant, piste de base préremplie si besoin), écarts avec le cahier. Vérifier que chaque chiffre du tableau vient d'une ligne `T01` relevée
- [ ] 4.2 CLAUDE.md, section Commandes : lancer le test de volume en local (Chrome isolé, Edge) et le point d'entrée de persistance ; vérifier que chaque commande documentée s'exécute

## 5. Intégration

- [ ] 5.1 `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello T-01 à l'ouverture de la PR, avec le lien du rapport ; carte dans « Fait » après la fusion.
- `openspec archive t-01-spike-sqlite-wasm-web` après la fusion.
