# Proposal

## Why

Carte Trello [T-07 · dnd_ui_kit : thème, tokens, icônes et composants transverses](https://trello.com/c/i7m9gSyM/75-t-07-dnduikit-th%C3%A8me-tokens-ic%C3%B4nes-et-composants-transverses), dernière carte de M0. Les écrans de M1 (création et fiche de personnage) ont besoin d'un socle commun : thème sombre issu de `docs/design/design_tokens.json`, polices, icônes de jeu, navigation adaptative et règles d'accessibilité (cahier §9, §10.2, §12.1, ENF-14 ; `docs/design/COMPOSANTS.md` §1). `app_theme.dart` et `pubspec_extrait.yaml`, cités par la passation design, n'ont jamais été fournis : ils sont produits ici.

## What Changes

- **Bibliothèque Material** : `dnd_ui_kit` et `game_table` passent de `package:flutter/material.dart` à `package:material_ui` 1.8, la bibliothèque Material séparée du SDK depuis Flutter 3.47, comme le prévoit la passation design.
- **Tokens** : constantes Dart pour les couleurs (sombre et clair), les couleurs de jeu, la typographie, les espacements, les rayons, les tailles, les points de rupture, les états et le mouvement. Un test vérifie chaque valeur contre `design_tokens.json`, la source de vérité.
- **Thème** : `AppTheme.dark` (par défaut) et `AppTheme.light` (V1.5), avec élévation tonale sans `surfaceTint` et cibles tactiles de 48 dp. Extension `GameColors` (dégâts, soins, PV temporaires, concentration, alerte), avec `hpBar(ratio)`. Constantes `AppSpacing` (marge de page selon le format), `AppRadii`, `AppSizes`, et `formFactorOf()` : téléphone < 600, tablette paysage de 600 à 1023, desktop ≥ 1024.
- **Typographie** : Cinzel (Display et Headline) et Roboto Flex (tout le reste) embarquées dans le kit, sous licence OFL, avec leur texte de licence. Style numérique à chiffres tabulaires.
- **Icônes** : `GameIcon`, une icône de trait 24 dp dessinée depuis un tracé SVG. Le jeu comprend :
  - les 15 états ;
  - les 13 types de dégâts ;
  - action, action Bonus et réaction ;
  - les 8 écoles de magie ;
  - les icônes transverses des maquettes (bouclier, PV temporaires, soins, dégâts, concentration, alerte, synchronisation).
  Les tracés viennent des maquettes ([0] Fondations, [G1] Écoles de magie, pavé de dégâts).
- **Navigation** : `AdaptiveNavigationScaffold`. Sous 600 dp, c'est une `NavigationBar` de 80 dp ; à partir de 600 dp, une `NavigationRail` de 80 dp. L'app y déclare ses 5 destinations (Accueil, Tables, Personnages, Compendium, Homebrew), avec leurs libellés dans l'ARB.
- **Accessibilité** :
  - taille du texte bornée de 85 à 200 % ;
  - durées d'animation nulles quand le système réduit les animations ;
  - libellés `Semantics` des icônes, et icônes décoratives exclues.
- **Tests golden** (§12.1) : une planche du kit (couleurs, typographie, icônes, navigation sur les trois formats), comparée seulement sous Linux (CI), parce que le rendu des polices varie d'un système à l'autre.
- **App** : `game_table` utilise le thème et la navigation adaptative, avec des pages provisoires pour les 5 destinations.

## Capabilities

### New Capabilities

- `ui-kit` : thème et tokens, typographie, icônes de jeu, navigation adaptative et règles d'accessibilité communes à tous les écrans.

### Modified Capabilities

Aucune.

## Impact

- `packages/dnd_ui_kit/` : `lib/src/tokens.dart`, `theme.dart`, `game_colors.dart`, `layout.dart`, `game_icons.dart`, `game_icon.dart`, `adaptive_navigation_scaffold.dart`, `accessibility.dart` ; polices et licences dans `fonts/` ; tests unitaires, de widget et golden.
- `apps/game_table/` : migration vers `material_ui`, thème, navigation, libellés ARB des destinations.
- **Dépendances** : `material_ui` 1.8.0 (et `cupertino_ui`, sa dépendance) ; `path_parsing` pour lire les tracés SVG.
- **Taille** : les polices pèsent 1,9 Mo, compatible avec ENF-05 (< 40 Mo).
- `.github/workflows/ci.yml` : tests golden dans le job Linux ; déclenchement manuel pour régénérer les références.
- `pubspec.yaml` (racine) : couverture de `dnd_ui_kit` ≥ 90 % ajoutée à `melos run coverage`.

**Écarts signalés :**
- Les maquettes ne donnent le tracé que de 5 types de dégâts sur 13 (tranchant, perforant, contondant, feu, froid). Les 8 autres (acide, foudre, tonnerre, nécrotique, radiant, psychique, force, poison) sont dessinés dans le même style et marqués « à valider par le design ».
- `COMPOSANTS.md` suggère une `IconData` personnalisée (police d'icônes) ou des SVG via `flutter_svg`. Le kit dessine les tracés lui-même : pas de police à générer, et pas de dépendance SVG complète pour des tracés simples.

**Hors périmètre :**
- Les composants métier (`CombatantCard`, `HpBar`, `ConditionChip`, `DamageKeypad`…) : ils arrivent avec les cartes US qui les utilisent (M1 à M3).
- Le grain des en-têtes (`TexturedHeader`) : M1, avec les écrans évocateurs.
- Le réglage de taille de texte dans le profil : M1 ; le kit fournit seulement les bornes.
- Le thème clair est livré dans le kit mais n'est pas proposé dans l'app (V1.5).
