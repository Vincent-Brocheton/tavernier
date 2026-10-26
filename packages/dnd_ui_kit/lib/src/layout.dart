import 'tokens.dart';

/// Format d'écran (COMPOSANTS §1, « Disposition par point de rupture »).
enum FormFactor { phone, tabletLandscape, desktop }

/// Format correspondant à une largeur en dp.
FormFactor formFactorOf(double width) => width < AppTokens.tabletMinWidth
    ? FormFactor.phone
    : width < AppTokens.desktopMinWidth
    ? FormFactor.tabletLandscape
    : FormFactor.desktop;

/// Espacements des tokens.
abstract final class AppSpacing {
  static final xxs = AppTokens.spacing['xxs']!;
  static final xs = AppTokens.spacing['xs']!;
  static final sm = AppTokens.spacing['sm']!;
  static final md = AppTokens.spacing['md']!;
  static final lg = AppTokens.spacing['lg']!;
  static final xl = AppTokens.spacing['xl']!;
  static final xxl = AppTokens.spacing['xxl']!;

  /// Marge de page : 16 sur téléphone, 24 sur tablette, 32 sur desktop.
  static double page(FormFactor formFactor) => switch (formFactor) {
    FormFactor.phone => md,
    FormFactor.tabletLandscape => xl,
    FormFactor.desktop => xxl,
  };
}

/// Rayons des tokens : xs champs, sm puces, md cartes, lg sections,
/// xl feuilles et dialogues, full boutons.
abstract final class AppRadii {
  static final xs = AppTokens.radius['xs']!;
  static final sm = AppTokens.radius['sm']!;
  static final md = AppTokens.radius['md']!;
  static final lg = AppTokens.radius['lg']!;
  static final xl = AppTokens.radius['xl']!;
  static final full = AppTokens.radius['full']!;
}

/// Tailles des tokens.
abstract final class AppSizes {
  static final touchTargetMin = AppTokens.size['touchTargetMin']!;
  static final topAppBar = AppTokens.size['topAppBar']!;
  static final navigationBar = AppTokens.size['navigationBar']!;
  static final navigationRail = AppTokens.size['navigationRail']!;
  static final combatantCardMin = AppTokens.size['combatantCardMin']!;
  static final hpBar = AppTokens.size['hpBar']!;
  static final chipInCard = AppTokens.size['chipInCard']!;
  static final chip = AppTokens.size['chip']!;
  static final button = AppTokens.size['button']!;
  static final keypadKey = AppTokens.size['keypadKey']!;
}
