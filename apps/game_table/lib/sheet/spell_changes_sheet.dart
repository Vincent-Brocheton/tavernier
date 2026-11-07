import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';

/// Niveau d'une classe de [character].
int _levelOf(CharacterInput character, String classId) =>
    character.classLevels.firstWhere((c) => c.classId == classId).level;

/// Sorts de [ids], par niveau croissant.
Map<int, List<ContentEntity>> _byLevel(ActiveContent content, Set<String> ids) {
  final levels = <int, List<ContentEntity>>{};
  for (final spell in sortedEntities(content, 'spell')) {
    if (ids.contains('${spell.id}')) {
      (levels[(spell.data as SpellData).level] ??= []).add(spell);
    }
  }
  return levels;
}

/// Modifier les sorts préparés et mineurs d'une classe (EF-PJ-07).
class SpellChangesSheet extends StatefulWidget {
  const SpellChangesSheet({
    super.key,
    required this.content,
    required this.character,
    required this.classId,
    required this.preparedMax,
    required this.onSave,
  });

  final ActiveContent content;
  final CharacterInput character;
  final String classId;
  final int preparedMax;
  final Future<void> Function(CharacterInput) onSave;

  @override
  State<SpellChangesSheet> createState() => _SpellChangesSheetState();
}

class _SpellChangesSheetState extends State<SpellChangesSheet> {
  late final List<SheetSpell> _spells = sheetSpells(
    widget.character,
    widget.content,
  );

  bool _mine(SheetSpell s) =>
      s.classId == widget.classId && s.origin == SpellOrigin.classList;

  bool _isCantrip(String id) =>
      (widget.content.entity(id)!.data as SpellData).level == 0;

  late final Set<String> _startCantrips = {
    for (final s in _spells)
      if (_mine(s) && _isCantrip(s.id)) s.id,
  };
  late final Set<String> _startPrepared = {
    for (final s in _spells)
      if (_mine(s) && s.prepared) s.id,
  };
  late final Set<String> _cantrips = {..._startCantrips};
  late final Set<String> _prepared = {..._startPrepared};

  /// Sorts connus autrement : un sort ne se prend pas deux fois.
  late final Set<String> _elsewhere = {
    for (final s in _spells)
      if (!_mine(s)) s.id,
  };

  ClassData get _data =>
      widget.content.entity(widget.classId)!.data as ClassData;

  bool get _changed =>
      _cantrips.length != _startCantrips.length ||
      !_cantrips.containsAll(_startCantrips) ||
      _prepared.length != _startPrepared.length ||
      !_prepared.containsAll(_startPrepared);

  /// Un retrait reste possible si la limite de remplacements n'est pas
  /// atteinte ; un ajout, s'il reste de la place.
  bool _canToggle(
    String id,
    Set<String> chosen,
    Set<String> start,
    int max,
    int? limit,
  ) {
    if (!chosen.contains(id)) return chosen.length < max;
    if (limit == null || !start.contains(id)) return true;
    return start.difference(chosen).length < limit;
  }

  String _rule(AppLocalizations l10n) => switch (_data.preparedChange) {
    PreparedChange.longRestAll => l10n.changeRuleLongRestAll,
    PreparedChange.longRestOne => l10n.changeRuleLongRestOne,
    _ => l10n.changeRuleLevelUp,
  };

