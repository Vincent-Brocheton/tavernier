import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../creation/subchoices.dart';
import '../l10n/app_localizations.dart';
import 'level_unlock_banner.dart';
import 'level_up_draft.dart';
import 'sheet_breakdowns.dart';
import 'sheet_page.dart';

enum _Step { classChoice, hitPoints, features, feat, spells, summary }

/// Une section de sorts à choisir.
typedef _SpellSection = ({
  String key,
  String title,
  int count,
  Set<String> ids,
});

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
  String get _classId => _draft.classId ?? _character.classLevels.first.classId;

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

  /// Sections de sorts du niveau gagné, dans l'ordre de l'écran.
  List<_SpellSection> _spellSections(AppLocalizations l10n, LevelGain gain) {
    final spells = spellGain(_content, _classId, gain.classLevel);
    final name = namesOf(_content, [_classId]);
    final book = {..._character.spells.spellbook, ...?_draft.spells[spellBook]}
      ..removeAll(_character.spells.prepared);
    // Thaumaturge : un sort mineur de plus, dans la liste de la classe.
    final bonus = [
      for (final choice in gain.choices)
        for (final option in choice.options)
          if (option.cantripListId == null &&
              (_draft.choices[choice.id]?.contains(option.pick) ?? false))
            option.bonusCantrips,
    ].fold(0, (sum, count) => sum + count);
    final cantrips = spells.cantrips + bonus;
    return [
      if (cantrips > 0)
        (
          key: spellCantrips,
          title: l10n.cantripsOf(name),
          count: cantrips,
          ids: spellsOfList(_content, _classId, 0, 0),
        ),
      if (spells.spellbook > 0)
        (
          key: spellBook,
          title: l10n.spellbookTitle,
          count: spells.spellbook,
          ids: spellsOfList(_content, _classId, 1, spells.maxLevel),
        ),
      if (spells.prepared > 0)
        (
          key: spellPrepared,
          title: l10n.preparedSpellsOf(name),
          count: spells.prepared,
          ids: spells.spellbook > 0
              ? book
              : spellsOfList(_content, _classId, 1, spells.maxLevel),
        ),
      for (final choice in gain.choices)
        for (final option in choice.options)
          if (_draft.choices[choice.id]?.contains(option.pick) ?? false)
            if (option.cantripListId case final list?)
              (
                key: spellAccess,
                title: l10n.cantripsOf(namesOf(_content, [list])),
                count: option.bonusCantrips,
                ids: spellsOfList(_content, list, 0, 0),
              ),
    ];
  }

  String? _missing(
    AppLocalizations l10n,
    _Step step,
    LevelGain gain,
    int slots,
  ) {
    switch (step) {
      case _Step.spells:
        final open = _spellSections(
          l10n,
          gain,
        ).any((s) => (_draft.spells[s.key]?.length ?? 0) != s.count);
        return open ? l10n.missingSpells : null;
      case _Step.classChoice:
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
        if (_draft.feat == magicInitiateFeat) {
          int chosen(String key) => _draft.featChoices[key]?.length ?? 0;
          return chosen(initiateList) == 1 &&
                  chosen(initiateAbility) == 1 &&
                  chosen(initiateCantrips) == magicInitiateCantrips &&
                  chosen(initiateSpell) == magicInitiateSpells
              ? null
              : l10n.missingLevelChoice;
        }
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
    final store = ref.read(characterStoreProvider);
    final from = computeSheet(_character, _content).level;
    try {
      final progression = await ref.read(
        sheetProgressionProvider((id: widget.id, level: from)).future,
      );
      await store.save(widget.id, after);
      // Montée sans validation du MJ, tracée dans l'historique (EF-SEA-06).
      await store.recordLevelUp(
        widget.id,
        byUserId: ref.read(currentUserProvider).value?.id,
        from: from,
        to: from + 1,
        unlock: progression?.unlock,
      );
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
      _Step.classChoice,
      _Step.hitPoints,
      _Step.features,
      if (gain.featCategories.isNotEmpty) _Step.feat,
      if (_spellSections(l10n, gain).isNotEmpty) _Step.spells,
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
          _Step.classChoice => _classChoice(l10n, text, before),
          _Step.hitPoints => _hitPoints(l10n, text, before, sheet),
          _Step.features => _features(l10n, text, gain, slots, before, sheet),
          _Step.feat => _feat(
            l10n,
            text,
            before,
            sheet,
            gain.featCategories.first,
          ),
          _Step.spells => _spells(l10n, text, gain),
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
            gain.classLevel == 1
                ? l10n.classLevel(name, 1)
                : l10n.levelFromTo(name, gain.classLevel - 1, gain.classLevel),
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

  /// Choix de la classe [G2] : les classes actuelles, puis les autres, celles
  /// dont le prérequis est rempli d'abord.
  List<Widget> _classChoice(
    AppLocalizations l10n,
    TextTheme text,
    ComputedSheet before,
  ) {
    String name(String id) => namesOf(_content, [id]);
    ClassData data(String id) => _content.entity(id)!.data as ClassData;
    ClassAccess access(String id) => classAccess(data(id), before.abilities);
    String status(ClassAccess value) => value.scores
        .map(
          (s) => value.open
              ? l10n.abilityReached(name(s.ability), s.score)
              : l10n.abilityMissing(
                  name(s.ability),
                  s.score,
                  multiclassMinimum - s.score,
                ),
        )
        .join(' · ');
    String needs(ClassData cls) => l10n.multiclassNeeds(
      cls.primaryAbilitiesAny ? 1 : cls.primaryAbilities.length,
      cls.primaryAbilities
          .map((id) => name('$id'))
          .join(cls.primaryAbilitiesAny ? l10n.abilityOr : l10n.abilityAnd),
      multiclassMinimum,
    );

    final current = {for (final c in _character.classLevels) c.classId};
    final eligible = current.every((id) => access(id).open);
    final others = [
      for (final entity in sortedEntities(_content, 'class'))
        if (!current.contains('${entity.id}')) '${entity.id}',
    ];
    final ordered = [
      ...others.where((id) => access(id).open),
      ...others.where((id) => !access(id).open),
    ];
    return [
      Text(l10n.classForLevel(before.level + 1), style: text.titleMedium),
      SizedBox(height: AppSpacing.xs),
      for (final level in _character.classLevels)
        SelectionCard(
          title: l10n.classLevel(name(level.classId), level.level + 1),
          subtitle: [
            l10n.continueClass,
            ...levelGain(
              _character,
              _content,
              level.classId,
            ).features.map((f) => f.name),
          ].join(' · '),
          selected: _classId == level.classId,
          onTap: () => _update((d) => d.selectClass(level.classId)),
        ),
      SizedBox(height: AppSpacing.sm),
      Text(l10n.multiclassHeading, style: text.titleSmall),
      SizedBox(height: AppSpacing.xs),
      for (final id in ordered)
        Opacity(
          opacity: access(id).open && eligible ? 1 : 0.6,
          child: SelectionCard(
            title: l10n.classLevel(name(id), 1),
            subtitle: '${needs(data(id))} · ${status(access(id))}',
            selected: _classId == id,
            onTap: access(id).open && eligible
                ? () => _update((d) => d.selectClass(id))
                : null,
          ),
        ),
      SizedBox(height: AppSpacing.xs),
      Text(l10n.multiclassRule(multiclassMinimum), style: text.bodySmall),
      for (final id in current)
        Text('${name(id)} : ${status(access(id))}', style: text.bodySmall),
    ];
  }

  List<Widget> _spells(AppLocalizations l10n, TextTheme text, LevelGain gain) {
    final known = {
      ...knownSpells(raisedOneLevel(_character, _classId), _content),
      ...?_draft.featChoices[initiateCantrips],
      ...?_draft.featChoices[initiateSpell],
    };
    final picked = {
      for (final MapEntry(:key, :value) in _draft.spells.entries)
        for (final spell in value) spell: key,
    };
    return [
      for (final section in _spellSections(l10n, gain)) ...[
        Text(
          l10n.spellSectionCount(
            section.title,
            _draft.spells[section.key]?.length ?? 0,
            section.count,
          ),
          style: text.titleMedium,
        ),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          children: [
            for (final spell in sortedEntities(_content, 'spell'))
              if (section.ids.contains('${spell.id}'))
                _spellChip(section, spell, known, picked),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        Text(l10n.spellKnownShort, style: text.bodySmall),
        SizedBox(height: AppSpacing.sm),
      ],
    ];
  }

  Widget _spellChip(
    _SpellSection section,
    ContentEntity spell,
    Set<String> known,
    Map<String, String> picked,
  ) {
    final id = '${spell.id}';
    final chosen = _draft.spells[section.key]?.contains(id) ?? false;
    // Le grimoire et les sorts préparés du Magicien sont les mêmes sorts.
    final elsewhere =
        picked[id] != null &&
        picked[id] != section.key &&
        !{spellBook, spellPrepared}.containsAll([picked[id], section.key]);
    final blocked = section.key == spellPrepared && _isWizard
        ? false
        : known.contains(id) || elsewhere;
    final full = (_draft.spells[section.key]?.length ?? 0) >= section.count;
    return FilterChip(
      label: Text(spell.name),
      selected: chosen,
      avatar: blocked ? const Icon(Icons.lock_outline, size: 16) : null,
      onSelected: chosen || (!blocked && (!full || section.count == 1))
          ? (_) => _update(
              (d) => section.key == spellBook
                  ? d.toggleSpellbook(id, section.count)
                  : d.toggleSpell(section.key, id, section.count),
            )
          : null,
    );
  }

  bool get _isWizard => spellbookSize(_classId) > 0;

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
    ComputedSheet after,
  ) {
    final cls = _content.entity(_classId)!.data as ClassData;
    final masteryWeapons = {
      for (final w in masteryOptions(_content, cls).weapons)
        if (after.proficientWeapons.contains('${w.id}')) '${w.id}',
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
          '${_choiceTitle(l10n, choice)} '
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

  String _choiceTitle(AppLocalizations l10n, OpenChoice choice) {
    final name = namesOf(_content, [choice.sourceId]);
    if (choice.id == multiclassSkillChoice(_classId)) {
      return l10n.multiclassSkill(name);
    }
    return choice.id == multiclassToolChoice(_classId)
        ? l10n.multiclassTool(name)
        : name;
  }

  /// Expertise : sur une compétence maîtrisée, et pas deux fois sur la même.
  /// La compétence d'une nouvelle classe compte, elle est maîtrisée à ce niveau.
  bool _optionBlocked(ChoiceOption option, ComputedSheet before) {
    final skill = _content.entity(option.pick);
    if (skill == null || !option.expertise) return false;
    final fresh = _draft.choices[multiclassSkillChoice(_classId)];
    if (fresh?.contains(option.pick) ?? false) return false;
    final breakdown = before.skillBreakdown[skillKey(skill)];
    if (breakdown == null) return false;
    final labels = breakdown.sources.map((c) => c.label);
    return !labels.contains('proficiency') || labels.contains('expertise');
  }

  /// Choix d'un Initié à la magie : liste, caractéristique, puis sorts.
  List<Widget> _initiate(
    AppLocalizations l10n,
    TextTheme text,
    ComputedSheet before,
  ) {
    final taken = {
      for (final feat in _character.feats)
        if (feat.featId == magicInitiateFeat) feat.choices?['spell_list'],
    };
    final list = _draft.featChoices[initiateList]?.firstOrNull;
    final known = knownSpells(raisedOneLevel(_character, _classId), _content);
    final other = {
      ...?_draft.spells[spellCantrips],
      ...?_draft.spells[spellPrepared],
      ...?_draft.spells[spellBook],
      ...?_draft.spells[spellAccess],
    };
    Widget chips(String title, String key, int count, int level) => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: AppSpacing.sm),
        Text(title, style: text.titleSmall),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xxs,
          children: [
            for (final spell in sortedEntities(_content, 'spell'))
              if (spellsOfList(
                _content,
                list!,
                level,
                level,
              ).contains('${spell.id}'))
                _chip(
                  spell.name,
                  _draft.featChoices[key]?.contains('${spell.id}') ?? false,
                  known.contains('${spell.id}') || other.contains('${spell.id}')
                      ? null
                      : () => _update(
                          (d) => d.toggleFeatChoice(key, '${spell.id}', count),
                        ),
                ),
          ],
        ),
      ],
    );

    return [
      SizedBox(height: AppSpacing.sm),
      Text(l10n.initiateListChoice, style: text.titleSmall),
      SizedBox(height: AppSpacing.xs),
      Wrap(
        spacing: AppSpacing.xs,
        children: [
          for (final id in magicInitiateLists)
            _chip(
              namesOf(_content, [id]),
              list == id,
              taken.contains(id)
                  ? null
                  : () => _update((d) => d.selectInitiateList(id)),
            ),
        ],
      ),
      if (taken.isNotEmpty) ...[
        SizedBox(height: AppSpacing.xs),
        Text(l10n.sameListRule, style: text.bodySmall),
      ],
      SizedBox(height: AppSpacing.sm),
      Text(l10n.initiateAbilityChoice, style: text.titleSmall),
      SizedBox(height: AppSpacing.xs),
      Wrap(
        spacing: AppSpacing.xs,
        children: [
          for (final id in magicInitiateAbilities)
            _chip(
              namesOf(_content, [id]),
              _draft.featChoices[initiateAbility]?.contains(id) ?? false,
              () => _update((d) => d.toggleFeatChoice(initiateAbility, id, 1)),
            ),
        ],
      ),
      if (list != null) ...[
        chips(
          l10n.initiateCantripChoice,
          initiateCantrips,
          magicInitiateCantrips,
          0,
        ),
        chips(l10n.initiateSpellChoice, initiateSpell, magicInitiateSpells, 1),
      ],
    ];
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
      if (category == 'general' &&
          featsForCategory(
            _content,
            category,
          ).any((f) => '${f.id}' == abilityScoreImprovementFeat)) ...[
        SuggestButton(
          onApply: () {
            final picks = suggestedImprovement(
              before,
              _content.entity(_classId)!.data as ClassData,
            );
            final mode = picks.length == 1
                ? ImprovementMode.two
                : ImprovementMode.oneAndOne;
            _update((d) {
              var next = d
                  .selectFeat(abilityScoreImprovementFeat)
                  .selectMode(mode);
              for (final code in picks) {
                if (!next.bonuses.contains(code)) {
                  next = next.toggleBonus(code, picks.length);
                }
              }
              return next;
            });
            return l10n.suggestImprovementReason(
              picks
                  .map((c) => namesOf(_content, [abilityIdByCode[c]!]))
                  .join(', '),
            );
          },
        ),
        SizedBox(height: AppSpacing.xs),
      ],
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
      if (_draft.feat == magicInitiateFeat) ..._initiate(l10n, text, before),
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

  String _dice(ComputedSheet sheet) =>
      sheet.hitDice.map((d) => '${d.total} ${d.die}').join(' + ');

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
        row(l10n.hitDiceLabel, _dice(before), _dice(after)),
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
