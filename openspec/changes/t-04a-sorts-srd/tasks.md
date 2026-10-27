## 1. Type d'entité sort

- [x] 1.1 Tests qui échouent dans `dnd_content` : lecture d'un sort valide, refus d'un niveau 10, d'une école inconnue, d'une portée `feet` sans valeur, d'un champ inconnu ; puis `SpellData` (freezed), lecteur `spell`, validation ; `build_runner` régénéré
- [ ] 1.2 Tests qui échouent dans `dnd_data` : aller-retour d'un sort dans la table `spell`, recherche par nom ; puis import et export du type `spell` dans `PackStore`

## 2. Extraction

- [ ] 2.1 Tests qui échouent : nettoyage (pied de page retiré, « mini-/male » recollé, paragraphe coupé par une page recollé), découpage d'un extrait de deux sorts, lecture de l'en-tête, portée convertie en pieds (9 m, 45 m, 1,5 km, personnelle, contact), coût et consommation du composant matériel ; puis la commande `extract-spells`
- [ ] 2.2 Table `spell_slugs.tsv` (339 lignes) ; l'extraction échoue sur un nom absent ou un slug en double. Vérifier qu'elle ne signale aucun manque
- [ ] 2.3 Lancer l'extraction sur le PDF, relire le rapport de raccords, écrire `sources/spell/*.json` et `extract/spell_classes.tsv`

## 3. Contenu et vérifications

- [ ] 3.1 Tests du pack SRD :
  - comptes : 339 sorts, 27 mineurs, niveaux 1 à 9 et 8 écoles présents ;
  - sorts témoins vérifiés contre le PDF, page citée : Boule de feu, Bénédiction, Rappel à la vie, Souhait, Aspersion acide, Bouclier.

  Régénérer `apps/game_table/assets/packs/srd-5.2.1-fr.dndpack` et vérifier que le test « pack embarqué » passe.
- [ ] 3.2 `docs/packs/FORMAT_DNDPACK.md` (type `spell`), CLAUDE.md (commande d'extraction) ; vérifier que chaque commande documentée s'exécute

## 4. Intégration

- [ ] 4.1 `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello T-04 (lot 1/5) ; la carte reste dans M1 jusqu'au lot 5.
- `openspec archive t-04a-sorts-srd` après la fusion.
