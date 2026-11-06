import 'package:material_ui/material_ui.dart';

import 'layout.dart';

/// Une étape d'assistant : son nom et le choix fait.
final class WizardStep {
  const WizardStep({required this.label, required this.detail, this.alert});

  /// Textes venus des ARB de l'application.
  final String label;
  final String detail;

  /// Étape franchie à reprendre : remplace [detail] et sa coche.
  final String? alert;
}

/// Liste verticale des étapes d'un assistant (COMPOSANTS §2.18). Une étape
/// passée est cochée ; seules les étapes atteintes se touchent.
class WizardSteps extends StatelessWidget {
  const WizardSteps({
    super.key,
    required this.steps,
    required this.current,
    required this.reached,
    required this.onSelected,
  });

  final List<WizardStep> steps;
  final int current;

  /// Dernière étape atteinte.
  final int reached;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final (i, step) in steps.indexed)
            _StepTile(
              number: i + 1,
              step: step,
              isCurrent: i == current,
              isDone: i < reached && i != current && step.alert == null,
              onTap: i <= reached ? () => onSelected(i) : null,
            ),
        ],
      ),
    );
  }
}

class _StepTile extends StatelessWidget {
  const _StepTile({
    required this.number,
    required this.step,
    required this.isCurrent,
    required this.isDone,
    required this.onTap,
  });

  final int number;
  final WizardStep step;
  final bool isCurrent;
  final bool isDone;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final radius = BorderRadius.circular(AppRadii.md);
    final alert = step.alert != null;
    return Semantics(
      selected: isCurrent,
      button: true,
      enabled: onTap != null,
      child: Material(
        color: isCurrent ? scheme.secondaryContainer : Colors.transparent,
        borderRadius: radius,
        child: InkWell(
          borderRadius: radius,
          onTap: onTap,
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: AppSizes.touchTargetMin),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.sm,
                vertical: AppSpacing.xs,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: alert
                        ? scheme.errorContainer
                        : isDone || isCurrent
                        ? scheme.primary
                        : Colors.transparent,
                    foregroundColor: alert
                        ? scheme.onErrorContainer
                        : isDone || isCurrent
                        ? scheme.onPrimary
                        : scheme.onSurfaceVariant,
                    child: alert
                        ? const Icon(Icons.priority_high, size: 16)
                        : isDone
                        ? const Icon(Icons.check, size: 16)
                        : Text('$number', style: text.labelMedium),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(step.label, style: text.titleSmall),
                        Text(
                          step.alert ?? step.detail,
                          style: text.bodySmall!.copyWith(
                            color: alert
                                ? scheme.error
                                : scheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Progression d'un assistant sur téléphone : « Étape n sur 9 » et une barre
/// de 4 dp.
class WizardProgress extends StatelessWidget {
  const WizardProgress({super.key, required this.label, required this.value});

  final String label;

  /// Entre 0 et 1.
  final double value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        SizedBox(height: AppSpacing.xxs),
        LinearProgressIndicator(
          value: value,
          minHeight: 4,
          semanticsLabel: label,
        ),
      ],
    );
  }
}

/// Pied d'assistant : Précédent (contour) et Suivant (plein). Une raison de
/// blocage désactive Suivant et s'affiche au-dessus.
class WizardFooter extends StatelessWidget {
  const WizardFooter({
    super.key,
    required this.previousLabel,
    required this.nextLabel,
    required this.onNext,
    this.onPrevious,
    this.blockedReason,
  });

  final String previousLabel;
  final String nextLabel;
  final VoidCallback? onPrevious;
  final VoidCallback? onNext;
  final String? blockedReason;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final phone =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone;
    Widget slot(Widget button) => phone ? Expanded(child: button) : button;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        if (blockedReason case final reason?) ...[
          Semantics(
            liveRegion: true,
            child: Text(
              reason,
              style: text.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            if (onPrevious != null) ...[
              slot(
                OutlinedButton(
                  onPressed: onPrevious,
                  child: Text(previousLabel),
                ),
              ),
              SizedBox(width: AppSpacing.sm),
            ],
            slot(
              FilledButton(
                onPressed: blockedReason == null ? onNext : null,
                child: Text(nextLabel),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
