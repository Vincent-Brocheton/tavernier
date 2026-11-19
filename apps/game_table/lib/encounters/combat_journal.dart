// Journal de la rencontre (US-25, EF-LOG-01, 02, Combat-Desktop, [TB1]) :
// une phrase par événement, « R3 · 21:42 », filtres, réservé au MJ.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'encounters_providers.dart';

/// Journal daté de [encounterId].
final combatLogProvider = StreamProvider.autoDispose
    .family<List<({DateTime at, CombatEvent event})>, String>(
      (ref, encounterId) =>
          ref.watch(combatStoreProvider).watchLog(encounterId),
    );

/// Filtres du journal.
enum JournalFilter { all, hp, conditions, actions }

/// Catégorie d'un événement, pour les filtres.
JournalFilter categoryOf(CombatEventType type) => switch (type) {
  CombatEventType.damage ||
  CombatEventType.heal ||
  CombatEventType.tempHp ||
  CombatEventType.deathSave => JournalFilter.hp,
  CombatEventType.conditionAdded ||
  CombatEventType.conditionRemoved ||
  CombatEventType.conditionSave ||
  CombatEventType.concentrationStarted ||
  CombatEventType.concentrationCheck ||
  CombatEventType.concentrationEnded => JournalFilter.conditions,
  CombatEventType.study ||
  CombatEventType.influence ||
  CombatEventType.observation => JournalFilter.actions,
  _ => JournalFilter.all,
};

/// Ouvre le journal de [encounter].
Future<void> showCombatJournal(BuildContext context, Encounter encounter) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (sheet) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(sheet).height * 0.9,
          child: CombatJournal(encounterId: encounter.id),
        ),
      ),
    );

/// Journal du MJ : les entrées les plus récentes d'abord.
class CombatJournal extends ConsumerStatefulWidget {
  const CombatJournal({super.key, required this.encounterId});

  final String encounterId;

  @override
  ConsumerState<CombatJournal> createState() => _CombatJournalState();
}

