import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart';

import 'game_colors.dart';
import 'layout.dart';
import 'tokens.dart';

const _package = 'dnd_ui_kit';

/// Typographie des tokens : Cinzel pour Display et Headline, Roboto Flex pour
/// le reste (COMPOSANTS §1).
abstract final class AppTypography {
  static const displayFamily = 'Cinzel';
  static const textFamily = 'RobotoFlex';

  static TextStyle _style(TypeScaleToken t) => TextStyle(
    fontFamily: t.display ? displayFamily : textFamily,
    package: _package,
    fontSize: t.size,
    height: t.lineHeight / t.size,
    fontWeight: FontWeight.values.firstWhere((w) => w.value == t.weight),
    // Polices variables : l'axe wght porte la graisse réelle.
    fontVariations: [FontVariation('wght', t.weight.toDouble())],
    letterSpacing: t.letterSpacing,
  );

  /// Échelle Material 3 complète, sans couleur (le thème l'ajoute).
  static TextTheme get textTheme {
    TextStyle s(String name) => _style(AppTokens.typeScale[name]!);
    return TextTheme(
      displayLarge: s('displayLarge'),
      displayMedium: s('displayMedium'),
      displaySmall: s('displaySmall'),
      headlineLarge: s('headlineLarge'),
      headlineMedium: s('headlineMedium'),
      headlineSmall: s('headlineSmall'),
      titleLarge: s('titleLarge'),
      titleMedium: s('titleMedium'),
      titleSmall: s('titleSmall'),
      bodyLarge: s('bodyLarge'),
      bodyMedium: s('bodyMedium'),
      bodySmall: s('bodySmall'),
      labelLarge: s('labelLarge'),
      labelMedium: s('labelMedium'),
      labelSmall: s('labelSmall'),
    );
  }

  /// [style] à chiffres tabulaires, pour PV, CA, initiative, DD, PX.
  static TextStyle numeric(TextStyle style) => style.copyWith(
    fontFeatures: [...?style.fontFeatures, const FontFeature.tabularFigures()],
  );
}

/// Thèmes de l'application : sombre au MVP, clair en V1.5.
abstract final class AppTheme {
  static final dark = _build(
    Brightness.dark,
    AppTokens.darkColors,
    GameColors.dark,
  );
  static final light = _build(
    Brightness.light,
    AppTokens.lightColors,
    GameColors.light,
  );

  static ThemeData _build(
    Brightness brightness,
    Map<String, Color> c,
    GameColors game,
  ) {
    final scheme = ColorScheme(
      brightness: brightness,
      primary: c['primary']!,
      onPrimary: c['onPrimary']!,
      primaryContainer: c['primaryContainer'],
      onPrimaryContainer: c['onPrimaryContainer'],
      secondary: c['secondary']!,
      onSecondary: c['onSecondary']!,
      secondaryContainer: c['secondaryContainer'],
      onSecondaryContainer: c['onSecondaryContainer'],
      tertiary: c['tertiary'],
      onTertiary: c['onTertiary'],
      tertiaryContainer: c['tertiaryContainer'],
      onTertiaryContainer: c['onTertiaryContainer'],
      error: c['error']!,
      onError: c['onError']!,
      errorContainer: c['errorContainer'],
      onErrorContainer: c['onErrorContainer'],
      surface: c['surface']!,
      onSurface: c['onSurface']!,
      surfaceDim: c['surfaceDim'],
      surfaceBright: c['surfaceBright'],
      surfaceContainerLowest: c['surfaceContainerLowest'],
      surfaceContainerLow: c['surfaceContainerLow'],
      surfaceContainer: c['surfaceContainer'],
      surfaceContainerHigh: c['surfaceContainerHigh'],
      surfaceContainerHighest: c['surfaceContainerHighest'],
      onSurfaceVariant: c['onSurfaceVariant'],
      outline: c['outline'],
      outlineVariant: c['outlineVariant'],
      inverseSurface: c['inverseSurface'],
      onInverseSurface: c['onInverseSurface'],
      inversePrimary: c['inversePrimary'],
      scrim: c['scrim'],
      // Élévation tonale par les surfaceContainer*, sans teinte (COMPOSANTS §1).
      surfaceTint: const Color(0x00000000),
    );
    // Libellés de navigation des maquettes : 12 px, sans espacement des
    // lettres, 500 (700 pour la destination active), sur une ligne.
    final navLabel = AppTypography.textTheme.labelMedium!.copyWith(
      letterSpacing: 0,
    );
    TextStyle navLabelFor(Set<WidgetState> states) =>
        states.contains(WidgetState.selected)
        ? navLabel.copyWith(
            fontWeight: FontWeight.w700,
            fontVariations: const [FontVariation('wght', 700)],
          )
        : navLabel;
    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      scaffoldBackgroundColor: scheme.surface,
      textTheme: AppTypography.textTheme,
      materialTapTargetSize: MaterialTapTargetSize.padded,
      extensions: [game],
      navigationBarTheme: NavigationBarThemeData(
        height: AppSizes.navigationBar,
        backgroundColor: scheme.surfaceContainer,
        indicatorColor: scheme.secondaryContainer,
        labelTextStyle: WidgetStateProperty.resolveWith(navLabelFor),
      ),
      navigationRailTheme: NavigationRailThemeData(
        minWidth: AppSizes.navigationRail,
        backgroundColor: scheme.surfaceContainerLow,
        indicatorColor: scheme.secondaryContainer,
        unselectedLabelTextStyle: navLabelFor(const {}),
        selectedLabelTextStyle: navLabelFor(const {WidgetState.selected}),
      ),
    );
  }
}

/// Ajoute les licences OFL des polices embarquées à la page « Licences ».
void registerFontLicenses() {
  LicenseRegistry.addLicense(() async* {
    for (final (name, file) in [
      ('Cinzel', 'OFL-Cinzel.txt'),
      ('Roboto Flex', 'OFL-RobotoFlex.txt'),
    ]) {
      yield LicenseEntryWithLineBreaks([
        name,
      ], await rootBundle.loadString('packages/$_package/fonts/$file'));
    }
  });
}
