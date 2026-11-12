import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'sheet_access.dart';
import 'sheet_features.dart';
import 'sheet_page.dart';
import 'simple_roll.dart';

/// Écrit l'état de jeu de [id] et relit les écrans qui le montrent.
Future<void> savePlayState(WidgetRef ref, String id, PlayState state) async {
  await ref.read(characterStoreProvider).saveState(id, state);
  ref.invalidate(playStateProvider(id));
}

/// PV actuels, sur l'onglet Principal.
class HitPointsTracker extends ConsumerWidget {
  const HitPointsTracker({super.key, required this.id, required this.sheet});

  final String id;
  final ComputedSheet sheet;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final play =
        ref.watch(playStateProvider(id)).asData?.value ?? const PlayState();
    void change(int delta) =>
        savePlayState(ref, id, changeHitPoints(play, sheet, delta));
    final current = hitPoints(play, sheet);
    final editable = SheetAccess.editableOf(context);
    return Row(
      children: [
        IconButton(
          tooltip: l10n.loseHitPoint,
          onPressed: editable && current > 0 ? () => change(-1) : null,
          icon: const Icon(Icons.remove),
        ),
        Text(
          l10n.hitPointsOf(current, sheet.hitPointsMax.value),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          tooltip: l10n.gainHitPoint,
          onPressed: current < sheet.hitPointsMax.value
              ? (editable ? () => change(1) : null)
              : null,
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}

/// Inspiration héroïque, sur l'onglet Principal.
class InspirationTracker extends ConsumerWidget {
  const InspirationTracker({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final play =
        ref.watch(playStateProvider(id)).asData?.value ?? const PlayState();
    final has = play.heroicInspiration;
    return Wrap(
      spacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        Icon(has ? Icons.star : Icons.star_border, size: 20),
        Text(has ? l10n.inspirationHeld : l10n.inspirationNone),
        if (SheetAccess.editableOf(context))
          TextButton(
            onPressed: () => savePlayState(ref, id, play.withInspiration(!has)),
            child: Text(has ? l10n.useResource : l10n.receiveInspiration),
          ),
      ],
    );
  }
}

/// Utilisations restantes d'une ressource, avec un bouton pour en dépenser.
class ResourceTracker extends ConsumerWidget {
  const ResourceTracker({
    super.key,
    required this.id,
    required this.resource,
    this.label,
  });

  final String id;
  final FeatureResource resource;
  final String? label;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final play =
        ref.watch(playStateProvider(id)).asData?.value ?? const PlayState();
    final left = resource.max - play.usedOf(resource.id);
    return Wrap(
      spacing: AppSpacing.xs,
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        ResourcePips(
          total: resource.max,
          available: left,
          semanticLabel: l10n.usesOf(left, resource.max),
        ),
        if (label != null)
          Text(label!, style: Theme.of(context).textTheme.bodySmall),
        TextButton(
          onPressed: left > 0 && SheetAccess.editableOf(context)
              ? () => savePlayState(
                  ref,
                  id,
                  play.withUsed({
                    ...play.used,
                    resource.id: play.usedOf(resource.id) + 1,
                  }),
                )
              : null,
          child: Text(l10n.useResource),
        ),
      ],
    );
  }
}

/// Repos court [P12] ou repos long [P13]. Rien n'est écrit avant « Terminer ».
class RestSheet extends ConsumerStatefulWidget {
  const RestSheet({
    super.key,
    required this.id,
    required this.kind,
    required this.content,
    required this.character,
    required this.sheet,
  });

  final String id;
  final RestKind kind;
  final ActiveContent content;
  final CharacterInput character;
  final ComputedSheet sheet;

  @override
  ConsumerState<RestSheet> createState() => _RestSheetState();
}

class _RestSheetState extends ConsumerState<RestSheet> {
  late final PlayState _start =
      ref.read(playStateProvider(widget.id)).asData?.value ?? const PlayState();
  late PlayState _state = _start;

  /// Résultat validé de chaque type de dé, et clé neuve après chaque dépense.
  final _rolls = <String, int?>{};
  var _round = 0;

  ComputedSheet get _sheet => widget.sheet;

  void _spend(String die) => setState(() {
    _state = spendHitDie(_state, _sheet, die, _rolls[die]!);
    _rolls.clear();
    _round++;
  });

