// Concentration en combat (US-23, EF-CON-04, 05, [1c], COMPOSANTS §2.5) :
// puce, alerte de test, début et fin avec retrait des effets liés.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'combat_view.dart';
import 'condition_sheets.dart';

/// Puce « Concentration · Bénédiction ».
class ConcentrationChip extends StatelessWidget {
  const ConcentrationChip(this.spell, {super.key});

  final String spell;

  @override
  Widget build(BuildContext context) {
    final colors = GameColors.of(context);
    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: colors.concentrationContainer,
      avatar: GameIcon(
        GameIcons.concentration,
        color: colors.onConcentrationContainer,
      ),
      label: Text(
        AppLocalizations.of(context).concentrationChip(spell),
        style: TextStyle(color: colors.onConcentrationContainer),
      ),
    );
  }
}

/// « Bénédiction prend fin. Effets retirés : Béni (Aldric, Thalia). »
String concentrationConsequence(
  AppLocalizations l10n,
  ActiveContent content,
  CombatState combat,
  Combatant caster,
) {
  final targets = <String, List<String>>{};
  for (final (c, i) in combat.linkedTo(caster.id)) {
    (targets[conditionName(l10n, content, i)] ??= []).add(c.label);
  }
  return [
    l10n.concentrationEndsLine(caster.concentration ?? ''),
    if (targets.isNotEmpty)
      l10n.concentrationRemovesLine(
        [
          for (final MapEntry(:key, :value) in targets.entries)
            '$key (${value.join(', ')})',
        ].join(', '),
      ),
  ].join(' ');
}

/// Demande confirmation de la fin de concentration de [caster] (EF-CON-05).
Future<bool> confirmEndConcentration(
  BuildContext context,
  ActiveContent content,
  CombatState combat,
  Combatant caster,
) async {
  final l10n = AppLocalizations.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: Text(l10n.concentrationEndTitle(caster.concentration ?? '')),
      content: Text(concentrationConsequence(l10n, content, combat, caster)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialog, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialog, true),
          child: Text(l10n.endConcentration),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

/// Alertes de concentration [1c] : une par test en attente.
class ConcentrationAlerts extends ConsumerWidget {
  const ConcentrationAlerts({
    required this.encounter,
    required this.combat,
    super.key,
  });

  final Encounter encounter;
  final CombatState combat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final colors = GameColors.of(context);
    final content = ref.watch(contentProvider).value;
    if (content == null) return const SizedBox.shrink();
    final style = text.bodyMedium!.copyWith(
      color: colors.onConcentrationContainer,
    );
    return Column(
      children: [
        for (final c in combat.combatants)
          if (c.concentrationChecks.firstOrNull case final check?)
            Card(
              color: colors.concentrationContainer,
              margin: EdgeInsets.only(top: AppSpacing.sm),
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        GameIcon(
                          GameIcons.concentration,
                          color: colors.onConcentrationContainer,
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            l10n.concentrationCheckTitle(c.label),
                            style: style.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      l10n.concentrationCheckDc(check.dc),
                      style: text.titleMedium!.copyWith(
                        color: colors.onConcentrationContainer,
                      ),
                    ),
                    Text(switch (check.damage ~/ 2) {
                      final half when half < 10 => l10n.concentrationWhyTen(
                        check.damage,
                        half,
                      ),
                      > 30 => l10n.concentrationWhyCap(check.damage),
                      _ => l10n.concentrationWhyHalf(check.damage, check.dc),
                    }, style: style),
                    if (c.saves['con'] case final bonus?)
                      Text(
                        l10n.concentrationBonus(
                          c.label,
                          bonus < 0 ? '$bonus' : '+$bonus',
                        ),
                        style: style,
                      ),
                    Text(
                      l10n.concentrationOnFail(
                        concentrationConsequence(l10n, content, combat, c),
                      ),
                      style: style,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        OutlinedButton(
                          onPressed: () async {
                            if (await confirmEndConcentration(
                              context,
                              content,
                              combat,
                              c,
                            )) {
                              await _check(ref, c, success: false);
                            }
                          },
                          child: Text(l10n.reminderFailed),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: colors.concentration,
                            foregroundColor: colors.onConcentration,
                          ),
                          onPressed: () => _check(ref, c, success: true),
                          child: Text(l10n.reminderSucceeded),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
      ],
    );
  }

  Future<void> _check(WidgetRef ref, Combatant c, {required bool success}) =>
      appendCombat(ref, encounter.id, [
        (
          CombatEventType.concentrationCheck,
          {'combatant': c.id, 'success': success},
        ),
      ]);
}

/// Section « Concentration » du détail d'un combattant.
class ConcentrationSection extends ConsumerWidget {
  const ConcentrationSection({
    required this.encounter,
    required this.combat,
    required this.combatant,
    super.key,
  });

  final Encounter encounter;
  final CombatState combat;
  final Combatant combatant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final content = ref.watch(contentProvider).value;
    final c = combatant;
    if (content == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.concentration, style: Theme.of(context).textTheme.titleSmall),
        if (c.concentration case final spell?)
          Wrap(
            spacing: AppSpacing.sm,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              ConcentrationChip(spell),
              OutlinedButton(
                onPressed: () async {
                  if (await confirmEndConcentration(
                    context,
                    content,
                    combat,
                    c,
                  )) {
                    await appendCombat(ref, encounter.id, [
                      (CombatEventType.concentrationEnded, {'combatant': c.id}),
                    ]);
                  }
                },
                child: Text(l10n.endConcentration),
              ),
            ],
          )
        else
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _start(context, ref, content),
              icon: const GameIcon(GameIcons.concentration),
              label: Text(l10n.concentrationStart),
            ),
          ),
      ],
    );
  }

  /// Nom du sort saisi, avec les sorts à concentration en suggestions.
  Future<void> _start(
    BuildContext context,
    WidgetRef ref,
    ActiveContent content,
  ) async {
    final l10n = AppLocalizations.of(context);
    final names = [
      for (final e in sortedEntities(content, 'spell'))
        if (e.data case SpellData(concentration: true)) e.name,
    ];
    var spell = '';
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l10n.concentrationStart),
        content: Autocomplete<String>(
          optionsBuilder: (value) => value.text.isEmpty
              ? const []
              : names.where(
                  (n) => n.toLowerCase().contains(value.text.toLowerCase()),
                ),
          onSelected: (v) => spell = v,
          fieldViewBuilder: (_, controller, focus, onSubmitted) => TextField(
            controller: controller,
            focusNode: focus,
            autofocus: true,
            decoration: InputDecoration(labelText: l10n.concentrationSpell),
            onChanged: (v) => spell = v,
            onSubmitted: (_) => onSubmitted(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, true),
            child: Text(l10n.concentrationStart),
          ),
        ],
      ),
    );
    if (confirmed != true || spell.trim().isEmpty) return;
    await appendCombat(ref, encounter.id, [
      (
        CombatEventType.concentrationStarted,
        {'combatant': combatant.id, 'spell': spell.trim()},
      ),
    ]);
  }
}
