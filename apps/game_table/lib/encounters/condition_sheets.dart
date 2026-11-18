// États en combat (US-22, EF-CON-01, 02) : feuille « Ajouter un état »
// [C5], puce d'état (`ConditionChip`, COMPOSANTS §2.3) et fiche d'état [K4].
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
import '../sheet/sheet_breakdowns.dart';
import 'combat_view.dart';
import 'encounters_providers.dart';

/// Icône d'un état ; `null` : « Autre effet ». Les icônes dessinées de §2.3
/// restent à produire : le libellé les accompagne toujours.
IconData conditionIcon(String? id) => switch (id?.split(':').last) {
  'prone' => Icons.airline_seat_flat,
  'grappled' => Icons.back_hand_outlined,
  'deafened' => Icons.hearing_disabled,
  'blinded' => Icons.visibility_off_outlined,
  'charmed' => Icons.favorite_border,
  'frightened' => Icons.sentiment_very_dissatisfied,
  'poisoned' => Icons.science_outlined,
  'restrained' => Icons.link,
  'exhaustion' => Icons.battery_1_bar,
  'stunned' => Icons.flare,
  'unconscious' => Icons.bedtime_outlined,
  'invisible' => Icons.blur_on,
  'incapacitated' => Icons.block,
  'paralyzed' => Icons.accessibility_new,
  'petrified' => Icons.view_in_ar_outlined,
  _ => Icons.auto_awesome,
};

/// Nom d'un état posé : « Épuisement 2 », le nom de l'état, ou le libellé.
String conditionName(
  AppLocalizations l10n,
  ActiveContent content,
  ConditionInstance i,
) => switch (i.condition) {
  exhaustionCondition => l10n.conditionExhaustion(i.levels),
  final id? => namesOf(content, [id]),
  null => i.label ?? '',
};

String _of(CombatState combat, String? id) =>
    combat.combatant(id ?? '')?.label ?? '?';

/// Durée courte, pour la puce : « 2 rd », « fin tour Mira », « JS FOR DD
/// 13 » ; `null` si indéfinie.
String? shortDuration(
  AppLocalizations l10n,
  CombatState combat,
  ConditionInstance i,
) {
  final d = i.duration;
  if (d.kind == DurationKind.turnEnd &&
      combat.active != null &&
      combat.combatant(d.combatant ?? '')?.unit == combat.active) {
    return l10n.chipExpires;
  }
  return switch (d.kind) {
    DurationKind.rounds => l10n.chipRounds(
      max(1, i.round + (d.rounds ?? 0) - combat.round),
    ),
    DurationKind.turnStart => l10n.chipTurnStart(_of(combat, d.combatant)),
    DurationKind.turnEnd => l10n.chipTurnEnd(_of(combat, d.combatant)),
    DurationKind.save => l10n.chipSave(
      abbreviation(l10n, d.ability ?? 'str'),
      d.dc ?? 0,
    ),
    DurationKind.indefinite => null,
  };
}

/// Durée en clair, pour la fiche [K4].
String longDuration(
  AppLocalizations l10n,
  ActiveContent content,
  CombatState combat,
  ConditionInstance i,
) {
  final d = i.duration;
  return switch (d.kind) {
    DurationKind.rounds => l10n.longRounds(
      max(1, i.round + (d.rounds ?? 0) - combat.round),
    ),
    DurationKind.turnStart => l10n.longTurnStart(_of(combat, d.combatant)),
    DurationKind.turnEnd => l10n.longTurnEnd(_of(combat, d.combatant)),
    DurationKind.save => l10n.longSave(
      namesOf(content, [abilityIdByCode[d.ability ?? 'str']!]),
      d.dc ?? 0,
    ),
    DurationKind.indefinite => l10n.longIndefinite,
  };
}

/// Puce d'état d'une carte : icône, nom, durée atténuée ; le toucher ouvre
/// la fiche d'état.
class ConditionChip extends ConsumerWidget {
  const ConditionChip({
    super.key,
    required this.encounter,
    required this.combat,
    required this.combatant,
    required this.instance,
  });

