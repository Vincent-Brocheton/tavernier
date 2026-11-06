## 1. Modèle et base

- [x] 1.1 Tests puis `MagicItemData`, `MagicItemCategory`, `Rarity` et texte obligatoire ; code généré
- [x] 1.2 Tests puis table `magic_item` et aller-retour `PackStore` ; instantané du schéma

## 2. Outillage

- [x] 2.1 Tests de l'extracteur puis `magic_item_extractor.dart` :
  - entrées, catégorie, rareté, `varies`, Artefact ;
  - harmonisation et créature exigée ;
  - ligne de type collée au texte ;
  - remplacement d'une table à sa place, `start` ou `resume` introuvable ;
  - slug manquant ou orphelin.
- [x] 2.2 `extract/magic_item_slugs.tsv` et commande `extract-magic-items`

## 3. Contenu

- [x] 3.1 Extraction des 258 objets ; relecture du rapport
- [x] 3.2 `extract/magic_item_tables.json` : tables des objets ; build du pack et extraction idempotente

## 4. Vérifications

- [x] 4.1 Tests de contenu : scénarios de la spec, concordance des cellules de table avec le texte en page ; pack régénéré dans l'app
- [x] 4.2 `FORMAT_DNDPACK.md`, `CLAUDE.md` ; `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Carte Trello T-04 : commentaire de fin de lot, puis passage dans « Fait ».
- `openspec archive t-04f-objets-magiques` après la fusion.
