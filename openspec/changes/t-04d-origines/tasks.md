## 1. Outillage

- [x] 1.1 Tests de l'extracteur d'origines puis `origin_extractor.dart` :
  - en-tête d'espèce (type, tailles « M ou P », Vitesse en pieds) ;
  - traits « Nom. Texte » et faux départs (sous-options du Gnome, du Goliath) ;
  - table de trait retirée et lignes recopiées ajoutées ;
  - dons : titre, catégorie, prérequis, « Répétable », intertitres ignorés.
- [x] 1.2 Configuration `srd_origins.dart` et commande `extract-origins` (fusion qui garde les effets).

## 2. Contenu

- [x] 2.1 Extraction des 9 espèces et des 17 dons ; relecture du diff de l'Humain et des dons de M0
- [x] 2.2 Effets des traits et des Faveurs épiques selon l'inventaire ; build du pack et extraction idempotente

## 3. Vérifications

- [x] 3.1 Tests de contenu, page citée :
  - Nain, Goliath, lignage drow, tailles au choix ;
  - Faveurs épiques ;
  - concordance des lignes de table avec le texte en mise en page.

  Pack régénéré dans l'app.
- [x] 3.2 `CLAUDE.md` (commande `extract-origins`) ; `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello T-04 (lot 4/5, origines).
- `openspec archive t-04d-origines` après la fusion.
