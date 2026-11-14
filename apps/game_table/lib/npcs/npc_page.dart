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
            ],
          ),
        ),
      ),
    );
  }
}
