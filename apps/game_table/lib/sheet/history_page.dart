import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../tables/table_labels.dart';
import 'conflicts.dart';

/// Adresse de l'historique d'une fiche.
String historyPath(String id) => '/characters/$id/historique';

/// Historique d'une fiche, avec le pseudonyme de chaque auteur connu.
final _historyProvider = FutureProvider.autoDispose
    .family<
      ({List<CharacterHistoryEntry> entries, Map<String, String> authors}),
      String
    >((ref, id) async {
      final entries = await ref.watch(characterStoreProvider).history(id);
      final store = ref.watch(characterStoreProvider);
      final authors = <String, String>{};
      for (final author in {
        ...entries.map((e) => e.authorUserId).nonNulls,
        for (final e in entries) ...[
          if (e.detail['kept_by'] case final String id) id,
          if (e.detail['replaced_by'] case final String id) id,
        ],
      }) {
        if (await store.pseudonymOf(author) case final pseudonym?) {
          authors[author] = pseudonym;
        }
      }
      return (entries: entries, authors: authors);
    });

/// Historique de la fiche (partie de [N2]) : dérogations du MJ, la plus
/// récente d'abord ; aucune notification n'a été envoyée (cahier §4.3).
class HistoryPage extends ConsumerWidget {
  const HistoryPage({super.key, required this.id});

  final String id;

  String _title(AppLocalizations l10n, Map<String, Object?> detail) {
    final sheet = '${detail['sheet']}';
    if (detail['kind'] == 'conflict') {
      return l10n.historyConflict(l10n.conflictField(detail['field']));
    }
    return switch (detail['check']) {
      'level' => l10n.historyDerogationLevel(sheet),
      'method' => l10n.historyDerogationMethod(
        l10n.statMethod(
          ScoreMethod.values.asNameMap()[sheet] ?? ScoreMethod.pointBuy,
        ),
      ),
      _ => l10n.historyDerogationRule('${detail['label'] ?? ''}'),
    };
  }

  /// Valeur d'un écart, telle qu'un joueur la lit.
  String _value(AppLocalizations l10n, Object? check, Object? value) =>
      switch ((check, ScoreMethod.values.asNameMap()['$value'])) {
        ('method', final method?) => l10n.statMethod(method),
        _ => '$value',
      };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final material = MaterialLocalizations.of(context);
    final history = ref.watch(_historyProvider(id)).value;
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.canPop() ? context.pop() : context.go('/'),
        ),
        title: Text(l10n.historyTitle),
      ),
      body: SafeArea(
        child: history == null
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: EdgeInsets.all(AppSpacing.md),
                children: [
                  if (history.entries.isEmpty)
                    Text(l10n.historyEmpty, style: text.bodyMedium),
                  for (final entry in history.entries)
                    Card(
                      margin: EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.md),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _title(l10n, entry.detail),
                              style: text.titleMedium,
                            ),
                            Text(
                              l10n.historyAuthor(
                                '${material.formatMediumDate(entry.at.toLocal())} · '
                                '${material.formatTimeOfDay(TimeOfDay.fromDateTime(entry.at.toLocal()))}',
                                history.authors[entry.authorUserId] ??
                                    l10n.roleGm,
                              ),
                              style: text.bodySmall,
                            ),
                            if (entry.detail['kind'] == 'conflict') ...[
                              SizedBox(height: AppSpacing.xs),
                              // EF-PJ-13 : la valeur écrasée reste visible,
                              // barrée.
                              Text.rich(
                                TextSpan(
                                  children: [
                                    TextSpan(
                                      text: l10n.conflictValue(
                                        entry.detail['replaced'],
                                      ),
                                      style: const TextStyle(
                                        decoration: TextDecoration.lineThrough,
                                      ),
                                    ),
                                    const TextSpan(text: '  →  '),
                                    TextSpan(
                                      text: l10n.conflictValue(
                                        entry.detail['kept'],
                                      ),
                                    ),
                                  ],
                                ),
                                style: text.bodyLarge,
                              ),
                              Text(
                                l10n.historyConflictAuthors(
                                  history.authors[entry.detail['kept_by']] ??
                                      l10n.conflictSomeone,
                                  history.authors[entry
                                          .detail['replaced_by']] ??
                                      l10n.conflictSomeone,
                                ),
                                style: text.bodySmall,
                              ),
                            ] else if (entry.detail['table'] != null) ...[
                              SizedBox(height: AppSpacing.xs),
                              Text(
                                l10n.historyValues(
                                  _value(
                                    l10n,
                                    entry.detail['check'],
                                    entry.detail['table'],
                                  ),
                                  _value(
                                    l10n,
                                    entry.detail['check'],
                                    entry.detail['sheet'],
                                  ),
                                ),
                                style: text.bodyMedium,
                              ),
                            ],
                            if (entry.detail['message'] case final String m)
                              Text(
                                l10n.historyMessage(m),
                                style: text.bodyMedium,
                              ),
                            SizedBox(height: AppSpacing.xs),
                            Text(
                              l10n.historyNoNotification,
                              style: text.bodySmall,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
