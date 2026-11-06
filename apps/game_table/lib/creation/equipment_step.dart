import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_draft.dart';
import 'creation_providers.dart';
import 'draft_input.dart';
import 'step_layout.dart';

/// Un objet et sa quantité (« Javeline × 8 »).
String itemLabel(ActiveContent content, Object id, int quantity) {
  final name = namesOf(content, [id]);
  return quantity > 1 ? '$name × $quantity' : name;
}

/// Étape 7, Équipement [P6].
class EquipmentStep extends ConsumerWidget {
  const EquipmentStep({super.key, required this.content});

  final ActiveContent content;

  String _content(
    AppLocalizations l10n,
    List<ItemQuantity> items,
    int gold, {
    bool tool = false,
  }) => [
    for (final item in items) itemLabel(content, item.item, item.quantity),
    if (tool) l10n.lotTool,
    l10n.goldPieces(gold),
  ].join(', ');

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final draft = ref.watch(creationProvider);
    final notifier = ref.read(creationProvider.notifier);
    final cls = content.entity(draft.classId!)!.data as ClassData;
    final background =
        content.entity(draft.backgroundId!)!.data as BackgroundData;
    final lot = draft.classEquipment;
    final categories = lot == null
        ? const <ToolCategory>[]
        : cls.startingEquipment[lot].toolChoice;
    final complete = missingAt(draft, 6, content) == null;
    final input = complete ? toCharacterInput(draft, content) : null;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(namesOf(content, [draft.classId!]), style: text.titleMedium),
          SizedBox(height: AppSpacing.xs),
          CardGrid(
            minWidth: 260,
            children: [
              for (final (i, lot) in cls.startingEquipment.indexed)
                SelectionCard(
                  title: l10n.lotName(String.fromCharCode(65 + i)),
                  subtitle: _content(
                    l10n,
                    lot.items,
                    lot.gold,
                    tool: lot.toolChoice.isNotEmpty,
                  ),
                  selected: draft.classEquipment == i,
                  onTap: () =>
                      notifier.update((d) => d.selectClassEquipment(i)),
                ),
            ],
          ),
          if (categories.isNotEmpty) ...[
            SizedBox(height: AppSpacing.sm),
            Text(l10n.lotToolChoice, style: text.titleSmall),
            SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: [
                for (final tool in sortedEntities(content, 'tool'))
                  if (categories.contains((tool.data as ToolData).category))
                    ChoiceChip(
                      label: Text(tool.name.split(' : ').last),
                      selected: draft.equipmentTool == '${tool.id}',
                      onSelected: (_) => notifier.update(
                        (d) => d.selectEquipmentTool('${tool.id}'),
                      ),
                    ),
              ],
            ),
          ],
          SizedBox(height: AppSpacing.md),
          Text(
            namesOf(content, [draft.backgroundId!]),
            style: text.titleMedium,
          ),
          SizedBox(height: AppSpacing.xs),
          CardGrid(
            minWidth: 260,
            children: [
              SelectionCard(
                title: l10n.lotName('A'),
                subtitle: _content(
                  l10n,
                  background.equipmentA,
                  background.goldA,
                ),
                selected: draft.backgroundEquipment == 0,
                onTap: () =>
                    notifier.update((d) => d.selectBackgroundEquipment(0)),
              ),
              SelectionCard(
                title: l10n.lotName('B'),
                subtitle: l10n.goldPieces(background.goldB),
                selected: draft.backgroundEquipment == 1,
                onTap: () =>
                    notifier.update((d) => d.selectBackgroundEquipment(1)),
              ),
            ],
          ),
          if (input != null) ...[
            SizedBox(height: AppSpacing.md),
            DetailRow(
              l10n.armorClassWithEquipment,
              '${computeSheet(input, content).armorClass.value}',
            ),
            DetailRow(
              l10n.startingGold,
              l10n.goldPieces(input.coins['gp'] ?? 0),
            ),
          ],
          SizedBox(height: AppSpacing.md),
        ],
      ),
    );
  }
}
