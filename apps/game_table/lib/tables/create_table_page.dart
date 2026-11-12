import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../l10n/app_localizations.dart';
import 'table_labels.dart';
import 'table_summary_card.dart';
import 'tables_providers.dart';

/// Niveaux de départ possibles.
const _minLevel = 1;
const _maxLevel = 20;

/// Nouvelle table [T8] : nom, description, niveau de départ, méthode de
/// caractéristiques, repos long, PV par niveau, progression, packs
/// (EF-TAB-01 à 04, EF-TAB-10). Aperçu de la carte sur desktop.
class CreateTablePage extends ConsumerStatefulWidget {
  const CreateTablePage({super.key});

  @override
  ConsumerState<CreateTablePage> createState() => _CreateTablePageState();
}

class _CreateTablePageState extends ConsumerState<CreateTablePage> {
  final _name = TextEditingController();
  final _description = TextEditingController();
  var _settings = const TableSettings(name: '');
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _description.dispose();
    super.dispose();
  }

  void _update(TableSettings Function(TableSettings) change) =>
      setState(() => _settings = change(_settings));

  Future<void> _create() async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    setState(() => _busy = true);
    final id = await ref
        .read(tableStoreProvider)
        .create(
          gmUserId: userId,
          settings: _settings,
          packs: await ref.read(defaultTablePacksProvider.future),
        );
    if (mounted) context.pushReplacement('/tables/$id');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final desktop =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.desktop;
    final canCreate =
        !_busy &&
        _settings.name.trim().isNotEmpty &&
        ref.watch(currentUserProvider).value != null;

    Widget card(List<Widget> children) => Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: children,
        ),
      ),
    );
    Widget title(String label, [String? hint]) => Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: text.titleMedium),
          if (hint != null) Text(hint, style: text.bodySmall),
        ],
      ),
    );

    final level = _settings.startingLevel;
    final identity = card([
      TextField(
        controller: _name,
        onChanged: (v) => _update((s) => s.copyWith(name: v)),
        decoration: InputDecoration(labelText: l10n.tableNameLabel),
      ),
      SizedBox(height: AppSpacing.md),
      TextField(
        controller: _description,
        minLines: 2,
        maxLines: 4,
        onChanged: (v) => _update((s) => s.copyWith(description: v)),
        decoration: InputDecoration(labelText: l10n.tableDescriptionLabel),
      ),
      SizedBox(height: AppSpacing.sm),
      Row(
        children: [
          Expanded(child: Text(l10n.startingLevelLabel)),
          IconButton.outlined(
            tooltip: l10n.levelDecrease,
            onPressed: level > _minLevel
                ? () => _update((s) => s.copyWith(startingLevel: level - 1))
                : null,
            icon: const Icon(Icons.remove),
          ),
          SizedBox(
            width: 40,
            child: Text(
              '$level',
              textAlign: TextAlign.center,
              style: text.titleLarge,
            ),
          ),
          IconButton.outlined(
            tooltip: l10n.levelIncrease,
            onPressed: level < _maxLevel
                ? () => _update((s) => s.copyWith(startingLevel: level + 1))
                : null,
            icon: const Icon(Icons.add),
          ),
        ],
      ),
    ]);

    final methodCards = [
      for (final method in [
        ScoreMethod.standardArray,
        ScoreMethod.pointBuy,
        ScoreMethod.random,
      ])
        SelectionCard(
          title: l10n.statMethod(method),
          subtitle: l10n.statMethodDetail(method),
          selected: _settings.statMethod == method,
          onTap: () => _update((s) => s.copyWith(statMethod: method)),
        ),
    ];
    final statMethod = card([
      title(l10n.statMethodTitle, l10n.statMethodHint),
      if (desktop)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (final (i, c) in methodCards.indexed) ...[
              if (i > 0) SizedBox(width: AppSpacing.sm),
              Expanded(child: c),
            ],
          ],
        )
      else
        for (final c in methodCards) ...[c, SizedBox(height: AppSpacing.sm)],
    ]);

    final longRest = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        title(l10n.longRestTitle),
        RadioGroup<LongRestRule>(
          groupValue: _settings.longRest,
          onChanged: (rule) => _update((s) => s.copyWith(longRest: rule)),
          child: Column(
            children: [
              for (final (rule, label, hint) in [
                (
                  LongRestRule.fullHitPoints,
                  l10n.longRestFull,
                  l10n.longRestFullHint,
                ),
                (
                  LongRestRule.hitDice,
                  l10n.longRestHitDice,
                  l10n.longRestHitDiceHint,
                ),
              ])
                RadioListTile<LongRestRule>(
                  value: rule,
                  contentPadding: EdgeInsets.zero,
                  title: Text(label),
                  subtitle: Text(hint),
                ),
            ],
          ),
        ),
      ],
    );
    final hpOnLevel = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        title(l10n.hpOnLevelTitle),
        SegmentedButton<HpOnLevel>(
          showSelectedIcon: false,
          segments: [
            for (final rule in HpOnLevel.values)
              ButtonSegment(value: rule, label: Text(l10n.hpOnLevel(rule))),
          ],
          selected: {_settings.hpOnLevel},
          onSelectionChanged: (s) =>
              _update((t) => t.copyWith(hpOnLevel: s.single)),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          _settings.hpOnLevel == HpOnLevel.average
              ? l10n.hpAverageHint
              : l10n.hpRollHint,
          style: text.bodySmall,
        ),
      ],
    );
    final progression = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        title(l10n.progressionTitle),
        SegmentedButton<Progression>(
          showSelectedIcon: false,
          segments: [
            for (final mode in Progression.values)
              ButtonSegment(value: mode, label: Text(l10n.progression(mode))),
          ],
          selected: {_settings.progression},
          onSelectionChanged: (s) =>
              _update((t) => t.copyWith(progression: s.single)),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          _settings.progression == Progression.xp
              ? l10n.progressionXpHint
              : l10n.progressionMilestonesHint,
          style: text.bodySmall,
        ),
      ],
    );
    final rules = card([
      if (desktop)
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: longRest),
            SizedBox(width: AppSpacing.lg),
            Expanded(child: hpOnLevel),
            SizedBox(width: AppSpacing.lg),
            Expanded(child: progression),
          ],
        )
      else ...[
        longRest,
        SizedBox(height: AppSpacing.md),
        hpOnLevel,
        SizedBox(height: AppSpacing.md),
        progression,
      ],
    ]);

    final packs = card([
      title(l10n.packsTitle, l10n.packsHint),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.srdPackName),
        subtitle: Text(l10n.srdPackAlways),
        value: true,
        onChanged: null,
      ),
    ]);

    final form = [
      identity,
      SizedBox(height: AppSpacing.md),
      statMethod,
      SizedBox(height: AppSpacing.md),
      rules,
      SizedBox(height: AppSpacing.md),
      packs,
    ];

    return Scaffold(
      appBar: AppBar(
        leading: CloseButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text(l10n.newTable),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: AppSpacing.sm),
            child: FilledButton(
              onPressed: canCreate ? _create : null,
              child: Text(l10n.createTable),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: desktop
            ? Padding(
                padding: EdgeInsets.all(AppSpacing.page(FormFactor.desktop)),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: ListView(children: form)),
                    SizedBox(width: AppSpacing.lg),
                    SizedBox(
                      width: 280,
                      child: TableSummaryCard(
                        settings: _settings,
                        title: l10n.previewTitle,
                        footer: l10n.previewNext,
                      ),
                    ),
                  ],
                ),
              )
            : ListView(padding: EdgeInsets.all(AppSpacing.md), children: form),
      ),
    );
  }
}
