import 'package:material_ui/material_ui.dart';

import 'game_colors.dart';
import 'layout.dart';

/// États de la synchronisation (ENF-02).
enum SyncIndicatorState { synced, pending, offline, conflict }

/// Indicateur de synchronisation (COMPOSANTS §2.14) : pilule de 32 dp, ou
/// icône seule ([compact]) sur téléphone, toujours avec son libellé pour les
/// lecteurs d'écran. Jamais bloquant.
class SyncIndicator extends StatelessWidget {
  const SyncIndicator({
    super.key,
    required this.state,
    required this.label,
    this.compact = false,
  });

  final SyncIndicatorState state;

  /// Libellé venu des ARB (« Synchronisé », « 3 modifications en attente »…).
  final String label;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final game = GameColors.of(context);
    final (icon, color) = switch (state) {
      SyncIndicatorState.synced => (Icons.cloud_done_outlined, game.heal),
      SyncIndicatorState.pending => (Icons.cloud_upload_outlined, game.tempHp),
      SyncIndicatorState.offline => (
        Icons.cloud_off_outlined,
        scheme.onSurfaceVariant,
      ),
      SyncIndicatorState.conflict => (Icons.warning_amber_outlined, game.alert),
    };
    final glyph = Icon(icon, size: 18, color: color);
    if (compact) {
      // Cible tactile de 48 dp pour l'infobulle.
      return Tooltip(
        message: label,
        child: Semantics(
          label: label,
          excludeSemantics: true,
          child: SizedBox.square(dimension: 48, child: Center(child: glyph)),
        ),
      );
    }
    return Container(
      height: 32,
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(AppRadii.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          glyph,
          SizedBox(width: AppSpacing.xs),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
