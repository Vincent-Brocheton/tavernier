import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_draft.dart';
import 'creation_providers.dart';
import 'step_layout.dart';
import 'subchoices.dart';

/// Titre d'une section, aussi cité par la raison du blocage.
String subchoiceTitle(
  AppLocalizations l10n,
  Subchoice section,
  CreationDraft draft,
  ActiveContent content,
) => switch (section.kind) {
  SubchoiceKind.classSkills => l10n.classSkillsOf(
    namesOf(content, [draft.classId!]),
  ),
  SubchoiceKind.classTools => l10n.classToolsTitle,
  SubchoiceKind.masteries => l10n.weaponMasteryTitle,
  SubchoiceKind.fightingStyle => l10n.fightingStyleTitle,
  SubchoiceKind.originFeat => l10n.originFeatTitle,
  SubchoiceKind.effect => switch (section.title) {
    final title? => l10n.choiceTitle(
      namesOf(content, [section.sourceId!]),
      title,
    ),
    null => namesOf(content, [section.sourceId!]),
  },
  SubchoiceKind.cantrips => l10n.cantripsOf(namesOf(content, [draft.classId!])),
  SubchoiceKind.spellbook => l10n.spellbookTitle,
  SubchoiceKind.preparedSpells => l10n.preparedSpellsOf(
    namesOf(content, [draft.classId!]),
  ),
  SubchoiceKind.initiateList => l10n.initiateListTitle(
    _initiateName(section, content),
  ),
  SubchoiceKind.initiateAbility => l10n.initiateAbilityTitle(
    _initiateName(section, content),
  ),
  SubchoiceKind.initiateCantrips => l10n.initiateCantripsTitle(
    _initiateName(section, content),
  ),
  SubchoiceKind.initiateSpell => l10n.initiateSpellTitle(
    _initiateName(section, content),
  ),
};

/// Nom du don, avec sa liste de sorts une fois connue.
String _initiateName(Subchoice section, ActiveContent content) {
  final name = namesOf(content, [section.sourceId!]);
  return section.listId == null
      ? name
      : '$name (${namesOf(content, [section.listId!])})';
}

/// Étape 6, Sous-choix [P5].
class SubchoicesStep extends ConsumerWidget {
  const SubchoicesStep({super.key, required this.content});

  final ActiveContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draft = ref.watch(creationProvider);
    final sections = subchoiceSections(draft, content);
    return StepLayout(
      detail: _ToComplete(sections: sections, draft: draft, content: content),
      list: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          for (final section in sections) ...[
            _Section(section: section, draft: draft, content: content),
            SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    );
  }
}

class _Section extends ConsumerWidget {
  const _Section({
    required this.section,
    required this.draft,
    required this.content,
  });

  final Subchoice section;
  final CreationDraft draft;
  final ActiveContent content;

  void _toggle(WidgetRef ref, String id) => ref
      .read(creationProvider.notifier)
      .update((d) => d.toggleOption(section, id));

