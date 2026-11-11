import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../l10n/app_localizations.dart';
import 'table_labels.dart';
import 'tables_providers.dart';

/// Configuration d'une table [F6], pour son MJ : création des personnages,
/// règles de jeu, visibilité des fiches, packs, archivage. Les modifications
/// restent à l'écran jusqu'à « Enregistrer », et chaque changement est daté
/// dans l'activité (EF-TAB-11). Archivée, la table est en lecture seule
/// (EF-TAB-07).
class ConfigurationTab extends ConsumerStatefulWidget {
  const ConfigurationTab({super.key, required this.table});

  final TableSummary table;

  @override
  ConsumerState<ConfigurationTab> createState() => _ConfigurationTabState();
}

class _ConfigurationTabState extends ConsumerState<ConfigurationTab> {
  late var _settings = widget.table.settings;
  late var _fullSheets = widget.table.fullSheetsVisible;
  var _busy = false;

  /// Version du formulaire : change à l'annulation, pour que les listes
  /// reprennent la configuration enregistrée.
  var _revision = 0;

  @override
  void didUpdateWidget(ConfigurationTab old) {
    super.didUpdateWidget(old);
    if (old.table != widget.table && !_dirty(old.table)) _reset();
  }

  bool _dirty(TableSummary table) =>
      _settings != table.settings || _fullSheets != table.fullSheetsVisible;

  void _reset() => setState(() {
    _settings = widget.table.settings;
    _fullSheets = widget.table.fullSheetsVisible;
    _revision++;
  });

  void _refresh() => ref
    ..invalidate(tableProvider(widget.table.id))
    ..invalidate(tableActivityProvider(widget.table.id))
    ..invalidate(myTablesProvider);

