import 'package:material_ui/material_ui.dart';

import 'tokens.dart';

/// Taille de texte choisie par l'utilisateur, bornée de 85 à 200 %
/// (tokens `typography.textScale`, ENF-14).
abstract final class AppTextScale {
  /// À placer dans `MaterialApp.builder`.
  static Widget clamp({required Widget child}) => Builder(
    builder: (context) => MediaQuery.withClampedTextScaling(
      minScaleFactor: AppTokens.textScaleMin,
      maxScaleFactor: AppTokens.textScaleMax,
      child: child,
    ),
  );
}

/// Durées et courbe de mouvement des tokens, nulles quand le système demande
/// de réduire les animations (COMPOSANTS §1).
abstract final class AppMotion {
  static final curve = Cubic(
    AppTokens.motionCurve.$1,
    AppTokens.motionCurve.$2,
    AppTokens.motionCurve.$3,
    AppTokens.motionCurve.$4,
  );

  static Duration standard(BuildContext context) =>
      _duration(context, AppTokens.motionStandardMs);

  static Duration emphasized(BuildContext context) =>
      _duration(context, AppTokens.motionEmphasizedMs);

  static Duration _duration(BuildContext context, int ms) =>
      MediaQuery.disableAnimationsOf(context)
      ? Duration.zero
      : Duration(milliseconds: ms);
}