  final Encounter encounter;
  final CombatState combat;
  final Combatant combatant;
  final ConditionInstance instance;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final content = ref.watch(contentProvider).value;
    if (content == null) return const SizedBox.shrink();
    final duration = shortDuration(l10n, combat, instance);
    return ActionChip(
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      avatar: Icon(conditionIcon(instance.condition), size: 16),
      label: Text.rich(
        TextSpan(
          text: conditionName(l10n, content, instance),
          children: [
            if (duration != null)
              TextSpan(
                text: ' · $duration',
                style: text.bodySmall!.copyWith(color: scheme.onSurfaceVariant),
              ),
          ],
        ),
      ),
      onPressed: () =>
          showConditionSheet(context, encounter, combatant.id, instance.id),
    );
  }
}

/// Puces des états de [combatant], dans l'ordre de pose.
class ConditionChips extends StatelessWidget {
  const ConditionChips({
    super.key,
    required this.encounter,
    required this.combat,
    required this.combatant,
  });

  final Encounter encounter;
  final CombatState combat;
  final Combatant combatant;

  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(top: AppSpacing.xxs),
    child: Wrap(
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxs,
      children: [
        for (final i in combatant.conditions)
          ConditionChip(
            encounter: encounter,
            combat: combat,
            combatant: combatant,
            instance: i,
          ),
      ],
    ),
  );
}

/// Fiche d'état [K4] : règle, durée dans ce combat, retrait.
Future<void> showConditionSheet(
  BuildContext context,
  Encounter encounter,
  String combatantId,
  String instanceId,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => SafeArea(
    child: _ConditionSheet(
      encounter: encounter,
      combatantId: combatantId,
      instanceId: instanceId,
    ),
  ),
);

class _ConditionSheet extends ConsumerWidget {
  const _ConditionSheet({
    required this.encounter,
    required this.combatantId,
    required this.instanceId,
  });

  final Encounter encounter;
  final String combatantId;
  final String instanceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final combat = ref.watch(combatStateProvider(encounter.id)).value;
    final content = ref.watch(contentProvider).value;
    final c = combat?.combatant(combatantId);
    final i = c?.conditions.where((i) => i.id == instanceId).firstOrNull;
    if (combat == null || content == null || c == null || i == null) {
      return const SizedBox.shrink();
    }
    final entity = i.condition == null ? null : content.entity(i.condition!);
    Future<void> remove({int? levels}) async {
      await appendCombat(ref, encounter.id, [
        (
          CombatEventType.conditionRemoved,
          {'combatant': c.id, 'instance': i.id, 'levels': ?levels},
        ),
      ]);
      if (context.mounted && levels == null) Navigator.pop(context);
    }

    return ListView(
      shrinkWrap: true,
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Row(
          children: [
            Icon(conditionIcon(i.condition)),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Text(
                conditionName(l10n, content, i),
                style: text.headlineSmall,
              ),
            ),
          ],
        ),
        if (entity != null)
          Text(
            l10n.conditionSource(
              entity.id.namespace == 'srd'
                  ? l10n.sourceSrd
                  : entity.id.namespace,
            ),
            style: text.labelMedium,
          ),
        if (entity?.textFr case final rule?) ...[
          SizedBox(height: AppSpacing.sm),
          Text(rule, style: text.bodyMedium),
        ],
        SizedBox(height: AppSpacing.md),
        Text(l10n.conditionInCombat, style: text.titleSmall),
        Text(
          [
            l10n.conditionLine(c.label, longDuration(l10n, content, combat, i)),
            if (combat.combatant(i.concentration ?? '') case final caster?)
              l10n.conditionLinked(caster.label, caster.concentration ?? ''),
            if (i.recurring case final r?)
              l10n.conditionRecurringLine(
                r.dice,
                namesOf(content, [r.type]).toLowerCase(),
                r.at == TurnPhase.start ? 0 : 1,
              ),
          ].join('\n'),
          style: text.bodyMedium,
        ),
        SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.xs,
          children: [
            if (i.condition == exhaustionCondition && i.levels > 1)
              OutlinedButton(
                onPressed: () => remove(levels: 1),
                child: Text(l10n.conditionRemoveLevel),
              ),
            FilledButton.tonal(
              onPressed: remove,
              child: Text(l10n.conditionRemove),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.close),
            ),
          ],
        ),
      ],
    );
  }
}