  /// Compétences et bottes se suggèrent (EF-PJ-15).
  Widget? _suggest(AppLocalizations l10n, WidgetRef ref) {
    final data = content.entity(draft.classId!)!.data as ClassData;
    final free = [
      for (final option in section.options)
        if (option.block == null) option.id,
    ];
    return switch (section.kind) {
      SubchoiceKind.classSkills => SuggestButton(
        onApply: () {
          final picks = suggestedSkills(content, data, free, section.count);
          ref
              .read(creationProvider.notifier)
              .update((d) => d.withClassSkills(picks));
          return l10n.suggestSkillsReason;
        },
      ),
      SubchoiceKind.masteries => SuggestButton(
        onApply: () {
          final picks = suggestedMasteries(data, free, section.count);
          ref
              .read(creationProvider.notifier)
              .update((d) => d.withMasteries(picks));
          return l10n.suggestMasteriesReason;
        },
      ),
      _ => null,
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final feats =
        section.kind == SubchoiceKind.fightingStyle ||
        section.kind == SubchoiceKind.originFeat;
    final known = [
      for (final o in section.options)
        if (o.block == OptionBlock.known) o.label,
    ];
    final expertise = section.options.any(
      (o) => o.block == OptionBlock.notProficient,
    );
    final sameList = section.options.any(
      (o) => o.block == OptionBlock.sameList,
    );
    final knownSpells = [
      for (final o in section.options)
        if (o.block == OptionBlock.spellKnown) o.label,
    ];
    final invalid = section.invalid;
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppRadii.lg),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_suggest(l10n, ref) case final button?) ...[
            Align(alignment: Alignment.centerLeft, child: button),
            SizedBox(height: AppSpacing.xs),
          ],
          Row(
            children: [
              Expanded(
                child: Text(
                  subchoiceTitle(l10n, section, draft, content),
                  style: text.titleMedium,
                ),
              ),
              Text(
                l10n.countOf(section.chosen.length, section.count),
                style: text.labelLarge,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          if (feats)
            CardGrid(
              minWidth: 260,
              children: [
                for (final option in section.options)
                  _featCard(ref, l10n, option),
              ],
            )
          else
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: [
                for (final option in section.options) _chip(ref, option),
              ],
            ),
          if (invalid.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.choiceToRedo(invalid.map((o) => o.label).join(', ')),
                style: text.bodySmall!.copyWith(color: scheme.error),
              ),
            ),
          if (known.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.alreadyKnownRule(known.join(', ')),
                style: text.bodySmall,
              ),
            ),
          if (expertise)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Text(l10n.expertiseRule, style: text.bodySmall),
            ),
          if (sameList)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Text(l10n.sameListRule, style: text.bodySmall),
            ),
          if (knownSpells.isNotEmpty)
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.xs),
              child: Text(
                l10n.spellKnownRule(knownSpells.join(', ')),
                style: text.bodySmall,
              ),
            ),
        ],
      ),
    );
  }

  Widget _chip(WidgetRef ref, SubchoiceOption option) {
    final chosen = section.chosen.contains(option.id);
    final full = section.count > 1 && section.chosen.length >= section.count;
    final blocked = option.block != null;
    return FilterChip(
      label: Text(
        option.detail == null
            ? option.label
            : '${option.label} · ${option.detail}',
      ),
      avatar: blocked && !chosen
          ? const Icon(Icons.lock_outline, size: 16)
          : null,
      selected: chosen,
      // Un choix devenu invalide reste touchable, pour le retirer.
      onSelected: chosen || (!blocked && !full)
          ? (_) => _toggle(ref, option.id)
          : null,
    );
  }

  Widget _featCard(
    WidgetRef ref,
    AppLocalizations l10n,
    SubchoiceOption option,
  ) {
    final blocked = option.block == OptionBlock.notRepeatable;
    final card = SelectionCard(
      title: option.label,
      subtitle: blocked ? l10n.featNotRepeatable : option.detail,
      selected: section.chosen.contains(option.id),
      onTap: blocked ? null : () => _toggle(ref, option.id),
    );
    return blocked ? Opacity(opacity: 0.6, child: card) : card;
  }
}

/// Panneau « À compléter » : l'état de chaque section.
class _ToComplete extends StatelessWidget {
  const _ToComplete({
    required this.sections,
    required this.draft,
    required this.content,
  });

  final List<Subchoice> sections;
  final CreationDraft draft;
  final ActiveContent content;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(l10n.toComplete, style: text.titleMedium),
        for (final section in sections)
          Padding(
            padding: EdgeInsets.only(top: AppSpacing.sm),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  section.complete ? Icons.check_circle : Icons.error_outline,
                  size: 20,
                  color: section.complete ? scheme.primary : scheme.error,
                ),
                SizedBox(width: AppSpacing.xs),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subchoiceTitle(l10n, section, draft, content),
                        style: text.titleSmall,
                      ),
                      Text(
                        _state(l10n, section),
                        style: text.bodySmall!.copyWith(
                          color: section.complete
                              ? scheme.onSurfaceVariant
                              : scheme.error,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  String _state(AppLocalizations l10n, Subchoice section) {
    // Plus de sélections que de places : l'Ordre divin a changé.
    if (section.invalid.isNotEmpty || section.chosen.length > section.count) {
      return l10n.stepToRedo;
    }
    if (!section.complete) {
      return l10n.choicesLeft(section.count - section.chosen.length);
    }
    return [
      for (final option in section.options)
        if (section.chosen.contains(option.id)) option.label,
    ].join(', ');
  }
}
