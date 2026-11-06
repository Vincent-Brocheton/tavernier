import 'package:material_ui/material_ui.dart';

import 'layout.dart';

/// Tuile d'acquisition par points (COMPOSANTS §2.10) : nom, coût, boutons −/+
/// et valeur. Un bouton sans action est désactivé.
class PointBuyTile extends StatelessWidget {
  const PointBuyTile({
    super.key,
    required this.label,
    required this.detail,
    required this.value,
    required this.raiseLabel,
    required this.lowerLabel,
    this.onRaise,
    this.onLower,
  });

  final String label;
  final String detail;
  final int value;

  /// Infobulles et noms lus des boutons, venus des ARB.
  final String raiseLabel;
  final String lowerLabel;
  final VoidCallback? onRaise;
  final VoidCallback? onLower;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: scheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppRadii.md),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: text.titleSmall),
                Text(
                  detail,
                  style: text.bodySmall!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          IconButton.outlined(
            icon: const Icon(Icons.remove),
            tooltip: lowerLabel,
            onPressed: onLower,
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$value',
              textAlign: TextAlign.center,
              style: text.titleLarge,
            ),
          ),
          IconButton.outlined(
            icon: const Icon(Icons.add),
            tooltip: raiseLabel,
            onPressed: onRaise,
          ),
        ],
      ),
    );
  }
}

/// État d'une [BonusToggle].
enum BonusToggleState {
  /// Peut recevoir le bonus.
  available,

  /// Porte le bonus.
  selected,

  /// Ne peut pas le recevoir : la ligne dit pourquoi.
  blocked,

  /// Porte un bonus devenu invalide, à retirer.
  invalid,
}

/// Bascule d'un bonus d'Historique (COMPOSANTS §2.9). L'état se lit au
/// remplissage, à la bordure et au libellé, pas à la seule couleur.
class BonusToggle extends StatelessWidget {
  const BonusToggle({
    super.key,
    required this.label,
    required this.semanticLabel,
    required this.state,
    required this.onTap,
  });

  final String label;

  /// Nom lu par les lecteurs d'écran (« +2 sur Force »).
  final String semanticLabel;
  final BonusToggleState state;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (background, foreground, border) = switch (state) {
      BonusToggleState.selected => (
        scheme.primary,
        scheme.onPrimary,
        scheme.primary,
      ),
      BonusToggleState.available => (
        Colors.transparent,
        scheme.onSurface,
        scheme.outline,
      ),
      BonusToggleState.blocked => (
        Colors.transparent,
        scheme.onSurfaceVariant,
        scheme.outlineVariant,
      ),
      BonusToggleState.invalid => (
        scheme.errorContainer,
        scheme.onErrorContainer,
        scheme.error,
      ),
    };
    final radius = BorderRadius.circular(AppRadii.sm);
    final blocked = state == BonusToggleState.blocked;
    return SizedBox(
      width: 56,
      height: AppSizes.touchTargetMin,
      child: Semantics(
        label: semanticLabel,
        selected: state == BonusToggleState.selected,
        button: true,
        enabled: !blocked,
        excludeSemantics: true,
        child: Material(
          color: background,
          shape: RoundedRectangleBorder(
            borderRadius: radius,
            side: BorderSide(color: border),
          ),
          child: InkWell(
            borderRadius: radius,
            onTap: blocked ? null : onTap,
            child: Center(
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge!.copyWith(
                  color: foreground,
                  decoration: state == BonusToggleState.invalid
                      ? TextDecoration.lineThrough
                      : null,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Bandeau d'erreur de règle en haut de contenu (COMPOSANTS §2.17, variante
/// erreur) : il explique un choix à refaire, et s'annonce quand il apparaît.
class StatusBanner extends StatelessWidget {
  const StatusBanner({super.key, required this.title, required this.message});

  final String title;
  final String message;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Semantics(
      liveRegion: true,
      child: Container(
        padding: EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: scheme.errorContainer,
          borderRadius: BorderRadius.circular(AppRadii.md),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.error_outline, color: scheme.onErrorContainer),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: text.titleSmall!.copyWith(
                      color: scheme.onErrorContainer,
                    ),
                  ),
                  Text(
                    message,
                    style: text.bodyMedium!.copyWith(
                      color: scheme.onErrorContainer,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
