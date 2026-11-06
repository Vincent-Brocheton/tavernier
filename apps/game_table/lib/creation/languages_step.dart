import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import 'creation_providers.dart';
import 'step_layout.dart';

/// Étape 4, Langues [P4].
class LanguagesStep extends ConsumerWidget {
  const LanguagesStep({super.key, required this.content});

  final ActiveContent content;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final notifier = ref.read(creationProvider.notifier);
    final chosen = ref.watch(creationProvider.select((d) => d.languages));
    final full = chosen.length == startingLanguageChoices;
    final languages = [
      for (final e in sortedEntities(content, 'language'))
        if ((e.data as LanguageData).category == LanguageCategory.standard &&
            '${e.id}' != startingLanguageId)
          e,
    ];

    return SingleChildScrollView(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CheckboxListTile(
              value: true,
              onChanged: null,
              controlAffinity: ListTileControlAffinity.leading,
              title: Text(namesOf(content, [startingLanguageId])),
              subtitle: Text(l10n.commonLanguageHint),
              secondary: const Icon(Icons.lock_outline),
            ),
            Padding(
              padding: EdgeInsets.only(top: AppSpacing.sm),
              child: Wrap(
                alignment: WrapAlignment.spaceBetween,
                crossAxisAlignment: WrapCrossAlignment.center,
                spacing: AppSpacing.xs,
                children: [
                  Text(l10n.standardLanguages, style: text.titleSmall),
                  SourceBadge(
                    l10n.countOf(chosen.length, startingLanguageChoices),
                  ),
                  TextButton(
                    onPressed: full
                        ? null
                        : () => notifier.update(
                            (d) => d.drawLanguages([
                              for (final e in languages) '${e.id}',
                            ]),
                          ),
                    child: Text(l10n.drawLanguages),
                  ),
                ],
              ),
            ),
            for (final language in languages)
              CheckboxListTile(
                value: chosen.contains('${language.id}'),
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(language.name),
                onChanged: full && !chosen.contains('${language.id}')
                    ? null
                    : (_) => notifier.update(
                        (d) => d.toggleLanguage('${language.id}'),
                      ),
              ),
            SizedBox(height: AppSpacing.sm),
            Text(l10n.rareLanguagesRule, style: text.bodySmall),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
