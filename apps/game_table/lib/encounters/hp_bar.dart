// Barre de PV (`HpBar`, COMPOSANTS §2.2) : plus de la moitié en soins,
// plus du quart en alerte, sinon en dégâts ; portion perdue d'un aperçu
// atténuée.
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

class HpBar extends StatelessWidget {
  const HpBar({super.key, required this.hp, required this.max, this.before});

  final int hp;
  final int max;

  /// PV avant un aperçu de dégâts : la portion perdue s'affiche atténuée.
  final int? before;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final ratio = max <= 0 ? 0.0 : (hp / max).clamp(0.0, 1.0);
    final color = ratio > 0.5
        ? colors.heal
        : ratio > 0.25
        ? colors.alert
        : colors.damage;
    final lost = before == null || max <= 0
        ? 0.0
        : ((before! - hp) / max).clamp(0.0, 1.0 - ratio);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadii.xs),
      child: SizedBox(
        height: 8,
        child: Row(
          children: [
            Expanded(
              flex: (ratio * 1000).round(),
              child: ColoredBox(color: color),
            ),
            if (lost > 0)
              Expanded(
                flex: (lost * 1000).round(),
                child: ColoredBox(color: colors.damage.withValues(alpha: 0.35)),
              ),
            Expanded(
              flex: ((1 - ratio - lost) * 1000).round(),
              child: ColoredBox(color: scheme.surfaceContainerHighest),
            ),
          ],
        ),
      ),
    );
  }
}
