## 1. Serveur

- [x] 1.1 pgTAP puis migration `character_proposal` : droits de création, de lecture et de réponse
- [x] 1.2 Flux de synchronisation `propositions` et test de synchronisation

## 2. Base locale

- [x] 2.1 Table Drift, schéma PowerSync, instantané du schéma
- [x] 2.2 Tests puis `CharacterStore` : proposer, lister, accepter (état de jeu gardé, historique), refuser

## 3. App

- [x] 3.1 Tests de widgets puis encadré [F4b] sur la fiche ; ARB
- [x] 3.2 Historique : proposition acceptée
- [x] 3.3 Pas d'essai dans le navigateur : une proposition demande un MJ, donc le lot c ou le projet hébergé. Les tests de widgets couvrent l'aperçu, l'acceptation, le refus, l'historique et la vue du MJ ; pgTAP et le test de synchronisation tournent en CI
