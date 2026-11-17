// Fiche d'un PNJ en bloc de stats (US-18, [C2]) : profil du monstre de
// départ, attitude envers le groupe, duplication.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import '../tables/tables_providers.dart';
import 'hidden_info_sheet.dart';
import 'new_npc_page.dart';
import 'npcs_providers.dart';
import 'stat_block_view.dart';

class NpcPage extends ConsumerWidget {
  const NpcPage({super.key, required this.tableId, required this.id});

  final String tableId;
  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final table = ref.watch(tableProvider(tableId)).value;
    final content = ref.watch(contentProvider).value;
    final npc = (ref.watch(tableNpcsProvider(tableId)).value ?? const <Npc>[])
        .where((n) => n.id == id)
        .firstOrNull;
    if (table == null || content == null || npc == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final store = ref.read(npcStoreProvider);
    final monster = monsterOf(content, npc.monsterId);
    final editable = !table.archived;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.npcHeader(table.settings.name)),
        actions: [
          if (editable)
            IconButton(
              tooltip: l10n.npcEdit,
              icon: const Icon(Icons.edit_outlined),
              onPressed: () async {
                final edit = await editNpcIdentity(context, npc);
                if (edit case (final name, final folder)) {
                  await store.update(
                    npc.id,
                    name: name,
                    folder: folder.isEmpty ? null : folder,
                    clearFolder: folder.isEmpty,
                  );
                }
              },
            ),
          if (editable)
            TextButton.icon(
              onPressed: () async {
                final copy = await store.duplicate(npc.id);
                if (context.mounted) {
                  // La copie remplace l'original : revenir ramène à la liste.
                  context.pushReplacement('/tables/$tableId/pnj/$copy');
                }
              },
              icon: const Icon(Icons.copy_outlined),
              label: Text(l10n.npcDuplicate),
            ),
        ],
      ),
      body: Align(
        alignment: Alignment.topCenter,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: [
              if (monster == null) ...[
                Text(npc.name, style: text.headlineSmall),
                if (npc.monsterId case final missing?)
                  Text(l10n.statMonsterMissing(missing)),
              ] else ...[
                StatBlockView(
                  monster: monster,
                  content: content,
                  name: npc.name,
                  source: l10n.statVariantOf(
                    content.entity(npc.monsterId!)!.name,
                    packLabelOf(l10n, content, npc.monsterId!),
                  ),
                ),
              ],
              SizedBox(height: AppSpacing.lg),
              Text(l10n.npcAttitudeTitle, style: text.titleMedium),
              SizedBox(height: AppSpacing.xs),
              IgnorePointer(
                ignoring: !editable,
                child: AttitudeSelector(
                  value: npc.attitude,
                  onChanged: (a) => store.update(npc.id, attitude: a),
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(l10n.npcAttitudeHelp, style: text.bodySmall),
              SizedBox(height: AppSpacing.lg),
              _HiddenInfoSection(npc: npc, editable: editable),
            ],
          ),
        ),
      ),
    );
  }
}

/// Informations cachées par palier de DD, révélées par l'Étude
/// (EF-PNJ-03, [C2]).
class _HiddenInfoSection extends ConsumerWidget {
  const _HiddenInfoSection({required this.npc, required this.editable});

  final Npc npc;
  final bool editable;

  /// Remplace le palier [index] (ou ajoute, sans [index]) puis réécrit la
  /// liste triée par DD.
  Future<void> _edit(BuildContext context, WidgetRef ref, [int? index]) async {
    final edit = await editHiddenInfo(
      context,
      initial: index == null ? null : npc.hiddenInfo[index],
    );
    if (edit == null) return;
    final list = [...npc.hiddenInfo];
    switch (edit) {
      case HiddenInfoSaved(:final info) when index == null:
        list.add(info);
      case HiddenInfoSaved(:final info):
        list[index!] = info;
      case HiddenInfoDeleted():
        list.removeAt(index!);
    }
    list.sort((a, b) => a.dc.compareTo(b.dc));
    await ref.read(npcStoreProvider).update(npc.id, hiddenInfo: list);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.hiddenInfoTitle, style: text.titleMedium),
        Text(l10n.hiddenInfoSubtitle, style: text.bodySmall),
        SizedBox(height: AppSpacing.xs),
        for (final (index, info) in npc.hiddenInfo.indexed)
          Card(
            margin: EdgeInsets.only(bottom: AppSpacing.xs),
            child: ListTile(
              leading: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(l10n.hiddenInfoDc, style: text.labelSmall),
                  Text('${info.dc}', style: text.titleMedium),
                ],
              ),
              title: Text(info.text),
              subtitle: Row(
                children: [
                  Icon(
                    info.revealed
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    size: 16,
                    color: scheme.onSurfaceVariant,
                  ),
                  SizedBox(width: AppSpacing.xs),
                  Text(
                    info.revealed
                        ? l10n.hiddenInfoRevealed
                        : l10n.hiddenInfoHidden,
                  ),
                ],
              ),
              onTap: editable ? () => _edit(context, ref, index) : null,
            ),
          ),
        if (editable)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _edit(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.hiddenInfoAdd),
            ),
          ),
      ],
    );
  }
}
