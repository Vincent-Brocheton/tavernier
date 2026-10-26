# Design

## Context

`dnd_ui_kit` ne contient qu'une constante de fumée. L'app `game_table` utilise `package:flutter/material.dart`, `ThemeData.dark()` et une page d'accueil sans navigation. Flutter 3.47 a déplacé Material dans le paquet `material_ui` (1.8.0). Celui-ci a ses propres types (`ThemeData`, `MaterialLocalizations`, `GlobalMaterialLocalizations`), non compatibles avec ceux de `flutter/material.dart`, et fournit une correction automatique (`dart fix --code=migrate_design_widgets`). Les tokens sont dans `docs/design/design_tokens.json`. Les tracés d'icônes sont dans les maquettes HTML : dictionnaires `I` et `C` de `Main.dc.html`, tracés de `G01-Ecoles-Magie.dc.html` et types de dégâts de `Combat-Phone-Degats.dc.html`. Motivation : proposal.md.

## Goals / Non-Goals

**Goals:**
- Un seul endroit pour chaque valeur visuelle, vérifié contre les tokens.
- Un socle que les composants métier de M1 réutilisent sans redéfinir de couleur, de taille ni d'icône.

**Non-Goals:**
- Pas de génération de code depuis les tokens : 130 valeurs stables ne justifient pas un générateur. Un test de concordance suffit.
- Pas de composant métier.

## Decisions

1. **Migration vers `material_ui`, d'un bloc.** Le kit et l'app passent ensemble à `package:material_ui/material_ui.dart`, avec `dart fix --apply --code=migrate_design_widgets`, puis les délégués de localisation de `material_ui`. Mélanger les deux bibliothèques ferait coexister deux `ThemeData` incompatibles. Le pont `MaterialMigrationBridge` du paquet n'est pas utilisé : aucune dépendance n'importe l'ancien Material.
2. **Tokens écrits à la main, vérifiés par test.**
   - `lib/src/tokens.dart` déclare les couleurs (`AppColorTokens.dark` / `.light`), les couleurs de jeu, l'échelle typographique, les espacements, les rayons, les tailles, les points de rupture, les opacités d'état et le mouvement.
   - `test/tokens_test.dart` lit `docs/design/design_tokens.json` depuis le dépôt et compare chaque jeton. Le message d'échec nomme le chemin du jeton (ex. `color.dark.primary`).
   - Alternative écartée : un générateur `build_runner`, plus lourd que les quelques lignes de comparaison.
3. **`AppTheme.dark` / `AppTheme.light`.**
   - `ColorScheme` est construit champ par champ depuis les tokens, sans `fromSeed`.
   - `surfaceTint: Colors.transparent`, pour l'élévation tonale.
   - `materialTapTargetSize: padded`.
   - `TextTheme` construit depuis l'échelle des tokens.
   - `extensions: [GameColors.dark]`.
   - Thèmes de la barre et du rail : hauteur et largeur 80 ; indicateur `secondaryContainer` (COMPOSANTS, description du jeton).
4. **`GameColors`.** C'est un `ThemeExtension` aux 20 couleurs (5 couleurs × couleur, conteneur, sur-couleur, sur-conteneur), avec `lerp` et `copyWith`, et `hpBar(current, max)` selon les paliers 50 % / 25 %. L'accès se fait par `GameColors.of(context)`.
5. **Mise en page.** `FormFactor { phone, tabletLandscape, desktop }` et `formFactorOf(double width)`. `AppSpacing` reprend les constantes des tokens, plus `page(FormFactor)` (16, 24 ou 32). `AppRadii` et `AppSizes` sont des constantes.
6. **Polices dans le kit.**
   - **Fichiers :** `packages/dnd_ui_kit/fonts/` contient `Cinzel.ttf`, `RobotoFlex.ttf` (fichiers variables officiels de google/fonts) et leurs `OFL-*.txt`.
   - **Déclaration :** elles sont déclarées dans le `pubspec.yaml` du kit, et les styles les référencent avec `package: 'dnd_ui_kit'` (familles `packages/dnd_ui_kit/Cinzel`, etc.).
   - **Graisse :** le poids 600 de Cinzel est obtenu par l'axe `wght` de la police variable (`FontVariation('wght', 600)`), en plus de `fontWeight`.
   - **Chiffres :** `AppTypography.numeric(TextStyle)` ajoute `FontFeature.tabularFigures()`.
   - **Licence :** le texte OFL est enregistré dans `LicenseRegistry`, au démarrage de l'app, par `registerFontLicenses()`.
