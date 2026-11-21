// Clôture d'une séance (US-35 lot d, EF-SEA-03, 04, [S4], [S7]) : rencontres
// jouées, sort des rencontres non jouées, PX ajoutés aux fiches (table en
// PX) ou niveau accordé aux PJ cochés (table en jalons).
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../encounters/encounters_providers.dart';
import '../l10n/app_localizations.dart';
import '../src/pop_if_current.dart';
import '../tables/tables_providers.dart';
import 'sessions_providers.dart';

/// Rencontre jouée d'une séance et son résumé.
typedef PlayedEncounter = ({Encounter encounter, EncounterSummary summary});

/// Rencontres terminées de la séance [sessionId], avec leur résumé.
final playedEncountersProvider = FutureProvider.autoDispose
    .family<List<PlayedEncounter>, ({String tableId, String sessionId})>((
      ref,
      key,
    ) async {
      final encounters = await ref.watch(
        tableEncountersProvider(key.tableId).future,
      );
      final store = ref.watch(combatStoreProvider);
      return [
        for (final e in encounters)
          if (e.sessionId == key.sessionId &&
              e.status == EncounterStatus.finished)
            (
              encounter: e,
              // Les PX comptés sont ceux accordés à la clôture du combat.
              summary: summarizeEncounter(
                await store.watchEvents(e.id).first,
                xpOf: (_) => 0,
              ),
            ),
      ];
    });

/// PX et niveau accordé d'une fiche.
final _accessProvider = FutureProvider.autoDispose.family(
  (ref, String id) => ref.watch(characterStoreProvider).access(id),
);

int _levelOf(CharacterSummary pc) =>
    pc.classes.fold(0, (sum, c) => sum + c.level);

/// Sort d'une rencontre non jouée.
enum _Fate { report, keep, delete }

class CloseSessionPage extends ConsumerStatefulWidget {
  const CloseSessionPage({
    super.key,
    required this.tableId,
    required this.sessionId,
  });

  final String tableId;
  final String sessionId;

  @override
  ConsumerState<CloseSessionPage> createState() => _CloseSessionPageState();
}

class _CloseSessionPageState extends ConsumerState<CloseSessionPage> {
  final _fates = <String, _Fate>{};
  final _reason = TextEditingController();

  /// PJ cochés pour le jalon ; `null` tant que l'utilisateur n'a rien
  /// changé (les présents).
  Set<String>? _granted;

