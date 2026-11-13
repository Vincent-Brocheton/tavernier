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

/// Export des données et date du dernier export.
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
        Align(
          alignment: Alignment.centerLeft,
          child: OutlinedButton.icon(
            onPressed: () => exportMyData(context, ref),
            icon: const Icon(Icons.download_outlined),
            label: Text(l10n.exportDataAction),
          ),
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