7. **Icônes par tracé.**
   - **Données :** `GameIcons` déclare des `GameIconData` (tracé SVG 24 × 24, épaisseur de trait). Les familles `GameIcons.conditions` (15), `damageTypes` (13), `actionEconomy` (3) et `schools` (8) sont des listes ordonnées et nommées.
   - **Widget :** `GameIcon(data, semanticLabel:)` lit `IconTheme` (taille, couleur) et peint le tracé avec un `CustomPainter`. Le tracé est converti par `path_parsing` (`writeSvgPathDataToPath`), mis à l'échelle de la taille demandée, trait arrondi.
   - **Sémantique :** sans libellé, l'icône est exclue de l'arbre sémantique.
   - **Alternative écartée :** une police d'icônes (`IconData`), qui demanderait un outil de génération de police hors Dart, ou `flutter_svg`, trop large pour des tracés simples.
   - **Tracés repris :** les tracés des maquettes sont repris tels quels.
   - **Tracés nouveaux :** les 8 types de dégâts absents des maquettes sont dessinés dans le même style (trait 2, grille 24) et marqués `// À valider par le design`.
8. **`AdaptiveNavigationScaffold`.**
   - **Entrées :** `destinations` (icône, icône sélectionnée, libellé), `selectedIndex`, `onDestinationSelected` et `body`.
   - **Disposition :** il choisit la barre ou le rail avec `formFactorOf(MediaQuery.sizeOf(context).width)`. Le rail porte ses libellés (`NavigationRailLabelType.all`).
   - **Cible :** chaque destination garde une cible d'au moins 48 dp.
   - **Libellés :** l'app fournit les libellés depuis l'ARB ; le kit ne contient aucune chaîne d'interface.
9. **Accessibilité.**
   - `AppTextScale.clamp(context, child)` applique `MediaQuery.withClampedTextScaling(min 0.85, max 2.0)`. L'app l'utilise dans `MaterialApp.builder`.
   - `AppMotion.standard(context)` et `emphasized(context)` renvoient `Duration.zero` si `MediaQuery.disableAnimationsOf(context)`.
10. **Golden.**
    - **Planche :** `test/golden/kit_golden_test.dart` rend une planche du kit (palette, échelle typographique, toutes les icônes, scaffold aux trois largeurs 390, 960 et 1440).
    - **Polices :** les vraies polices sont chargées par `FontLoader` dans le test.
    - **Plateforme :** le test est marqué `golden` et ignoré hors Linux (`skip: !Platform.isLinux`). Le job « checks » de la CI les exécute.
    - **Références :** elles sont produites par le même job lancé à la main (`workflow_dispatch` avec `update_goldens: true`), qui publie les images en artefact, ensuite commitées dans `test/golden/goldens/`.
    - **Alternative écartée :** comparer sous Windows, où le rendu diffère de Linux et casserait la CI.
11. **App.** `GameTableApp` utilise `theme: AppTheme.dark`, `themeMode: dark`, `builder: AppTextScale.clamp`, et un `AdaptiveNavigationScaffold` à 5 destinations. Chaque destination affiche une page provisoire (titre, en Headline Cinzel). Les libellés `navHome`, `navTables`, `navCharacters`, `navCompendium` et `navHomebrew` sont dans `app_fr.arb`. Les icônes de navigation sont les tracés du rail des maquettes desktop (`GameIcons.navigation`). Les libellés de navigation suivent les maquettes : 12 px, sans espacement des lettres, 500 (700 pour la destination active), sur une ligne à partir de 375 dp.
12. **Couverture.** `dnd_ui_kit` passe sous `coverage` avec un seuil de 90 % (`flutter test --coverage`). Les tests golden, ignorés sous Windows, ne comptent pas pour le seuil local.

## Risks / Trade-offs

- [`material_ui` récent, API proche mais pas identique à l'ancien Material] → la migration passe par l'outil officiel ; l'analyse stricte et les tests de widget vérifient le résultat.
- [Références golden générées en CI, pas en local] → la procédure est documentée dans CLAUDE.md ; un changement visuel volontaire demande de relancer le job et de commiter l'artefact.
- [Polices variables mal rendues par `fontWeight` seul] → l'axe `wght` est fixé explicitement ; la planche golden le vérifie.
- [8 icônes de dégâts dessinées hors maquettes] → elles sont signalées dans le code, la PR et la carte, et restent faciles à remplacer (une chaîne de tracé chacune).
