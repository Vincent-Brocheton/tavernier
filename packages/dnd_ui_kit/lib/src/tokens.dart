// Jetons de design, recopiés de docs/design/design_tokens.json (source de
// vérité). test/tokens_test.dart vérifie chaque valeur contre ce fichier :
// toute modification commence par les tokens.
import 'dart:ui';

/// Un pas de l'échelle typographique Material 3.
final class TypeScaleToken {
  const TypeScaleToken({
    required this.display,
    required this.size,
    required this.lineHeight,
    required this.weight,
    required this.letterSpacing,
  });

  /// `true` : famille des titres (Cinzel) ; sinon famille du texte.
  final bool display;
  final double size;
  final double lineHeight;
  final int weight;
  final double letterSpacing;
}

/// Valeurs brutes des tokens, par nom de jeton.
abstract final class AppTokens {
  static const darkColors = <String, Color>{
    'primary': Color(0xFF84D5C4),
    'onPrimary': Color(0xFF00382F),
    'primaryContainer': Color(0xFF1F5047),
    'onPrimaryContainer': Color(0xFFA6F2E0),
    'secondary': Color(0xFFD8C4AE),
    'onSecondary': Color(0xFF3B2E20),
    'secondaryContainer': Color(0xFF54463A),
    'onSecondaryContainer': Color(0xFFF5E0C9),
    'tertiary': Color(0xFFE7C28A),
    'onTertiary': Color(0xFF422C00),
    'tertiaryContainer': Color(0xFF5D4200),
    'onTertiaryContainer': Color(0xFFFFDEA8),
    'error': Color(0xFFFFB4AB),
    'onError': Color(0xFF690005),
    'errorContainer': Color(0xFF93000A),
    'onErrorContainer': Color(0xFFFFDAD6),
    'surface': Color(0xFF1A1612),
    'surfaceDim': Color(0xFF1A1612),
    'surfaceBright': Color(0xFF413B36),
    'surfaceContainerLowest': Color(0xFF14110D),
    'surfaceContainerLow': Color(0xFF221E1A),
    'surfaceContainer': Color(0xFF27221E),
    'surfaceContainerHigh': Color(0xFF322C28),
    'surfaceContainerHighest': Color(0xFF3D3732),
    'onSurface': Color(0xFFEDE0D6),
    'onSurfaceVariant': Color(0xFFD3C4B6),
    'outline': Color(0xFF9C8E82),
    'outlineVariant': Color(0xFF4F453C),
    'inverseSurface': Color(0xFFEDE0D6),
    'onInverseSurface': Color(0xFF382F28),
    'inversePrimary': Color(0xFF006B5E),
    'scrim': Color(0xFF000000),
  };

  static const lightColors = <String, Color>{
    'primary': Color(0xFF006B5E),
    'onPrimary': Color(0xFFFFFFFF),
    'primaryContainer': Color(0xFFA0F2E0),
    'onPrimaryContainer': Color(0xFF00201B),
    'secondary': Color(0xFF6E5B49),
    'onSecondary': Color(0xFFFFFFFF),
    'secondaryContainer': Color(0xFFF5E0C9),
    'onSecondaryContainer': Color(0xFF2A1C10),
    'tertiary': Color(0xFF7A5900),
    'onTertiary': Color(0xFFFFFFFF),
    'tertiaryContainer': Color(0xFFFFDEA8),
    'onTertiaryContainer': Color(0xFF261900),
    'error': Color(0xFFBA1A1A),
    'onError': Color(0xFFFFFFFF),
    'errorContainer': Color(0xFFFFDAD6),
    'onErrorContainer': Color(0xFF410002),
    'surface': Color(0xFFFFF8F3),
    'surfaceDim': Color(0xFFE1D8D1),
    'surfaceBright': Color(0xFFFFF8F3),
    'surfaceContainerLowest': Color(0xFFFFFFFF),
    'surfaceContainerLow': Color(0xFFFBF2EB),
    'surfaceContainer': Color(0xFFF5ECE5),
    'surfaceContainerHigh': Color(0xFFEFE6DF),
    'surfaceContainerHighest': Color(0xFFE9E1DA),
    'onSurface': Color(0xFF1F1B17),
    'onSurfaceVariant': Color(0xFF4F453C),
    'outline': Color(0xFF81756A),
    'outlineVariant': Color(0xFFD3C4B6),
    'inverseSurface': Color(0xFF352F2B),
    'onInverseSurface': Color(0xFFF9EFE8),
    'inversePrimary': Color(0xFF84D5C4),
    'scrim': Color(0xFF000000),
  };

  static const darkGameColors = <String, Color>{
    'damage': Color(0xFFFF9F8F),
    'damageContainer': Color(0xFF73241B),
    'onDamageContainer': Color(0xFFFFDAD3),
    'onDamage': Color(0xFF3B0905),
    'heal': Color(0xFF9ED98C),
    'healContainer': Color(0xFF24501C),
    'onHealContainer': Color(0xFFBAF5A6),
    'onHeal': Color(0xFF10380F),
    'tempHp': Color(0xFFA7C8FF),
    'tempHpContainer': Color(0xFF1C4778),
    'onTempHpContainer': Color(0xFFD5E3FF),
    'onTempHp': Color(0xFF0B2A55),
    'concentration': Color(0xFFD4BBFF),
    'concentrationContainer': Color(0xFF523A7E),
    'onConcentrationContainer': Color(0xFFEBDCFF),
    'onConcentration': Color(0xFF2A1450),
    'alert': Color(0xFFFFC266),
    'alertContainer': Color(0xFF634000),
    'onAlertContainer': Color(0xFFFFDDB0),
    'onAlert': Color(0xFF3A2600),
  };

