// Onglet « PNJ » d'une table, pour son MJ (US-18, EF-PNJ-02, [F4]).
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import 'npcs_providers.dart';

/// PNJ de [table] rangés par dossier, filtrés par attitude.
class NpcsTab extends ConsumerStatefulWidget {
  const NpcsTab({super.key, required this.table});

  final TableSummary table;

  @override
  ConsumerState<NpcsTab> createState() => _NpcsTabState();
}

class _NpcsTabState extends ConsumerState<NpcsTab> {
  /// Attitude filtrée ; `null` : tous.
  Attitude? _filter;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final npcs = ref.watch(tableNpcsProvider(widget.table.id)).value;
    final content = ref.watch(contentProvider).value;
    if (npcs == null || content == null) {
      return const Center(child: CircularProgressIndicator());
    }
    int count(Attitude a) => npcs.where((n) => n.attitude == a).length;
    final shown = [
      for (final n in npcs)
        if (_filter == null || n.attitude == _filter) n,
    ];
    final filters = [
      (null, l10n.npcFilterAll(npcs.length)),
      (Attitude.hostile, l10n.npcFilterHostile(count(Attitude.hostile))),
      (Attitude.friendly, l10n.npcFilterFriendly(count(Attitude.friendly))),
      (
        Attitude.indifferent,
        l10n.npcFilterIndifferent(count(Attitude.indifferent)),
      ),
    ];
    // Dans l'ordre de la liste : par dossier, sans dossier en dernier.
    final groups = <String?, List<Npc>>{};
    for (final npc in shown) {
      (groups[npc.folder] ??= []).add(npc);
    }
    return Align(
      alignment: Alignment.topLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            if (!widget.table.archived)
              Align(
                alignment: Alignment.centerLeft,
                child: FilledButton.tonalIcon(
                  onPressed: () =>
                      context.push('/tables/${widget.table.id}/pnj/nouveau'),
                  icon: const Icon(Icons.add),
                  label: Text(l10n.npcNew),
                ),
              ),
            if (npcs.isEmpty)
              Padding(
                padding: EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  l10n.npcEmpty,
                  textAlign: TextAlign.center,
                  style: text.titleMedium,
                ),
              )
            else ...[
              SizedBox(height: AppSpacing.sm),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  for (final (attitude, label) in filters)
                    ChoiceChip(
                      label: Text(label),
                      selected: _filter == attitude,
                      onSelected: (_) => setState(() => _filter = attitude),
                    ),
                ],
              ),
              for (final MapEntry(key: folder, value: list)
                  in groups.entries) ...[
                Padding(
                  padding: EdgeInsets.only(
                    top: AppSpacing.md,
                    bottom: AppSpacing.xs,
                  ),
                  child: Text(
                    (folder ?? l10n.npcNoFolder).toUpperCase(),
                    style: text.labelLarge,
                  ),
                ),
                for (final npc in list)
                  _NpcTile(tableId: widget.table.id, npc: npc),
              ],
            ],
          ],
        ),
      ),
    );
  }
}

class _NpcTile extends ConsumerWidget {
  const _NpcTile({required this.tableId, required this.npc});

  final String tableId;
  final Npc npc;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value!;
    final monster = monsterOf(content, npc.monsterId);
    final (label, icon) = attitudeLabel(l10n, npc.attitude);
    return Card(
      margin: EdgeInsets.only(bottom: AppSpacing.xs),
      child: ListTile(
        leading: CircleAvatar(
          child: Text(npc.name.characters.first.toUpperCase()),
        ),
        title: Text(npc.name),
        subtitle: monster == null
            ? null
            : Text(
                l10n.npcSummary(
                  content.entity(npc.monsterId!)!.name,
                  monster.cr,
                  sourceLabelOf(l10n, content, npc.monsterId!),
                ),
              ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 18),
            SizedBox(width: AppSpacing.xs),
            Text(label, style: text.labelLarge),
          ],
        ),
        onTap: () => context.push('/tables/$tableId/pnj/${npc.id}'),
      ),
    );
  }
}
