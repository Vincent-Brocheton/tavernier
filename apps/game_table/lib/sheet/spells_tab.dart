import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'sheet_breakdowns.dart';
import 'sheet_page.dart';
import 'spell_changes_sheet.dart';

enum _Filter { all, prepared, concentration, rituals }

String _school(AppLocalizations l10n, SpellSchool school) => switch (school) {
  SpellSchool.abjuration => l10n.schoolAbjuration,
  SpellSchool.conjuration => l10n.schoolConjuration,
  SpellSchool.divination => l10n.schoolDivination,
  SpellSchool.enchantment => l10n.schoolEnchantment,
  SpellSchool.evocation => l10n.schoolEvocation,
  SpellSchool.illusion => l10n.schoolIllusion,
  SpellSchool.necromancy => l10n.schoolNecromancy,
  SpellSchool.transmutation => l10n.schoolTransmutation,
};

String _range(AppLocalizations l10n, SpellRange range) => switch (range.kind) {
  RangeKind.self => l10n.rangeSelf,
  RangeKind.touch => l10n.rangeTouch,
  RangeKind.feet => formatFeet(range.feet!),
  RangeKind.sight => l10n.rangeSight,
  RangeKind.unlimited => l10n.rangeUnlimited,
  RangeKind.special => l10n.rangeSpecial,
};

String _capitalized(String value) =>
    value.isEmpty ? value : '${value[0].toUpperCase()}${value.substring(1)}';

/// Onglet Sorts [P14], [P17], [F5a], [F5b].
class SpellsTab extends ConsumerStatefulWidget {
  const SpellsTab({
    super.key,
    required this.id,
    required this.content,
    required this.character,
    required this.sheet,
  });

  final String id;
  final ActiveContent content;
  final CharacterInput character;
  final ComputedSheet sheet;

  @override
  ConsumerState<SpellsTab> createState() => _SpellsTabState();
}

class _SpellsTabState extends ConsumerState<SpellsTab> {
  _Filter _filter = _Filter.all;

  ActiveContent get _content => widget.content;
  ComputedSheet get _sheet => widget.sheet;

  PlayState get _play =>
      ref.watch(playStateProvider(widget.id)).asData?.value ??
      const PlayState();

  /// À lire hors de `build`, depuis un rappel.
  PlayState get _latest =>
      ref.read(playStateProvider(widget.id)).asData?.value ?? const PlayState();

  String _name(String id) => namesOf(_content, [id]);

  Future<void> _saveCharacter(CharacterInput character) async {
    await ref.read(characterStoreProvider).save(widget.id, character);
    ref
      ..invalidate(characterProvider(widget.id))
      ..invalidate(charactersProvider);
  }

  Future<void> _store(PlayState state) async {
    await ref.read(characterStoreProvider).saveState(widget.id, state);
    ref.invalidate(playStateProvider(widget.id));
  }

