// Suppression du compte [T15] (US-17, EF-CPT-04, ENF-10).
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'account_providers.dart';
import 'backup_widgets.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  ConsumerState<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  final _confirmation = TextEditingController();
  var _busy = false;

  @override
  void dispose() {
    _confirmation.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _busy = true);
    try {
      await ref.read(sessionActionsProvider).deleteAccount();
    } on Exception {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.deleteAccountOffline)),
      );
      if (mounted) setState(() => _busy = false);
      return;
    }
    if (mounted) context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final confirmed =
        _confirmation.text.trim().toUpperCase() ==
        l10n.deleteAccountConfirmWord;
    Widget consequence(Widget icon, String text) => Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          IconTheme.merge(
            data: IconThemeData(color: colors.onSurfaceVariant),
            child: icon,
          ),
          SizedBox(width: AppSpacing.md),
          Expanded(child: Text(text, style: theme.textTheme.bodyLarge)),
        ],
      ),
    );
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: l10n.cancel,
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.deleteAccountTitle),
      ),
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 640),
            child: Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.all(AppSpacing.md),
                    children: [
                      Card(
                        margin: EdgeInsets.zero,
                        color: colors.primaryContainer,
                        child: Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.deleteAccountBackupTitle,
                                style: theme.textTheme.titleMedium,
                              ),
                              SizedBox(height: AppSpacing.xs),
                              Text(l10n.deleteAccountBackupBody),
                              SizedBox(height: AppSpacing.sm),
                              FilledButton.icon(
                                onPressed: () => exportMyData(context, ref),
                                icon: const Icon(Icons.download_outlined),
                                label: Text(l10n.exportDataAction),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        l10n.deleteAccountWhatHappens,
                        style: theme.textTheme.titleMedium,
                      ),
                      SizedBox(height: AppSpacing.sm),
                      consequence(
                        GameIcon(GameIcons.navigation['characters']!),
                        l10n.deleteAccountCharacters,
                      ),
                      consequence(
                        GameIcon(GameIcons.navigation['tables']!),
                        l10n.deleteAccountTables,
                      ),
                      consequence(
                        GameIcon(GameIcons.navigation['homebrew']!),
                        l10n.deleteAccountPacks,
                      ),
                      consequence(
                        const Icon(Icons.schedule),
                        l10n.deleteAccountServers,
                      ),
                      SizedBox(height: AppSpacing.md),
                      TextField(
                        controller: _confirmation,
                        enabled: !_busy,
                        autocorrect: false,
                        textCapitalization: TextCapitalization.characters,
                        onChanged: (_) => setState(() {}),
                        decoration: InputDecoration(
                          labelText: l10n.deleteAccountConfirmLabel,
                          helperText: l10n.deleteAccountFinal,
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: colors.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: _busy ? null : () => context.pop(),
                          child: Text(l10n.cancel),
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: colors.error,
                            foregroundColor: colors.onError,
                          ),
                          onPressed: confirmed && !_busy ? _delete : null,
                          child: Text(l10n.deleteAccountConfirm),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
