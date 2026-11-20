// Écran « En combat » du joueur (US-36, EF-VJ-01 à 06, [J1] à [J3]) : la
// vue publiée par l'appareil du MJ, et les demandes du joueur pour son PJ.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../account/sync_state.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../sheet/combat_tab.dart';
import '../sheet/conflicts.dart';
import '../sheet/rest_sheet.dart';
import '../sheet/sheet_breakdowns.dart';
import '../sheet/simple_roll.dart';
import '../sheet/spells_tab.dart';
import 'hp_bar.dart';
import 'player_sync.dart';

/// Combat en cours où figure le PJ [id] ; `null` hors combat (EF-VJ-01).
final characterCombatProvider = StreamProvider.autoDispose
    .family<PublishedCombatView?, String>(
      (ref, id) => ref.watch(combatViewStoreProvider).watchCharacter(id),
    );

/// Vrai si [view] montre le PJ [id] joué par l'utilisateur [me].
bool isMyCombat(PublishedCombatView? view, String id, String? me) =>
    me != null &&
    _orderOf(view?.payload ?? const {})
        .any((o) => o['character'] == id && o['owner'] == me);

List<Map<String, Object?>> _orderOf(Map<String, Object?> view) => [
  for (final o in (view['order'] as List?) ?? const [])
    Map<String, Object?>.from(o as Map),
];

String _health(AppLocalizations l10n, Object? health) => switch (health) {
  'wounded' => l10n.healthWounded,
  'badly' => l10n.healthBadly,
  'down' => l10n.combatUnconscious,
  'dead' => l10n.combatDead,
  _ => l10n.healthUnhurt,
};

/// Écran « En combat » du PJ [id] : bandeau du tour, son PJ, ses actions et
/// ses sorts ; « Fiche complète » ([onSheet]) ramène à la fiche.
class PlayerCombatScreen extends ConsumerStatefulWidget {
  const PlayerCombatScreen({
    super.key,
    required this.id,
    required this.content,
    required this.character,
    required this.sheet,
    required this.view,
    required this.onSheet,
  });

  final String id;
  final ActiveContent content;
  final CharacterInput character;
  final ComputedSheet sheet;
  final PublishedCombatView view;
  final VoidCallback onSheet;

  @override
  ConsumerState<PlayerCombatScreen> createState() => _PlayerCombatState();
}

class _PlayerCombatState extends ConsumerState<PlayerCombatScreen> {
  /// Économie d'actions cochée pendant son tour (EF-VJ-02), remise à zéro
  /// à chaque tour.
  final _used = <String>{};
  Object? _turn;

  Map<String, Object?> get _view => widget.view.payload;

  Future<void> _send(String type, [Map<String, Object?> payload = const {}]) =>
      ref
          .read(combatRequestStoreProvider)
          .send(
            encounterId: widget.view.encounterId,
            tableId: widget.view.tableId,
            characterId: widget.id,
            authorUserId: ref.read(currentUserProvider).value?.id,
            type: type,
            payload: payload,
          );