  @override
  void dispose() {
    _reason.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final table = ref.watch(tableProvider(widget.tableId)).value;
    final sessions =
        ref.watch(tableSessionsProvider(widget.tableId)).value ?? const [];
    final session = sessions.where((s) => s.id == widget.sessionId).firstOrNull;
    final played = ref
        .watch(
          playedEncountersProvider((
            tableId: widget.tableId,
            sessionId: widget.sessionId,
          )),
        )
        .value;
    final encounters =
        ref.watch(tableEncountersProvider(widget.tableId)).value ?? const [];
    final group =
        ref.watch(tableGroupProvider(widget.tableId)).value ?? const [];
    final present =
        ref.watch(sessionAttendanceProvider(widget.sessionId)).value ??
        const <String>{};
    if (table == null || session == null || played == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final milestone = table.settings.progression == Progression.milestones;
    final unplayed = [
      for (final e in encounters)
        if (e.sessionId == session.id && e.status != EncounterStatus.finished)
          e,
    ];
    // La séance prévue suivante reçoit les rencontres reportées.
    final next = sessions
        .where(
          (s) => s.status == SessionStatus.planned && s.number > session.number,
        )
        .fold<GameSession?>(
          null,
          (best, s) => best == null || s.number < best.number ? s : best,
        );
    _Fate fateOf(Encounter e) =>
        _fates[e.id] ?? (next == null ? _Fate.keep : _Fate.report);
    final xp = sessionXp([for (final p in played) p.summary.awarded]);
    final total = played.fold(
      0,
      (sum, p) =>
          sum + (p.summary.awarded?.values.fold<int>(0, (a, b) => a + b) ?? 0),
    );
    final rounds = played.fold(0, (sum, p) => sum + p.summary.rounds);
    final granted = _granted ?? {...present};
    final me = ref.watch(currentUserProvider).value?.id;

    Future<void> close() async {
      final characters = ref.read(characterStoreProvider);
      final encounterStore = ref.read(encounterStoreProvider);
      if (milestone) {
        for (final pc in group) {
          final unlock = (await ref.read(_accessProvider(pc.id).future))
              ?.levelUnlock;
          final already = ((unlock?['level'] as int?) ?? 0) > _levelOf(pc);
          if (granted.contains(pc.id) && !already) {
            await characters.grantLevel(
              pc.id,
              level: _levelOf(pc) + 1,
              origin: UnlockOrigin.milestone.name,
              byUserId: me!,
              reason: _reason.text.trim().isEmpty ? null : _reason.text.trim(),
              sessionId: session.id,
            );
          }
        }
      } else {
        for (final MapEntry(:key, :value) in xp.entries) {
          if (value > 0) {
            await characters.addXp(
              key,
              amount: value,
              byUserId: me!,
              sessionId: session.id,
            );
          }
        }
      }
      for (final e in unplayed) {
        switch (fateOf(e)) {
          case _Fate.report:
            await encounterStore.update(e.id, sessionId: next!.id);
          case _Fate.keep:
            await encounterStore.update(e.id, clearSession: true);
          case _Fate.delete:
            await encounterStore.delete(e.id);
        }
      }
      await ref
          .read(sessionStoreProvider)
          .update(session.id, status: SessionStatus.closed);
      if (context.mounted) popIfCurrent(context);
    }

    Widget stat(String value, String label) => Expanded(
      child: Column(
        children: [
          Text(value, style: text.headlineMedium),
          Text(label, style: text.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.closeTitle(session.number), style: text.bodySmall),
            Text(session.title, style: text.titleLarge),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.xs,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.closeBack),
              ),
              FilledButton(
                onPressed: close,
                child: Text(l10n.closeTitle(session.number)),
              ),
            ],
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Row(
            children: [
              stat('${played.length}', l10n.closePlayed(played.length)),
              if (milestone)
                stat('$rounds', l10n.closeRounds)
              else ...[
                stat(formatThousands(total), l10n.closeXpTotal),
                stat(
                  formatThousands(xp.values.fold(0, (a, b) => a > b ? a : b)),
                  l10n.closeXpEach,
                ),
              ],
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(l10n.closePlayedTitle, style: text.titleMedium),
          for (final p in played)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(p.encounter.title),
              subtitle: Text(
                milestone
                    ? l10n.closePlayedLineMilestone(p.summary.rounds)
                    : l10n.closePlayedLine(
                        p.summary.rounds,
                        formatThousands(
                          p.summary.awarded?.values.fold<int>(
                                0,
                                (a, b) => a + b,
                              ) ??
                              0,
                        ),
                      ),
              ),
            ),
          if (unplayed.isNotEmpty) ...[
            SizedBox(height: AppSpacing.md),
            Text(l10n.closeUnplayedTitle, style: text.titleMedium),
            for (final e in unplayed) ...[
              Text(e.title, style: text.bodyLarge),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final (fate, label) in [
                    if (next != null)
                      (_Fate.report, l10n.closeReport(next.number)),
                    (_Fate.keep, l10n.closeKeep),
                    (_Fate.delete, l10n.closeDelete),
                  ])
                    ChoiceChip(
                      label: Text(label),
                      selected: fateOf(e) == fate,
                      onSelected: (_) => setState(() => _fates[e.id] = fate),
                    ),
                ],
              ),
            ],
          ],
          SizedBox(height: AppSpacing.md),
          if (milestone) ...[
            Text(l10n.closeMilestoneTitle, style: text.titleMedium),
            Text(l10n.closeMilestoneHint, style: text.bodySmall),
            SizedBox(height: AppSpacing.sm),
            TextField(
              controller: _reason,
              decoration: InputDecoration(labelText: l10n.closeReason),
            ),
            SizedBox(height: AppSpacing.sm),
            Text(l10n.closeGrantTo.toUpperCase(), style: text.labelMedium),
            for (final pc in group)
              _GrantRow(
                pc: pc,
                present: present.contains(pc.id),
                checked: granted.contains(pc.id),
                onChanged: (on) => setState(() {
                  _granted = {...granted};
                  on ? _granted!.add(pc.id) : _granted!.remove(pc.id);
                }),
              ),
            Text(l10n.closeMilestoneFoot, style: text.bodySmall),
          ] else ...[
            Text(l10n.closeXpTitle, style: text.titleMedium),
            Text(l10n.closeXpHint, style: text.bodySmall),
            for (final pc in group) _XpRow(pc: pc, gained: xp[pc.id] ?? 0),
            Text(l10n.closeXpFoot, style: text.bodySmall),
          ],
        ],
      ),
    );
  }
}

class _XpRow extends ConsumerWidget {
  const _XpRow({required this.pc, required this.gained});

  final CharacterSummary pc;
  final int gained;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final from = ref.watch(_accessProvider(pc.id)).value?.xp ?? 0;
    final to = from + gained;
    final level = _levelOf(pc);
    final next = nextXpThreshold(level);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(pc.name),
      subtitle: Text(
        gained == 0
            ? l10n.closeAbsent
            : next == null
            ? l10n.closeXpLineMax(formatThousands(from), formatThousands(to))
            : l10n.closeXpLine(
                formatThousands(from),
                formatThousands(to),
                formatThousands(next),
                level + 1,
              ),
      ),
      trailing: Text(
        gained == 0 ? '0' : '+${formatThousands(gained)}',
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _GrantRow extends ConsumerWidget {
  const _GrantRow({
    required this.pc,
    required this.present,
    required this.checked,
    required this.onChanged,
  });

  final CharacterSummary pc;
  final bool present;
  final bool checked;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final level = _levelOf(pc);
    final unlock = ref.watch(_accessProvider(pc.id)).value?.levelUnlock;
    // Déjà servi pendant la séance : coché et grisé (EF-SEA-04).
    final already = ((unlock?['level'] as int?) ?? 0) > level;
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      value: already || checked,
      onChanged: already ? null : (on) => onChanged(on ?? false),
      title: Text(pc.name),
      subtitle: Text(
        [
          if (already)
            l10n.closeAlreadyGranted
          else
            present ? l10n.closePresent : l10n.closeAbsentTonight,
          l10n.closeLevels(level, level + 1),
        ].join(' · '),
      ),
    );
  }
}
