// Détail d'un combattant (US-20, EF-INI-07, [C8]) : CA, PV, profil,
// compteurs (actions et résistances légendaires, réaction, recharges),
// retrait du combat.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../npcs/stat_block_view.dart';
import 'combat_view.dart';
import 'encounters_providers.dart';

/// Ouvre le détail du combattant [id] de [encounter].
Future<void> showCombatantSheet(
  BuildContext context,
  Encounter encounter,
  String id,
) => showModalBottomSheet<void>(
  context: context,
  isScrollControlled: true,
  builder: (_) => SafeArea(
    child: SizedBox(
      height: MediaQuery.sizeOf(context).height * 0.85,
      child: _CombatantDetail(encounter: encounter, id: id),
    ),
  ),
);

class _CombatantDetail extends ConsumerWidget {
  const _CombatantDetail({required this.encounter, required this.id});

  final Encounter encounter;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final combat = ref.watch(combatStateProvider(encounter.id)).value;
    final content = ref.watch(contentProvider).value;
    final npcs = ref.watch(tableNpcsProvider(encounter.tableId)).value;
    final c = combat?.combatant(id);
    if (c == null || content == null || npcs == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final monster = monsterOfCombatant(content, npcs, c);
    String counterLabel(String counter) => switch (counter) {
      reactionCounter => l10n.combatReaction,
      legendaryActionsCounter => l10n.combatLegendaryActions,
      'legendary_resistance' => l10n.combatLegendaryResistance,
      _ => l10n.combatRechargeCounter(counter.substring(9)),
    };
    Future<void> use(String counter) => appendCombat(ref, encounter.id, [
      (CombatEventType.counterUsed, {'combatant': c.id, 'counter': counter}),
    ]);
    Future<void> restore(String counter) => appendCombat(ref, encounter.id, [
      (
        CombatEventType.counterRestored,
        {'combatant': c.id, 'counter': counter},
      ),
    ]);
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Text(c.label, style: text.headlineSmall),
        Wrap(
          spacing: AppSpacing.md,
          children: [
            if (c.ac case final ac?) Text(l10n.combatAc(ac)),
            if ((c.hp, c.hpMax) case (final hp?, final max?))
              Text(l10n.combatHp(hp, max)),
          ],
        ),
        if (c.unconscious && !c.stable) ...[
          SizedBox(height: AppSpacing.md),
          Text(l10n.combatDeathSaves, style: text.titleSmall),
          SizedBox(height: AppSpacing.xs),
          DeathSavesRow(combatant: c),
          SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final (outcome, label) in [
                ('success', l10n.deathSuccess),
                ('failure', l10n.deathFailure),
                ('nat1', l10n.deathNat1),
                ('nat20', l10n.deathNat20),
              ])
                OutlinedButton(
                  onPressed: () => appendCombat(ref, encounter.id, [
                    (
                      CombatEventType.deathSave,
                      {'combatant': c.id, 'outcome': outcome},
                    ),
                  ]),
                  child: Text(label),
                ),
            ],
          ),
        ],
        if (c.stable && c.unconscious) Text(l10n.combatStable),
        if (c.dead) Text(l10n.combatDead),
        SizedBox(height: AppSpacing.md),
        for (final counter in c.counters)
          Card(
            margin: EdgeInsets.only(bottom: AppSpacing.xs),
            child: Padding(
              padding: EdgeInsets.all(AppSpacing.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          counterLabel(counter),
                          style: text.titleSmall,
                        ),
                      ),
                      Text(
                        counter == reactionCounter
                            ? (c.remaining(counter) > 0
                                  ? l10n.combatAvailable
                                  : l10n.combatUsed)
                            : l10n.combatRemaining(
                                c.remaining(counter),
                                c.max(counter),
                              ),
                        style: text.bodySmall,
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Wrap(
                    spacing: AppSpacing.xs,
                    children: [
                      for (var i = 0; i < c.max(counter); i++)
                        _Pip(
                          full: i < c.remaining(counter),
                          label: counterLabel(counter),
                          onTap: () => i < c.remaining(counter)
                              ? use(counter)
                              : restore(counter),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        if (monster != null) ...[
          SizedBox(height: AppSpacing.md),
          StatBlockView(monster: monster, content: content),
        ],
        SizedBox(height: AppSpacing.md),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () async {
              await appendCombat(ref, encounter.id, [
                (CombatEventType.combatantRemoved, {'combatant': c.id}),
              ]);
              if (context.mounted) Navigator.pop(context);
            },
            icon: const Icon(Icons.person_remove_outlined),
            label: Text(l10n.combatRemove),
          ),
        ),
      ],
    );
  }
}

/// Pion d'un compteur : plein (disponible) ou vide (utilisé), 48 dp.
class _Pip extends StatelessWidget {
  const _Pip({required this.full, required this.label, required this.onTap});

  final bool full;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Semantics(
      button: true,
      label: full ? l10n.combatPipUse(label) : l10n.combatPipRestore(label),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox.square(
          dimension: 48,
          child: Center(
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: full ? scheme.primary : null,
                border: Border.all(color: scheme.primary, width: 2),
              ),
              child: full
                  ? null
                  : Icon(Icons.close, size: 16, color: scheme.primary),
            ),
          ),
        ),
      ),
    );
  }
}
