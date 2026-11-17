// Onglet « Rencontres » d'une table, pour son MJ (US-19, EF-REN-01, 03, 05,
// [F5]) : rencontres par séance, recherche, filtres, budget de la prochaine
// séance.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../sessions/sessions_providers.dart';
import 'encounter_sheets.dart';
import 'encounters_providers.dart';

enum _Filter { all, toPlay, finished }

class EncountersTab extends ConsumerStatefulWidget {
  const EncountersTab({super.key, required this.table});

  final TableSummary table;

  @override
  ConsumerState<EncountersTab> createState() => _EncountersTabState();
}

class _EncountersTabState extends ConsumerState<EncountersTab> {
  var _filter = _Filter.all;
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final tableId = widget.table.id;
    final encounters = ref.watch(tableEncountersProvider(tableId)).value;
    final sessions = ref.watch(tableSessionsProvider(tableId)).value;
    final content = ref.watch(contentProvider).value;
    final npcs = ref.watch(tableNpcsProvider(tableId)).value;
    if (encounters == null ||
        sessions == null ||
        content == null ||
        npcs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final query = foldAccents(_query.trim());
    bool shown(Encounter e) {
      final keep = switch (_filter) {
        _Filter.all => true,
        _Filter.toPlay =>
          e.status == EncounterStatus.draft ||
              e.status == EncounterStatus.ready,
        _Filter.finished => e.status == EncounterStatus.finished,
      };
      if (!keep || query.isEmpty) return keep;
      return [
        e.title,
        for (final f in foesOf(l10n, e, content, npcs)) f.name,
      ].any((s) => foldAccents(s).contains(query));
    }

    final toPlay = encounters
        .where(
          (e) =>
              e.status == EncounterStatus.draft ||
              e.status == EncounterStatus.ready,
        )
        .length;
    final visible = encounters.where(shown).toList();
    // Séances à venir par date, réserve, puis séances closes, plus récentes
    // d'abord.
    final open = [
      for (final s in sessions.reversed)
        if (s.status != SessionStatus.closed) s,
    ];
    final closed = [
      for (final s in sessions)
        if (s.status == SessionStatus.closed) s,
    ];
    final sessionIds = {for (final s in sessions) s.id};
    final sections = <(GameSession?, List<Encounter>)>[
      for (final s in open)
        (
          s,
          [
            for (final e in visible)
              if (e.sessionId == s.id) e,
          ],
        ),
      (
        null,
        [
          // Une séance absente (supprimée ailleurs, pas encore
          // synchronisée) : la rencontre reste visible, en réserve.
          for (final e in visible)
            if (!sessionIds.contains(e.sessionId)) e,
        ],
      ),
      for (final s in closed)
        (
          s,
          [
            for (final e in visible)
              if (e.sessionId == s.id) e,
          ],
        ),
    ].where((section) => section.$2.isNotEmpty).toList();

    final wide =
        formFactorOf(MediaQuery.sizeOf(context).width) != FormFactor.phone;
    final list = ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        if (!widget.table.archived)
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.tonalIcon(
              onPressed: () => createEncounter(context, ref, widget.table.id),
              icon: const Icon(Icons.add),
              label: Text(l10n.encounterNew),
            ),
          ),
        SizedBox(height: AppSpacing.sm),
        TextField(
          decoration: InputDecoration(
            hintText: l10n.encounterSearch,
            prefixIcon: const Icon(Icons.search),
          ),
          onChanged: (v) => setState(() => _query = v),
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final (filter, label) in [
              (_Filter.all, l10n.encounterFilterAll),
              (_Filter.toPlay, l10n.encounterFilterToPlay(toPlay)),
              (_Filter.finished, l10n.encounterFilterFinished),
            ])
              ChoiceChip(
                label: Text(label),
                selected: _filter == filter,
                onSelected: (_) => setState(() => _filter = filter),
              ),
          ],
        ),
        if (sections.isEmpty)
          Padding(
            padding: EdgeInsets.all(AppSpacing.lg),
            child: Text(
              l10n.encounterEmpty,
              textAlign: TextAlign.center,
              style: text.titleMedium,
            ),
          ),
        for (final (session, list) in sections) ...[
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.md, bottom: AppSpacing.xs),
            child: Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: session == null
                        ? l10n.encounterReserve.toUpperCase()
                        : l10n.sessionNumber(session.number).toUpperCase(),
                    style: text.labelLarge,
                  ),
                  TextSpan(
                    text: session == null
                        ? '  ${l10n.encounterReserveHint}'
                        : [
                            '  ${l10n.encounterSessionDate(session.date)}',
                            if (session.status == SessionStatus.closed)
                              l10n.encounterSessionClosed,
                          ].join(' · '),
                    style: text.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          for (final e in list)
            _EncounterTile(
              table: widget.table,
              encounter: e,
              foes: foesOf(l10n, e, content, npcs),
            ),
        ],
      ],
    );
    if (!wide) return list;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 2, child: list),
        Expanded(
          child: _SidePanel(tableId: tableId, next: open.firstOrNull),
        ),
      ],
    );
  }
}