class _CombatJournalState extends ConsumerState<CombatJournal> {
  var _filter = JournalFilter.all;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final log = ref.watch(combatLogProvider(widget.encounterId)).value;
    final content = ref.watch(contentProvider).value;
    if (log == null || content == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final events = [for (final (at: _, :event) in log) event];
    final at = {for (final (:at, :event) in log) event.id: at};
    final phrases = JournalPhrases(l10n, content, events);
    final entries = [
      for (final entry in combatJournal(events).reversed)
        if (_filter == JournalFilter.all ||
            categoryOf(entry.event.type) == _filter)
          entry,
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.journalTitle, style: text.headlineSmall),
                    Text(
                      l10n.journalUndoable(undoableCount(events)),
                      style: text.bodySmall,
                    ),
                  ],
                ),
              ),
              CloseButton(onPressed: () => Navigator.pop(context)),
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: Wrap(
            spacing: AppSpacing.xs,
            children: [
              for (final (filter, label) in [
                (JournalFilter.all, l10n.journalAll),
                (JournalFilter.hp, l10n.journalHp),
                (JournalFilter.conditions, l10n.journalConditions),
                (JournalFilter.actions, l10n.journalActions),
              ])
                ChoiceChip(
                  label: Text(label),
                  selected: _filter == filter,
                  onSelected: (_) => setState(() => _filter = filter),
                ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              for (final entry in entries)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(
                    phrases.of(entry),
                    style: entry.undone
                        ? const TextStyle(
                            decoration: TextDecoration.lineThrough,
                          )
                        : null,
                  ),
                  subtitle: Text(
                    [
                      l10n.journalWhen(
                        entry.round,
                        _clock(at[entry.event.id]!.toLocal()),
                      ),
                      if (entry.undone) l10n.journalUndone,
                    ].join(' · '),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

String _clock(DateTime t) =>
    '${t.hour.toString().padLeft(2, '0')}:'
    '${t.minute.toString().padLeft(2, '0')}';

/// Phrases du journal, avec les noms des combattants, des états et des
/// unités, gardés même après un retrait.
final class JournalPhrases {
  JournalPhrases(this.l10n, this.content, List<CombatEvent> events)
    : _labels = combatantLabels(events),
      _groups = {
        for (final e in events)
          if (e.type == CombatEventType.combatantAdded)
            if (e.payload['group_id'] case final String group)
              group: e.payload['label']! as String,
      },
      _instances = {
        for (final e in events)
          if (e.type == CombatEventType.conditionAdded)
            e.payload['instance']! as String:
                (e.payload['label'] as String?) ??
                content.entity('${e.payload['condition']}')?.name ??
                '',
      };

  final AppLocalizations l10n;
  final ActiveContent content;
  final Map<String, String> _labels;
  final Map<String, String> _groups;
  final Map<String, String> _instances;

  String _name(Object? id) => _labels['$id'] ?? _groups['$id'] ?? '$id';

  String _counter(String counter) => switch (counter) {
    reactionCounter => l10n.combatReaction,
    legendaryActionsCounter => l10n.combatLegendaryActions,
    'legendary_resistance' => l10n.combatLegendaryResistance,
    _ when counter.startsWith('recharge:') => l10n.combatRechargeCounter(
      counter.substring(9),
    ),
    _ => counter,
  };

  /// « Mira Solen (22 → 10) », « Brannoc (5 → 0, Inconscient) ».
  String _targets(JournalEntry entry) => [
    for (final id in entry.event.payload['targets']! as List)
      switch (entry.hp['$id']) {
        final h? when h.before != null && h.after != null => switch (h.dead
            ? l10n.combatDead
            : h.unconscious
            ? l10n.combatUnconscious
            : h.outOfCombat
            ? l10n.combatOutOfCombat
            : null) {
          final fallen? => l10n.journalTargetFallen(
            _name(id),
            h.before!,
            h.after!,
            fallen,
          ),
          null => l10n.journalTarget(_name(id), h.before!, h.after!),
        },
        _ => _name(id),
      },
  ].join(', ');

  String _result(Object? success) =>
      success == true ? l10n.reminderSucceeded : l10n.reminderFailed;

  /// Phrase de [entry].
  String of(JournalEntry entry) {
    final p = entry.event.payload;
    return switch (entry.event.type) {
      CombatEventType.combatantAdded => l10n.journalJoined(_name(p['id'])),
      CombatEventType.combatantRemoved => l10n.journalRemoved(
        _name(p['combatant']),
      ),
      CombatEventType.initiativeRolled => l10n.journalInitiative(
        _name(p['unit']),
      ),
      CombatEventType.orderSet => l10n.journalOrder,
      CombatEventType.combatStarted => l10n.journalStarted,
      CombatEventType.turnAdvanced => l10n.journalTurn,
      CombatEventType.counterUsed => l10n.journalCounterUsed(
        _name(p['combatant']),
        _counter('${p['counter']}'),
      ),
      CombatEventType.counterRestored => l10n.journalCounterRestored(
        _name(p['combatant']),
        _counter('${p['counter']}'),
      ),
      CombatEventType.damage => l10n.journalDamage(
        p['amount']! as int,
        namesOf(content, ['${p['type']}']).toLowerCase(),
        _targets(entry),
      ),
      CombatEventType.heal => l10n.journalHeal(
        p['amount']! as int,
        _targets(entry),
      ),
      CombatEventType.tempHp => l10n.journalTempHp(
        p['amount']! as int,
        [for (final id in p['targets']! as List) _name(id)].join(', '),
      ),
      CombatEventType.deathSave => l10n.journalDeathSave(
        _name(p['combatant']),
        switch (p['outcome']) {
          'success' => l10n.deathSuccess,
          'failure' => l10n.deathFailure,
          'nat1' => l10n.deathNat1,
          'nat20' => l10n.deathNat20,
          _ => l10n.deathStabilized,
        },
      ),
      CombatEventType.conditionAdded => l10n.journalConditionAdded(
        _name(p['combatant']),
        _instances['${p['instance']}'] ?? '',
      ),
      CombatEventType.conditionRemoved => l10n.journalConditionRemoved(
        _name(p['combatant']),
        _instances['${p['instance']}'] ?? '',
      ),
      CombatEventType.conditionSave => l10n.journalConditionSave(
        _name(p['combatant']),
        _instances['${p['instance']}'] ?? '',
        _result(p['success']),
      ),
      CombatEventType.concentrationStarted => l10n.journalConcentration(
        _name(p['combatant']),
        '${p['spell']}',
      ),
      CombatEventType.concentrationCheck => l10n.journalConcentrationCheck(
        _name(p['combatant']),
        _result(p['success']),
      ),
      CombatEventType.concentrationEnded => l10n.journalConcentrationEnded(
        _name(p['combatant']),
      ),
      CombatEventType.initiativeSwapped => l10n.journalSwapped(
        _name(p['combatant']),
        _name(p['with']),
      ),
      CombatEventType.study => l10n.journalStudy(
        _name(p['actor']),
        namesOf(content, ['${p['skill']}']),
        (p['total'] as int?) ?? 0,
        _name(p['target']),
        (p['revealed'] as List?)?.length ?? 0,
      ),
      CombatEventType.influence => l10n.journalInfluence(
        _name(p['actor']),
        _name(p['target']),
        switch (p['reception']) {
          'willing' => l10n.journalInfluenceWilling,
          'unwilling' => l10n.journalInfluenceUnwilling,
          _ => _result(p['success']),
        },
      ),
      CombatEventType.observation => l10n.journalObservation(
        _name(p['actor']),
        namesOf(content, ['${p['skill']}']),
        (p['total'] as int?) ?? 0,
        '${p['discovery'] ?? ''}',
      ),
      CombatEventType.undo => l10n.journalUndo,
    };
  }
}
