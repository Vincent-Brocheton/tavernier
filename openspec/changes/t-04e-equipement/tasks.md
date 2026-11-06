## 1. Modèle et base

- [x] 1.1 Tests puis `StartingEquipmentOption` et `ClassData.starting_equipment` (types de référence des objets) ; code généré
- [x] 1.2 Tests puis table `class_equipment_option` et aller-retour `PackStore` ; instantané du schéma

## 2. Outillage

- [x] 2.1 Tests de l'extracteur puis `equipment_extractor.dart` :
  - outils : découpage, caractéristique, poids, prix, variantes ;
  - objets : descriptions, texte du parent pour une variante ;
  - vérification d'une ligne de `gear.tsv` contre le tableau en page.
- [x] 2.2 Configuration (slugs des outils), `extract/gear.tsv`, commande `extract-equipment`

## 3. Contenu

- [x] 3.1 Extraction des outils et des objets ; relecture du diff des outils et objets de M0
- [x] 3.2 Équipement de départ des 12 classes ; build du pack et extraction idempotente

## 4. Vérifications

- [x] 4.1 Tests de contenu, page citée :
  - Outils de voleur, luth, acide ;
  - options du Guerrier et du Barde ;
  - or de chaque option relu dans le SRD.

  Pack régénéré dans l'app.
- [x] 4.2 `FORMAT_DNDPACK.md`, `CLAUDE.md` ; `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello T-04 (lot 4/5, équipement).
- `openspec archive t-04e-equipement` après la fusion.
