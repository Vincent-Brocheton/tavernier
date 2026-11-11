import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'configuration_tab.dart';
import 'table_labels.dart';
import 'table_summary_card.dart';
import 'tables_providers.dart';

/// Page d'une table (US-13) : le rôle, le nom et la description, puis les
/// onglets « Vue d'ensemble » (réglages et activité) et, pour le MJ,
/// « Configuration » [F6].
class TablePage extends ConsumerWidget {
  const TablePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final table = ref.watch(tableProvider(id)).value;
    final gm = table?.role == TableRole.gm;
    return DefaultTabController(
      // Une clé par rôle : le nombre d'onglets en dépend.
      key: ValueKey(gm),
      length: gm ? 2 : 1,
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () => context.canPop() ? context.pop() : context.go('/'),
          ),
        ),
        body: SafeArea(
          child: table == null
              ? const SizedBox.shrink()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            (gm ? l10n.youAreGm : l10n.youArePlayer)
                                .toUpperCase(),
                            style: text.labelMedium!.copyWith(
                              color: scheme.primary,
                            ),
                          ),
                          Text(
                            table.settings.name,
                            style: text.headlineMedium!.copyWith(
                              color: scheme.tertiary,
                            ),
                          ),
                          if (table.settings.description
                              case final description?)
                            Padding(
                              padding: EdgeInsets.only(top: AppSpacing.xs),
                              child: Text(description, style: text.bodyMedium),
                            ),
                        ],
                      ),
                    ),
                    TabBar(
                      isScrollable: true,
                      tabAlignment: TabAlignment.start,
                      tabs: [
                        Tab(text: l10n.tabOverview),
                        if (gm) Tab(text: l10n.tabConfiguration),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(
                        children: [
                          _Overview(table: table),
                          if (gm) ConfigurationTab(table: table),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

/// Vue d'ensemble : les réglages en vigueur et l'activité récente.
class _Overview extends ConsumerWidget {
  const _Overview({required this.table});

  final TableSummary table;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final material = MaterialLocalizations.of(context);
    final activity = ref.watch(tableActivityProvider(table.id)).value;
    String describe(TableActivity entry) => switch (entry.kind) {
      'archived' => l10n.activityArchived,
      'restored' => l10n.activityRestored,
      _ => l10n.changeLine(
        l10n.settingLabel('${entry.detail['field']}'),
        l10n.settingValue('${entry.detail['field']}', entry.detail['from']),
        l10n.settingValue('${entry.detail['field']}', entry.detail['to']),
      ),
    };
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            if (table.archived) ...[
              StatusBanner(
                kind: StatusBannerKind.alert,
                icon: Icons.inventory_2_outlined,
                message: l10n.archivedBanner,
              ),
              SizedBox(height: AppSpacing.md),
            ],
            TableSummaryCard(settings: table.settings, showName: false),
            SizedBox(height: AppSpacing.md),
            Text(l10n.activityTitle, style: text.titleMedium),
            SizedBox(height: AppSpacing.sm),
            if (activity != null && activity.isEmpty)
              Text(l10n.activityEmpty, style: text.bodyMedium),
            for (final entry in activity ?? const <TableActivity>[])
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.history),
                title: Text(describe(entry)),
                subtitle: Text(
                  '${material.formatMediumDate(entry.at.toLocal())} · '
                  '${material.formatTimeOfDay(TimeOfDay.fromDateTime(entry.at.toLocal()))}',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
