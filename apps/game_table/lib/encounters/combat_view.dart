// Écran de combat (US-20, EF-INI-05 à 07, [1a]) : ordre d'initiative,
// unité active, rappel de recharge, tour suivant, annulation, ajout et fin.
import 'dart:math';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../tables/tables_providers.dart';
import 'combatant_sheet.dart';
import 'concentration.dart';
import 'condition_sheets.dart';
import 'damage_keypad.dart';
import 'encounters_providers.dart';
import 'foe_picker.dart';
import 'hp_bar.dart';
import 'launch.dart';
import 'turn_reminders.dart';

/// Profil d'un combattant : son monstre, ou le monstre de départ d'un PNJ.
MonsterData? monsterOfCombatant(
  ActiveContent content,
  List<Npc> npcs,
  Combatant c,
) => switch (c.refId) {
  null => null,
  final ref => switch (content.entity(ref)?.data) {
    final MonsterData m => m,
    _ => monsterOf(
      content,
      npcs.where((n) => n.id == ref).firstOrNull?.monsterId,
    ),
  },
};

/// Écrit des événements au journal de [encounterId].
Future<void> appendCombat(
  WidgetRef ref,
  String encounterId,
  List<NewCombatEvent> events,
) => ref
    .read(combatStoreProvider)
    .append(
      encounterId,
      authorUserId: ref.read(currentUserProvider).value?.id,
      events,
    );

/// « Annuler », menu (ajout, fin) de l'en-tête du combat.
List<Widget> combatActions(
  BuildContext context,
  WidgetRef ref,
  Encounter encounter,
) {
  final l10n = AppLocalizations.of(context);
  final events = ref.watch(combatEventsProvider(encounter.id)).value;
  final undoable = events == null ? null : lastUndoable(events);
  return [
    IconButton(
      tooltip: l10n.combatUndo,
      icon: const Icon(Icons.undo),
      onPressed: undoable == null
          ? null
          : () => appendCombat(ref, encounter.id, [
              (CombatEventType.undo, {'event': undoable}),
            ]),
    ),
    PopupMenuButton<String>(
      onSelected: (action) async {
        if (action == 'add') {
          await _addCombatant(context, ref, encounter);
        } else {
          final confirmed = await showDialog<bool>(
            context: context,
            builder: (dialog) => AlertDialog(
              title: Text(l10n.combatFinish),
              content: Text(l10n.combatFinishBody(encounter.title)),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialog, false),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(dialog, true),
                  child: Text(l10n.combatFinish),
                ),
              ],
            ),
          );
          if (confirmed != true) return;
          await ref.read(combatStoreProvider).finish(encounter.id);
          if (context.mounted) context.pop();
        }
      },
      itemBuilder: (_) => [
        PopupMenuItem(value: 'add', child: Text(l10n.combatAdd)),
        PopupMenuItem(value: 'finish', child: Text(l10n.combatFinish)),
      ],
    ),
  ];
}

/// Renfort : un monstre ou un PNJ, numéroté après ses semblables, avec son
/// jet d'initiative.
Future<void> _addCombatant(
  BuildContext context,
  WidgetRef ref,
  Encounter encounter,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (sheet) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(sheet).height * 0.85,
      child: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          FoePicker(
            tableId: encounter.tableId,
            encounterId: encounter.id,
            onAdd: (kind, refId) async {
              final l10n = AppLocalizations.of(sheet);
              final content = await ref.read(contentProvider.future);
              final npcs = await ref.read(
                tableNpcsProvider(encounter.tableId).future,
              );
              final combat = await ref.read(
                combatStateProvider(encounter.id).future,
              );
              final npc = kind == 'npc'
                  ? npcs.where((n) => n.id == refId).firstOrNull
                  : null;
              final monster = monsterOf(content, npc?.monsterId ?? refId);
              final name = npc?.name ?? content.entity(refId)?.name;
              if (monster == null || name == null) {
                // Fiche complète : sa fiche se calcule au lancement seulement.
                if (!sheet.mounted) return;
                ScaffoldMessenger.of(
                  sheet,
                ).showSnackBar(SnackBar(content: Text(l10n.combatCannotJoin)));
                return;
              }
              final label = reinforcementLabel(name, [
                for (final c in combat.combatants) c.label,
              ]);
              final id = uuidV7();
              final random = Random();
              final roll = rollInitiative(
                monster.initiative,
                RollMode.normal,
                random,
              );
              await appendCombat(ref, encounter.id, [
                (
                  CombatEventType.combatantAdded,
                  profileCombatant(
                    id: id,
                    kind: kind,
                    refId: refId,
                    label: label,
                    monster: monster,
                    hpMode: encounter.hpMode,
                    random: random,
                  ),
                ),
                (
                  CombatEventType.initiativeRolled,
                  {'unit': id, 'dice': roll.dice, 'bonus': roll.bonus},
                ),
              ]);
              if (sheet.mounted) {
                Navigator.pop(sheet);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(l10n.combatJoined(label, roll.total))),
                );
              }
            },
          ),
        ],
      ),
    ),
  ),
);

