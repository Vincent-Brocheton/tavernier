// Lancement et initiative d'une rencontre (US-20, EF-INI-01 à 04, [C3]).
import 'dart:math';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../sessions/sessions_providers.dart';
import '../tables/tables_providers.dart';
import 'combat_view.dart';
import 'encounters_providers.dart';
import 'launch.dart';

/// Lance [encounter] : ses combattants, les jets automatiques, l'état « En
/// cours » ; puis ouvre l'écran d'initiative.
/// Rencontres en cours de lancement : un second appui ne relance pas.
final _launching = <String>{};

Future<void> launchEncounter(
  BuildContext context,
  WidgetRef ref,
  Encounter encounter,
) async {
  if (!_launching.add(encounter.id)) return;
  try {
    await _launch(context, ref, encounter);
  } finally {
    _launching.remove(encounter.id);
  }
}

Future<void> _launch(
  BuildContext context,
  WidgetRef ref,
  Encounter encounter,
) async {
  final tableId = encounter.tableId;
  final content = await ref.read(contentProvider.future);
  final npcs = await ref.read(tableNpcsProvider(tableId).future);
  final group = await ref.read(tableGroupProvider(tableId).future);
  final present = switch (encounter.sessionId) {
    final session? => await ref.read(sessionAttendanceProvider(session).future),
    null => {for (final pc in group) pc.id},
  };
  final party = [
    for (final pc in group)
      if (present.contains(pc.id))
        (id: pc.id, name: pc.name, owner: pc.ownerUserId),
  ];
  final characters = ref.read(characterStoreProvider);
  final sheets = <String, SheetInfo>{};
  for (final id in [
    for (final pc in party) pc.id,
    for (final npc in npcs)
      if (npc.characterId case final sheet?
          when encounter.groups.any((g) => g.refId == npc.id))
        sheet,
  ]) {
    ComputedSheet? sheet;
    try {
      final input = await characters.load(id);
      if (input != null) sheet = computeSheet(input, content);
    } on Object {
      // Fiche illisible : bonus 0, sans PV ; le MJ corrige en combat.
    }
    sheets[id] = (sheet: sheet, hp: (await characters.loadState(id)).hpCurrent);
  }
  await ref
      .read(combatStoreProvider)
      .launch(
        encounter.id,
        authorUserId: ref.read(currentUserProvider).value?.id,
        launchEvents(
          encounter: encounter,
          content: content,
          npcs: npcs,
          party: party,
          sheets: sheets,
          random: Random(),
        ),
      );
  if (context.mounted) {
    await context.push('/tables/$tableId/rencontres/${encounter.id}/combat');
  }
}

class CombatPage extends ConsumerWidget {
  const CombatPage({super.key, required this.tableId, required this.id});

  final String tableId;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final state = ref.watch(combatStateProvider(id));
    final encounter =
        (ref.watch(tableEncountersProvider(tableId)).value ??
                const <Encounter>[])
            .where((e) => e.id == id)
            .firstOrNull;
    if (state.hasError) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(child: Text(l10n.combatUnreadable)),
      );
    }
    final combat = state.value;
    if (combat == null || encounter == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final allRolled = combat.order.every(
      (u) => combat.members(u).first.initiative != null,
    );
    final starting = combat.round == 0;
    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(onPressed: () => context.pop()),
        actions: starting ? null : combatActions(context, ref, encounter),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              starting
                  ? l10n.combatLaunching(encounter.title)
                  : encounter.title,
              style: text.bodySmall,
            ),
            Text(
              starting ? l10n.combatInitiative : l10n.combatRound(combat.round),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: starting
            ? _Initiative(encounterId: id, tableId: tableId, combat: combat)
            : CombatView(encounter: encounter, combat: combat),
      ),
      bottomNavigationBar: starting
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        allRolled ? l10n.combatAllRolled : '',
                        style: text.bodySmall,
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: allRolled
                          ? () => ref.read(combatStoreProvider).append(
                              id,
                              authorUserId: ref
                                  .read(currentUserProvider)
                                  .value
                                  ?.id,
                              [(CombatEventType.combatStarted, const {})],
                            )
                          : null,
                      icon: const Icon(Icons.play_arrow),
                      label: Text(l10n.combatStart),
                    ),
                  ],
                ),
              ),
            )
          // Le combat porte son propre pied (cibles, Tour suivant).
          : null,
    );
  }
}

/// Nom d'une unité : le combattant seul, ou « Vétéran 1–2 » pour un groupe.
String _unitLabel(AppLocalizations l10n, CombatState combat, String unit) {
  final members = combat.members(unit);
  if (members.length == 1) return members.single.label;
  final first = members.first.label;
  final base = first.replaceFirst(RegExp(r' \d+$'), '');
  return l10n.combatGroupLabel(base, members.length);
}

