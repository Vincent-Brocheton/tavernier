import 'package:material_ui/material_ui.dart';

import 'layout.dart';
import 'selection_card.dart';
import 'theme.dart';

/// Tuile d'une valeur simple : CA, Initiative, Vitesse… (COMPOSANTS §2.15).
class StatTile extends StatelessWidget {
  const StatTile({
    super.key,
    required this.value,
    required this.label,
    required this.onTap,
  });

  final String value;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadii.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadii.lg),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.xs),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(value, style: AppTypography.numeric(text.titleLarge!)),
              Text(label, style: text.bodySmall, textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }
}

/// Tuile de caractéristique : abréviation, modificateur, valeur et jet de
/// sauvegarde. La maîtrise du jet se lit à une icône (COMPOSANTS §2.15).
class AbilityTile extends StatelessWidget {
  const AbilityTile({
    super.key,
    required this.label,
    required this.modifier,
    required this.score,
    required this.save,
    required this.saveProficient,
    required this.semanticLabel,
    required this.onTap,
  });

  final String label;
  final String modifier;
  final int score;
  final String save;
  final bool saveProficient;
  final String semanticLabel;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      label: semanticLabel,
      button: true,
      onTap: onTap,
      excludeSemantics: true,
      child: Material(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.lg),
        child: InkWell(
          borderRadius: BorderRadius.circular(AppRadii.lg),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.xs),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(label, style: text.labelMedium),
                Text(modifier, style: AppTypography.numeric(text.titleLarge!)),
                Text('$score', style: AppTypography.numeric(text.bodyMedium!)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      saveProficient
                          ? Icons.radio_button_checked
                          : Icons.radio_button_unchecked,
                      size: 12,
                      color: saveProficient
                          ? scheme.primary
                          : scheme.onSurfaceVariant,
                    ),
                    SizedBox(width: AppSpacing.xxs),
                    Text(save, style: AppTypography.numeric(text.bodySmall!)),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Pastilles d'une ressource : pleine si disponible (COMPOSANTS §2.16).
class ResourcePips extends StatelessWidget {
  const ResourcePips({
    super.key,
    required this.total,
    required this.available,
    required this.semanticLabel,
  });

  final int total;
  final int available;

  /// « 2 utilisations sur 3 ».
  final String semanticLabel;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    return Semantics(
      label: semanticLabel,
      excludeSemantics: true,
      child: Wrap(
        spacing: AppSpacing.xxs,
        children: [
          for (var i = 0; i < total; i++)
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i < available ? color : null,
                border: Border.all(color: color, width: 2),
              ),
            ),
        ],
      ),
    );
  }
}

/// Une ligne de décomposition.
final class BreakdownLine {
  const BreakdownLine({required this.amount, required this.label, this.badge});

  final String amount;
  final String label;

  /// Source de la ligne : « Création », « SRD 5.2.1 ».
  final String? badge;
}

/// Une valeur alimentée par celle qu'on décompose (« Athlétisme +5 »).
final class BreakdownUse {
  const BreakdownUse(this.label, this.value);

  final String label;
  final String value;
}

/// Décomposition d'une valeur (COMPOSANTS §2.8, [2b]).
class ValueBreakdown extends StatelessWidget {
  const ValueBreakdown({
    super.key,
    required this.category,
    required this.title,
    required this.value,
    required this.lines,
    required this.closeLabel,
    this.modifier,
    this.rule,
    this.usesLabel,
    this.uses = const [],
  });

  final String category;
  final String title;
  final String value;
  final String? modifier;
  final List<BreakdownLine> lines;

  /// Règle de calcul (« Modificateur +4 = (18 − 10) ÷ 2… »).
  final String? rule;
  final String? usesLabel;
  final List<BreakdownUse> uses;
  final String closeLabel;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final numeric = AppTypography.numeric(text.titleMedium!);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(category, style: text.bodySmall),
                    Text(title, style: text.titleLarge),
                  ],
                ),
              ),
              Text(value, style: AppTypography.numeric(text.titleLarge!)),
              if (modifier case final modifier?) ...[
                SizedBox(width: AppSpacing.sm),
                Text(
                  modifier,
                  style: AppTypography.numeric(text.titleLarge!)
                      .copyWith(color: scheme.primary),
                ),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          for (final line in lines)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xs),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(
                      line.amount,
                      style: numeric,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(child: Text(line.label, style: text.bodyMedium)),
                  if (line.badge case final badge?) SourceBadge(badge),
                ],
              ),
            ),
          if (rule case final rule?) ...[
            Divider(color: scheme.outlineVariant),
            Text(rule, style: text.bodySmall),
          ],
          if (uses.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            if (usesLabel case final label?)
              Text(label, style: text.labelLarge),
            SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final use in uses)
                  Chip(label: Text('${use.label} ${use.value}')),
              ],
            ),
          ],
          SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(closeLabel),
            ),
          ),
        ],
      ),
    );
  }
}

/// Ouvre [child] en feuille modale au téléphone, en boîte de dialogue ailleurs.
Future<void> showAdaptiveSheet(BuildContext context, Widget child) {
  final phone =
      formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone;
  if (phone) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => SafeArea(child: SingleChildScrollView(child: child)),
    );
  }
  return showDialog<void>(
    context: context,
    builder: (_) => Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 440),
        child: SingleChildScrollView(child: child),
      ),
    ),
  );
}