/// Combat en cours : rappel de recharge, ordre d'initiative, cibles, et le
/// pied « Dégâts / Soins / PV temp. / Tour suivant ».
class CombatView extends ConsumerStatefulWidget {
  const CombatView({super.key, required this.encounter, required this.combat});

  final Encounter encounter;
  final CombatState combat;

  @override
  ConsumerState<CombatView> createState() => _CombatViewState();
}

class _CombatViewState extends ConsumerState<CombatView> {
  /// Cibles du pavé : toucher en choisit une, l'appui long en ajoute.
  final _targets = <String>{};

  Encounter get encounter => widget.encounter;
  CombatState get combat => widget.combat;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value;
    final npcs = ref.watch(tableNpcsProvider(encounter.tableId)).value;
    if (content == null || npcs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    // Un combattant retiré n'est plus une cible.
    _targets.removeWhere((id) => combat.combatant(id) == null);
    final targets = [for (final id in _targets) combat.combatant(id)!.label];
    Future<void> keypad(KeypadMode mode) =>
        showDamageKeypad(context, encounter, {..._targets}, mode);
    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              Wrap(
                spacing: AppSpacing.sm,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Chip(label: Text(l10n.combatRound(combat.round))),
                  Text(
                    l10n.combatCount(combat.combatants.length),
                    style: text.bodySmall,
                  ),
                ],
              ),
              TurnStartBanner(encounter: encounter, combat: combat),
              ConcentrationAlerts(encounter: encounter, combat: combat),
              _RechargeReminder(
                encounterId: encounter.id,
                combat: combat,
                content: content,
                npcs: npcs,
              ),
              for (final unit in combat.order) ...[
                if (combat.members(unit).length > 1)
                  Padding(
                    padding: EdgeInsets.only(top: AppSpacing.sm),
                    child: Text(
                      l10n.combatGroupHeader(
                        combat
                            .members(unit)
                            .first
                            .label
                            .replaceFirst(RegExp(r' \d+$'), ''),
                      ),
                      style: text.labelMedium,
                    ),
                  ),
                for (final c in combat.members(unit))
                  _CombatantCard(
                    encounter: encounter,
                    combat: combat,
                    combatant: c,
                    active: combat.active == unit,
                    targeted: _targets.contains(c.id),
                    subtitle: _subtitleOf(context, ref, content, npcs, c),
                    onTap: () => setState(
                      () => _targets
                        ..clear()
                        ..add(c.id),
                    ),
                    onLongPress: () => setState(
                      () => _targets.contains(c.id)
                          ? _targets.remove(c.id)
                          : _targets.add(c.id),
                    ),
                  ),
              ],
            ],
          ),
        ),
        // Pied : cibles, puis Dégâts / Soins / PV temp. et « Tour suivant »,
        // toujours accessible (EF-INI-05).
        SafeArea(
          top: false,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  targets.isEmpty
                      ? l10n.combatNoTarget
                      : l10n.combatTargets(targets.length, targets.join(', ')),
                  style: text.bodySmall,
                ),
                SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    for (final (mode, label, icon) in [
                      (KeypadMode.damage, l10n.combatDamage, Icons.flash_on),
                      (
                        KeypadMode.heal,
                        l10n.combatHeal,
                        Icons.add_circle_outline,
                      ),
                      (
                        KeypadMode.tempHp,
                        l10n.combatTempHp,
                        Icons.shield_moon_outlined,
                      ),
                    ])
                      Padding(
                        padding: EdgeInsets.only(right: AppSpacing.xs),
                        child: IconButton.filledTonal(
                          tooltip: label,
                          icon: Icon(icon),
                          onPressed: _targets.isEmpty
                              ? null
                              : () => keypad(mode),
                        ),
                      ),
                    Padding(
                      padding: EdgeInsets.only(right: AppSpacing.xs),
                      child: IconButton.filledTonal(
                        tooltip: l10n.combatCondition,
                        icon: const Icon(Icons.label_outline),
                        onPressed: _targets.isEmpty
                            ? null
                            : () => showAddCondition(context, encounter, {
                                ..._targets,
                              }),
                      ),
                    ),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: () =>
                            nextTurn(context, ref, encounter, combat),
                        icon: const Icon(Icons.skip_next),
                        label: Text(l10n.combatNextTurn),
                      ),
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

  String? _subtitleOf(
    BuildContext context,
    WidgetRef ref,
    ActiveContent content,
    List<Npc> npcs,
    Combatant c,
  ) {
    final l10n = AppLocalizations.of(context);
    if (monsterOfCombatant(content, npcs, c) case final monster?) {
      return l10n.combatMonsterLine(
        l10n.creatureType(monster.creatureType.name),
        monster.cr,
      );
    }
    final summary =
        (ref.watch(tableGroupProvider(encounter.tableId)).value ??
                const <CharacterSummary>[])
            .where((s) => s.id == c.refId)
            .firstOrNull;
    final classes = [
      for (final cl
          in summary?.classes ?? const <({String classId, int level})>[])
        l10n.classLevel(namesOf(content, [cl.classId]), cl.level),
    ].join(' / ');
    return c.kind == CombatantKind.pc
        ? (classes.isEmpty ? l10n.combatPcShort : l10n.combatPc(classes))
        : l10n.combatNpc;
  }
}

