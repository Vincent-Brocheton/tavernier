// « Mes données » [A7] et rappel de sauvegarde [G6] (US-17, ENF-10, ENF-12).
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'data_backup.dart';

/// Lance l'export ; dit s'il a échoué.
Future<void> exportMyData(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  try {
    await ref.read(dataBackupProvider).export();
  } on Exception {
    messenger.showSnackBar(SnackBar(content: Text(l10n.exportFailed)));
  }
}

/// Choisit une sauvegarde, fait confirmer, l'importe et dit ce qui a été
/// ajouté, ou pourquoi le fichier est refusé.
Future<void> importMyData(BuildContext context, WidgetRef ref) async {
  final messenger = ScaffoldMessenger.of(context);
  final l10n = AppLocalizations.of(context);
  final bytes = await ref.read(openFileProvider)();
  if (bytes == null || !context.mounted) return;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.importConfirmTitle),
      content: Text(l10n.importConfirmBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.importConfirm),
        ),
      ],
    ),
  );
  if (confirmed != true) return;
  String message;
  try {
    final result = await ref.read(dataBackupProvider).import(bytes);
    message = l10n.importDone(result.added, result.kept);
  } on FormatException {
    message = l10n.importRefused;
  } on Exception {
    message = l10n.importFailed;
  }
  messenger.showSnackBar(SnackBar(content: Text(message)));
}

/// Export et import des données, date du dernier export.
class MyDataSection extends ConsumerWidget {
  const MyDataSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final last = ref.watch(lastExportProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.exportDataHint),
        SizedBox(height: AppSpacing.sm),
        Text(
          last == null
              ? l10n.exportNever
              : l10n.exportLast(
                  MaterialLocalizations.of(context)
                      .formatMediumDate(last.toLocal()),
                ),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            OutlinedButton.icon(
              onPressed: () => exportMyData(context, ref),
              icon: const Icon(Icons.download_outlined),
              label: Text(l10n.exportDataAction),
            ),
            OutlinedButton.icon(
              onPressed: () => importMyData(context, ref),
              icon: const Icon(Icons.upload_file_outlined),
              label: Text(l10n.importDataAction),
            ),
          ],
        ),
      ],
    );
  }
}

/// « Aucune sauvegarde depuis N jours » [G6], sur l'accueil.
class BackupReminderBanner extends ConsumerWidget {
  const BackupReminderBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = ref.watch(backupReminderProvider);
    if (days == null) return const SizedBox.shrink();
    final l10n = AppLocalizations.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        StatusBanner(
          kind: StatusBannerKind.alert,
          icon: Icons.save_outlined,
          title: l10n.backupReminderTitle(days),
          message: l10n.backupReminderBody,
        ),
        Wrap(
          alignment: WrapAlignment.end,
          spacing: AppSpacing.sm,
          children: [
            TextButton(
              onPressed: () =>
                  ref.read(backupSnoozedProvider.notifier).snooze(),
              child: Text(l10n.backupLater),
            ),
            TextButton(
              onPressed: () => exportMyData(context, ref),
              child: Text(l10n.backupExportNow),
            ),
          ],
        ),
      ],
    );
  }
}
