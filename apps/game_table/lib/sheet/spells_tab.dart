import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'sheet_breakdowns.dart';

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
class SpellsTab extends StatefulWidget {
  const SpellsTab({
    super.key,
    required this.content,
    required this.character,
    required this.sheet,
  });

  final ActiveContent content;
  final CharacterInput character;
  final ComputedSheet sheet;

  @override
  State<SpellsTab> createState() => _SpellsTabState();
}

class _SpellsTabState extends State<SpellsTab> {
  _Filter _filter = _Filter.all;

  ActiveContent get _content => widget.content;
  ComputedSheet get _sheet => widget.sheet;

  String _name(String id) => namesOf(_content, [id]);

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
                  available: total,
                  semanticLabel: l10n.slotsOf(i + 1, total, total),
                ),
                SizedBox(width: AppSpacing.xs),
                Text('$total / $total', style: text.bodySmall),
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
        ],
      ),
      onTap: () =>
          showAdaptiveSheet(context, _SpellDetail(entity: entity, data: data)),
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

/// Fiche de sort (EF-PJ-08).
class _SpellDetail extends StatelessWidget {
  const _SpellDetail({required this.entity, required this.data});

  final ContentEntity entity;
  final SpellData data;

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
          Text(entity.name, style: text.headlineSmall),
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
          Text(entity.textFr ?? '', style: text.bodyMedium),
          SizedBox(height: AppSpacing.sm),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.close),
            ),
          ),
        ],
      ),
    );
  }
}
