import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'table_labels.dart';

/// Résumé des réglages d'une table : l'aperçu de [T8], et la carte de la
/// page de la table.
class TableSummaryCard extends StatelessWidget {
  const TableSummaryCard({
    super.key,
    required this.settings,
    this.title,
    this.footer,
    this.showName = true,
  });

  /// Faux sur la page de la table, qui porte déjà le nom en tête.
  final bool showName;

  final TableSettings settings;

  /// Au-dessus du nom (« Aperçu de la carte »).
  final String? title;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final rows = [
      (l10n.startingLevelShort, '${settings.startingLevel}'),
      (l10n.previewCharacteristics, l10n.statMethod(settings.statMethod)),
      (l10n.previewLongRest, l10n.longRestShort(settings.longRest)),
      (l10n.previewHpPerLevel, l10n.hpOnLevel(settings.hpOnLevel)),
      (l10n.previewProgression, l10n.progression(settings.progression)),
      (l10n.previewPacks, l10n.srdPackName),
    ];
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title case final title?) Text(title, style: text.labelMedium),
            SizedBox(height: AppSpacing.xs),
            if (showName) ...[
              Text(
                settings.name.trim().isEmpty ? '—' : settings.name.trim(),
                style: text.headlineSmall!.copyWith(color: scheme.tertiary),
              ),
              SizedBox(height: AppSpacing.sm),
            ],
            for (final (label, value) in rows)
              Padding(
                padding: EdgeInsets.symmetric(vertical: AppSpacing.xxs),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: Text(label, style: text.bodyMedium)),
                    Expanded(child: Text(value, style: text.bodyMedium)),
                  ],
                ),
              ),
            if (footer case final footer?) ...[
              SizedBox(height: AppSpacing.sm),
              Text(footer, style: text.bodySmall),
            ],
          ],
        ),
      ),
    );
  }
}