class _EncounterTile extends ConsumerWidget {
  const _EncounterTile({
    required this.table,
    required this.encounter,
    required this.foes,
  });

  final TableSummary table;
  final Encounter encounter;
  final List<Foe> foes;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final levels = ref.watch(
      presentLevelsProvider((
        tableId: table.id,
        sessionId: encounter.sessionId,
      )),
    );
    final (label, background, foreground) = switch (encounter.status) {
      EncounterStatus.draft => (
        l10n.encounterDraft,
        scheme.surfaceContainerHighest,
        scheme.onSurface,
      ),
      EncounterStatus.ready => (
        l10n.encounterReady,
        colors.healContainer,
        colors.onHealContainer,
      ),
      EncounterStatus.running => (
        l10n.encounterRunning,
        scheme.primaryContainer,
        scheme.onPrimaryContainer,
      ),
      EncounterStatus.finished => (
        l10n.encounterFinished,
        scheme.surfaceContainerHighest,
        scheme.onSurface,
      ),
    };
    final editable = !table.archived;
    final store = ref.read(encounterStoreProvider);
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(child: Text(encounter.title, style: text.titleMedium)),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xxs,
                  ),
                  decoration: BoxDecoration(
                    color: background,
                    borderRadius: BorderRadius.circular(AppRadii.xs),
                  ),
                  child: Text(
                    label,
                    style: text.labelMedium!.copyWith(color: foreground),
                  ),
                ),
              ],
            ),
            Text(encounterSummary(l10n, foes, levels), style: text.bodySmall),
            Wrap(
              alignment: WrapAlignment.end,
              spacing: AppSpacing.xs,
              children: [
                if (editable)
                  TextButton(
                    onPressed: () => store.duplicate(encounter.id),
                    child: Text(l10n.encounterDuplicate),
                  ),
                if (editable && encounter.sessionId == null)
                  OutlinedButton(
                    onPressed: () async {
                      final session = await chooseSession(
                        context,
                        ref,
                        table.id,
                      );
                      if (session != null) {
                        await store.update(encounter.id, sessionId: session);
                      }
                    },
                    child: Text(l10n.encounterMove),
                  ),
                FilledButton.tonal(
                  onPressed: () => context.push(
                    '/tables/${table.id}/rencontres/${encounter.id}',
                  ),
                  child: Text(l10n.encounterOpen),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// « Dupliquer » et le budget de la prochaine séance ([F5], grand écran).
class _SidePanel extends ConsumerWidget {
  const _SidePanel({required this.tableId, required this.next});

  final String tableId;
  final GameSession? next;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final levels = next == null
        ? null
        : ref.watch(
            presentLevelsProvider((tableId: tableId, sessionId: next!.id)),
          );
    final budget = levels == null || levels.isEmpty
        ? null
        : encounterBudget(levels);
    Widget row(String label, int xp) => Row(
      children: [
        Expanded(child: Text(label)),
        Text(l10n.encounterXp(formatThousands(xp))),
      ],
    );
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l10n.encounterDuplicate, style: text.titleMedium),
                SizedBox(height: AppSpacing.xs),
                Text(l10n.encounterDuplicateHelp, style: text.bodySmall),
              ],
            ),
          ),
        ),
        if (budget != null) ...[
          SizedBox(height: AppSpacing.md),
          Card(
            margin: EdgeInsets.zero,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.encounterBudgetTitle, style: text.titleMedium),
                  SizedBox(height: AppSpacing.xs),
                  row(l10n.difficultyLow, budget.low),
                  row(l10n.difficultyModerate, budget.moderate),
                  row(l10n.difficultyHigh, budget.high),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    levels!.toSet().length == 1
                        ? l10n.encounterBudgetSameLevel(
                            levels.length,
                            levels.first,
                          )
                        : l10n.encounterBudgetMixed(levels.length),
                    style: text.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}
