import 'package:material_ui/material_ui.dart';

import 'game_colors.dart';
import 'layout.dart';

/// État d'une règle de [PasswordRules].
enum PasswordRuleState { met, unmet, pending }

/// Une règle et son état.
typedef PasswordRule = ({String label, PasswordRuleState state});

/// Règles du mot de passe (COMPOSANTS §2.58) : jauge de robustesse en
/// 4 segments, exposée comme une mesure avec son libellé, puis les règles
/// cochées au fil de la saisie, chacune lue avec son état. [A3], [A5]
class PasswordRules extends StatelessWidget {
  const PasswordRules({
    super.key,
    required this.strength,
    required this.strengthLabel,
    required this.rules,
    required this.metLabel,
    required this.unmetLabel,
    required this.pendingLabel,
  });

  /// Clé de la jauge, pour les tests.
  static const meterKey = Key('password-strength-meter');

  /// Robustesse, de 0 à 4 segments.
  final int strength;
  final String strengthLabel;
  final List<PasswordRule> rules;
  final String metLabel;
  final String unmetLabel;
  final String pendingLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final game = GameColors.of(context);
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          key: meterKey,
          container: true,
          label: strengthLabel,
          value: '$strength/4',
          excludeSemantics: true,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  for (var i = 0; i < 4; i++) ...[
                    if (i > 0) SizedBox(width: AppSpacing.xxs),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: i < strength
                              ? game.heal
                              : scheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              SizedBox(height: AppSpacing.xxs),
              Text(strengthLabel, style: text.bodySmall),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        for (final rule in rules)
          // Un nœud par règle : chacune se lit avec son état.
          Semantics(
            container: true,
            label:
                '${rule.label}, ${switch (rule.state) {
                  PasswordRuleState.met => metLabel,
                  PasswordRuleState.unmet => unmetLabel,
                  PasswordRuleState.pending => pendingLabel,
                }}',
            excludeSemantics: true,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
              child: Row(
                children: [
                  Icon(
                    switch (rule.state) {
                      PasswordRuleState.met => Icons.check,
                      PasswordRuleState.unmet => Icons.close,
                      PasswordRuleState.pending => Icons.hourglass_empty,
                    },
                    size: 18,
                    color: _color(rule.state, scheme, game),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(
                    child: Text(
                      rule.label,
                      style: text.bodyMedium!.copyWith(
                        color: _color(rule.state, scheme, game),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  static Color _color(
    PasswordRuleState state,
    ColorScheme scheme,
    GameColors game,
  ) => switch (state) {
    PasswordRuleState.met => game.heal,
    PasswordRuleState.unmet => scheme.error,
    PasswordRuleState.pending => scheme.onSurfaceVariant,
  };
}
