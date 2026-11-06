import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_providers.dart';
import 'step_layout.dart';
import 'subchoices.dart';

/// Étape 3, Espèce [P3].
class SpeciesStep extends ConsumerWidget {
  const SpeciesStep({super.key, required this.content});

  final ActiveContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final phone =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone;
    final draft = ref.watch(creationProvider);
    final species = sortedEntities(content, 'species');
    final selected = draft.speciesId == null
        ? null
        : content.entity(draft.speciesId!);

    return StepLayout(
      detail: selected == null ? null : SpeciesDetail(selected, content),
      list: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final entity in species) ...[
            _card(ref, l10n, entity, '${entity.id}' == draft.speciesId, phone),
            SizedBox(height: AppSpacing.xs),
          ],
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
    final data = entity.data as SpeciesData;
    final sizes = data.sizes.join(' ${l10n.orWord} ');
    return SelectionCard(
      title: entity.name,
      subtitle: namesOf(content, data.traits.take(3)),
      trailing: '$sizes · ${formatFeet(data.speedFeet)}',
      selected: selected,
      onTap: () => ref
          .read(creationProvider.notifier)
          .update((d) => d.selectSpecies('${entity.id}', data.sizes)),
      child: phone && selected ? SpeciesDetail(entity, content) : null,
    );
  }
}

/// Taille à choisir et traits de l'espèce.
class SpeciesDetail extends ConsumerWidget {
  const SpeciesDetail(this.entity, this.content, {super.key});

  final ContentEntity entity;
  final ActiveContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = entity.data as SpeciesData;
    final text = Theme.of(context).textTheme;
    final size = ref.watch(creationProvider.select((d) => d.size));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (data.sizes.length > 1) ...[
          DetailHeading(l10n.labelSizeCategory),
          SegmentedButton<String>(
            emptySelectionAllowed: true,
            showSelectedIcon: false,
            segments: [
              for (final value in data.sizes)
                ButtonSegment(value: value, label: Text(value)),
            ],
            selected: {?size},
            onSelectionChanged: (values) {
              if (values.isEmpty) return;
              ref
                  .read(creationProvider.notifier)
                  .update((d) => d.selectSize(values.single));
            },
          ),
        ],
        for (final id in data.traits)
          if (content.entity('$id') case final trait?)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Text.rich(
                TextSpan(
                  style: text.bodySmall,
                  children: [
                    TextSpan(
                      text: trait.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if ((trait.data as FeatureData).level case final level?
                        when level > 1)
                      TextSpan(text: ' ${l10n.traitFromLevel(level)}'),
                    TextSpan(text: '. ${firstSentence(trait.textFr ?? '')}'),
                  ],
                ),
              ),
            ),
      ],
    );
  }
}