/// Début du tour de l'unité active : ses capacités à recharge épuisées.
class _RechargeReminder extends ConsumerWidget {
  const _RechargeReminder({
    required this.encounterId,
    required this.combat,
    required this.content,
    required this.npcs,
  });

  final String encounterId;
  final CombatState combat;
  final ActiveContent content;
  final List<Npc> npcs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final colors = GameColors.of(context);
    final active = combat.active;
    if (active == null) return const SizedBox.shrink();
    final due = [
      for (final c in combat.members(active))
        for (final counter in c.counters)
          if (counter.startsWith('recharge:') && c.remaining(counter) == 0)
            if (monsterOfCombatant(content, npcs, c)?.actions
                    .where((a) => a.name == counter.substring(9))
                    .firstOrNull
                    ?.uses
                    ?.recharge
                case final range?)
              (c, counter, range),
    ];
    if (due.isEmpty) return const SizedBox.shrink();
    return Card(
      color: colors.alertContainer,
      margin: EdgeInsets.only(top: AppSpacing.sm),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (c, counter, range) in due) ...[
              Text(
                l10n.combatRechargeReminder(
                  c.label,
                  counter.substring(9),
                  range.replaceAll('-', '–'),
                ),
                style: text.bodyMedium!.copyWith(
                  color: colors.onAlertContainer,
                ),
              ),
              Wrap(
                spacing: AppSpacing.sm,
                children: [
                  FilledButton(
                    onPressed: () async {
                      final roll = Random().nextInt(6) + 1;
                      final success = rechargeSucceeds(range, roll);
                      if (success) {
                        await appendCombat(ref, encounterId, [
                          (
                            CombatEventType.counterRestored,
                            {'combatant': c.id, 'counter': counter},
                          ),
                        ]);
                      }
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              success
                                  ? l10n.combatRecharged(roll)
                                  : l10n.combatNotRecharged(roll),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(l10n.combatRollD6),
                  ),
                  OutlinedButton(
                    onPressed: () => appendCombat(ref, encounterId, [
                      (
                        CombatEventType.counterRestored,
                        {'combatant': c.id, 'counter': counter},
                      ),
                    ]),
                    child: Text(l10n.combatRechargedManual),
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

/// Carte de combattant (`CombatantCard`, COMPOSANTS §2.1) : initiative,
/// nom, sorte, CA, PV et PV temporaires ; « En cours » pour l'unité active ;
/// à 0 PV, « Inconscient » et jets contre la mort, « Mort » ou « Hors de
/// combat ». Toucher la cible, l'appui long en ajoute une, l'icône ouvre
/// le détail.
class _CombatantCard extends StatelessWidget {
  const _CombatantCard({
    required this.encounter,
    required this.combat,
    required this.combatant,
    required this.active,
    required this.targeted,
    required this.subtitle,
    required this.onTap,
    required this.onLongPress,
  });

  final Encounter encounter;
  final CombatState combat;
  final Combatant combatant;
  final bool active;
  final bool targeted;
  final String? subtitle;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final c = combatant;
    final hp = c.hp;
    final hpMax = c.hpMax;
    final status = c.dead
        ? l10n.combatDead
        : c.unconscious
        ? (c.stable ? l10n.combatStable : l10n.combatUnconscious)
        : c.outOfCombat
        ? l10n.combatOutOfCombat
        : null;
    final card = Card(
      margin: EdgeInsets.only(top: AppSpacing.xs),
      color: active ? scheme.primaryContainer : null,
      shape: active || targeted
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              side: BorderSide(
                color: targeted ? scheme.tertiary : scheme.primary,
                width: 2,
              ),
            )
          : null,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: active ? scheme.primary : null,
                foregroundColor: active ? scheme.onPrimary : null,
                child: Text('${c.initiative?.total ?? '—'}'),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: AppSpacing.xs,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Text(c.label, style: text.titleMedium),
                        if (active)
                          Chip(
                            visualDensity: VisualDensity.compact,
                            avatar: const Icon(Icons.play_arrow, size: 16),
                            label: Text(l10n.combatActive),
                          ),
                      ],
                    ),
                    Text(status ?? subtitle ?? '', style: text.bodySmall),
                    if (hp != null && hpMax != null && hpMax > 0) ...[
                      SizedBox(height: AppSpacing.xxs),
                      HpBar(hp: hp, max: hpMax),
                    ],
                    if (c.unconscious && !c.stable)
                      Padding(
                        padding: EdgeInsets.only(top: AppSpacing.xxs),
                        child: DeathSavesRow(combatant: c),
                      ),
                    if (c.conditions.isNotEmpty)
                      ConditionChips(
                        encounter: encounter,
                        combat: combat,
                        combatant: c,
                      ),
                    if (c.concentration case final spell?)
                      ConcentrationChip(spell),
                    if (c.kind == CombatantKind.pc && !c.dead)
                      _ReactionChip(encounter: encounter, combatant: c),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (c.ac case final ac?)
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.shield_outlined, size: 16),
                        Text(' $ac', style: text.titleSmall),
                      ],
                    ),
                  if (hp != null && hpMax != null)
                    Text(l10n.combatHp(hp, hpMax), style: text.bodySmall),
                  if (c.tempHp > 0)
                    Text(
                      l10n.combatTempHpValue(c.tempHp),
                      style: text.labelSmall!.copyWith(color: colors.tempHp),
                    ),
                ],
              ),
              IconButton(
                tooltip: l10n.combatDetail,
                icon: const Icon(Icons.info_outline),
                onPressed: () => showCombatantSheet(context, encounter, c.id),
              ),
            ],
          ),
        ),
      ),
    );
    // Hors de combat ou mort : la carte reste, estompée.
    return c.outOfCombat || c.dead ? Opacity(opacity: 0.6, child: card) : card;
  }
}

