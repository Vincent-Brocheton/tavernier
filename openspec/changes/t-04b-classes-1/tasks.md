## 1. Modèle

- [x] 1.1 Tests qui échouent : une classe avec `spell_list` et `spellcasting_ability` se lit et se réécrit ; une classe sans ces champs reste valide ; une liste qui cite une aptitude fait échouer `validatePack` ; puis `ClassData` et `build_runner`
- [x] 1.2 Tests qui échouent dans `dnd_data` : aller-retour d'une classe avec liste de sorts, table `spell_class` remplie ; puis `PackStore`

## 2. Extraction des aptitudes

- [ ] 2.1 Tests qui échouent :
  - découpage d'un extrait (deux aptitudes de classe, titre de sous-classe, une aptitude de sous-classe) ;
  - même nom à deux niveaux ;
  - fusion qui garde `data` et `effects` d'un fichier existant.

  Puis la commande `extract-features`.
- [x] 2.2 `extract/feature_slugs.tsv` pour les 6 classes et sous-classes ; extraction des textes, relecture du rapport de raccords

## 3. Contenu

- [ ] 3.1 Barbare et Voie du Berserker : classe (traits, table, colonnes), sous-classe, effets des aptitudes selon l'inventaire
- [ ] 3.2 Barde et Collège du Savoir
- [ ] 3.3 Clerc et Domaine de la Vie
- [ ] 3.4 Druide et Cercle de la Terre
- [ ] 3.5 Ensorceleur et Sorcellerie draconique
- [ ] 3.6 Magicien et Évocateur
- [ ] 3.7 Listes de sorts des 5 lanceurs depuis `spell_classes.tsv`

## 4. Vérifications

- [ ] 4.1 Tests de contenu par classe, page citée : traits de base, colonnes témoins, emplacements au niveau 20, une aptitude calculable, concordance des listes de sorts avec les en-têtes ; pack régénéré dans l'app
- [ ] 4.2 `docs/packs/FORMAT_DNDPACK.md` (champs de classe), CLAUDE.md (commande `extract-features`)

## 5. Intégration

- [ ] 5.1 `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello T-04 (lot 2/5).
- `openspec archive t-04b-classes-1` après la fusion.
