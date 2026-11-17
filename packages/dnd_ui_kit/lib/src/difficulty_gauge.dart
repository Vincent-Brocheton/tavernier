import 'package:material_ui/material_ui.dart';

import 'game_colors.dart';
import 'layout.dart';

/// Niveau atteint sur la jauge : sous Faible, Faible, Modérée, Élevée.
enum GaugeLevel { belowLow, low, moderate, high }

/// Repère de la jauge : libellé (« Faible »), valeur affichée (« 2 000 »)
/// et seuil en PX.
typedef GaugeMark = ({String label, String value, int xp});

/// Jauge de difficulté (`DifficultyGauge`, COMPOSANTS §2.12, [C1]) : barre
/// avec les repères Faible, Modérée et Élevée. À gauche, le libellé de la
/// difficulté et son icône ; à droite, le total de PX. Sous Faible, la
/// barre est `outline` ; Faible soins, Modérée alerte, Élevée dégâts.
class DifficultyGauge extends StatelessWidget {
  const DifficultyGauge({
    super.key,
    required this.title,
    required this.levelLabel,
    required this.level,
    required this.xp,
    required this.xpLabel,
    required this.caption,
    required this.marks,
  });

  /// « Difficulté ».
  final String title;
  final String levelLabel;
  final GaugeLevel level;
  final int xp;

  /// « 3 000 PX ».
  final String xpLabel;

  /// « 4 PJ de niveau 5 ».
  final String caption;

  /// Faible, Modérée, Élevée.
  final List<GaugeMark> marks;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final (color, icon) = switch (level) {
      GaugeLevel.belowLow => (scheme.outline, Icons.remove_circle_outline),
      GaugeLevel.low => (colors.heal, Icons.check_circle_outline),
      GaugeLevel.moderate => (colors.alert, Icons.warning_amber),
      GaugeLevel.high => (colors.damage, Icons.dangerous_outlined),
    };
    // L'échelle dépasse un peu le seuil Élevé, pour le voir franchi.
    final top = marks.isEmpty || marks.last.xp == 0
        ? 1
        : (marks.last.xp * 1.15).round();
    final fill = (xp / top).clamp(0.0, 1.0);
    return Semantics(
      liveRegion: true,
      label: '$title : $levelLabel, $xpLabel, $caption',
      child: ExcludeSemantics(
        // Une ligne de libellés, puis la barre sur toute la largeur : la
        // jauge tient sur un téléphone.
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: text.labelSmall),
                      Text(levelLabel, style: text.titleLarge),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(xpLabel, style: text.titleLarge),
                    Text(caption, style: text.bodySmall),
                  ],
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = constraints.maxWidth;
                return SizedBox(
                  height: 64,
                  child: Stack(
                    children: [
                      Positioned(
                        left: 0,
                        right: 0,
                        top: 4,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppRadii.sm),
                          child: LinearProgressIndicator(
                            value: fill,
                            minHeight: 16,
                            color: color,
                            backgroundColor: scheme.surfaceContainerHighest,
                          ),
                        ),
                      ),
                      for (final mark in marks)
                        Positioned(
                          left: (width * mark.xp / top - 36).clamp(
                            0,
                            width - 72,
                          ),
                          width: 72,
                          top: 0,
                          child: Column(
                            children: [
                              Container(
                                width: 2,
                                height: 24,
                                color: scheme.onSurface,
                              ),
                              Text(mark.label, style: text.labelSmall),
                              Text(mark.value, style: text.labelSmall),
                            ],
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
