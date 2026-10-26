# Proposal

## Why

Carte Trello [T-01 · Spike SQLite WASM sur Web](https://trello.com/c/0LH9VODh/21-t-01-spike-sqlite-wasm-sur-web). Le Web est la première plateforme (cahier §1, ENF-06) et la base locale y tourne en SQLite WASM (§10.1). Le cahier classe ce point comme un risque moyen (§14.1, « SQLite WASM sur Web ») et demande un spike en M0 : 10 000 entités, démarrage, persistance après fermeture, test sur Safari, en-têtes COOP/COEP pour OPFS, repli IndexedDB automatique. ENF-07 exige aussi de demander au navigateur un stockage persistant.

US-04 a montré que la base s'ouvre sur Chrome, mais seulement en IndexedDB : le serveur de développement n'envoie pas les en-têtes d'isolation, donc OPFS n'est pas disponible. Ni les volumes, ni les temps, ni les autres navigateurs n'ont été mesurés. Les décisions de M1 (import du pack au premier lancement, recherche du compendium) en dépendent.

## What Changes

- **Mesures sur 10 000 entités** : un pack synthétique de 10 000 entités (plafond ENF-09), généré dans le test, importé puis interrogé. Le test mesure l'import, la réouverture, une recherche FTS5 et la relecture d'un personnage, et écrit ces temps dans sa sortie.
- **Stockage choisi visible** : l'ouverture de la base expose le stockage retenu par drift (OPFS ou IndexedDB) et les fonctions manquantes du navigateur. Le test vérifie qu'avec les en-têtes COOP/COEP, Chrome choisit OPFS, et que sans eux la base fonctionne en IndexedDB.
- **Stockage persistant (ENF-07)** : une fonction `requestPersistentStorage()` demande `navigator.storage.persist()` sur le Web et renvoie le résultat (accordé ou refusé). Elle renvoie toujours « accordé » sur mobile.
- **Navigateurs** : le test d'intégration Web tourne en CI sur Chrome (avec et sans isolation), Firefox et Safari (runner macOS), et en local sur Chrome et Edge.
- **Persistance après fermeture du navigateur** : vérification manuelle en local sur Chrome, Edge et Firefox (écrire, fermer le navigateur, rouvrir, relire), consignée dans le rapport. Un test automatique ne peut pas fermer et relancer le navigateur avec le même profil.
- **Rapport et décision** : `docs/spikes/T-01-sqlite-wasm-web.md` donne les mesures par navigateur et par stockage, et une recommandation pour M1 (stockage cible, en-têtes à exiger de l'hébergement, seuils retenus). Les écarts avec le cahier y sont signalés au lieu d'être tranchés.

## Capabilities

### New Capabilities

Aucune.

### Modified Capabilities

- `local-database` : la base Web précise son stockage (OPFS avec isolation, repli IndexedDB), demande un stockage persistant (ENF-07) et tient les volumes du plafond ENF-09 (10 000 entités) sur les navigateurs d'ENF-06.

## Impact

- `apps/game_table/lib/database.dart` : remontée du stockage choisi ; nouvelle `lib/persistent_storage.dart`, avec une implémentation Web et une pour les autres plateformes.
- `apps/game_table/integration_test/` : test de volume `web_storage_test.dart`.
- `.github/workflows/ci.yml` : le job Web devient une matrice (Chrome isolé, Chrome sans isolation, Firefox) ; un job Safari sur runner macOS.
- `docs/spikes/T-01-sqlite-wasm-web.md` (nouveau).
- **Dépendance** : `web` (paquet officiel Dart, déjà présent dans le verrou via drift) devient une dépendance directe de l'app.
- **Machine locale** : Chrome, Edge et Firefox sont installés. Aucun téléchargement n'est prévu en local. Firefox et Safari sont automatisés seulement en CI, où geckodriver et safaridriver sont fournis par les runners.

**Hors périmètre :**
- Alerte affichée quand le stockage persistant est refusé (ENF-07) : l'app n'a pas encore d'écran ; renvoyée à M1, avec le premier lancement.
- Import du pack SRD au premier lancement de l'app : M1.
- Choix de l'hébergeur Web et configuration réelle de ses en-têtes : M2, avec le déploiement. Le rapport liste ce qu'il faudra exiger.
- Sauvegarde par la synchronisation en cas d'éviction (§14.1, point 4) : M2 (PowerSync).
- Safari sur iOS (navigateur) : le simulateur iOS de CI teste l'app native, pas Safari ; le Web mobile n'est pas une cible d'ENF-06.
