import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'device_settings.dart';

/// Demande le consentement aux rapports de plantage [T1] s'il ne l'a pas été
/// (EF-CPT-06) : le dialogue ne se ferme qu'avec une réponse.
Future<void> askCrashConsentIfNeeded(
  BuildContext context,
  WidgetRef ref,
) async {
  if (ref.read(deviceSettingsProvider).crashReports != null) return;
  final consent = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const CrashConsentDialog(),
  );
  await ref.read(deviceSettingsProvider.notifier).setCrashReports(consent!);
}

/// Dialogue du premier lancement [T1] : rien de jeu, aucune mesure d'usage,
/// modifiable dans les réglages.
class CrashConsentDialog extends StatelessWidget {
  const CrashConsentDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return PopScope(
      canPop: false,
      child: AlertDialog(
        icon: const Icon(Icons.verified_user_outlined),
        // Titre en texte courant, comme [T1] (pas la police d'affichage).
        title: Text(
          l10n.consentTitle,
          textAlign: TextAlign.center,
          style: text.headlineSmall!.copyWith(
            fontFamily: text.bodyLarge!.fontFamily,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.consentBody, style: text.bodyMedium),
            SizedBox(height: AppSpacing.sm),
            for (final point in [
              l10n.consentNoGameData,
              l10n.consentNoUsage,
              l10n.consentChangeable,
            ])
              Padding(
                padding: EdgeInsets.only(top: AppSpacing.xxs),
                child: Text('•  $point', style: text.bodyMedium),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(l10n.consentRefuse),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l10n.consentAccept),
          ),
        ],
      ),
    );
  }
}
