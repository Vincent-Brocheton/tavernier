## 1. Outillage

- [x] 1.1 Table de progression :
  - tests des dés « 1d6 » / « 2d6 » selon le suffixe de colonne ;
  - mètres en pieds (`_feet`) ;
  - valeurs repoussées par un exposant.

  Puis `progression_table.dart`.
- [x] 1.2 Sections de classe :
  - tests de la fin de section au titre de la classe suivante (saut de page compris) ;
  - « Origines des / personnages » ;
  - CRLF ;
  - encadré qui coupe une phrase.

  Puis `feature_extractor.dart`. Vérifier que les six classes du lot 2 ne changent pas.

## 2. Contenu

- [x] 2.1 Configuration des 5 classes, slugs des 111 aptitudes, traits de base ; extraction (textes, tables, listes de sorts) ; relecture des textes et des listes de sorts contre les sections « Liste des sorts »
- [x] 2.2 Effets des aptitudes selon l'inventaire ; build du pack et extraction idempotente

## 3. Vérifications

- [x] 3.1 Tests de contenu par classe, page citée : traits, colonnes témoins (Arts martiaux, Déplacement sans armure, Magie de pacte, Attaque sournoise, emplacements des demi-lanceurs), une aptitude calculable par classe, concordance des listes de sorts ; pack régénéré dans l'app
- [x] 3.2 `docs/packs/FORMAT_DNDPACK.md` (suffixes de colonne, valeurs d'armes) ; `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello T-04 (lot 3/5).
- `openspec archive t-04c-classes-2` après la fusion.
