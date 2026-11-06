import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_providers.dart';
import 'step_layout.dart';

/// Nom du don d'origines, avec sa liste de sorts imposée (« Initié à la
/// magie (Clerc) »).
String _featName(ActiveContent content, BackgroundData data) {
  final name = namesOf(content, [data.originFeat]);
  final list = data.originFeatChoices?['spell_list'];
  return list == null
      ? name
      : '$name (${namesOf(content, ['srd:class:$list'])})';
}

/// Étape 2, Historique [P2].
class BackgroundStep extends ConsumerWidget {
  const BackgroundStep({super.key, required this.content});

  final ActiveContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final phone =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone;
    final draft = ref.watch(creationProvider);
    final backgrounds = sortedEntities(content, 'background');
    final selected = draft.backgroundId == null
        ? null
        : content.entity(draft.backgroundId!);

    return StepLayout(
      detail: selected == null ? null : BackgroundDetail(selected, content),
      list: CardGrid(
        children: [
          for (final entity in backgrounds)
            _card(
              ref,
              l10n,
              entity,
              '${entity.id}' == draft.backgroundId,
              phone,
            ),
        ],
      ),
    );
  }

  Widget _card(
    WidgetRef ref,
    AppLocalizations l10n,
    ContentEntity entity,
    bool selected,
    bool phone,
  ) {
    final data = entity.data as BackgroundData;
    return SelectionCard(
      title: entity.name,
      subtitle:
          '${namesOf(content, data.abilities)}\n'
          '${l10n.featLine(_featName(content, data))}',
      selected: selected,
      onTap: () => ref
          .read(creationProvider.notifier)
          .update((d) => d.selectBackground('${entity.id}')),
      footer: [sourceBadgeOf(l10n, content, '${entity.id}')],
      child: phone && selected
          ? BackgroundDetail(entity, content, compact: true)
          : null,
    );
  }
}

/// Détail d'un Historique. [compact] : dans la carte sélectionnée, sans titre.
class BackgroundDetail extends ConsumerWidget {
  const BackgroundDetail(
    this.entity,
    this.content, {
    super.key,
    this.compact = false,
  });

  final ContentEntity entity;
  final ActiveContent content;
  final bool compact;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = entity.data as BackgroundData;
    final text = Theme.of(context).textTheme;
    final feat = content.entity('${data.originFeat}');
    final category = data.toolChoiceCategory;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!compact)
          Row(
            children: [
              Expanded(
                child: Text(
                  entity.name,
                  style: text.titleLarge!.copyWith(
                    color: Theme.of(context).colorScheme.tertiary,
                  ),
                ),
              ),
              sourceBadgeOf(l10n, content, '${entity.id}'),
            ],
          ),
        DetailHeading(l10n.labelEligibleAbilities),
        Text(namesOf(content, data.abilities), style: text.bodyMedium),
        Text(l10n.bonusSpread, style: text.bodySmall),
        DetailHeading(l10n.labelOriginFeat),
        Text(_featName(content, data), style: text.titleSmall),
        if (feat?.textFr case final description?)
          Text(description, style: text.bodySmall),
        DetailHeading(l10n.labelSkills),
        Text(namesOf(content, data.skillProficiencies), style: text.bodyMedium),
        DetailHeading(l10n.labelTool),
        if (data.toolProficiency case final tool?)
          Text(namesOf(content, [tool]), style: text.bodyMedium),
        if (category != null) ...[
          Text(
            l10n.toolChoiceLine(_toolCategory(l10n, category)),
            style: text.bodyMedium,
          ),
          _ToolChoice(content: content, category: category),
        ],
      ],
    );
  }
}

class _ToolChoice extends ConsumerWidget {
  const _ToolChoice({required this.content, required this.category});

  final ActiveContent content;
  final ToolCategory category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final chosen = ref.watch(creationProvider.select((d) => d.toolChoice));
    final tools = sortedEntities(
      content,
      'tool',
    ).where((e) => (e.data as ToolData).category == category).toList();
    return Semantics(
      label: l10n.labelToolChoice,
      child: Wrap(
        spacing: AppSpacing.xs,
        runSpacing: AppSpacing.xxs,
        children: [
          for (final tool in tools)
            ChoiceChip(
              // « Boîte de jeux : dés » : la catégorie est déjà affichée.
              label: Text(tool.name.split(' : ').last),
              selected: chosen == '${tool.id}',
              onSelected: (_) => ref
                  .read(creationProvider.notifier)
                  .update((d) => d.selectTool('${tool.id}')),
            ),
        ],
      ),
    );
  }
}

String _toolCategory(AppLocalizations l10n, ToolCategory category) =>
    switch (category) {
      ToolCategory.gamingSet => l10n.toolGamingSet,
      ToolCategory.musicalInstrument => l10n.toolMusicalInstrument,
      ToolCategory.artisan => l10n.toolArtisan,
      ToolCategory.other => '',
    };