  Future<void> _save() async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    setState(() => _busy = true);
    await ref
        .read(tableStoreProvider)
        .update(
          widget.table.id,
          authorUserId: userId,
          settings: _settings,
          fullSheetsVisible: _fullSheets,
        );
    _refresh();
    if (mounted) setState(() => _busy = false);
  }

  Future<void> _setArchived(bool archived) async {
    final userId = ref.read(currentUserProvider).value?.id;
    if (userId == null) return;
    setState(() => _busy = true);
    await ref
        .read(tableStoreProvider)
        .setArchived(widget.table.id, archived: archived, authorUserId: userId);
    _refresh();
    if (mounted) setState(() => _busy = false);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final saved = widget.table.settings;
    final archived = widget.table.archived;
    final editable = !archived && !_busy;
    final desktop =
        formFactorOf(MediaQuery.sizeOf(context).width) == FormFactor.desktop;

    final changes = [
      if (_settings.statMethod != saved.statMethod)
        ('statMethod', saved.statMethod.name, _settings.statMethod.name),
      if (_settings.startingLevel != saved.startingLevel)
        ('startingLevel', saved.startingLevel, _settings.startingLevel),
      if (_settings.longRest != saved.longRest)
        ('longRest', saved.longRest.name, _settings.longRest.name),
      if (_settings.hpOnLevel != saved.hpOnLevel)
        ('hpOnLevel', saved.hpOnLevel.name, _settings.hpOnLevel.name),
      if (_settings.progression != saved.progression)
        ('progression', saved.progression.name, _settings.progression.name),
      if (_fullSheets != widget.table.fullSheetsVisible)
        ('fullSheetsVisible', widget.table.fullSheetsVisible, _fullSheets),
    ];

    Widget card(String title, List<Widget> children) => Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: text.titleMedium),
            SizedBox(height: AppSpacing.sm),
            ...children,
          ],
        ),
      ),
    );
    Widget dropdown<T>({
      required String label,
      required T value,
      required List<(T, String)> options,
      required void Function(T) onChanged,
    }) => DropdownButtonFormField<T>(
      key: ValueKey((label, _revision)),
      initialValue: value,
      decoration: InputDecoration(labelText: label),
      isExpanded: true,
      items: [
        for (final (option, optionLabel) in options)
          DropdownMenuItem(value: option, child: Text(optionLabel)),
      ],
      onChanged: editable ? (v) => onChanged(v as T) : null,
    );
    Widget responsive(List<Widget> fields) => desktop
        ? Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (final (i, field) in fields.indexed) ...[
                if (i > 0) SizedBox(width: AppSpacing.md),
                Expanded(child: field),
              ],
            ],
          )
        : Column(
            children: [
              for (final (i, field) in fields.indexed) ...[
                if (i > 0) SizedBox(height: AppSpacing.md),
                field,
              ],
            ],
          );

    final form = [
      if (archived) ...[
        StatusBanner(
          kind: StatusBannerKind.alert,
          icon: Icons.inventory_2_outlined,
          message: l10n.archivedBanner,
        ),
        SizedBox(height: AppSpacing.md),
      ],
      card(l10n.characterCreationSection, [
        responsive([
          dropdown<ScoreMethod>(
            label: l10n.statMethodTitle,
            value: _settings.statMethod,
            options: [
              for (final method in [
                ScoreMethod.standardArray,
                ScoreMethod.pointBuy,
                ScoreMethod.random,
              ])
                (method, l10n.statMethod(method)),
            ],
            onChanged: (m) =>
                setState(() => _settings = _settings.copyWith(statMethod: m)),
          ),
          dropdown<int>(
            label: l10n.startingLevelShort,
            value: _settings.startingLevel,
            options: [for (var l = 1; l <= 20; l++) (l, '$l')],
            onChanged: (l) => setState(
              () => _settings = _settings.copyWith(startingLevel: l),
            ),
          ),
        ]),
        if (_settings.statMethod != saved.statMethod) ...[
          SizedBox(height: AppSpacing.md),
          StatusBanner(
            kind: StatusBannerKind.alert,
            title: l10n.methodChangeTitle,
            message: l10n.methodChangeBody(
              l10n.statMethod(_settings.statMethod),
            ),
          ),
        ],
      ]),
      SizedBox(height: AppSpacing.md),
      card(l10n.gameRulesSection, [
        responsive([
          dropdown<LongRestRule>(
            label: l10n.longRestTitle,
            value: _settings.longRest,
            options: [
              (LongRestRule.fullHitPoints, l10n.longRestFull),
              (LongRestRule.hitDice, l10n.longRestHitDice),
            ],
            onChanged: (r) =>
                setState(() => _settings = _settings.copyWith(longRest: r)),
          ),
          dropdown<HpOnLevel>(
            label: l10n.hpOnLevelTitle,
            value: _settings.hpOnLevel,
            options: [for (final r in HpOnLevel.values) (r, l10n.hpOnLevel(r))],
            onChanged: (r) =>
                setState(() => _settings = _settings.copyWith(hpOnLevel: r)),
          ),
          dropdown<Progression>(
            label: l10n.previewProgression,
            value: _settings.progression,
            options: [
              for (final m in Progression.values) (m, l10n.progression(m)),
            ],
            onChanged: (m) =>
                setState(() => _settings = _settings.copyWith(progression: m)),
          ),
        ]),
        SizedBox(height: AppSpacing.sm),
        Text(l10n.milestonesNote, style: text.bodySmall),
      ]),
      SizedBox(height: AppSpacing.md),
      card(l10n.visibilitySection, [
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.fullSheetsLabel),
          subtitle: Text(l10n.fullSheetsHint),
          value: _fullSheets,
          onChanged: editable ? (v) => setState(() => _fullSheets = v) : null,
        ),
      ]),
      SizedBox(height: AppSpacing.md),
      card(l10n.packsTitle, [Text(l10n.srdPackName, style: text.bodyMedium)]),
      SizedBox(height: AppSpacing.md),
      card(l10n.sensitiveZone, [
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(archived ? l10n.restoreTable : l10n.archiveTable),
          subtitle: Text(archived ? l10n.restoreHint : l10n.archiveHint),
          trailing: OutlinedButton(
            onPressed: _busy ? null : () => _setArchived(!archived),
            child: Text(archived ? l10n.restoreAction : l10n.archiveAction),
          ),
        ),
      ]),
    ];

    final side = [
      if (changes.isNotEmpty) ...[
        card(l10n.unsavedTitle, [
          for (final (field, from, to) in changes)
            Text(
              l10n.changeLine(
                l10n.settingLabel(field),
                l10n.settingValue(field, from),
                l10n.settingValue(field, to),
              ),
              style: text.bodyMedium,
            ),
          SizedBox(height: AppSpacing.sm),
          Wrap(
            alignment: WrapAlignment.end,
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: [
              TextButton(
                onPressed: _busy ? null : _reset,
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: editable ? _save : null,
                child: Text(l10n.accountSave),
              ),
            ],
          ),
        ]),
        SizedBox(height: AppSpacing.md),
      ],
      card(l10n.whoIsNotifiedTitle, [
        Text(l10n.whoIsNotifiedBody, style: text.bodyMedium),
      ]),
    ];

    if (desktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md),
              children: form,
            ),
          ),
          SizedBox(
            width: 360,
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md),
              children: side,
            ),
          ),
        ],
      );
    }
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        // Sur téléphone, les modifications en attente d'abord : le bouton
        // « Enregistrer » reste à portée.
        ...side,
        ...form,
      ],
    );
  }
}
