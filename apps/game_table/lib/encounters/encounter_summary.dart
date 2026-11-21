// Fin de rencontre (US-25, EF-LOG-03, [C11]) : résumé, PX par PJ, clôture
// rangée dans la séance ; le résumé d'une rencontre terminée.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../src/pop_if_current.dart';
import 'combat_journal.dart';
import 'combat_view.dart';
import 'encounters_providers.dart';
import 'player_sync.dart';

/// Fiche d'un PJ, pour ses PX et sa classe ; `null` si illisible.
final _pcInputProvider = FutureProvider.autoDispose
    .family<CharacterInput?, String>((ref, id) async {
      try {
        return await ref.watch(characterStoreProvider).load(id);
      } on Object {
        return null;
      }
    });

/// Ouvre la fin de [encounter] ; vrai si elle a été close.
Future<bool> showEncounterSummary(
  BuildContext context,
  Encounter encounter, {
  bool readOnly = false,
}) async =>
    await Navigator.of(context).push<bool>(
      MaterialPageRoute(
        builder: (_) =>
            EncounterSummaryPage(encounter: encounter, readOnly: readOnly),
      ),
    ) ??
    false;

/// Fin de rencontre [C11].
class EncounterSummaryPage extends ConsumerStatefulWidget {
  const EncounterSummaryPage({
    super.key,
    required this.encounter,
    this.readOnly = false,
  });

  final Encounter encounter;

  /// Rencontre terminée : le résumé, sans clôture.
  final bool readOnly;

  @override
  ConsumerState<EncounterSummaryPage> createState() =>
      _EncounterSummaryPageState();
}

class _EncounterSummaryPageState extends ConsumerState<EncounterSummaryPage> {
  final _xp = <String, TextEditingController>{};

  @override
  void dispose() {
    for (final c in _xp.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final encounter = widget.encounter;
    final events = ref.watch(combatEventsProvider(encounter.id)).value;
    final content = ref.watch(contentProvider).value;
    final npcs = ref.watch(tableNpcsProvider(encounter.tableId)).value;
    if (events == null || content == null || npcs == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final summary = summarizeEncounter(
      events,
      xpOf: (c) => monsterOfCombatant(content, npcs, c)?.xp ?? 0,
    );
    final phrases = JournalPhrases(l10n, content, events);
    for (final pc in summary.pcs) {
      _xp.putIfAbsent(
        pc.id,
        () => TextEditingController(
          text: '${summary.awarded?[pc.id] ?? summary.xpShare}',
        ),
      );
    }
    int xpOf(Combatant pc) => int.tryParse(_xp[pc.id]!.text) ?? 0;

    Future<void> close() async {
      await appendCombat(ref, encounter.id, [
        (
          CombatEventType.encounterFinished,
          {
            'rounds': summary.rounds,
            'xp_total': summary.xpTotal,
            'xp': {for (final pc in summary.pcs) pc.id: xpOf(pc)},
          },
        ),
      ]);
      await ref.read(combatStoreProvider).finish(encounter.id);
      // Les joueurs quittent l'écran « En combat ».
      await ref.read(combatViewStoreProvider).remove(encounter.id);
      if (context.mounted) popIfCurrent(context, true);
    }

    Widget stat(String value, String label) => Expanded(
      child: Column(
        children: [
          Text(value, style: text.headlineMedium),
          Text(label, style: text.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );

    String fallenLine(FallenCombatant f, {required bool pc}) => switch (f) {
      _ when pc && f.dead => l10n.summaryPcDead(f.round),
      _ when pc && f.stable => l10n.summaryPcStable(f.round),
      _ when pc => l10n.summaryPcDown(f.round),
      _ when f.knockedOut => l10n.summaryKnockedOut(f.round),
      _ => l10n.summaryRound(f.round),
    };

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.summaryTitle, style: text.bodySmall),
            Text(encounter.title),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              stat('${summary.rounds}', l10n.summaryRounds(summary.rounds)),
              stat(formatThousands(summary.xpTotal), l10n.summaryXpTotal),
              stat(
                l10n.summaryFallenCount(summary.fallen.length, summary.foes),
                l10n.summaryFoesFallen,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(l10n.summaryXpTitle, style: text.titleMedium),
          for (final pc in summary.pcs)
            Consumer(
              builder: (context, ref, _) {
                final input = switch (pc.refId) {
                  final id? => ref.watch(_pcInputProvider(id)).value,
                  null => null,
                };
                final gained = xpOf(pc);
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(pc.label),
                  subtitle: input == null
                      ? null
                      : Text(
                          [
                            for (final c in input.classLevels)
                              l10n.classLevel(
                                namesOf(content, [c.classId]),
                                c.level,
                              ),
                            l10n.summaryXpTrack(
                              formatThousands(input.xp),
                              formatThousands(input.xp + gained),
                            ),
                          ].join(' · '),
                        ),
                  trailing: SizedBox(
                    width: 112,
                    child: widget.readOnly
                        ? Text(
                            l10n.summaryXpGain(formatThousands(gained)),
                            textAlign: TextAlign.end,
                          )
                        : TextField(
                            controller: _xp[pc.id],
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.end,
                            decoration: InputDecoration(
                              suffixText: l10n.summaryXpUnit,
                            ),
                            onChanged: (_) => setState(() {}),
                          ),
                  ),
                );
              },
            ),
          if (!widget.readOnly)
            Text(
              l10n.summaryXpHelp(
                formatThousands(summary.xpTotal),
                summary.pcs.length,
              ),
              style: text.bodySmall,
            ),
          SizedBox(height: AppSpacing.md),
          Text(l10n.summaryFallenTitle, style: text.titleMedium),
          if (summary.fallen.isEmpty && summary.downedPcs.isEmpty)
            Text(l10n.summaryNobodyFell, style: text.bodySmall),
          for (final f in summary.fallen)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(f.label),
              subtitle: Text(fallenLine(f, pc: false)),
            ),
          for (final f in summary.downedPcs)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(l10n.summaryPcLabel(f.label)),
              subtitle: Text(fallenLine(f, pc: true)),
            ),
          if (summary.moments.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            Text(l10n.summaryMoments, style: text.titleMedium),
            for (final m in summary.moments)
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xxs),
                child: Text(l10n.summaryMoment(m.round, phrases.of(m))),
              ),
          ],
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => showCombatJournal(context, encounter),
              child: Text(l10n.summarySeeEvents(events.length)),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          if (!widget.readOnly)
            Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(l10n.summaryBack),
                ),
                FilledButton(
                  onPressed: close,
                  child: Text(
                    encounter.sessionId == null
                        ? l10n.summaryClose
                        : l10n.summaryCloseInSession,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