  Widget _concentration(AppLocalizations l10n, TextTheme text, String id) {
    final colors = GameColors.of(context);
    final data = _content.entity(id)?.data;
    return Card(
      color: colors.concentrationContainer,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.sm),
        child: Row(
          children: [
            GameIcon(
              GameIcons.concentration,
              color: colors.onConcentrationContainer,
            ),
            SizedBox(width: AppSpacing.xs),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.concentrationActive,
                    style: text.labelMedium?.copyWith(
                      color: colors.onConcentrationContainer,
                    ),
                  ),
                  Text(
                    _name(id),
                    style: text.titleMedium?.copyWith(
                      color: colors.onConcentrationContainer,
                    ),
                  ),
                  if (data is SpellData)
                    Text(
                      data.duration,
                      style: text.bodySmall?.copyWith(
                        color: colors.onConcentrationContainer,
                      ),
                    ),
                ],
              ),
            ),
            TextButton(
              onPressed: () => _store(endConcentration(_latest)),
              child: Text(
                l10n.endConcentration,
                style: TextStyle(color: colors.onConcentrationContainer),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _shown(SheetSpell spell, SpellData data) => switch (_filter) {
    _Filter.all => true,
    _Filter.prepared =>
      data.level == 0 || spell.prepared || spell.alwaysPrepared,
    _Filter.concentration => data.concentration,
    _Filter.rituals => data.ritual,
  };

  /// « Clerc 3 + Paladin 4 ÷ 2 (arrondi supérieur) = 5 ».
  String _casterSum(AppLocalizations l10n) {
    final parts = <String>[];
    var halves = 0;
    for (final level in widget.character.classLevels) {
      final data = _content.entity(level.classId)?.data;
      if (data is! ClassData) continue;
      final label = l10n.classLevel(_name(level.classId), level.level);
      switch (data.multiclass.casterDivisor) {
        case 1:
          parts.add(label);
        case 2:
          halves++;
          parts.add(l10n.casterHalf(label));
      }
    }
    final sum = parts.join(' + ');
    return l10n.casterSum(
      halves > 0 ? l10n.casterRounded(sum) : sum,
      _sheet.casterLevel!,
    );
  }

  List<Widget> _castingValues(
    AppLocalizations l10n,
    TextTheme text,
    List<SheetSpell> spells,
  ) {
    final breakdowns = SheetBreakdowns(l10n, _content, _sheet);
    final several = _sheet.spellcasting.length > 1;
    return [
      for (final MapEntry(key: classId, value: casting)
          in _sheet.spellcasting.entries) ...[
        if (several) Text(_name(classId), style: text.titleMedium),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            StatTile(
              value: '${casting.saveDc.value}',
              label: l10n.spellSaveDc(abbreviation(l10n, casting.ability)),
              onTap: () => showAdaptiveSheet(
                context,
                breakdowns.spellValue(l10n.spellSaveDcTitle, casting.saveDc),
              ),
            ),
            StatTile(
              value: formatSigned(casting.attackBonus.value),
              label: l10n.spellAttack,
              onTap: () => showAdaptiveSheet(
                context,
                breakdowns.spellValue(l10n.spellAttack, casting.attackBonus),
              ),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        if (casting.preparedMax > 0)
          Text(
            l10n.preparedOfMax(
              spells.where((s) => s.classId == classId && s.prepared).length,
              casting.preparedMax,
            ),
            style: text.bodyMedium,
          ),
        if (spellbookSize(classId) > 0)
          Text(
            l10n.spellbookCount(spells.where((s) => s.inSpellbook).length),
            style: text.bodyMedium,
          ),
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            TextButton(
              onPressed: () => showAdaptiveSheet(
                context,
                SpellChangesSheet(
                  content: _content,
                  character: widget.character,
                  classId: classId,
                  preparedMax: casting.preparedMax,
                  onSave: _saveCharacter,
                ),
              ),
              child: Text(l10n.changeSpells),
            ),
            if (spellbookSize(classId) > 0)
              TextButton(
                onPressed: () => showAdaptiveSheet(
                  context,
                  SpellCopySheet(
                    content: _content,
                    character: widget.character,
                    classId: classId,
                    onSave: _saveCharacter,
                  ),
                ),
                child: Text(l10n.copySpellAction),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
      ],
    ];
  }

  List<Widget> _slots(AppLocalizations l10n, TextTheme text) {
    final slots = _sheet.spellSlots;
    final pact = _sheet.pactMagic;
    return [
      if (slots.isNotEmpty) ...[
        Text(
          _sheet.casterLevel == null
              ? l10n.spellSlotsTitle
              : l10n.spellSlotsCombined,
          style: text.titleMedium,
        ),
        if (_sheet.casterLevel != null)
          Text(_casterSum(l10n), style: text.bodySmall),
        SizedBox(height: AppSpacing.xs),
        for (final (i, total) in slots.indexed)
          if (total - _play.usedOf(slotResource(i + 1)) case final left)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xxs),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: Text(l10n.slotLevel(i + 1), style: text.bodyMedium),
                  ),
                  ResourcePips(
                    total: total,
                    available: left,
                    semanticLabel: l10n.slotsOf(i + 1, left, total),
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text('$left / $total', style: text.bodySmall),
                ],
              ),
            ),
        SizedBox(height: AppSpacing.sm),
      ],
      if (pact != null) ...[
        Text(l10n.pactMagicTitle, style: text.titleMedium),
        Text(
          l10n.pactSlots(pact.slots, pact.slotLevel),
          style: text.bodyMedium,
        ),
        ResourcePips(
          total: pact.slots,
          available: pact.slots - _play.usedOf(pactSlotResource),
          semanticLabel: l10n.slotsOf(
            pact.slotLevel,
            pact.slots - _play.usedOf(pactSlotResource),
            pact.slots,
          ),
        ),
        Text(l10n.pactRecharge, style: text.bodySmall),
        SizedBox(height: AppSpacing.sm),
      ],
    ];
  }

  Widget _row(
    AppLocalizations l10n,
    ContentEntity entity,
    SpellData data,
    SheetSpell spell,
  ) {
    final several = _sheet.spellcasting.length > 1;
    final castable = data.level == 0 || spell.prepared || spell.alwaysPrepared;
    final options = castable
        ? castOptions(data, _sheet, _play, spellId: spell.id)
        : [
            // Savoir rituel : le grimoire suffit, sans préparer le sort.
            if (spell.inSpellbook && data.ritual)
              CastOption(level: data.level, left: 0, ritual: true),
          ];
    void open() => showAdaptiveSheet(
      context,
      _SpellDetail(
        entity: entity,
        data: data,
        options: options,
        replaced: replacedConcentration(spell.id, data, _latest),
        onCast: (option) => _store(castSpell(_latest, spell.id, data, option)),
        name: _name,
      ),
    );
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(entity.name),
      subtitle: Text(
        [
          _school(l10n, data.school),
          data.castingTime,
          if (spell.alwaysPrepared) l10n.alwaysPrepared,
          if (spell.inSpellbook && !spell.prepared) l10n.inSpellbook,
          if (several && spell.classId != null) _name(spell.classId!),
        ].join(' · '),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (data.concentration)
            _Badge(letter: l10n.badgeConcentration, label: l10n.concentration),
          if (data.ritual) _Badge(letter: l10n.badgeRitual, label: l10n.ritual),
          SizedBox(width: AppSpacing.xs),
          TextButton(
            onPressed: options.isEmpty ? null : open,
            child: Text(l10n.castSpell),
          ),
        ],
      ),
      onTap: open,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final spells = sheetSpells(widget.character, _content);
    if (spells.isEmpty && _sheet.spellcasting.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.lg),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.noSpells, style: text.titleMedium),
              SizedBox(height: AppSpacing.xs),
              Text(
                l10n.noSpellsHint,
                style: text.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    final always = spells.where((s) => s.alwaysPrepared).length;
    final levels = <int, List<(ContentEntity, SpellData, SheetSpell)>>{};
    for (final entity in sortedEntities(_content, 'spell')) {
      final spell = spells.where((s) => s.id == '${entity.id}').firstOrNull;
      final data = entity.data as SpellData;
      if (spell != null && _shown(spell, data)) {
        (levels[data.level] ??= []).add((entity, data, spell));
      }
    }
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        if (_play.concentrationSpellId case final id?) ...[
          _concentration(l10n, text, id),
          SizedBox(height: AppSpacing.sm),
        ],
        ..._castingValues(l10n, text, spells),
        ..._slots(l10n, text),
        if (always > 0) ...[
          Text(l10n.alwaysPreparedCount(always), style: text.bodySmall),
          SizedBox(height: AppSpacing.sm),
        ],
        Wrap(
          spacing: AppSpacing.xs,
          children: [
            for (final (filter, label) in [
              (_Filter.all, l10n.filterAllSpells),
              (_Filter.prepared, l10n.filterPrepared),
              (_Filter.concentration, l10n.concentration),
              (_Filter.rituals, l10n.filterRituals),
            ])
              ChoiceChip(
                label: Text(label),
                selected: _filter == filter,
                onSelected: (_) => setState(() => _filter = filter),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        if (levels.isEmpty) Text(l10n.noSpellMatches, style: text.bodyMedium),
        for (final level in levels.keys.toList()..sort()) ...[
          Text(
            (level == 0 ? l10n.cantripsHeading : l10n.spellLevelName(level))
                .toUpperCase(),
            style: text.labelMedium,
          ),
          for (final (entity, data, spell) in levels[level]!)
            _row(l10n, entity, data, spell),
          SizedBox(height: AppSpacing.sm),
        ],
      ],
    );
  }
}

