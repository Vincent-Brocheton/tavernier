import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'table_summary_card.dart';
import 'tables_providers.dart';

/// Page d'une table, première version (US-13) : le rôle, le nom, la
/// description et le résumé des réglages. La configuration [F6] et les
/// autres onglets viennent avec les cartes suivantes.
class TablePage extends ConsumerWidget {
  const TablePage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final table = ref.watch(tableProvider(id)).value;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
      ),
      body: SafeArea(
        child: table == null
            ? const SizedBox.shrink()
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: ListView(
                    padding: EdgeInsets.all(AppSpacing.md),
                    children: [
                      Text(
                        (table.role == TableRole.gm
                                ? l10n.youAreGm
                                : l10n.youArePlayer)
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
                      if (table.settings.description case final description?)
                        Padding(
                          padding: EdgeInsets.only(top: AppSpacing.xs),
                          child: Text(description, style: text.bodyMedium),
                        ),
                      SizedBox(height: AppSpacing.md),
                      TableSummaryCard(
                        settings: table.settings,
                        showName: false,
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
