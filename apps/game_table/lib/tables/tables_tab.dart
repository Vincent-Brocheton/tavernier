import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../l10n/app_localizations.dart';
import 'table_labels.dart';
import 'tables_providers.dart';

/// Onglet Tables : un compte est nécessaire (cahier §4) ; sans session, on
/// propose de se connecter. Connecté, les tables de l'utilisateur et
/// « Nouvelle table » (US-13).
class TablesTab extends ConsumerWidget {
  const TablesTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final accounts = ref.watch(accountGatewayProvider) != null;
    final signedIn = ref.watch(currentUserProvider).value != null;

    if (!accounts || !signedIn) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(l10n.navTables, style: text.headlineMedium),
              SizedBox(height: AppSpacing.sm),
              Text(l10n.signInPurpose, textAlign: TextAlign.center),
              if (accounts) ...[
                SizedBox(height: AppSpacing.md),
                FilledButton(
                  onPressed: () => context.push('/connexion'),
                  child: Text(l10n.signInAction),
                ),
              ],
            ],
          ),
        ),
      );
    }

    final tables = ref.watch(myTablesProvider).value ?? const [];
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            Text(l10n.navTables, style: text.headlineMedium),
            SizedBox(height: AppSpacing.md),
            if (tables.isEmpty)
              Text(l10n.tablesEmpty, style: text.bodyMedium)
            else
              for (final table in tables)
                Card(
                  margin: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ListTile(
                    title: Text(table.settings.name),
                    subtitle: Text(
                      [
                        l10n.role(table.role),
                        l10n.statMethod(table.settings.statMethod),
                        l10n.progression(table.settings.progression),
                      ].join(' · '),
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push('/tables/${table.id}'),
                  ),
                ),
            SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                FilledButton.icon(
                  onPressed: () => context.push('/rejoindre'),
                  icon: const Icon(Icons.login),
                  label: Text(l10n.joinTable),
                ),
                OutlinedButton.icon(
                  onPressed: () => context.push('/tables/nouvelle'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.newTable),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
