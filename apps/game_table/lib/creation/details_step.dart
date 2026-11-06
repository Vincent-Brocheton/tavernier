import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_draft.dart';
import 'creation_providers.dart';

/// Nom français d'un alignement (SRD, « Étape 4. Alignement »).
String alignmentName(AppLocalizations l10n, String code) => switch (code) {
  'LB' => l10n.alignmentLB,
  'NB' => l10n.alignmentNB,
  'CB' => l10n.alignmentCB,
  'LN' => l10n.alignmentLN,
  'N' => l10n.alignmentN,
  'CN' => l10n.alignmentCN,
  'LM' => l10n.alignmentLM,
  'NM' => l10n.alignmentNM,
  'CM' => l10n.alignmentCM,
  _ => code,
};

/// Étape 8, Détails [P7].
class DetailsStep extends ConsumerWidget {
  const DetailsStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(creationProvider);
    final notifier = ref.read(creationProvider.notifier);
    Widget field(
      String label,
      String value,
      CreationDraft Function(CreationDraft, String) change, {
      int lines = 3,
    }) => Padding(
      padding: EdgeInsets.only(bottom: AppSpacing.sm),
      child: TextFormField(
        initialValue: value,
        minLines: lines,
        maxLines: lines == 1 ? 1 : null,
        decoration: InputDecoration(labelText: label),
        onChanged: (text) => notifier.update((d) => change(d, text)),
      ),
    );

    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: Padding(
            padding: EdgeInsets.only(top: AppSpacing.xs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                field(
                  l10n.detailName,
                  draft.name,
                  (d, text) => d.withDetails(name: text),
                  lines: 1,
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: AppSpacing.sm),
                  child: DropdownButtonFormField<String>(
                    initialValue: draft.alignment,
                    decoration: InputDecoration(
                      labelText: l10n.detailAlignment,
                    ),
                    items: [
                      for (final code in alignments)
                        DropdownMenuItem(
                          value: code,
                          child: Text(alignmentName(l10n, code)),
                        ),
                    ],
                    onChanged: (code) =>
                        notifier.update((d) => d.withDetails(alignment: code)),
                  ),
                ),
                field(
                  l10n.detailAppearance,
                  draft.appearance,
                  (d, text) => d.withDetails(appearance: text),
                ),
                field(
                  l10n.detailPersonality,
                  draft.personality,
                  (d, text) => d.withDetails(personality: text),
                ),
                field(
                  l10n.detailBackstory,
                  draft.backstory,
                  (d, text) => d.withDetails(backstory: text),
                  lines: 5,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
