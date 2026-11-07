import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../creation/subchoices.dart';
import '../l10n/app_localizations.dart';
import 'level_up_draft.dart';
import 'sheet_breakdowns.dart';
import 'sheet_page.dart';

enum _Step { hitPoints, features, feat, summary }

/// Montée de niveau [P10], [P11].
class LevelUpPage extends ConsumerWidget {
  const LevelUpPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final content = ref.watch(contentProvider).asData?.value;
    final character = ref.watch(characterProvider(id));
    return Scaffold(
      body: SafeArea(
        child: switch ((content, character)) {
          (final content?, AsyncData(value: final character?)) => _Wizard(
            id: id,
            content: content,
            character: character,
          ),
          (_, AsyncData(value: null)) ||
          (_, AsyncError()) => const CharacterNotFound(),
          _ => const Center(child: CircularProgressIndicator()),
        },
      ),
    );
  }
}

class _Wizard extends ConsumerStatefulWidget {
  const _Wizard({
    required this.id,
    required this.content,
    required this.character,
  });

  final String id;
  final ActiveContent content;
  final CharacterInput character;

  @override
  ConsumerState<_Wizard> createState() => _WizardState();
}

class _WizardState extends ConsumerState<_Wizard> {
  LevelUpDraft _draft = const LevelUpDraft();
  int _index = 0;
  bool _saving = false;

  ActiveContent get _content => widget.content;

  /// Le personnage tel qu'à l'ouverture : enregistrer le relit, et l'assistant
  /// ne doit pas recalculer un niveau de plus pendant qu'il se ferme.
  late final CharacterInput _character = widget.character;
  String get _classId => _character.classLevels.first.classId;

  void _update(LevelUpDraft Function(LevelUpDraft) change) =>
      setState(() => _draft = change(_draft));

  /// Bonus attendus du don retenu : 2 pour une Amélioration à +1 et +1, 1 pour
  /// les autres, aucun si le don n'en demande pas.
  int get _bonusCount {
    if (_draft.feat == null) return 0;
    if (_draft.feat == abilityScoreImprovementFeat) {
      return _draft.mode == ImprovementMode.two ? 1 : 2;
    }
    return _bonusChoice != null ? 1 : 0;
  }

  /// `choice` d'un don à +1 (Empoigneur) : ses options citent des bonus.
  Effect? get _bonusChoice {
    final effects = _content.entity(_draft.feat ?? '')?.effects ?? const [];
    for (final effect in effects) {
      if (effect.op != 'choice') continue;
      final options = effect.args['options']! as List<Object?>;
      final first = (options.first! as List<Object?>).first!;
      if ((first as Map<String, Object?>)['op'] == 'ability_bonus') {
        return effect;
      }
    }
    return null;
  }

  List<OpenChoice> get _featOptions => _draft.feat == null
      ? const []
      : [
          for (final choice in openChoices(_content, [_draft.feat!]))
            if (choice.options.isNotEmpty) choice,
        ];

  String? _missing(
    AppLocalizations l10n,
    _Step step,
    LevelGain gain,
    int slots,
  ) {
    switch (step) {
      case _Step.hitPoints:
      case _Step.summary:
        return null;
      case _Step.features:
        if (gain.subclasses.isNotEmpty && _draft.subclassId == null) {
          return l10n.missingSubclass;
        }
        final open = gain.choices.any(
          (c) => (_draft.choices[c.id]?.length ?? 0) != c.count,
        );
        if (open) return l10n.missingLevelChoice;
        return _draft.masteries.length == slots ? null : l10n.missingMastery;
      case _Step.feat:
        if (_draft.feat == null) return l10n.missingFeat;
        if (_draft.bonuses.length != _bonusCount) return l10n.missingFeatBonus;
        final open = _featOptions.any(
          (c) => (_draft.featChoices[c.id]?.length ?? 0) != c.count,
        );
        return open ? l10n.missingLevelChoice : null;
    }
  }