  List<Widget> _dice(AppLocalizations l10n, TextTheme text) => [
    Text(l10n.hitDiceSpent, style: text.titleSmall),
    for (final dice in _sheet.hitDice)
      if (hitDiceLeft(_state, dice) case final left) ...[
        SizedBox(height: AppSpacing.xs),
        Text(
          l10n.hitDiceLeft(left, dice.total, dice.die),
          style: text.bodyMedium,
        ),
        if (left > 0) ...[
          SimpleRoll(
            key: ValueKey('${dice.die}-$_round'),
            formula: DiceFormula(
              1,
              int.parse(dice.die.substring(1)),
              bonus: _sheet.abilities['con']!.modifier,
            ),
            bonusLabel: l10n.abbrCon,
            onChanged: (roll) => setState(() => _rolls[dice.die] = roll),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: OutlinedButton(
              onPressed: _rolls[dice.die] == null
                  ? null
                  : () => _spend(dice.die),
              child: Text(l10n.spendHitDie(dice.die)),
            ),
          ),
        ],
      ],
    SizedBox(height: AppSpacing.sm),
  ];

  /// Ressources dont le repos change les utilisations.
  List<Widget> _recovered(AppLocalizations l10n, PlayState after) {
    final rows = <Widget>[];
    for (final group in featureGroups(
      widget.character,
      _sheet,
      widget.content,
    )) {
      for (final feature in group.features) {
        final resource = feature.resource;
        if (resource == null) continue;
        final before = resource.max - _state.usedOf(resource.id);
        final next = resource.max - after.usedOf(resource.id);
        if (before != next) {
          rows.add(
            DetailRow(
              feature.entity.name,
              l10n.recoveredUses(before, next, resource.max),
            ),
          );
        }
      }
    }
    final slots = _sheet.spellSlots.indexed
        .where(
          (s) =>
              _state.usedOf(slotResource(s.$1 + 1)) !=
              after.usedOf(slotResource(s.$1 + 1)),
        )
        .isNotEmpty;
    if (slots ||
        _state.usedOf(pactSlotResource) != after.usedOf(pactSlotResource)) {
      rows.add(DetailRow(l10n.spellSlotsTitle, l10n.slotsRecovered));
    }
    return rows;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final short = widget.kind == RestKind.short;
    final after = finishRest(_state, _sheet, widget.kind);
    final max = _sheet.hitPointsMax.value;
    final allowed = canRest(_start, _sheet);
    final recovered = _recovered(l10n, after);
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            short ? l10n.shortRest : l10n.longRest,
            style: text.headlineSmall,
          ),
          Text(
            short ? l10n.shortRestHint : l10n.longRestHint,
            style: text.bodySmall,
          ),
          SizedBox(height: AppSpacing.sm),
          if (!allowed) ...[
            Text(l10n.restNeedsHitPoint, style: text.bodyMedium),
            SizedBox(height: AppSpacing.sm),
          ] else ...[
            DetailRow(
              l10n.statHitPoints,
              l10n.hitPointsChange(
                hitPoints(_start, _sheet),
                hitPoints(after, _sheet),
                max,
              ),
            ),
            if (short)
              ..._dice(l10n, text)
            else ...[
              for (final dice in _sheet.hitDice)
                DetailRow(
                  l10n.hitDiceLabel,
                  l10n.hitDiceChange(
                    hitDiceLeft(_start, dice),
                    dice.total,
                    dice.die,
                  ),
                ),
              if (after.heroicInspiration && !_start.heroicInspiration)
                DetailRow(l10n.inspirationHeld, l10n.inspirationGained),
              if (_start.exhaustion > 0)
                DetailRow(
                  l10n.exhaustion,
                  '${_start.exhaustion} → ${after.exhaustion}',
                ),
              if (_start.concentrationSpellId case final spell?)
                DetailRow(
                  l10n.concentrationEnds,
                  namesOf(widget.content, [spell]),
                ),
            ],
            if (recovered.isEmpty)
              Text(l10n.nothingToRecover, style: text.bodySmall)
            else ...[
              Text(l10n.recoveredTitle, style: text.titleSmall),
              ...recovered,
            ],
            SizedBox(height: AppSpacing.sm),
          ],
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.xs,
            children: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(l10n.cancelCast),
              ),
              FilledButton(
                onPressed: allowed
                    ? () {
                        savePlayState(ref, widget.id, after);
                        Navigator.of(context).pop();
                      }
                    : null,
                child: Text(short ? l10n.finishShortRest : l10n.finishLongRest),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