/// Ouvre la feuille « Ajouter un état » [C5] pour [targets].
Future<void> showAddCondition(
  BuildContext context,
  Encounter encounter,
  Set<String> targets,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  showDragHandle: true,
  builder: (sheet) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(sheet).height * 0.9,
      child: _AddCondition(encounter: encounter, targets: targets),
    ),
  ),
);

class _AddCondition extends ConsumerStatefulWidget {
  const _AddCondition({required this.encounter, required this.targets});

  final Encounter encounter;
  final Set<String> targets;

  @override
  ConsumerState<_AddCondition> createState() => _AddConditionState();
}

class _AddConditionState extends ConsumerState<_AddCondition> {
  /// État choisi ; `null` : « Autre effet ».
  String? _condition = 'srd:condition:prone';
  var _kind = DurationKind.rounds;
  var _rounds = 1;
  String? _who;
  final _dc = TextEditingController(text: '10');
  var _ability = 'str';
  var _levels = 1;
  final _label = TextEditingController();
  var _recurring = false;
  final _dice = TextEditingController(text: '1d4');
  var _damageType = 'srd:damage-type:fire';
  var _at = TurnPhase.start;

  /// Lanceur dont la concentration maintient l'état ; `null` : aucun.
  String? _caster;

  @override
  void dispose() {
    _dc.dispose();
    _label.dispose();
    _dice.dispose();
    super.dispose();
  }

  bool get _exhaustion => _condition == exhaustionCondition;

  /// Formule des dégâts récurrents lisible (« 1d4 », « 2d6 + 3 »).
  bool get _diceValid {
    try {
      DiceFormula.parse(_dice.text);
      return true;
    } on FormatException {
      return false;
    }
  }

  Future<void> _add(CombatState combat) async {
    final duration = switch (_kind) {
      _ when _exhaustion => {'kind': 'indefinite'},
      DurationKind.rounds => {'kind': 'rounds', 'rounds': _rounds},
      DurationKind.turnStart => {'kind': 'turn_start', 'combatant': _who},
      DurationKind.turnEnd => {'kind': 'turn_end', 'combatant': _who},
      DurationKind.save => {
        'kind': 'save',
        'dc': int.tryParse(_dc.text) ?? 10,
        'ability': _ability,
      },
      DurationKind.indefinite => {'kind': 'indefinite'},
    };
    await appendCombat(ref, widget.encounter.id, [
      for (final id in widget.targets)
        if (combat.combatant(id) != null)
          (
            CombatEventType.conditionAdded,
            {
              'combatant': id,
              'instance': uuidV7(),
              'condition': ?_condition,
              if (_condition == null) 'label': _label.text.trim(),
              'duration': duration,
              if (_exhaustion) 'levels': _levels,
              'concentration': ?_caster,
              if (_condition == null && _recurring)
                'recurring': {
                  'dice': _dice.text.trim(),
                  'type': _damageType,
                  'at': _at.name,
                },
            },
          ),
    ]);
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final combat = ref.watch(combatStateProvider(widget.encounter.id)).value;
    final content = ref.watch(contentProvider).value;
    if (combat == null || content == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final targets = [for (final id in widget.targets) ?combat.combatant(id)];
    // Lanceur qui ne se concentre plus : plus de lien possible.
    if (combat.combatant(_caster ?? '')?.concentration == null) _caster = null;
    final conditions = sortedEntities(content, 'condition');
    bool immune(String id) =>
        targets.isNotEmpty &&
        targets.every((c) => c.conditionImmunities.contains(id));
    _who ??=
        switch (combat.active) {
          final unit? => combat.members(unit).firstOrNull?.id,
          null => null,
        } ??
        targets.firstOrNull?.id;
    final selected = _condition == null ? null : content.entity(_condition!);
    final name = selected?.name ?? l10n.conditionOther;
    final canAdd =
        targets.isNotEmpty &&
        (_condition == null
            ? _label.text.trim().isNotEmpty && (!_recurring || _diceValid)
            : !immune(_condition!)) &&
        (!{DurationKind.turnStart, DurationKind.turnEnd}.contains(_kind) ||
            _exhaustion ||
            _who != null);

    Widget tile(String? id, String label, {bool disabled = false}) {
      final child = Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(conditionIcon(id), size: 20),
          FittedBox(fit: BoxFit.scaleDown, child: Text(label, maxLines: 1)),
        ],
      );
      final onPressed = disabled ? null : () => setState(() => _condition = id);
      final style = ButtonStyle(
        padding: WidgetStatePropertyAll(
          EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
        ),
      );
      final button = _condition == id && !disabled
          ? FilledButton.tonal(style: style, onPressed: onPressed, child: child)
          : OutlinedButton(style: style, onPressed: onPressed, child: child);
      return disabled
          ? Tooltip(message: l10n.conditionImmune, child: button)
          : button;
    }

