# dnd_ui_kit

Socle visuel de l'application (cahier §9, §10.2 ; `docs/design/COMPOSANTS.md`) : jetons de design, thèmes, polices, icônes de jeu, navigation adaptative et règles d'accessibilité. Bibliothèque Material : `package:material_ui` (et non `package:flutter/material.dart`).

## Utilisation

```dart
MaterialApp(
  theme: AppTheme.dark,
  darkTheme: AppTheme.dark,
  themeMode: ThemeMode.dark,
  builder: (context, child) => AppTextScale.clamp(child: child!),
);
```

- **Couleurs de jeu** : `GameColors.of(context).damage`, `.heal`, `.tempHp`, `.concentration`, `.alert` (et leurs conteneurs), `hpBar(pv, max)`. Toujours avec une icône et un libellé.
- **Mise en page** : `formFactorOf(largeur)`, `AppSpacing.page(format)`, `AppRadii`, `AppSizes`.
- **Chiffres** : `AppTypography.numeric(style)` (chiffres tabulaires) pour PV, CA, initiative, DD, PX.
- **Icônes** : `GameIcon(GameIcons.conditions['poisoned']!, semanticLabel: 'Empoisonné')`.
  - Familles : `conditions`, `damageTypes`, `actionEconomy`, `schools`, `navigation`, plus les icônes transverses.
  - Sans `semanticLabel`, l'icône est décorative.
- **Navigation** : `AdaptiveNavigationScaffold`, avec une barre sous 600 dp et un rail au-delà.
- **Mouvement** : `AppMotion.standard(context)`, nul si le système réduit les animations.
- **Licences** : `registerFontLicenses()` au démarrage de l'app.

## Jetons

`lib/src/tokens.dart` recopie `docs/design/design_tokens.json`, qui reste la source de vérité. Une valeur se change d'abord dans le JSON, puis dans `tokens.dart` : `test/tokens_test.dart` échoue en nommant tout jeton qui diffère.

## Polices

Cinzel (Display et Headline) et Roboto Flex (le reste), fichiers variables du dépôt google/fonts, licence SIL OFL 1.1 (`fonts/OFL-*.txt`).

## Tests golden

`test/golden/kit_golden_test.dart` compare la planche du kit et la navigation sur trois formats. La comparaison ne tourne que sous Linux : ailleurs, ces tests sont ignorés. Pour régénérer les références après un changement visuel voulu :

1. poser l'étiquette `update-goldens` sur la pull request ;
2. télécharger l'artefact `goldens` du job « Format, analyse, tests, couverture » et le copier dans `test/golden/goldens/` ;
3. commiter, puis retirer l'étiquette.

En cas d'échec, l'artefact `echecs-golden` contient les images d'écart.
