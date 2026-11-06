import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_providers.dart';
import 'step_layout.dart';

enum _Filter { all, martial, casters, homebrew }

bool _isMartial(ClassData data) =>
    data.weaponProficiencies.any((w) => w.startsWith('martial'));

bool _isHomebrew(ContentEntity entity) => entity.id.namespace != 'srd';

/// Caractéristiques principales, jointes par « ou » si l'une suffit.
String primaryOf(
  AppLocalizations l10n,
  ActiveContent content,
  ClassData data,
) => namesOf(
  content,
  data.primaryAbilities,
  separator: ' ${data.primaryAbilitiesAny ? l10n.orWord : l10n.andWord} ',
);

/// Étape 1, Classe [P1].
class ClassStep extends ConsumerStatefulWidget {
  const ClassStep({super.key, required this.content});

  final ActiveContent content;

  @override
  ConsumerState<ClassStep> createState() => _ClassStepState();
}

class _ClassStepState extends ConsumerState<ClassStep> {
  var _filter = _Filter.all;
  var _query = '';

  ActiveContent get _content => widget.content;

  bool _matches(ContentEntity entity) {
    final data = entity.data as ClassData;
    final query = _query.trim().toLowerCase();
    return entity.name.toLowerCase().contains(query) &&
        switch (_filter) {
          _Filter.all => true,
          _Filter.martial => _isMartial(data),
          _Filter.casters => data.spellcastingAbility != null,
          _Filter.homebrew => _isHomebrew(entity),
        };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final phone =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone;
    final draft = ref.watch(creationProvider);
    final classes = sortedEntities(_content, 'class');
    final shown = classes.where(_matches).toList();
    final selected = draft.classId == null
        ? null
        : _content.entity(draft.classId!);
    final filters = [
      (_Filter.all, l10n.filterAll),
      (_Filter.martial, l10n.filterMartial),
      (_Filter.casters, l10n.filterCasters),
      if (classes.any(_isHomebrew)) (_Filter.homebrew, l10n.filterHomebrew),
    ];

    return StepLayout(
      detail: selected == null ? null : ClassDetail(selected, _content),
      list: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: l10n.searchClass,
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: (value) => setState(() => _query = value),
          ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xxs,
            children: [
              for (final (filter, label) in filters)
                ChoiceChip(
                  label: Text(label),
                  selected: _filter == filter,
                  onSelected: (_) => setState(() => _filter = filter),
                ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          if (shown.isEmpty)
            Text(l10n.noResult)
          else
            CardGrid(
              children: [
                for (final entity in shown)
                  _card(l10n, entity, draft.classId, phone),
              ],
            ),
        ],
      ),
    );
  }

  Widget _card(
    AppLocalizations l10n,
    ContentEntity entity,
    String? selectedId,
    bool phone,
  ) {
    final data = entity.data as ClassData;
    final selected = '${entity.id}' == selectedId;
    return SelectionCard(
      title: entity.name,
      subtitle: l10n.classPrimary(primaryOf(l10n, _content, data)),
      selected: selected,
      onTap: () => ref
          .read(creationProvider.notifier)
          .update((d) => d.selectClass('${entity.id}')),
      footer: [
        SourceBadge(l10n.classHitDie(data.hitDie)),
        sourceBadgeOf(l10n, _content, '${entity.id}'),
      ],
      child: phone && selected
          ? ClassDetail(entity, _content, compact: true)
          : null,
    );
  }
}

/// Détail d'une classe. [compact] : dans la carte sélectionnée, sans titre.
class ClassDetail extends StatelessWidget {
  const ClassDetail(
    this.entity,
    this.content, {
    super.key,
    this.compact = false,
  });

  final ContentEntity entity;
  final ActiveContent content;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final data = entity.data as ClassData;
    final text = Theme.of(context).textTheme;
    final firstLevel = data.levels.firstOrNull?.features ?? const [];
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
        DetailRow(l10n.labelPrimary, primaryOf(l10n, content, data)),
        DetailRow(l10n.labelHitDie, l10n.hitDiePerLevel(data.hitDie)),
        DetailRow(
          l10n.labelSaves,
          namesOf(content, data.savingThrows, separator: ' ${l10n.andWord} '),
        ),
        DetailRow(
          l10n.labelSkills,
          l10n.skillsAmong(
            data.skillChoiceCount,
            namesOf(content, data.skillChoices),
          ),
        ),
        DetailRow(
          l10n.labelWeapons,
          data.weaponProficiencies.map((w) => _weapon(l10n, w)).join(', '),
        ),
        DetailRow(
          l10n.labelArmor,
          data.armorTraining.isEmpty
              ? l10n.armorNone
              : data.armorTraining.map((a) => _armor(l10n, a)).join(', '),
        ),
        if (firstLevel.isNotEmpty) ...[
          DetailHeading(l10n.labelAtLevel1),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xxs,
            children: [
              for (final feature in firstLevel)
                SourceBadge(content.entity('$feature')?.name ?? '$feature'),
            ],
          ),
        ],
      ],
    );
  }
}

String _weapon(AppLocalizations l10n, String value) => switch (value) {
  'simple' => l10n.weaponSimple,
  'martial' => l10n.weaponMartial,
  'martial_light' => l10n.weaponMartialLight,
  'martial_finesse_or_light' => l10n.weaponMartialFinesseOrLight,
  _ => value,
};

String _armor(AppLocalizations l10n, String value) => switch (value) {
  'light' => l10n.armorLight,
  'medium' => l10n.armorMedium,
  'heavy' => l10n.armorHeavy,
  'shield' => l10n.armorShield,
  _ => value,
};
