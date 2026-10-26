# Tasks

Branche `feature/us-03-compute-sheet-niveau-1`. Chaque tâche commence par le test qui échoue (superpowers:test-driven-development) ; vérification de chaque tâche : `cd packages/dnd_rules && fvm dart test` vert.

## 1. Mise en place

- [x] 1.1 Ajouter `dnd_content` aux dépendances de `dnd_rules`, `srd_builder` en dépendance de test, freezed/json_serializable/build_runner en dev ; vérifier par `fvm exec melos bootstrap` puis `fvm dart analyze packages/dnd_rules`
- [x] 1.2 `tool/check_coverage.dart` échoue sur un rapport sans ligne instrumentée ; vérifier qu'un lcov vide donne le code 1 et le lcov de `dnd_content` le code 0

## 2. Entrée du personnage et contenu actif

- [ ] 2.1 Test : `CharacterInput.fromJson` lit l'entrée de `aldric_n1.json` et refuse un champ inconnu ; aligner la fixture (`choices.skillful`, `srd:resource:heroic-inspiration`) sans toucher aux valeurs attendues ; implémenter `CharacterInput` (freezed)
- [ ] 2.2 Test : `ActiveContent` retrouve une entité du pack SRD chargé depuis les sources, et renvoie `null` pour un identifiant absent ; implémenter `ActiveContent`

## 3. Caractéristiques et génération

- [ ] 3.1 Tests des exigences « Valeurs de caractéristique », « Bonus de maîtrise » et « Décomposition » (Force d'Aldric) ; implémenter `computeSheet` pour ces valeurs avec `Computed`
- [ ] 3.2 Tests de « Génération des valeurs » (27 points, 29 points, valeurs standard, aléatoire) et de « Bonus d'Historique conformes » (non éligible, 1-1-1, plafond 20) ; implémenter les contrôles `abilityGeneration` et `backgroundBonus`

## 4. Maîtrises, sauvegardes, compétences

- [ ] 4.1 Tests de « Jets de sauvegarde » et « Compétences et Perception passive » (y compris Intuition par le choix `skillful`) ; implémenter la collecte des effets actifs et la résolution des choix

## 5. Effets de dons et d'aptitudes

- [ ] 5.1 Tests de « Dons accordés conformes » (Polyvalent avec Défense, don d'Historique remplacé) ; implémenter le contrôle `featGrant`
- [ ] 5.2 Tests d'« Initiative », « Classe d'armure » (avec et sans armure), « Vitesse, points de vie et dés de vie » et « Ressources » ; implémenter ces calculs et leurs décompositions
- [ ] 5.3 Test : chaque opération du DSL présente dans l'échantillon M0 modifie la fiche d'au moins un personnage de test ; vérifier qu'il échoue si l'on retire l'interprétation d'une opération

## 6. Bottes et attaques

- [ ] 6.1 Tests d'« Emplacements de bottes » et de « Bottes choisies conformes » (trop de bottes, arme non maîtrisée) ; implémenter le contrôle `weaponMastery`
- [ ] 6.2 Tests d'« Attaques » (épée longue, javeline, mains nues, arme Finesse) ; implémenter les attaques

## 7. Multiclassage et références

- [ ] 7.1 Tests de « Prérequis de multiclassage » (remplis, non remplis) avec une seconde classe en mémoire ; implémenter le contrôle `multiclass`
- [ ] 7.2 Tests d'« Erreurs signalées sans interrompre le calcul » (personnage invalide, espèce inconnue) ; implémenter le contrôle `reference`

## 8. Critère de sortie M0 et intégration

- [ ] 8.1 Test des fixtures [D1] : chaque fixture `active` est recalculée et chaque clé de `expected` est reproduite ; les autres sont `skip` avec leur statut ; vérifier qu'Aldric niveau 1 passe et qu'une valeur attendue faussée le fait échouer
- [ ] 8.2 Mettre à jour `packages/dnd_rules/README.md` (point d'entrée, format d'entrée) et le README des fixtures (format `choices`) ; vérifier la relecture des deux fichiers
- [ ] 8.3 `fvm exec melos run format`, `analyze`, `test` et `coverage` verts, couverture de `dnd_rules` ≥ 95 %

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello US-03 à l'ouverture de la PR ; carte dans « Fait » après la fusion.
- `openspec archive us-03-compute-sheet-niveau-1` après la fusion.
- Vérifier le critère de sortie M0 (cahier §3) dans le bilan du jalon.
