import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_draft.dart';
import 'creation_providers.dart';
import 'step_layout.dart';

String _signed(int value) => value < 0 ? '−${-value}' : '+$value';

/// Étape 5, Caractéristiques [3a], [3b] : acquisition par points, puis bonus
/// d'Historique (US-06).
class AbilitiesStep extends ConsumerWidget {
  const AbilitiesStep({super.key, required this.content});

  final ActiveContent content;

  String _name(String code) => namesOf(content, [abilityIdByCode[code]!]);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(creationProvider);
    final eligible = eligibleAbilities(draft, content);
    final invalid = [
      for (final code in abilityCodes)
        if (draft.bonuses.containsKey(code) && !eligible.contains(code)) code,
    ];
    final background = namesOf(content, [draft.backgroundId!]);
    final allowed = eligible.map(_name).join(', ');

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (invalid.isNotEmpty) ...[
            StatusBanner(
              title: l10n.bonusInvalidTitle,
              message: l10n.bonusInvalidMessage(
                invalid.map(_name).join(', '),
                background,
                allowed,
              ),
            ),
            SizedBox(height: AppSpacing.md),
          ],
          _Section(
            child: _PointBuy(draft: draft, name: _name),
          ),
          SizedBox(height: AppSpacing.md),
          _Section(
            child: _Bonuses(
              draft: draft,
              eligible: eligible,
              background: background,
              allowed: allowed,
              name: _name,
            ),
          ),
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
    padding: EdgeInsets.all(AppSpacing.md),
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      borderRadius: BorderRadius.circular(AppRadii.lg),
    ),
    child: child,
  );
}

class _PointBuy extends ConsumerWidget {
  const _PointBuy({required this.draft, required this.name});

  final CreationDraft draft;
  final String Function(String) name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final notifier = ref.read(creationProvider.notifier);
    final spent = pointBuyBudget - draft.remainingPoints;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(l10n.pointBuy, style: text.titleMedium)),
            Text(l10n.pointsOf(spent, pointBuyBudget), style: text.labelLarge),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        LinearProgressIndicator(
          value: spent / pointBuyBudget,
          minHeight: 8,
          semanticsLabel: l10n.pointsOf(spent, pointBuyBudget),
        ),
        SizedBox(height: AppSpacing.sm),
        CardGrid(
          minWidth: 250,
          children: [
            for (final code in abilityCodes)
              PointBuyTile(
                label: name(code),
                detail: l10n.costOf(pointBuyCosts[draft.scores[code]]!),
                value: draft.scores[code]!,
                raiseLabel: l10n.raiseAbility(name(code)),
                lowerLabel: l10n.lowerAbility(name(code)),
                onRaise: draft.canRaise(code)
                    ? () => notifier.update((d) => d.raiseScore(code))
                    : null,
                onLower: draft.canLower(code)
                    ? () => notifier.update((d) => d.lowerScore(code))
                    : null,
              ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Text(
          l10n.pointBuyCosts(
            [
              for (final MapEntry(:key, :value) in pointBuyCosts.entries)
                '$key → $value',
            ].join(' · '),
          ),
          style: text.bodySmall,
        ),
      ],
    );
  }
}

class _Bonuses extends ConsumerWidget {
  const _Bonuses({
    required this.draft,
    required this.eligible,
    required this.background,
    required this.allowed,
    required this.name,
  });

  final CreationDraft draft;
  final Set<String> eligible;
  final String background;
  final String allowed;
  final String Function(String) name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final notifier = ref.read(creationProvider.notifier);
    final twoOne = draft.distribution == '2-1';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.backgroundBonus(background), style: text.titleMedium),
        Text(l10n.bonusCap(allowed, abilityScoreCap), style: text.bodySmall),
        SizedBox(height: AppSpacing.sm),
        SegmentedButton<String>(
          segments: [
            ButtonSegment(value: '2-1', label: Text(l10n.distributionTwoOne)),
            ButtonSegment(value: '1-1-1', label: Text(l10n.distributionOnes)),
          ],
          selected: {draft.distribution},
          onSelectionChanged: (values) =>
              notifier.update((d) => d.setDistribution(values.single)),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          children: [
            Expanded(child: Text(l10n.labelAbility, style: text.labelSmall)),
            _Cell(32, Text(l10n.labelBase, style: text.labelSmall)),
            if (twoOne) _Cell(60, Text('+2', style: text.labelSmall)),
            _Cell(60, Text('+1', style: text.labelSmall)),
            _Cell(44, Text(l10n.labelTotal, style: text.labelSmall)),
          ],
        ),
        for (final code in abilityCodes)
          _BonusRow(
            code: code,
            draft: draft,
            eligible: eligible.contains(code),
            name: name(code),
            background: background,
          ),
      ],
    );
  }
}

class _Cell extends StatelessWidget {
  const _Cell(this.width, this.child);

  final double width;
  final Widget child;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: width,
    child: Center(child: child),
  );
}

class _BonusRow extends ConsumerWidget {
  const _BonusRow({
    required this.code,
    required this.draft,
    required this.eligible,
    required this.name,
    required this.background,
  });

  final String code;
  final CreationDraft draft;
  final bool eligible;
  final String name;
  final String background;

  BonusToggleState _state(int value) {
    final bonus = draft.bonuses[code];
    if (bonus == value) {
      return eligible ? BonusToggleState.selected : BonusToggleState.invalid;
    }
    return eligible && bonus == null
        ? BonusToggleState.available
        : BonusToggleState.blocked;
  }

  String _rule(AppLocalizations l10n) {
    if (!eligible) return l10n.notEligibleFor(background);
    return switch (draft.distribution == '2-1' ? draft.bonuses[code] : null) {
      2 => l10n.plusOneElsewhere,
      1 => l10n.plusTwoElsewhere,
      _ => l10n.eligible,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final notifier = ref.read(creationProvider.notifier);
    final base = draft.scores[code]!;
    final total = base + (draft.bonuses[code] ?? 0);

    Widget toggle(int value) {
      final state = _state(value);
      return _Cell(
        60,
        BonusToggle(
          label: eligible || state == BonusToggleState.invalid
              ? '+$value'
              : '—',
          semanticLabel: l10n.bonusOn(value, name),
          state: state,
          onTap: () => notifier.update((d) => d.setBonus(code, value)),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: text.titleSmall),
                Text(
                  _rule(l10n),
                  style: text.bodySmall!.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          _Cell(32, Text('$base', style: text.bodyMedium)),
          if (draft.distribution == '2-1') toggle(2),
          toggle(1),
          _Cell(
            44,
            Column(
              children: [
                Text('$total', style: text.titleMedium),
                Text(_signed(abilityModifier(total)), style: text.bodySmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