class _Initiative extends ConsumerStatefulWidget {
  const _Initiative({
    required this.encounterId,
    required this.tableId,
    required this.combat,
  });

  final String encounterId;
  final String tableId;
  final CombatState combat;

  @override
  ConsumerState<_Initiative> createState() => _InitiativeState();
}

class _InitiativeState extends ConsumerState<_Initiative> {
  /// Unités surprises, réglées avant le jet d'un PJ.
  final _surprised = <String>{};

  CombatState get _combat => widget.combat;

  bool _isSurprised(String unit) =>
      _surprised.contains(unit) ||
      (_combat.members(unit).first.initiative?.surprised ?? false);

  Future<void> _append(List<NewCombatEvent> events) => ref
      .read(combatStoreProvider)
      .append(
        widget.encounterId,
        authorUserId: ref.read(currentUserProvider).value?.id,
        events,
      );

  /// Jet d'une unité : [die] saisi pour un PJ, sinon lancé.
  Future<void> _roll(String unit, {int? die, bool? surprised}) {
    final lead = _combat.members(unit).first;
    final isSurprised = surprised ?? _isSurprised(unit);
    final mode = combineRollModes(
      advantage: lead.advantage,
      surprised: isSurprised,
    );
    final roll = die == null
        ? rollInitiative(lead.bonus, mode, Random())
        : InitiativeRoll(dice: [die], bonus: lead.bonus);
    return _append([
      (
        CombatEventType.initiativeRolled,
        {
          'unit': unit,
          'dice': roll.dice,
          'dropped': ?roll.dropped,
          'bonus': lead.bonus,
          'mode': mode.name,
          'surprised': isSurprised,
        },
      ),
    ]);
  }

  Future<void> _toggleSurprise(String unit, bool on) async {
    setState(() => on ? _surprised.add(unit) : _surprised.remove(unit));
    final lead = _combat.members(unit).first;
    // Un monstre surpris est relancé ; un PJ garde son jet saisi.
    if (lead.kind != CombatantKind.pc) await _roll(unit, surprised: on);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final pseudonyms = {
      for (final m
          in ref.watch(tableMembersProvider(widget.tableId)).value ??
              const <TableMemberInfo>[])
        m.userId: m.pseudonym,
    };
    final wide =
        formFactorOf(MediaQuery.sizeOf(context).width) != FormFactor.phone;
    final units = _combat.order;

    final surprise = Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.combatSurprise, style: text.titleMedium),
            Text(l10n.combatSurpriseHelp, style: text.bodySmall),
            SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                for (final unit in units)
                  FilterChip(
                    label: Text(_unitLabel(l10n, _combat, unit)),
                    selected: _isSurprised(unit),
                    onSelected: (on) => _toggleSurprise(unit, on),
                  ),
              ],
            ),
          ],
        ),
      ),
    );

    final rows = [
      for (final unit in units)
        _UnitRow(
          key: ValueKey(unit),
          label: _unitLabel(l10n, _combat, unit),
          members: _combat.members(unit),
          surprised: _isSurprised(unit),
          player: pseudonyms[_combat.members(unit).first.owner],
          onDie: (die) => _roll(unit, die: die),
        ),
    ];

    final order = _OrderPanel(
      combat: _combat,
      pseudonyms: pseudonyms,
      onReorder: (order) => _append([
        (CombatEventType.orderSet, {'order': order}),
      ]),
    );

    if (!wide) {
      return ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          surprise,
          SizedBox(height: AppSpacing.md),
          ...rows,
          SizedBox(height: AppSpacing.md),
          order,
        ],
      );
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              surprise,
              SizedBox(height: AppSpacing.md),
              ...rows,
            ],
          ),
        ),
        SizedBox(
          width: 380,
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [order],
          ),
        ),
      ],
    );
  }
}

/// Ligne d'une unité : bonus et mode, jet, total, origine ; saisie d'un PJ.
class _UnitRow extends StatelessWidget {
  const _UnitRow({
    super.key,
    required this.label,
    required this.members,
    required this.surprised,
    required this.player,
    required this.onDie,
  });

