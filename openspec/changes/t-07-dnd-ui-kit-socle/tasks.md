## 1. Migration Material

- [x] 1.1 Ajouter `material_ui` au kit et à l'app, migrer les imports (`dart fix --apply --code=migrate_design_widgets`) et les délégués de localisation ; vérifier `flutter analyze` sans erreur, les tests existants verts et `flutter build web` réussi

## 2. Tokens, thème, mise en page

- [x] 2.1 Test qui échoue : `tokens_test.dart` compare chaque jeton de `design_tokens.json` aux constantes ; puis `tokens.dart`. Vérifier qu'une valeur modifiée fait échouer le test en nommant le jeton
- [x] 2.2 Tests qui échouent : `formFactorOf` (599, 600, 1023, 1024), `AppSpacing.page`, `GameColors.hpBar` (31/52, 14/52, 2/11, et les bornes 50 % et 25 %) ; puis `layout.dart` et `game_colors.dart`
- [x] 2.3 Tests qui échouent : `AppTheme.dark` (surface `#1A1612`, `primary`, `surfaceTint` transparent, extension `GameColors`, cible tactile 48 dp mesurée sur un bouton, `headlineSmall` en Cinzel 24, `bodyMedium` en Roboto Flex 14, style numérique `tnum`) ; puis `theme.dart`, polices dans `fonts/` avec licences, `registerFontLicenses()`

## 3. Icônes

- [x] 3.1 Tests qui échouent : 15 états, 13 dégâts, 3 actions, 8 écoles, chaque tracé lisible par `path_parsing` ; `GameIcon` rendu à la taille de l'`IconTheme`, libellé sémantique présent ou exclu ; puis `game_icons.dart` (tracés des maquettes, 8 dégâts dessinés et marqués) et `game_icon.dart`

## 4. Navigation et accessibilité

- [x] 4.1 Tests qui échouent : barre à 390 dp, rail à 960 et 1440 dp, cinq destinations, sélection au toucher ; puis `adaptive_navigation_scaffold.dart`
- [ ] 4.2 Tests qui échouent : texte borné à 200 % pour une demande de 300 % et à 85 % pour 50 % ; `AppMotion` nul si animations réduites ; puis `accessibility.dart`

## 5. Application

- [ ] 5.1 Test de widget qui échoue : l'app démarre en thème sombre, affiche les cinq destinations (libellés de l'ARB) et change de page au toucher ; puis thème, navigation et ARB dans `game_table`. Vérifier `flutter build web` et un lancement sur Chrome

## 6. Golden et CI

- [ ] 6.1 Planche golden `test/golden/kit_golden_test.dart` (marquée `golden`, ignorée hors Linux) ; job CI qui l'exécute, déclenchement manuel `update_goldens` qui publie les références en artefact ; références générées en CI et commitées ; vérifier que le job passe
- [ ] 6.2 Couverture de `dnd_ui_kit` ≥ 90 % dans `melos run coverage` ; README du kit et CLAUDE.md (polices, tokens, régénération des goldens)

## 7. Intégration

- [ ] 7.1 `fvm exec melos run format`, `analyze`, `test` et `coverage` verts

## Workflow follow-up

- Revue `code-review` de la pull request, CI verte, fusion.
- Commentaire sur la carte Trello T-07 à l'ouverture de la PR (icônes de dégâts à valider) ; carte dans « Fait » après la fusion.
- `openspec archive t-07-dnd-ui-kit-socle` après la fusion, puis bilan du critère de sortie de M0.