  Future<void> _save(AppLocalizations l10n, CharacterInput after) async {
    if (_saving) return;
    setState(() => _saving = true);
    try {
      await ref.read(characterStoreProvider).save(widget.id, after);
    } on Exception {
      if (mounted) {
        setState(() => _saving = false);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.saveFailed)));
      }
      return;
    }
    ref
      ..invalidate(characterProvider(widget.id))
      ..invalidate(charactersProvider);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final gain = levelGain(
      _character,
      _content,
      _classId,
      subclassId: _draft.subclassId,
      picks: _draft.choices,
    );
    final before = computeSheet(_character, _content);
    final after = applyLevelUp(_character, _classId, _draft.toChoices());
    final sheet = computeSheet(after, _content);
    final slots = sheet.weaponMasterySlots - before.weaponMasterySlots;
    final steps = [
      _Step.hitPoints,
      _Step.features,
      if (gain.featCategories.isNotEmpty) _Step.feat,
      _Step.summary,
    ];
    final step = steps[_index];
    final last = step == _Step.summary;
    final phone =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.phone;
    final changes = _Changes(content: _content, before: before, after: sheet);
    final body = SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: switch (step) {
          _Step.hitPoints => _hitPoints(l10n, text, before, sheet),
          _Step.features => _features(l10n, text, gain, slots, before),
          _Step.feat => _feat(
            l10n,
            text,
            before,
            sheet,
            gain.featCategories.first,
          ),
          _Step.summary => [
            Text(l10n.levelUpReady, style: text.titleMedium),
            for (final feature in gain.features)
              DetailRow(l10n.featuresGained, feature.name),
            if (_draft.feat case final feat?)
              DetailRow(l10n.filterFeats, namesOf(_content, [feat])),
            SizedBox(height: AppSpacing.sm),
            if (phone) changes,
            if (sheet.integrityErrors.isNotEmpty)
              for (final error in sheet.integrityErrors)
                StatusBanner(title: l10n.ruleError, message: error.message),
            if (_hasSpells) Text(l10n.spellsNotYet, style: text.bodySmall),
          ],
        },
      ),
    );
    final name = namesOf(_content, [_classId]);
    final blocked =
        _missing(l10n, step, gain, slots) ??
        (last && sheet.integrityErrors.isNotEmpty ? l10n.missingRules : null);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(_character.name, style: text.bodyMedium),
          Text(l10n.levelUpTitle, style: text.labelMedium),
          Text(
            l10n.levelFromTo(name, gain.classLevel - 1, gain.classLevel),
            style: text.headlineSmall,
          ),
          Text(l10n.stepOf(_index + 1, steps.length), style: text.bodySmall),
          SizedBox(height: AppSpacing.sm),
          Expanded(
            child: phone
                ? body
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: body),
                      SizedBox(width: AppSpacing.lg),
                      SizedBox(
                        width: 300,
                        child: SingleChildScrollView(child: changes),
                      ),
                    ],
                  ),
          ),
          WizardFooter(
            previousLabel: l10n.previous,
            nextLabel: last ? l10n.saveCharacter : l10n.next,
            onPrevious: _index == 0
                ? () => context.pop()
                : () => setState(() => _index--),
            onNext: last
                ? () => _save(l10n, after)
                : () => setState(() => _index++),
            blockedReason: blocked,
          ),
        ],
      ),
    );
  }

  bool get _hasSpells {
    final data = _content.entity(_classId)?.data;
    return data is ClassData && data.spellList.isNotEmpty;
  }

  List<Widget> _hitPoints(
    AppLocalizations l10n,
    TextTheme text,
    ComputedSheet before,
    ComputedSheet after,
  ) => [
    Text(
      l10n.hitPointsGain(after.hitPointsMax.value - before.hitPointsMax.value),
      style: text.titleLarge,
    ),
    Text(l10n.hitPointsAverage, style: text.bodyMedium),
  ];

  Widget _chip(String label, bool chosen, VoidCallback? onTap) => FilterChip(
    label: Text(label),
    selected: chosen,
    onSelected: onTap == null ? null : (_) => onTap(),
  );

  List<Widget> _features(
    AppLocalizations l10n,
    TextTheme text,
    LevelGain gain,
    int slots,
    ComputedSheet before,
  ) {
    final cls = _content.entity(_classId)!.data as ClassData;
    final masteryWeapons = {
      for (final w in masteryOptions(_content, cls).weapons) '${w.id}',
    };
    final taken = {for (final m in _character.weaponMasteries) m.weaponId};
    return [
      Text(l10n.featuresGained, style: text.titleMedium),
      for (final feature in gain.features)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(feature.name),
          subtitle: Text(firstSentence(feature.textFr ?? '')),
        ),
      if (gain.subclasses.isNotEmpty) ...[
        SizedBox(height: AppSpacing.sm),
        Text(l10n.subclassTitle, style: text.titleMedium),
        SizedBox(height: AppSpacing.xs),
        CardGrid(
          minWidth: 260,
          children: [
            for (final subclass in gain.subclasses)
              SelectionCard(
                title: subclass.name,
                subtitle: firstSentence(subclass.textFr ?? ''),
                selected: _draft.subclassId == '${subclass.id}',
                onTap: () =>
                    _update((d) => d.copyWith(subclassId: '${subclass.id}')),
              ),
          ],
        ),
      ],
      for (final choice in gain.choices) ...[
        SizedBox(height: AppSpacing.sm),
        Text(
          '${namesOf(_content, [choice.sourceId])} '
          '${(_draft.choices[choice.id]?.length ?? 0)} / ${choice.count}',
          style: text.titleMedium,
        ),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          children: [
            for (final option in choice.options)
              _chip(
                option.label,
                _draft.choices[choice.id]?.contains(option.pick) ?? false,
                _optionBlocked(option, before)
                    ? null
                    : () => _update(
                        (d) =>
                            d.togglePick(choice.id, option.pick, choice.count),
                      ),
              ),
          ],
        ),
      ],
      if (slots > 0) ...[
        SizedBox(height: AppSpacing.sm),
        Text(l10n.masteriesGained(slots), style: text.titleMedium),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          children: [
            for (final weapon in sortedEntities(_content, 'weapon'))
              if (masteryWeapons.contains('${weapon.id}') &&
                  !taken.contains('${weapon.id}'))
                _chip(
                  weapon.name,
                  _draft.masteries.contains('${weapon.id}'),
                  () => _update((d) => d.toggleMastery('${weapon.id}', slots)),
                ),
          ],
        ),
      ],
    ];
  }

  /// Expertise : sur une compétence maîtrisée, et pas deux fois sur la même.
  bool _optionBlocked(ChoiceOption option, ComputedSheet before) {
    final skill = _content.entity(option.pick);
    if (skill == null || !option.expertise) return false;
    final breakdown = before.skillBreakdown[skillKey(skill)];
    if (breakdown == null) return false;
    final labels = breakdown.sources.map((c) => c.label);
    return !labels.contains('proficiency') || labels.contains('expertise');
  }

  String _blockReason(AppLocalizations l10n, FeatBlock block) =>
      switch (block) {
        FeatBlock.level => l10n.featBlockLevel,
        FeatBlock.ability => l10n.featBlockAbility,
        FeatBlock.feature => l10n.featBlockFeature,
        FeatBlock.notRepeatable => l10n.featBlockNotRepeatable,
      };

  List<Widget> _feat(
    AppLocalizations l10n,
    TextTheme text,
    ComputedSheet before,
    ComputedSheet after,
    String category,
  ) {
    final level = after.level;
    final offered = {
      for (final feat in featsForCategory(_content, category)) feat.id,
    };
    final feats = [
      for (final feat in sortedEntities(_content, 'feat'))
        if (offered.contains(feat.id)) feat,
    ];
    final bonusCodes = _draft.feat == abilityScoreImprovementFeat
        ? abilityCodes
        : _bonusChoice == null
        ? const <String>[]
        : [
            for (final option
                in _bonusChoice!.args['options']! as List<Object?>)
              ((option! as List<Object?>).first!
                      as Map<String, Object?>)['ability']!
                  as String,
          ];
    final increment =
        _draft.feat == abilityScoreImprovementFeat &&
            _draft.mode == ImprovementMode.two
        ? 2
        : 1;
    return [
      Text(
        category == 'general' ? l10n.featChoiceTitle : l10n.featChoiceOther,
        style: text.titleMedium,
      ),
      Text(l10n.featChoiceHint, style: text.bodySmall),
      SizedBox(height: AppSpacing.xs),
      CardGrid(
        minWidth: 260,
        children: [
          for (final feat in feats)
            if (featBlock(feat, _character, before, level, _content)
                case final block)
              Opacity(
                opacity: block == null ? 1 : 0.6,
                child: SelectionCard(
                  title: feat.name,
                  subtitle: block == null
                      ? firstSentence(feat.textFr ?? '')
                      : _blockReason(l10n, block),
                  selected: _draft.feat == '${feat.id}',
                  onTap: block != null
                      ? null
                      : () => _update((d) => d.selectFeat('${feat.id}')),
                ),
              ),
        ],
      ),
      if (_draft.feat == abilityScoreImprovementFeat) ...[
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            ChoiceChip(
              label: Text(l10n.improvementTwo),
              selected: _draft.mode == ImprovementMode.two,
              onSelected: (_) =>
                  _update((d) => d.selectMode(ImprovementMode.two)),
            ),
            ChoiceChip(
              label: Text(l10n.improvementOneAndOne),
              selected: _draft.mode == ImprovementMode.oneAndOne,
              onSelected: (_) =>
                  _update((d) => d.selectMode(ImprovementMode.oneAndOne)),
            ),
          ],
        ),
      ],
      if (bonusCodes.isNotEmpty) ...[
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          children: [
            for (final code in bonusCodes)
              _chip(
                '${abbreviation(l10n, code)} '
                '${before.abilities[code]!.value}',
                _draft.bonuses.contains(code),
                before.abilities[code]!.value + increment > abilityScoreCap
                    ? null
                    : () => _update((d) => d.toggleBonus(code, _bonusCount)),
              ),
          ],
        ),
      ],
      for (final choice in _featOptions) ...[
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          children: [
            for (final option in choice.options)
              _chip(
                option.label,
                _draft.featChoices[choice.id]?.contains(option.pick) ?? false,
                () => _update(
                  (d) =>
                      d.toggleFeatChoice(choice.id, option.pick, choice.count),
                ),
              ),
          ],
        ),
      ],
    ];
  }
}