/// Lettre C ou R : le libellé complet reste lu par le lecteur d'écran.
class _Badge extends StatelessWidget {
  const _Badge({required this.letter, required this.label});

  final String letter;
  final String label;

  @override
  Widget build(BuildContext context) => Semantics(
    label: label,
    excludeSemantics: true,
    child: Tooltip(
      message: label,
      child: Padding(
        padding: EdgeInsets.only(left: AppSpacing.xs),
        child: Text(letter, style: Theme.of(context).textTheme.labelLarge),
      ),
    ),
  );
}

/// Fiche de sort (EF-PJ-08) et lancement [P14].
class _SpellDetail extends StatefulWidget {
  const _SpellDetail({
    required this.entity,
    required this.data,
    required this.options,
    required this.replaced,
    required this.onCast,
    required this.name,
  });

  final ContentEntity entity;
  final SpellData data;
  final List<CastOption> options;

  /// Sort à concentration que ce lancer arrête.
  final String? replaced;
  final ValueChanged<CastOption> onCast;
  final String Function(String) name;

  @override
  State<_SpellDetail> createState() => _SpellDetailState();
}

class _SpellDetailState extends State<_SpellDetail> {
  late CastOption? _option = widget.options.firstOrNull;

  SpellData get data => widget.data;

  String _optionLabel(AppLocalizations l10n, CastOption option) {
    if (option.ritual) return l10n.castRitual;
    if (option.free) return l10n.castFree(option.left);
    final level = l10n.spellLevelName(option.level);
    return option.pact
        ? l10n.castPactSlot(level, option.left)
        : l10n.castSlot(level, option.left);
  }