/// « Réaction disponible / utilisée » d'un PJ (EF-INI-08) : un appui la
/// dépense ou la rend ; elle revient au début de son tour.
class _ReactionChip extends ConsumerWidget {
  const _ReactionChip({required this.encounter, required this.combatant});

  final Encounter encounter;
  final Combatant combatant;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final c = combatant;
    final available = c.remaining(reactionCounter) > 0;
    return ActionChip(
      visualDensity: VisualDensity.compact,
      avatar: Icon(
        available ? Icons.bolt : Icons.check_circle_outline,
        size: 16,
      ),
      label: Text(
        available ? l10n.combatReactionAvailable : l10n.combatReactionUsed,
      ),
      onPressed: () => appendCombat(ref, encounter.id, [
        (
          available
              ? CombatEventType.counterUsed
              : CombatEventType.counterRestored,
          {'combatant': c.id, 'counter': reactionCounter},
        ),
      ]),
    );
  }
}

/// Jets contre la mort (`DeathSaves`, COMPOSANTS §2.7) : trois cercles de
/// réussite, trois carrés d'échec, avec une icône en plus de la couleur.
class DeathSavesRow extends StatelessWidget {
  const DeathSavesRow({super.key, required this.combatant});

  final Combatant combatant;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = GameColors.of(context);
    final scheme = Theme.of(context).colorScheme;
    Widget mark(bool filled, bool success) => Container(
      width: 18,
      height: 18,
      margin: EdgeInsets.only(right: AppSpacing.xxs),
      decoration: BoxDecoration(
        shape: success ? BoxShape.circle : BoxShape.rectangle,
        color: filled ? (success ? colors.heal : colors.damage) : null,
        border: Border.all(color: success ? colors.heal : colors.damage),
      ),
      child: filled
          ? Icon(
              success ? Icons.check : Icons.close,
              size: 14,
              color: scheme.surface,
            )
          : null,
    );
    return Semantics(
      label: l10n.combatDeathSavesLabel(
        combatant.deathSuccesses,
        combatant.deathFailures,
      ),
      child: ExcludeSemantics(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < 3; i++)
              mark(i < combatant.deathSuccesses, true),
            SizedBox(width: AppSpacing.sm),
            for (var i = 0; i < 3; i++)
              mark(i < combatant.deathFailures, false),
          ],
        ),
      ),
    );
  }
}
