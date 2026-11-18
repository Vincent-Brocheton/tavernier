// Préparer une rencontre (US-19, EF-REN-02 à 04, [C1]) : jauge de
// difficulté, personnages présents, adversaires numérotés, mode de PV, et
// ajout depuis le bestiaire et les PNJ.
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
import '../tables/tables_providers.dart';
import 'combat_page.dart';
import 'encounters_providers.dart';
import 'foe_picker.dart';

class EncounterPage extends ConsumerWidget {
  const EncounterPage({super.key, required this.tableId, required this.id});

  final String tableId;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final table = ref.watch(tableProvider(tableId)).value;
    final content = ref.watch(contentProvider).value;
    final npcs = ref.watch(tableNpcsProvider(tableId)).value;
    final encounter =
        (ref.watch(tableEncountersProvider(tableId)).value ??
                const <Encounter>[])
            .where((e) => e.id == id)
            .firstOrNull;
    if (table == null || content == null || npcs == null || encounter == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final session =
        (ref.watch(tableSessionsProvider(tableId)).value ??
                const <GameSession>[])
            .where((s) => s.id == encounter.sessionId)
            .firstOrNull;
    final store = ref.read(encounterStoreProvider);
    final editable = !table.archived;
    final wide =
        formFactorOf(MediaQuery.sizeOf(context).width) != FormFactor.phone;
    final picker = FoePicker(tableId: tableId, encounterId: id);

    final preparation = ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        _Gauge(tableId: tableId, encounter: encounter),
        if (editable &&
            (encounter.status == EncounterStatus.draft ||
                encounter.status == EncounterStatus.ready))
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.encounterReadyToPlay),
            value: encounter.status == EncounterStatus.ready,
            onChanged: (on) => store.update(
              id,
              status: on ? EncounterStatus.ready : EncounterStatus.draft,
            ),
          ),
        SizedBox(height: AppSpacing.sm),
        _Present(tableId: tableId, sessionId: encounter.sessionId),
        SizedBox(height: AppSpacing.md),
        _Foes(encounter: encounter, editable: editable),
        if (editable && !wide) ...[
          SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerLeft,
            child: FilledButton.tonalIcon(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (context) => SafeArea(
                  child: SizedBox(
                    height: MediaQuery.sizeOf(context).height * 0.85,
                    child: ListView(
                      padding: EdgeInsets.all(AppSpacing.md),
                      children: [picker],
                    ),
                  ),
                ),
              ),
              icon: const Icon(Icons.add),
              label: Text(l10n.encounterAddFoe),
            ),
          ),
        ],
        SizedBox(height: AppSpacing.md),
        Text(l10n.encounterBudgetNote, style: text.bodySmall),
      ],
    );

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              [
                table.settings.name,
                if (session != null) l10n.sessionNumber(session.number),
              ].join(' · '),
              style: text.bodySmall,
            ),
            Text(encounter.title),
          ],
        ),
        actions: [
          if (editable)
            TextButton(
              onPressed: () async {
                final copy = await store.duplicate(id);
                // La copie remplace l'original : revenir ramène à la liste.
                if (context.mounted) {
                  context.pushReplacement('/tables/$tableId/rencontres/$copy');
                }
              },
              child: Text(l10n.encounterDuplicate),
            ),
        ],
      ),
      // En bas : sur téléphone, l'en-tête n'a pas la place.
      bottomNavigationBar: editable
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: switch (encounter.status) {
                  EncounterStatus.draft ||
                  EncounterStatus.ready => FilledButton.icon(
                    onPressed: () => launchEncounter(context, ref, encounter),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.encounterLaunch),
                  ),
                  EncounterStatus.running => FilledButton.tonalIcon(
                    onPressed: () =>
                        context.push('/tables/$tableId/rencontres/$id/combat'),
                    icon: const Icon(Icons.play_arrow),
                    label: Text(l10n.encounterResume),
                  ),
                  EncounterStatus.finished => const SizedBox.shrink(),
                },
              ),
            )
          : null,
      body: SafeArea(
        child: wide && editable
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 360,
                    child: ListView(
                      padding: EdgeInsets.all(AppSpacing.md),
                      children: [picker],
                    ),
                  ),
                  Expanded(child: preparation),
                ],
              )
            : preparation,
      ),
    );
  }
}

/// Jauge de difficulté, ou « Aucun personnage présent ».
class _Gauge extends ConsumerWidget {
  const _Gauge({required this.tableId, required this.encounter});