  Future<void> _askAmount(String title, String type) async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final amount = await showDialog<int>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(title),
        content: TextField(
          controller: controller,
          autofocus: true,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          decoration: InputDecoration(labelText: l10n.playerCombatHpField),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () =>
                Navigator.pop(dialog, int.tryParse(controller.text)),
            child: Text(l10n.playerCombatSend),
          ),
        ],
      ),
    );
    // Pas de dispose : le champ vit encore pendant la fermeture animée.
    if (amount != null && amount > 0) await _send(type, {'amount': amount});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final round = (_view['round'] as int?) ?? 0;
    final active = _view['active'] as String?;
    final order = _orderOf(_view);
    final me = order.where((o) => o['character'] == widget.id).firstOrNull;
    final myTurn = active != null && me?['unit'] == active;
    if (_turn != (round, active)) {
      _turn = (round, active);
      _used.clear();
    }
    final offline =
        ref.watch(syncIndicatorProvider)?.state == SyncIndicatorState.offline;
    final pending =
        ref.watch(combatRequestsProvider(widget.view.encounterId)).value ??
        const [];
    final title = [
      l10n.playerCombatTitle((_view['title'] as String?) ?? '', round),
      if (widget.view.updatedAt case final at? when offline)
        l10n.playerCombatLastKnown(
          TimeOfDay.fromDateTime(at.toLocal()).format(context),
        ),
    ].join(' · ');
    final playing = order.where((o) => o['active'] == true).firstOrNull;
    final until = turnsUntil(_view, widget.id);
    final headline = myTurn
        ? l10n.playerCombatYourTurn
        : active == null
        ? l10n.playerCombatNotStarted
        : [
            if (playing != null)
              l10n.playerCombatTurnOf(playing['label']! as String),
            if (until != null && !offline) l10n.playerCombatIn(until),
          ].join(' · ');
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ColoredBox(
            color: myTurn ? scheme.primaryContainer : scheme.surface,
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: text.bodySmall),
                  Text(headline, style: text.titleLarge),
                  if (myTurn) ...[
                    SizedBox(height: AppSpacing.xs),
                    Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: [
                        for (final (key, label) in [
                          ('action', l10n.economyAction),
                          ('bonus', l10n.actionBonus),
                          ('reaction', l10n.economyReaction),
                          ('move', l10n.economyMove),
                        ])
                          FilterChip(
                            label: Text(label),
                            selected: _used.contains(key),
                            onSelected: (used) => setState(
                              () => used ? _used.add(key) : _used.remove(key),
                            ),
                          ),
                      ],
                    ),
                  ],
                  if (offline) ...[
                    SizedBox(height: AppSpacing.xs),
                    Text(l10n.playerCombatOffline, style: text.bodyMedium),
                  ],
                  if (pending.isNotEmpty)
                    Text(
                      l10n.playerCombatPending(pending.length),
                      style: text.bodySmall,
                    ),
                ],
              ),
            ),
          ),
          TabBar(
            tabs: [
              Tab(text: l10n.playerCombatTabMine),
              Tab(text: l10n.playerCombatTabActions),
              Tab(text: l10n.tabSpells),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _Mine(
                  id: widget.id,
                  content: widget.content,
                  sheet: widget.sheet,
                  view: _view,
                  offline: offline,
                  send: _send,
                  askAmount: _askAmount,
                ),
                CombatTab(
                  id: widget.id,
                  content: widget.content,
                  character: widget.character,
                  sheet: widget.sheet,
                ),
                SpellsTab(
                  id: widget.id,
                  content: widget.content,
                  character: widget.character,
                  sheet: widget.sheet,
                  // Le journal du MJ suit la concentration (EF-VJ-04).
                  onConcentration: (spell) => spell == null
                      ? _send('concentration_ended')
                      : _send('concentration_started', {'spell': spell}),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onSheet,
                    child: Text(l10n.playerCombatSheet),
                  ),
                ),
                if (myTurn) ...[
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: FilledButton(
                      onPressed: () => _send('turn_advanced'),
                      child: Text(l10n.playerCombatEndTurn),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Onglet « Mon personnage » : PV, jets demandés, états reçus, ordre du tour.
class _Mine extends ConsumerWidget {
  const _Mine({
    required this.id,
    required this.content,
    required this.sheet,
    required this.view,
    required this.offline,
    required this.send,
    required this.askAmount,
  });

  final String id;
  final ActiveContent content;
  final ComputedSheet sheet;
  final Map<String, Object?> view;
  final bool offline;
  final Future<void> Function(String, [Map<String, Object?>]) send;
  final Future<void> Function(String title, String type) askAmount;

  String _duration(AppLocalizations l10n, Map<String, Object?> c) =>
      switch (c['duration']) {
        'rounds' => l10n.chipRounds((c['rounds'] as int?) ?? 1),
        'turn_start' => l10n.chipTurnStart((c['of'] as String?) ?? '?'),
        'turn_end' => l10n.chipTurnEnd((c['of'] as String?) ?? '?'),
        'save' => l10n.chipSave(
          abbreviation(l10n, (c['ability'] as String?) ?? 'str'),
          (c['dc'] as int?) ?? 0,
        ),
        _ => '',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final pc = Map<String, Object?>.from(
      ((view['pcs'] as Map?)?[id] as Map?) ?? const {},
    );
    final hp = (pc['hp'] as int?) ?? 0;
    final max = (pc['hp_max'] as int?) ?? 0;
    final temp = (pc['temp_hp'] as int?) ?? 0;
    final death = pc['death'] as Map?;
    final checks = (pc['checks'] as List?) ?? const [];
    final conditions = [
      for (final c in (pc['conditions'] as List?) ?? const [])
        Map<String, Object?>.from(c as Map),
    ];
    final round = (view['round'] as int?) ?? 0;
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Card(
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Wrap(
                  spacing: AppSpacing.sm,
                  runSpacing: AppSpacing.xs,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Text(l10n.combatHp(hp, max), style: text.headlineMedium),
                    if (temp > 0)
                      Chip(label: Text(l10n.combatTempHpValue(temp))),
                    if (pc['concentration'] case final String spell)
                      Chip(
                        avatar: const Icon(Icons.adjust),
                        label: Text(spell),
                      ),
                    Chip(
                      label: Text(
                        pc['reaction'] == true
                            ? l10n.combatReactionAvailable
                            : l10n.combatReactionUsed,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.xs),
                HpBar(hp: hp, max: max),
                SizedBox(height: AppSpacing.sm),
                Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: [
                    for (final (label, type) in [
                      (l10n.combatDamage, 'damage'),
                      (l10n.combatHeal, 'heal'),
                      (l10n.combatTempHp, 'temp_hp'),
                    ])
                      FilledButton.tonal(
                        onPressed: () => askAmount(label, type),
                        child: Text(label),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
        if (checks.isNotEmpty)
          _SaveRequest(
            key: ValueKey(('check', round, checks.length)),
            check: Map<String, Object?>.from(checks.first as Map),
            spell: (pc['concentration'] as String?) ?? '',
            bonus: sheet.savingThrows['con'] ?? 0,
            onResult: (success) =>
                send('concentration_check', {'success': success}),
          ),
        if (death != null && death['stable'] != true && death['dead'] != true)
          _DeathSave(
            key: ValueKey(('death', death['successes'], death['failures'])),
            death: death,
            onResult: (outcome) => send('death_save', {'outcome': outcome}),
          ),
        for (final c in conditions)
          Card(
            child: ListTile(
              title: Text(switch (c['condition']) {
                exhaustionCondition => exhaustionLabel(
                  l10n,
                  (c['levels'] as int?) ?? 1,
                ),
                final String id => namesOf(content, [id]),
                _ => (c['label'] as String?) ?? '',
              }),
              subtitle: switch (c['concentration']) {
                final String caster => Text(l10n.playerCombatFrom(caster)),
                _ => null,
              },
              trailing: Text(_duration(l10n, c)),
            ),
          ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.playerCombatOrder, style: text.titleMedium),
        for (final o in _orderOf(view)) _OrderRow(entry: o, mine: id),
        if (offline)
          Text(l10n.playerCombatOfflineOrder, style: text.bodySmall)
        else
          Text(l10n.playerCombatFoesNote, style: text.bodySmall),
      ],
    );
  }
}

class _OrderRow extends ConsumerWidget {
  const _OrderRow({required this.entry, required this.mine});

  final Map<String, Object?> entry;
  final String mine;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final pc = entry['kind'] == 'pc';
    final player = switch (entry['owner']) {
      final String owner when pc => ref.watch(pseudonymOfProvider(owner)).value,
      _ => null,
    };
    return Card(
      color: entry['active'] == true
          ? Theme.of(context).colorScheme.primaryContainer
          : null,
      child: ListTile(
        title: Text(entry['label']! as String),
        subtitle: switch ((entry['active'] == true, pc)) {
          (true, _) => Text(l10n.playerCombatPlaying),
          (_, true) when entry['character'] == mine => Text(
            l10n.playerCombatYou,
          ),
          (_, true) => Text(l10n.playerCombatPc(player ?? '')),
          _ => null,
        },
        trailing: Text(
          pc ? _health(l10n, entry['health']) : l10n.playerCombatFoe,
        ),
      ),
    );
  }
}

/// Test de concentration demandé ([J5], EF-VJ-05).
class _SaveRequest extends StatefulWidget {
  const _SaveRequest({
    super.key,
    required this.check,
    required this.spell,
    required this.bonus,
    required this.onResult,
  });

  final Map<String, Object?> check;
  final String spell;
  final int bonus;
  final ValueChanged<bool> onResult;

  @override
  State<_SaveRequest> createState() => _SaveRequestState();
}

class _SaveRequestState extends State<_SaveRequest> {
  int? _dice;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final dc = (widget.check['dc'] as int?) ?? 10;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.playerCombatSaveRequested, style: text.titleMedium),
            Text(l10n.playerCombatConcentrationOn(widget.spell, dc)),
            Text(
              l10n.playerCombatDamageTaken(
                (widget.check['damage'] as int?) ?? 0,
              ),
              style: text.bodySmall,
            ),
            SimpleRoll(
              formula: DiceFormula(1, 20, bonus: widget.bonus),
              bonusLabel: abbreviation(l10n, 'con'),
              onChanged: (v) => setState(() => _dice = v),
            ),
            Text(l10n.playerCombatRollNote, style: text.bodySmall),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: switch (_dice) {
                  final dice? when !_sent => () {
                    setState(() => _sent = true);
                    widget.onResult(dice + widget.bonus >= dc);
                  },
                  _ => null,
                },
                child: Text(l10n.playerCombatSend),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Jet contre la mort demandé ([J6], EF-VJ-05).
class _DeathSave extends StatefulWidget {
  const _DeathSave({super.key, required this.death, required this.onResult});

  final Map<Object?, Object?> death;
  final ValueChanged<String> onResult;

  @override
  State<_DeathSave> createState() => _DeathSaveState();
}

class _DeathSaveState extends State<_DeathSave> {
  int? _dice;
  bool _sent = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.combatDeathSaves, style: text.titleMedium),
            Text(
              '${l10n.deathSuccess} ${widget.death['successes']} · '
              '${l10n.deathFailure} ${widget.death['failures']}',
            ),
            SimpleRoll(
              formula: const DiceFormula(1, 20),
              onChanged: (v) => setState(() => _dice = v),
            ),
            Text(l10n.playerCombatRollNote, style: text.bodySmall),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton(
                onPressed: switch (_dice) {
                  final dice? when !_sent => () {
                    setState(() => _sent = true);
                    widget.onResult(deathSaveOutcome(dice));
                  },
                  _ => null,
                },
                child: Text(l10n.playerCombatSend),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
