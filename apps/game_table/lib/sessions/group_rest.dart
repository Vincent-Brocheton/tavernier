// Repos de groupe (US-38, EF-PJ-19, [J9], [J10]) : le MJ le déclenche pour
// les PJ présents et suit qui a terminé ; chaque joueur le reçoit sur sa
// fiche.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../sheet/rest_sheet.dart';
import '../sheet/sheet_access.dart';
import '../sheet/sheet_page.dart';
import '../tables/tables_providers.dart';

/// Seule voie d'écriture des repos de groupe (cahier §10).
final groupRestStoreProvider = Provider<GroupRestStore>(
  (ref) => GroupRestStore(ref.watch(databaseProvider)),
);

/// Repos ouverts d'une table, le plus récent d'abord.
final openRestsProvider = StreamProvider.autoDispose
    .family<List<GroupRest>, String>(
      (ref, tableId) => ref.watch(groupRestStoreProvider).watchOpen(tableId),
    );

/// Repos ouvert qui attend encore le PJ de la fiche donnée.
final restForCharacterProvider = StreamProvider.autoDispose
    .family<GroupRest?, String>(
      (ref, id) => ref.watch(groupRestStoreProvider).watchForCharacter(id),
    );

/// Récapitulatifs d'un repos, par fiche.
final restDoneProvider = StreamProvider.autoDispose
    .family<Map<String, Map<String, Object?>>, String>(
      (ref, restId) => ref.watch(groupRestStoreProvider).watchDone(restId),
    );

RestKind _kind(GroupRest rest) =>
    rest.kind == 'long' ? RestKind.long : RestKind.short;

/// Pseudonyme du MJ de [tableId], ou « Le MJ ».
String _gmName(WidgetRef ref, AppLocalizations l10n, String tableId) =>
    (ref.watch(tableMembersProvider(tableId)).value ?? const [])
        .where((m) => m.role == TableRole.gm)
        .firstOrNull
        ?.pseudonym ??
    l10n.groupRestGm;

/// Ouvre l'écran de repos de [rest] sur la fiche [id] ; « Terminer » signale
/// la fin, avec son récapitulatif, au nom de l'utilisateur.
Future<void> openGroupRest(
  BuildContext context,
  WidgetRef ref, {
  required GroupRest rest,
  required String id,
  required String origin,
}) async {
  // L'écran part de l'état de jeu : il doit être chargé.
  final character = await ref.read(characterProvider(id).future);
  final play = await ref.read(playStateProvider(id).future);
  final content = await ref.read(contentProvider.future);
  if (character == null || !context.mounted) return;
  final store = ref.read(groupRestStoreProvider);
  final author = ref.read(currentUserProvider).value?.id;
  await showAdaptiveSheet(
    context,
    RestSheet(
      id: id,
      kind: _kind(rest),
      content: content,
      character: character,
      sheet: computeSheet(character, content, exhaustion: play.exhaustion),
      origin: origin,
      onFinished: (summary) => store.markDone(
        restId: rest.id,
        tableId: rest.tableId,
        characterId: id,
        authorUserId: author,
        summary: summary,
      ),
    ),
  );
}

/// « 2 dés de vie dépensés · PV 34 → 41 ».
String restSummaryLabel(AppLocalizations l10n, Map<String, Object?> s) =>
    l10n.groupRestSummary(
      (s['hit_dice'] as int?) ?? 0,
      (s['hp_before'] as int?) ?? 0,
      (s['hp_after'] as int?) ?? 0,
    );

/// Panneau du MJ sur une séance en cours ([J9]) : déclencher le repos pour
/// les PJ [present], suivre qui a terminé, le faire pour un absent, clore.
class GroupRestPanel extends ConsumerWidget {
  const GroupRestPanel({
    super.key,
    required this.tableId,
    required this.sessionId,
    required this.present,
    required this.group,
  });

  final String tableId;
  final String sessionId;
  final Set<String> present;
  final List<CharacterSummary> group;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final store = ref.watch(groupRestStoreProvider);
    final rest = (ref.watch(openRestsProvider(tableId)).value ?? const [])
        .where((r) => r.sessionId == sessionId)
        .firstOrNull;
    final names = {for (final pc in group) pc.id: pc.name};
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l10n.groupRestTitle, style: text.titleMedium),
            if (rest == null) ...[
              Text(
                present.isEmpty ? l10n.groupRestNoPresent : l10n.groupRestHelp,
                style: text.bodySmall,
              ),
              SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.sm,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final (kind, label) in [
                    ('short', l10n.shortRest),
                    ('long', l10n.longRest),
                  ])
                    OutlinedButton(
                      onPressed: present.isEmpty
                          ? null
                          : () => store.start(
                              tableId: tableId,
                              sessionId: sessionId,
                              kind: kind,
                              characters: [
                                for (final pc in group)
                                  if (present.contains(pc.id)) pc.id,
                              ],
                            ),
                      child: Text(label),
                    ),
                ],
              ),
            ] else ...[
              Text(
                rest.kind == 'long'
                    ? l10n.groupRestOpenLong
                    : l10n.groupRestOpenShort,
                style: text.bodySmall,
              ),
              for (final id in rest.characters)
                _RestRow(rest: rest, id: id, name: names[id] ?? '?'),
              SizedBox(height: AppSpacing.sm),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: () => store.close(rest.id),
                  child: Text(l10n.groupRestClose),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _RestRow extends ConsumerWidget {
  const _RestRow({required this.rest, required this.id, required this.name});

  final GroupRest rest;
  final String id;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final done = ref.watch(restDoneProvider(rest.id)).value?[id];
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(name),
      subtitle: done == null
          ? TextButton(
              style: TextButton.styleFrom(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.zero,
              ),
              onPressed: () => openGroupRest(
                context,
                ref,
                rest: rest,
                id: id,
                origin: l10n.groupRestOrigin(
                  name,
                  _gmName(ref, l10n, rest.tableId),
                ),
              ),
              child: Text(l10n.groupRestDoFor(name)),
            )
          : Text(restSummaryLabel(l10n, done)),
      trailing: Chip(
        label: Text(done == null ? l10n.groupRestWaiting : l10n.groupRestDone),
      ),
    );
  }
}

/// Bandeau de la fiche d'un PJ attendu par un repos de groupe ([J10]).
class GroupRestBanner extends ConsumerWidget {
  const GroupRestBanner({super.key, required this.id, required this.name});

  final String id;
  final String name;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rest = ref.watch(restForCharacterProvider(id)).value;
    // Le propriétaire, ou le MJ ; pas un membre qui lit la fiche.
    if (rest == null || !SheetAccess.editableOf(context)) {
      return const SizedBox.shrink();
    }
    final gm = _gmName(ref, l10n, rest.tableId);
    return MaterialBanner(
      leading: const Icon(Icons.bedtime_outlined),
      content: Text(
        rest.kind == 'long'
            ? l10n.groupRestBannerLong(gm)
            : l10n.groupRestBannerShort(gm),
      ),
      actions: [
        FilledButton(
          onPressed: () => openGroupRest(
            context,
            ref,
            rest: rest,
            id: id,
            origin: l10n.groupRestOrigin(name, gm),
          ),
          child: Text(l10n.groupRestDo),
        ),
      ],
    );
  }
}