  static const lightGameColors = <String, Color>{
    'damage': Color(0xFFB3261E),
    'damageContainer': Color(0xFFFFDAD3),
    'onDamageContainer': Color(0xFF410E0B),
    'onDamage': Color(0xFFFFFFFF),
    'heal': Color(0xFF2E6B23),
    'healContainer': Color(0xFFBAF5A6),
    'onHealContainer': Color(0xFF062100),
    'onHeal': Color(0xFFFFFFFF),
    'tempHp': Color(0xFF2A5EA8),
    'tempHpContainer': Color(0xFFD5E3FF),
    'onTempHpContainer': Color(0xFF001B3D),
    'onTempHp': Color(0xFFFFFFFF),
    'concentration': Color(0xFF6B4EA2),
    'concentrationContainer': Color(0xFFEBDCFF),
    'onConcentrationContainer': Color(0xFF250059),
    'onConcentration': Color(0xFFFFFFFF),
    'alert': Color(0xFF845400),
    'alertContainer': Color(0xFFFFDDB0),
    'onAlertContainer': Color(0xFF2A1800),
    'onAlert': Color(0xFFFFFFFF),
  };

  static const displayFamily = 'Cinzel';
  static const textFamily = 'Roboto Flex';

  static const typeScale = <String, TypeScaleToken>{
    'displayLarge': TypeScaleToken(
      display: true,
      size: 57.0,
      lineHeight: 64.0,
      weight: 600,
      letterSpacing: 0.0,
    ),
    'displayMedium': TypeScaleToken(
      display: true,
      size: 45.0,
      lineHeight: 52.0,
      weight: 600,
      letterSpacing: 0.0,
    ),
    'displaySmall': TypeScaleToken(
      display: true,
      size: 36.0,
      lineHeight: 44.0,
      weight: 600,
      letterSpacing: 0.0,
    ),
    'headlineLarge': TypeScaleToken(
      display: true,
      size: 32.0,
      lineHeight: 40.0,
      weight: 600,
      letterSpacing: 0.0,
    ),
    'headlineMedium': TypeScaleToken(
      display: true,
      size: 28.0,
      lineHeight: 36.0,
      weight: 600,
      letterSpacing: 0.0,
    ),
    'headlineSmall': TypeScaleToken(
      display: true,
      size: 24.0,
      lineHeight: 32.0,
      weight: 600,
      letterSpacing: 0.0,
    ),
    'titleLarge': TypeScaleToken(
      display: false,
      size: 22.0,
      lineHeight: 28.0,
      weight: 400,
      letterSpacing: 0.0,
    ),
    'titleMedium': TypeScaleToken(
      display: false,
      size: 16.0,
      lineHeight: 24.0,
      weight: 500,
      letterSpacing: 0.15,
    ),
    'titleSmall': TypeScaleToken(
      display: false,
      size: 14.0,
      lineHeight: 20.0,
      weight: 500,
      letterSpacing: 0.1,
    ),
    'bodyLarge': TypeScaleToken(
      display: false,
      size: 16.0,
      lineHeight: 24.0,
      weight: 400,
      letterSpacing: 0.5,
    ),
    'bodyMedium': TypeScaleToken(
      display: false,
      size: 14.0,
      lineHeight: 20.0,
      weight: 400,
      letterSpacing: 0.25,
    ),
    'bodySmall': TypeScaleToken(
      display: false,
      size: 12.0,
      lineHeight: 16.0,
      weight: 400,
      letterSpacing: 0.4,
    ),
    'labelLarge': TypeScaleToken(
      display: false,
      size: 14.0,
      lineHeight: 20.0,
      weight: 500,
      letterSpacing: 0.1,
    ),
    'labelMedium': TypeScaleToken(
      display: false,
      size: 12.0,
      lineHeight: 16.0,
      weight: 500,
      letterSpacing: 0.5,
    ),
    'labelSmall': TypeScaleToken(
      display: false,
      size: 11.0,
      lineHeight: 16.0,
      weight: 500,
      letterSpacing: 0.5,
    ),
  };

  static const textScaleMin = 0.85;
  static const textScaleMax = 2.0;

  static const spacing = <String, double>{
    'xxs': 4.0,
    'xs': 8.0,
    'sm': 12.0,
    'md': 16.0,
    'lg': 20.0,
    'xl': 24.0,
    'xxl': 32.0,
  };

  static const radius = <String, double>{
    'xs': 4.0,
    'sm': 8.0,
    'md': 12.0,
    'lg': 16.0,
    'xl': 28.0,
    'full': 999.0,
  };

  static const size = <String, double>{
    'touchTargetMin': 48.0,
    'topAppBar': 64.0,
    'navigationBar': 80.0,
    'navigationRail': 80.0,
    'combatantCardMin': 64.0,
    'hpBar': 8.0,
    'chipInCard': 26.0,
    'chip': 32.0,
    'button': 40.0,
    'keypadKey': 52.0,
  };

  static const phoneMaxWidth = 599.0;
  static const tabletMinWidth = 600.0;
  static const desktopMinWidth = 1024.0;

  static const state = <String, double>{
    'hover': 0.08,
    'focus': 0.1,
    'pressed': 0.1,
    'dragged': 0.16,
    'disabledContent': 0.38,
    'disabledContainer': 0.12,
  };

  static const motionStandardMs = 300;
  static const motionEmphasizedMs = 500;

  /// `cubic-bezier(0.2, 0, 0, 1)` des tokens, pour les deux mouvements.
  static const motionCurve = (0.2, 0.0, 0.0, 1.0);

  static const grainOpacity = 0.07;
  static const grainOpacityOnColoredCover = 0.16;
}