  final String tableId;
  final Encounter encounter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final content = ref.watch(contentProvider).value!;
    final npcs = ref.watch(tableNpcsProvider(tableId)).value!;
    final levels = ref.watch(
      presentLevelsProvider((tableId: tableId, sessionId: encounter.sessionId)),
    );
    if (levels == null) return const LinearProgressIndicator();
    final xp = xpOfFoes(foesOf(l10n, encounter, content, npcs));
    final xpLabel = l10n.encounterXp(formatThousands(xp));
    if (levels.isEmpty) {
      return Row(
        children: [
          Expanded(child: Text(l10n.encounterNoParty)),
          Text(xpLabel, style: Theme.of(context).textTheme.titleLarge),
        ],
      );
    }
    final budget = encounterBudget(levels);
    final difficulty = encounterDifficulty(xp, budget);
    GaugeMark mark(String label, int xp) =>
        (label: label, value: formatThousands(xp), xp: xp);
    return DifficultyGauge(
      title: l10n.encounterDifficultyTitle,
      levelLabel: difficultyLabel(l10n, difficulty),
      level: GaugeLevel.values[difficulty.index],
      xp: xp,
      xpLabel: xpLabel,
      caption: levels.toSet().length == 1
          ? l10n.encounterPartySame(levels.length, levels.first)
          : l10n.encounterPartyMixed(levels.length),
      marks: [
        mark(l10n.difficultyLow, budget.low),
        mark(l10n.difficultyModerate, budget.moderate),
        mark(l10n.difficultyHigh, budget.high),
      ],
    );
  }
}

/// Personnages présents, d'après la séance (ou toute la table en réserve).
class _Present extends ConsumerWidget {
  const _Present({required this.tableId, required this.sessionId});

  final String tableId;
  final String? sessionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value!;
    final group =
        ref.watch(tableGroupProvider(tableId)).value ??
        const <CharacterSummary>[];
    final present = switch (sessionId) {
      final session? =>
        ref.watch(sessionAttendanceProvider(session)).value ?? const {},
      null => {for (final pc in group) pc.id},
    };
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.encounterPresent, style: text.titleMedium),
            SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final pc in group)
                  if (present.contains(pc.id))
                    Chip(
                      avatar: const Icon(Icons.check, size: 18),
                      label: Text(
                        [
                          pc.name,
                          for (final c in pc.classes)
                            l10n.classLevel(
                              namesOf(content, [c.classId]),
                              c.level,
                            ),
                        ].join(' · '),
                      ),
                    ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Adversaires : numérotation, initiative commune, quantité, PX ; mode de
/// PV des monstres.
class _Foes extends ConsumerWidget {
  const _Foes({required this.encounter, required this.editable});

  final Encounter encounter;
  final bool editable;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value!;
    final npcs = ref.watch(tableNpcsProvider(encounter.tableId)).value!;
    final store = ref.read(encounterStoreProvider);
    final foes = foesOf(l10n, encounter, content, npcs);
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Le titre, puis le mode de PV : sur téléphone, le libellé passe
            // au-dessus des deux boutons.
            Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.xs,
              children: [
                Text(l10n.encounterFoes, style: text.titleMedium),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    Text(l10n.encounterHpMode, style: text.bodySmall),
                    IgnorePointer(
                      ignoring: !editable,
                      child: SegmentedButton<HpMode>(
                        segments: [
                          ButtonSegment(
                            value: HpMode.average,
                            label: Text(l10n.encounterHpAverage),
                          ),
                          ButtonSegment(
                            value: HpMode.roll,
                            label: Text(l10n.encounterHpRoll),
                          ),
                        ],
                        selected: {encounter.hpMode},
                        showSelectedIcon: false,
                        onSelectionChanged: (s) =>
                            store.update(encounter.id, hpMode: s.single),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            if (foes.isEmpty)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Text(l10n.encounterNoFoes),
              ),
            for (final foe in foes) ...[
              const Divider(),
              Text(foe.name, style: text.titleSmall),
              Text(
                [
                  if (foe.cr case final cr?) l10n.encounterCr(cr),
                  if (foe.quantity > 1)
                    l10n.encounterNumbered(foe.name, foe.quantity)
                  else
                    l10n.encounterUnique,
                ].join(' · '),
                style: text.bodySmall,
              ),
              Wrap(
                alignment: WrapAlignment.end,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.xs,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Checkbox(
                        value: foe.sharedInitiative,
                        onChanged: editable
                            ? (on) => store.updateGroup(
                                foe.groupId,
                                sharedInitiative: on,
                              )
                            : null,
                      ),
                      Text(
                        l10n.encounterSharedInitiative,
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                  IconButton.outlined(
                    tooltip: l10n.encounterOneLess,
                    icon: const Icon(Icons.remove),
                    onPressed: editable
                        ? () => foe.quantity > 1
                              ? store.updateGroup(
                                  foe.groupId,
                                  quantity: foe.quantity - 1,
                                )
                              : store.removeGroup(foe.groupId)
                        : null,
                  ),
                  Text('${foe.quantity}', style: text.titleMedium),
                  IconButton.outlined(
                    tooltip: l10n.encounterOneMore,
                    icon: const Icon(Icons.add),
                    onPressed: editable && foe.quantity < maxGroupQuantity
                        ? () => store.updateGroup(
                            foe.groupId,
                            quantity: foe.quantity + 1,
                          )
                        : null,
                  ),
                  SizedBox(
                    width: 88,
                    child: Text(
                      l10n.encounterXp(formatThousands(foe.xp * foe.quantity)),
                      textAlign: TextAlign.end,
                      style: text.titleSmall,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }
}
