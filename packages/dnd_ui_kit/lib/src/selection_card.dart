import 'package:material_ui/material_ui.dart';

import 'layout.dart';

/// Carte d'un choix exclusif (classe, Historique, espèce). La sélection se
/// lit à la coche et à la bordure, pas à la seule couleur.
///
/// Quand elle s'ouvre, la carte vient à l'écran : le choix qu'elle contient
/// peut bloquer l'étape.
class SelectionCard extends StatefulWidget {
  const SelectionCard({
    super.key,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.selected = false,
    this.footer,
    this.child,
  });

  final String title;
  final String? subtitle;

  /// Valeur à droite du titre (« M · 9 m »).
  final String? trailing;
  final bool selected;

  /// Sans action, la carte est inactive.
  final VoidCallback? onTap;

  /// Puces sous le texte (dé de vie, source).
  final List<Widget>? footer;

  /// Contenu ouvert sous la carte sélectionnée (téléphone).
  final Widget? child;

  @override
  State<SelectionCard> createState() => _SelectionCardState();
}

class _SelectionCardState extends State<SelectionCard> {
  @override
  void didUpdateWidget(SelectionCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.child != null && oldWidget.child == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        Scrollable.ensureVisible(
          context,
          duration: const Duration(milliseconds: 200),
          alignmentPolicy: ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final selected = widget.selected;
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppRadii.md);
    return Material(
      color: selected ? scheme.primaryContainer : scheme.surfaceContainerLow,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
        side: selected
            ? BorderSide(color: scheme.primary, width: 2)
            : BorderSide.none,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            selected: selected,
            button: true,
            child: InkWell(
              onTap: widget.onTap,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: AppSizes.touchTargetMin),
                child: Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(widget.title, style: text.titleMedium),
                          ),
                          if (widget.trailing case final value?)
                            Text(value, style: text.bodyMedium),
                          if (selected) ...[
                            SizedBox(width: AppSpacing.xs),
                            Icon(Icons.check_circle, color: scheme.primary),
                          ],
                        ],
                      ),
                      if (widget.subtitle case final value?)
                        Text(
                          value,
                          style: text.bodySmall!.copyWith(
                            color: selected
                                ? scheme.onPrimaryContainer
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      if (widget.footer case final chips?) ...[
                        SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xxs,
                          children: chips,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ),
          // Hors de la zone tactile : le contenu a ses propres commandes.
          if (widget.child case final content?)
            Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: content,
            ),
        ],
      ),
    );
  }
}

/// Petite étiquette de texte (COMPOSANTS §2.13, `SourceBadge`) : source d'un
/// contenu, en `tertiaryContainer` pour un homebrew.
class SourceBadge extends StatelessWidget {
  const SourceBadge(this.label, {super.key, this.homebrew = false});

  final String label;
  final bool homebrew;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: AppSpacing.xxs,
      ),
      decoration: BoxDecoration(
        color: homebrew
            ? scheme.tertiaryContainer
            : scheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall!.copyWith(
          color: homebrew ? scheme.onTertiaryContainer : scheme.onSurface,
        ),
      ),
    );
  }
}
