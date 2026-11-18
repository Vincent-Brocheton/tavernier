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
import 'encounters_providers.dart';
import 'foe_picker.dart';
import 'launch.dart';

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

/// Combat en cours : rappel de recharge, ordre d'initiative.
class CombatView extends ConsumerWidget {
  const CombatView({super.key, required this.encounter, required this.combat});

  final Encounter encounter;
  final CombatState combat;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value;
    final npcs = ref.watch(tableNpcsProvider(encounter.tableId)).value;
    if (content == null || npcs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    return ListView(
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
              combatant: c,
              active: combat.active == unit,
              subtitle: _subtitleOf(context, ref, content, npcs, c),
            ),
        ],
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
/// nom, sorte, CA, PV ; « En cours » pour l'unité active.
class _CombatantCard extends StatelessWidget {
  const _CombatantCard({
    required this.encounter,
    required this.combatant,
    required this.active,
    required this.subtitle,
  });

  final Encounter encounter;
  final Combatant combatant;
  final bool active;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final colors = GameColors.of(context);
    final c = combatant;
    final hp = c.hp;
    final hpMax = c.hpMax;
    return Card(
      margin: EdgeInsets.only(top: AppSpacing.xs),
      color: active ? scheme.primaryContainer : null,
      shape: active
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadii.md),
              side: BorderSide(color: scheme.primary, width: 2),
            )
          : null,
      child: InkWell(
        onTap: () => showCombatantSheet(context, encounter, c.id),
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
                    if (subtitle case final s?) Text(s, style: text.bodySmall),
                    if (hp != null && hpMax != null && hpMax > 0) ...[
                      SizedBox(height: AppSpacing.xxs),
                      LinearProgressIndicator(
                        value: (hp / hpMax).clamp(0.0, 1.0),
                        color: colors.heal,
                      ),
                    ],
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
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