/// Panneau « Ce qui change » [P10] : deux fiches comparées.
class _Changes extends StatelessWidget {
  const _Changes({
    required this.content,
    required this.before,
    required this.after,
  });

  final ActiveContent content;
  final ComputedSheet before;
  final ComputedSheet after;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    Widget row(String label, Object from, Object to) =>
        DetailRow(label, '$from → $to');
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.whatChanges, style: text.titleMedium),
        row(
          l10n.statHitPoints,
          before.hitPointsMax.value,
          after.hitPointsMax.value,
        ),
        row(
          l10n.statProficiency,
          formatSigned(before.proficiencyBonus),
          formatSigned(after.proficiencyBonus),
        ),
        row(
          l10n.hitDiceLabel,
          '${before.hitDice.total} ${before.hitDice.die}',
          '${after.hitDice.total} ${after.hitDice.die}',
        ),
        row(
          l10n.weaponMasteryTitle,
          before.weaponMasterySlots,
          after.weaponMasterySlots,
        ),
        for (final code in abilityCodes)
          if (before.abilities[code]!.value != after.abilities[code]!.value)
            row(
              namesOf(content, [abilityIdByCode[code]!]),
              before.abilities[code]!.value,
              after.abilities[code]!.value,
            ),
      ],
    );
  }
}