  /// Le second sort à concentration demande confirmation (EF-PJ-09).
  Future<void> _cast(AppLocalizations l10n, CastOption option) async {
    if (widget.replaced case final replaced?) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (dialog) => AlertDialog(
          title: Text(l10n.replaceConcentrationTitle(widget.name(replaced))),
          content: Text(l10n.replaceConcentrationHint),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialog).pop(false),
              child: Text(l10n.cancelCast),
            ),
            FilledButton(
              onPressed: () => Navigator.of(dialog).pop(true),
              child: Text(l10n.confirmCast),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }
    widget.onCast(option);
    if (mounted) Navigator.of(context).pop();
  }

  String _components(AppLocalizations l10n) => [
    if (data.components.verbal) l10n.componentVerbal,
    if (data.components.somatic) l10n.componentSomatic,
    if (data.components.material case final material?)
      l10n.componentMaterial(material),
  ].join(', ');

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final school = _school(l10n, data.school);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(widget.entity.name, style: text.headlineSmall),
          Text(
            data.level == 0
                ? l10n.cantripOf(school)
                : l10n.spellOfLevel(school, l10n.spellLevelName(data.level)),
            style: text.bodyMedium,
          ),
          SizedBox(height: AppSpacing.sm),
          DetailRow(
            l10n.spellCasting,
            [
              _capitalized(data.castingTime),
              if (data.ritual) l10n.ritual,
            ].join(' · '),
          ),
          DetailRow(l10n.spellRange, _range(l10n, data.range)),
          DetailRow(l10n.spellComponents, _components(l10n)),
          DetailRow(
            l10n.spellDuration,
            data.concentration
                ? l10n.durationConcentration(data.duration)
                : _capitalized(data.duration),
          ),
          if (data.materialConsumed)
            DetailRow(l10n.spellMaterial, l10n.materialConsumed),
          SizedBox(height: AppSpacing.sm),
          Text(widget.entity.textFr ?? '', style: text.bodyMedium),
          SizedBox(height: AppSpacing.sm),
          if (widget.replaced case final replaced?) ...[
            Text(
              l10n.replacesConcentration(widget.name(replaced)),
              style: text.bodySmall,
            ),
            SizedBox(height: AppSpacing.xs),
          ],
          if (data.level > 0 && widget.options.isNotEmpty) ...[
            Text(l10n.castSlotTitle, style: text.titleSmall),
            SizedBox(height: AppSpacing.xs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: [
                for (final option in widget.options)
                  ChoiceChip(
                    label: Text(_optionLabel(l10n, option)),
                    selected: identical(_option, option),
                    onSelected: (_) => setState(() => _option = option),
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.sm),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
              if (_option case final option?) ...[
                SizedBox(width: AppSpacing.xs),
                FilledButton(
                  onPressed: () => _cast(l10n, option),
                  child: Text(l10n.castSpell),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}