  final String label;
  final List<Combatant> members;
  final bool surprised;
  final String? player;
  final ValueChanged<int> onDie;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final lead = members.first;
    final roll = lead.initiative;
    final mode =
        roll?.mode ??
        combineRollModes(advantage: lead.advantage, surprised: surprised);
    final subtitle = [
      switch (lead.kind) {
        CombatantKind.pc => l10n.combatPc(player ?? ''),
        CombatantKind.npc => l10n.combatNpc,
        CombatantKind.monster => null,
      },
      if (members.length > 1) l10n.encounterSharedInitiative,
      if (surprised) l10n.combatSurprised,
    ].nonNulls.join(' · ');
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.xs),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.xs,
          children: [
            SizedBox(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: text.titleSmall),
                  if (subtitle.isNotEmpty)
                    Text(subtitle, style: text.bodySmall),
                ],
              ),
            ),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(formatSigned(lead.bonus)),
                if (mode != RollMode.normal) ...[
                  SizedBox(width: AppSpacing.xs),
                  Chip(
                    visualDensity: VisualDensity.compact,
                    label: Text(
                      mode == RollMode.advantage
                          ? l10n.combatAdvantage
                          : l10n.combatDisadvantage,
                    ),
                  ),
                ],
              ],
            ),
            if (roll != null)
              Text(
                roll.dropped == null
                    ? '${roll.dice.single}'
                    : l10n.combatRollDropped(roll.dice.single, roll.dropped!),
              )
            else if (lead.kind != CombatantKind.monster)
              _DieField(label: l10n.combatDie, onDie: onDie),
            Text(roll == null ? '—' : '${roll.total}', style: text.titleLarge),
            Text(
              roll == null
                  ? ''
                  : lead.kind == CombatantKind.pc
                  ? l10n.combatEnteredByGm
                  : l10n.combatAutoRoll,
              style: text.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}

/// « Ordre du tour » : total, nom, égalités et qui décide ; glisser pour
/// réordonner.
class _OrderPanel extends StatelessWidget {
  const _OrderPanel({
    required this.combat,
    required this.pseudonyms,
    required this.onReorder,
  });

  final CombatState combat;
  final Map<String, String?> pseudonyms;
  final ValueChanged<List<String>> onReorder;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final colors = GameColors.of(context);
    String players(InitiativeTie tie) =>
        [for (final p in tie.players) pseudonyms[p] ?? '?']
            .reduce(l10n.combatPlayersAnd);
    String? tieOf(String unit) =>
        switch (combat.ties.where((t) => t.units.contains(unit)).firstOrNull) {
          final tie? when tie.gmDecides => l10n.combatTieGm,
          final tie? => l10n.combatTiePlayers(players(tie)),
          null => null,
        };
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.combatOrder, style: text.titleMedium),
            SizedBox(height: AppSpacing.xs),
            ReorderableListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              buildDefaultDragHandles: false,
              onReorderItem: (from, to) {
                final order = [...combat.order];
                order.insert(to, order.removeAt(from));
                onReorder(order);
              },
              children: [
                for (final (index, unit) in combat.order.indexed)
                  ListTile(
                    key: ValueKey(unit),
                    contentPadding: EdgeInsets.zero,
                    leading: ReorderableDragStartListener(
                      index: index,
                      child: const Icon(Icons.drag_indicator),
                    ),
                    title: Text(_unitLabel(l10n, combat, unit)),
                    subtitle: switch (tieOf(unit)) {
                      final tie? => Text(
                        tie,
                        style: text.labelSmall!.copyWith(color: colors.alert),
                      ),
                      null => null,
                    },
                    trailing: Text(
                      '${combat.members(unit).first.initiative?.total ?? '—'}',
                      style: text.titleMedium,
                    ),
                  ),
              ],
            ),
            for (final tie in combat.ties)
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xs),
                child: Card(
                  margin: EdgeInsets.zero,
                  color: colors.alertContainer,
                  child: Padding(
                    padding: EdgeInsets.all(AppSpacing.sm),
                    child: Text(
                      tie.gmDecides
                          ? l10n.combatTieGmHelp(tie.total)
                          : l10n.combatTiePlayersHelp(tie.total, players(tie)),
                      style: text.bodySmall!.copyWith(
                        color: colors.onAlertContainer,
                      ),
                    ),
                  ),
                ),
              ),
            SizedBox(height: AppSpacing.sm),
            Text(l10n.combatOrderNote, style: text.bodySmall),
          ],
        ),
      ),
    );
  }
}

/// Dé gardé d'un PJ (1 à 20), enregistré à la validation ou en quittant le
/// champ.
class _DieField extends StatefulWidget {
  const _DieField({required this.label, required this.onDie});

  final String label;
  final ValueChanged<int> onDie;

  @override
  State<_DieField> createState() => _DieFieldState();
}

class _DieFieldState extends State<_DieField> {
  final _focus = FocusNode();
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _focus.addListener(() {
      if (!_focus.hasFocus) _submit();
    });
  }

  @override
  void dispose() {
    _focus.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final die = int.tryParse(_controller.text);
    if (die != null && die >= 1 && die <= 20) widget.onDie(die);
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 96,
    child: TextField(
      controller: _controller,
      focusNode: _focus,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: InputDecoration(labelText: widget.label, isDense: true),
      onSubmitted: (_) => _submit(),
    ),
  );
}
