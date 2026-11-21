// Rappels de tour (US-22, EF-CON-03, `TurnReminder` §2.6) : dialogue de fin
// de tour [C6] et bandeau de début de tour [1a].
import 'dart:math';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../src/pop_if_current.dart';
import 'combat_view.dart';
import 'condition_sheets.dart';

/// Nom d'une unité : son groupe sans numéro, ou son combattant.
String unitLabel(CombatState combat, String unit) {
  final members = combat.members(unit);
  if (members.isEmpty) return unit;
  return members.length > 1
      ? members.first.label.replaceFirst(RegExp(r' \d+$'), '')
      : members.first.label;
}

/// « Tour suivant » : le dialogue de fin de tour [C6] s'il y a des rappels,
/// sinon le passage direct.
Future<void> nextTurn(
  BuildContext context,
  WidgetRef ref,
  Encounter encounter,
  CombatState combat,
) async {
  final reminders = turnReminders(combat, TurnPhase.end);
  if (reminders.isEmpty) {
    return appendCombat(ref, encounter.id, [
      (CombatEventType.turnAdvanced, const {}),
    ]);
  }
  await showDialog<void>(
    context: context,
    builder: (_) => _EndOfTurnDialog(
      encounter: encounter,
      combat: combat,
      reminders: reminders,
    ),
  );
}

/// Dégâts récurrents de [r] : tirés, puis appliqués au porteur.
Future<int> _applyRecurring(
  WidgetRef ref,
  Encounter encounter,
  TurnReminder r,
) async {
  final recurring = r.instance.recurring!;
  final amount = max(
    0,
    rollDice(DiceFormula.parse(recurring.dice), Random()).total,
  );
  await appendCombat(ref, encounter.id, [
    (
      CombatEventType.damage,
      {
        'targets': [r.combatant.id],
        'amount': amount,
        'type': recurring.type,
      },
    ),
  ]);
  return amount;
}

class _EndOfTurnDialog extends ConsumerStatefulWidget {
  const _EndOfTurnDialog({
    required this.encounter,
    required this.combat,
    required this.reminders,
  });

  final Encounter encounter;
  final CombatState combat;
  final List<TurnReminder> reminders;

  @override
  ConsumerState<_EndOfTurnDialog> createState() => _EndOfTurnDialogState();
}

class _EndOfTurnDialogState extends ConsumerState<_EndOfTurnDialog> {
  /// Résultat affiché par rappel (sauvegarde saisie, dégâts appliqués).
  final _done = <int, String>{};

  /// Le tour passe une seule fois, même sur un double toucher.
  var _advancing = false;

  Future<void> _save(
    int index,
    TurnReminder r, {
    required bool success,
    DiceRoll? roll,
  }) async {
    final l10n = AppLocalizations.of(context);
    await appendCombat(ref, widget.encounter.id, [
      (
        CombatEventType.conditionSave,
        {
          'combatant': r.combatant.id,
          'instance': r.instance.id,
          'success': success,
          if (roll != null)
            'roll': {'dice': roll.dice, 'bonus': roll.formula.bonus},
        },
      ),
    ]);
    final outcome = success ? l10n.reminderSucceeded : l10n.reminderFailed;
    setState(
      () => _done[index] = roll == null
          ? outcome
          : l10n.reminderRolled(outcome, roll.total),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final colors = GameColors.of(context);
    final content = ref.watch(contentProvider).value;
    final combat = widget.combat;
    final active = combat.active!;
    final order = combat.order;
    final next = order.isEmpty
        ? active
        : order[(order.indexOf(active) + 1) % order.length];
    if (content == null) return const SizedBox.shrink();

    Widget reminder(int index, TurnReminder r) {
      final name = conditionName(l10n, content, r.instance);
      final done = _done[index];
      final d = r.instance.duration;
      final (
        String title,
        String line,
        List<Widget> actions,
      ) = switch (r.kind) {
        ReminderKind.save => (
          l10n.reminderSaveTitle(name),
          [
            l10n.reminderSaveLine(
              namesOf(content, [abilityIdByCode[d.ability ?? 'str']!]),
              d.dc ?? 0,
            ),
            if (r.saveBonus case final bonus?)
              l10n.reminderBonus(bonus < 0 ? '$bonus' : '+$bonus'),
          ].join(' · '),
          [
            if (r.saveBonus case final bonus?)
              OutlinedButton.icon(
                onPressed: () {
                  final roll = rollDice(
                    DiceFormula(1, 20, bonus: bonus),
                    Random(),
                  );
                  _save(
                    index,
                    r,
                    success: roll.total >= (d.dc ?? 0),
                    roll: roll,
                  );
                },
                icon: const Icon(Icons.casino_outlined),
                label: Text(l10n.reminderRoll),
              ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colors.damage),
              onPressed: () => _save(index, r, success: false),
              child: Text(l10n.reminderFailed),
            ),
            FilledButton(
              style: FilledButton.styleFrom(backgroundColor: colors.heal),
              onPressed: () => _save(index, r, success: true),
              child: Text(l10n.reminderSucceeded),
            ),
          ],
        ),
        ReminderKind.recurring => (
          l10n.reminderRecurringTitle(name),
          l10n.reminderRecurringLine(
            r.instance.recurring!.dice,
            namesOf(content, [r.instance.recurring!.type]).toLowerCase(),
          ),
          [
            FilledButton.tonal(
              onPressed: () async {
                final amount = await _applyRecurring(ref, widget.encounter, r);
                setState(() => _done[index] = l10n.reminderApplied(amount));
              },
              child: Text(l10n.reminderApply),
            ),
          ],
        ),
        _ => (
          l10n.reminderExpiresTitle(name),
          l10n.reminderDuration(
            longDuration(l10n, content, combat, r.instance),
          ),
          const <Widget>[],
        ),
      };
      return Card(
        margin: EdgeInsets.only(bottom: AppSpacing.sm),
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(conditionIcon(r.instance.condition), size: 20),
                  SizedBox(width: AppSpacing.xs),
                  Expanded(child: Text(title, style: text.titleSmall)),
                  if (r.kind == ReminderKind.expires)
                    Chip(
                      visualDensity: VisualDensity.compact,
                      label: Text(l10n.reminderRemoved),
                    ),
                ],
              ),
              if (r.combatant.unit != active ||
                  combat.members(active).length > 1)
                Text(r.combatant.label, style: text.bodySmall),
              Text(line, style: text.bodySmall),
              if (done != null)
                Padding(
                  padding: EdgeInsets.only(top: AppSpacing.xs),
                  child: Text(done, style: text.titleSmall),
                )
              else if (actions.isNotEmpty) ...[
                SizedBox(height: AppSpacing.xs),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: actions,
                ),
                if (r.kind == ReminderKind.save)
                  Padding(
                    padding: EdgeInsets.only(top: AppSpacing.xxs),
                    child: Text(
                      l10n.reminderSaveHelp(name),
                      style: text.bodySmall,
                    ),
                  ),
              ],
            ],
          ),
        ),
      );
    }

    return AlertDialog(
      icon: Icon(Icons.schedule, color: colors.alert),
      title: Text(l10n.turnEndTitle(unitLabel(combat, active))),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.combatRound(combat.round),
              textAlign: TextAlign.center,
              style: text.bodySmall,
            ),
            SizedBox(height: AppSpacing.sm),
            for (final (i, r) in widget.reminders.indexed) reminder(i, r),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.reminderLater),
        ),
        TextButton(
          onPressed: _advancing
              ? null
              : () async {
                  setState(() => _advancing = true);
                  await appendCombat(ref, widget.encounter.id, [
                    (CombatEventType.turnAdvanced, const {}),
                  ]);
                  if (context.mounted) popIfCurrent(context);
                },
          child: Text(l10n.reminderNextTurn(unitLabel(combat, next))),
        ),
      ],
    );
  }
}