  Widget _section(
    TextTheme text,
    String title,
    Set<String> ids,
    Set<String> chosen,
    Set<String> start,
    int max,
    int? limit,
  ) {
    final levels = _byLevel(widget.content, ids);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('$title ${chosen.length} / $max', style: text.titleMedium),
        SizedBox(height: AppSpacing.xs),
        for (final level in levels.keys.toList()..sort())
          Padding(
            padding: EdgeInsets.only(bottom: AppSpacing.xs),
            child: Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: [
                for (final spell in levels[level]!)
                  if ('${spell.id}' case final id)
                    FilterChip(
                      label: Text(spell.name),
                      selected: chosen.contains(id),
                      avatar: _elsewhere.contains(id)
                          ? const Icon(Icons.lock_outline, size: 16)
                          : null,
                      onSelected:
                          _elsewhere.contains(id) ||
                              !_canToggle(id, chosen, start, max, limit)
                          ? null
                          : (selected) => setState(
                              () =>
                                  selected ? chosen.add(id) : chosen.remove(id),
                            ),
                    ),
              ],
            ),
          ),
        SizedBox(height: AppSpacing.xs),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final classId = widget.classId;
    final level = _levelOf(widget.character, classId);
    final content = widget.content;
    final maxLevel = spellGain(content, classId, level).maxLevel;
    final wizard = spellbookSize(classId) > 0;
    final cantripMax = _startCantrips.length;
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.changeSpells, style: text.headlineSmall),
          Text(namesOf(content, [classId]), style: text.bodyMedium),
          SizedBox(height: AppSpacing.xs),
          Text(_rule(l10n), style: text.bodySmall),
          SizedBox(height: AppSpacing.sm),
          if (cantripMax > 0)
            _section(
              text,
              l10n.cantripsHeading,
              spellsOfList(content, classId, 0, 0),
              _cantrips,
              _startCantrips,
              cantripMax,
              cantripChangeLimit,
            ),
          if (widget.preparedMax > 0)
            _section(
              text,
              l10n.filterPrepared,
              wizard
                  ? {...widget.character.spells.spellbook}
                  : spellsOfList(content, classId, 1, maxLevel),
              _prepared,
              _startPrepared,
              widget.preparedMax,
              changeLimit(_data),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
              SizedBox(width: AppSpacing.xs),
              FilledButton(
                onPressed: _changed
                    ? () {
                        widget.onSave(
                          withClassSpells(
                            widget.character,
                            content,
                            classId,
                            prepared: [..._prepared],
                            cantrips: [..._cantrips],
                          ),
                        );
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text(l10n.saveSpells),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Recopier un sort dans le grimoire [G3].
class SpellCopySheet extends StatefulWidget {
  const SpellCopySheet({
    super.key,
    required this.content,
    required this.character,
    required this.classId,
    required this.onSave,
  });

  final ActiveContent content;
  final CharacterInput character;
  final String classId;
  final Future<void> Function(CharacterInput) onSave;

  @override
  State<SpellCopySheet> createState() => _SpellCopySheetState();
}

class _SpellCopySheetState extends State<SpellCopySheet> {
  String? _spell;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = widget.content;
    final character = widget.character;
    final level = _levelOf(character, widget.classId);
    final maxLevel = spellGain(content, widget.classId, level).maxLevel;
    final known = {for (final s in sheetSpells(character, content)) s.id};
    final gold = character.coins['gp'] ?? 0;
    final levels = _byLevel(
      content,
      spellsOfList(content, widget.classId, 1, maxLevel).difference(known),
    );
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.copySpellAction, style: text.headlineSmall),
          Text(
            l10n.copySpellRule(copyHoursPerLevel, copyGoldPerLevel),
            style: text.bodySmall,
          ),
          Text(l10n.goldPieces(gold), style: text.bodyMedium),
          SizedBox(height: AppSpacing.sm),
          for (final spellLevel in levels.keys.toList()..sort()) ...[
            Text(
              l10n.copySpellLevel(
                l10n.spellLevelName(spellLevel),
                copyGoldPerLevel * spellLevel,
              ),
              style: text.titleSmall,
            ),
            SizedBox(height: AppSpacing.xxs),
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xxs,
              children: [
                for (final spell in levels[spellLevel]!)
                  ChoiceChip(
                    label: Text(spell.name),
                    selected: _spell == '${spell.id}',
                    onSelected: gold < copyGoldPerLevel * spellLevel
                        ? null
                        : (_) => setState(() => _spell = '${spell.id}'),
                  ),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.close),
              ),
              SizedBox(width: AppSpacing.xs),
              FilledButton(
                onPressed: _spell == null
                    ? null
                    : () {
                        final data = content.entity(_spell!)!.data as SpellData;
                        widget.onSave(
                          copySpell(
                            character,
                            _spell!,
                            data.level,
                            widget.classId,
                          ),
                        );
                        Navigator.of(context).pop();
                      },
                child: Text(l10n.copySpellConfirm),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