    final whoField = DropdownButtonFormField<String>(
      initialValue: _who,
      isExpanded: true,
      items: [
        for (final c in combat.combatants)
          DropdownMenuItem(value: c.id, child: Text(c.label)),
      ],
      onChanged: (v) => setState(() => _who = v),
    );

    return ListView(
      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
      children: [
        Row(
          children: [
            Expanded(
              child: Text(l10n.conditionAddTitle, style: text.headlineSmall),
            ),
            CloseButton(onPressed: () => Navigator.pop(context)),
          ],
        ),
        Text(
          l10n.conditionTargets(
            targets.length,
            [for (final c in targets) c.label].join(', '),
          ),
          style: text.bodyMedium,
        ),
        SizedBox(height: AppSpacing.sm),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: AppSpacing.xs,
          crossAxisSpacing: AppSpacing.xs,
          childAspectRatio: 1.4,
          children: [
            for (final e in conditions)
              tile('${e.id}', e.name, disabled: immune('${e.id}')),
            tile(null, l10n.conditionOther),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        if (selected?.textFr case final rule?)
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${selected!.name} : ',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                TextSpan(text: rule.split('\n').skip(1).join(' ')),
              ],
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: text.bodySmall,
          ),
        if (_condition == null) ...[
          TextField(
            controller: _label,
            decoration: InputDecoration(labelText: l10n.conditionOtherLabel),
            onChanged: (_) => setState(() {}),
          ),
        ],
        SizedBox(height: AppSpacing.sm),
        if (_exhaustion)
          Row(
            children: [
              Expanded(child: Text(l10n.conditionLevels)),
              IconButton(
                tooltip: l10n.conditionLevelsLess,
                onPressed: _levels > 1 ? () => setState(() => _levels--) : null,
                icon: const Icon(Icons.remove),
              ),
              Text('$_levels', style: text.titleMedium),
              IconButton(
                tooltip: l10n.conditionLevelsMore,
                onPressed: _levels < 6 ? () => setState(() => _levels++) : null,
                icon: const Icon(Icons.add),
              ),
            ],
          )
        else
          RadioGroup<DurationKind>(
            groupValue: _kind,
            onChanged: (k) => setState(() => _kind = k ?? _kind),
            child: Column(
              children: [
                RadioListTile<DurationKind>(
                  value: DurationKind.rounds,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.durationRounds),
                  secondary: _kind == DurationKind.rounds
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              tooltip: l10n.durationRoundsLess,
                              onPressed: _rounds > 1
                                  ? () => setState(() => _rounds--)
                                  : null,
                              icon: const Icon(Icons.remove),
                            ),
                            Text('$_rounds'),
                            IconButton(
                              tooltip: l10n.durationRoundsMore,
                              onPressed: () => setState(() => _rounds++),
                              icon: const Icon(Icons.add),
                            ),
                          ],
                        )
                      : null,
                ),
                RadioListTile<DurationKind>(
                  value: DurationKind.turnStart,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.durationTurnStart),
                ),
                if (_kind == DurationKind.turnStart) whoField,
                RadioListTile<DurationKind>(
                  value: DurationKind.turnEnd,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.durationTurnEnd),
                ),
                if (_kind == DurationKind.turnEnd) whoField,
                RadioListTile<DurationKind>(
                  value: DurationKind.save,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.durationSave),
                ),
                if (_kind == DurationKind.save) ...[
                  Row(
                    children: [
                      SizedBox(
                        width: 96,
                        child: TextField(
                          controller: _dc,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: l10n.conditionDc,
                          ),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          initialValue: _ability,
                          isExpanded: true,
                          decoration: InputDecoration(
                            labelText: l10n.conditionSaveAbility,
                          ),
                          items: [
                            for (final code in abilityCodes)
                              DropdownMenuItem(
                                value: code,
                                child: Text(
                                  namesOf(content, [abilityIdByCode[code]!]),
                                ),
                              ),
                          ],
                          onChanged: (v) =>
                              setState(() => _ability = v ?? _ability),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xxs),
                  Text(l10n.durationSaveHelp, style: text.bodySmall),
                ],
                RadioListTile<DurationKind>(
                  value: DurationKind.indefinite,
                  contentPadding: EdgeInsets.zero,
                  title: Text(l10n.durationIndefinite),
                ),
              ],
            ),
          ),
        if (_condition == null) ...[
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.conditionRecurring),
            value: _recurring,
            onChanged: (v) => setState(() => _recurring = v),
          ),
          if (_recurring) ...[
            Row(
              children: [
                SizedBox(
                  width: 96,
                  child: TextField(
                    controller: _dice,
                    decoration: InputDecoration(
                      labelText: l10n.conditionRecurringDice,
                      errorText: _diceValid ? null : l10n.conditionDiceInvalid,
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _damageType,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.conditionRecurringType,
                    ),
                    items: [
                      for (final t in sortedEntities(content, 'damage-type'))
                        DropdownMenuItem(value: '${t.id}', child: Text(t.name)),
                    ],
                    onChanged: (v) =>
                        setState(() => _damageType = v ?? _damageType),
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            SegmentedButton<TurnPhase>(
              segments: [
                ButtonSegment(
                  value: TurnPhase.start,
                  label: Text(l10n.conditionRecurringStart),
                ),
                ButtonSegment(
                  value: TurnPhase.end,
                  label: Text(l10n.conditionRecurringEnd),
                ),
              ],
              selected: {_at},
              onSelectionChanged: (s) => setState(() => _at = s.first),
            ),
          ],
        ],
        SizedBox(height: AppSpacing.sm),
        DropdownButtonFormField<String?>(
          initialValue: _caster,
          isExpanded: true,
          decoration: InputDecoration(labelText: l10n.concentrationLink),
          items: [
            DropdownMenuItem(child: Text(l10n.concentrationNone)),
            for (final c in combat.combatants)
              if (c.concentration case final spell?)
                DropdownMenuItem(
                  value: c.id,
                  child: Text(l10n.concentrationOption(c.label, spell)),
                ),
          ],
          onChanged: (v) => setState(() => _caster = v),
        ),
        SizedBox(height: AppSpacing.md),
        SizedBox(
          height: 56,
          child: FilledButton(
            onPressed: canAdd ? () => _add(combat) : null,
            child: Text(
              l10n.conditionAdd(
                _condition == null && _label.text.trim().isNotEmpty
                    ? _label.text.trim()
                    : name,
              ),
            ),
          ),
        ),
        SizedBox(height: AppSpacing.md),
      ],
    );
  }
}