/// Bandeau de début de tour [1a] : états expirés ou qui expirent à la fin
/// de ce tour, dégâts récurrents ; « OK » le masque jusqu'au tour suivant.
class TurnStartBanner extends ConsumerStatefulWidget {
  const TurnStartBanner({
    super.key,
    required this.encounter,
    required this.combat,
  });

  final Encounter encounter;
  final CombatState combat;

  @override
  ConsumerState<TurnStartBanner> createState() => _TurnStartBannerState();
}

class _TurnStartBannerState extends ConsumerState<TurnStartBanner> {
  String? _dismissed;
  final _applied = <String, int>{};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final colors = GameColors.of(context);
    final combat = widget.combat;
    final content = ref.watch(contentProvider).value;
    final active = combat.active;
    final turn = '${combat.round}:$active';
    if (active == null || content == null || _dismissed == turn) {
      return const SizedBox.shrink();
    }
    final reminders = turnReminders(combat, TurnPhase.start);
    if (reminders.isEmpty) return const SizedBox.shrink();
    final style = text.bodyMedium!.copyWith(color: colors.onAlertContainer);
    String named(TurnReminder r) {
      final name = conditionName(l10n, content, r.instance);
      final alone =
          r.combatant.unit == active && combat.members(active).length == 1;
      return alone ? name : l10n.reminderOf(name, r.combatant.label);
    }

    return Card(
      color: colors.alertContainer,
      margin: EdgeInsets.only(top: AppSpacing.sm),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber, color: colors.onAlertContainer),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.turnStartTitle(unitLabel(combat, active)),
                    style: style.copyWith(fontWeight: FontWeight.bold),
                  ),
                  for (final r in reminders)
                    switch (r.kind) {
                      ReminderKind.expired => Text(
                        l10n.bannerExpired(named(r)),
                        style: style,
                      ),
                      ReminderKind.recurring => Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: AppSpacing.xs,
                        children: [
                          Text(
                            l10n.bannerRecurring(
                              named(r),
                              r.instance.recurring!.dice,
                              namesOf(content, [
                                r.instance.recurring!.type,
                              ]).toLowerCase(),
                            ),
                            style: style,
                          ),
                          if (_applied['$turn:${r.instance.id}']
                              case final amount?)
                            Text(l10n.reminderApplied(amount), style: style)
                          else
                            TextButton(
                              onPressed: () async {
                                final amount = await _applyRecurring(
                                  ref,
                                  widget.encounter,
                                  r,
                                );
                                setState(
                                  () => _applied['$turn:${r.instance.id}'] =
                                      amount,
                                );
                              },
                              child: Text(l10n.reminderApply),
                            ),
                        ],
                      ),
                      _ => Text(l10n.bannerExpires(named(r)), style: style),
                    },
                ],
              ),
            ),
            TextButton(
              onPressed: () => setState(() => _dismissed = turn),
              child: Text(l10n.ok),
            ),
          ],
        ),
      ),
    );
  }
}
