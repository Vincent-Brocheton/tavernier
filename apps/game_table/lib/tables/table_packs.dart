// Packs d'une table (US-30 lot b, EF-HB-09, EF-HB-10) : le SRD verrouillé,
// et les packs activés par le MJ, chacun à sa version figée. Activer envoie
// le fichier au stockage, puis l'inscrit dans `table_pack`.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../homebrew/import_page.dart' show importedPacksProvider;
import '../homebrew/pack_storage.dart';
import '../l10n/app_localizations.dart';
import 'tables_providers.dart';

class TablePacksCard extends ConsumerStatefulWidget {
  const TablePacksCard({
    super.key,
    required this.tableId,
    required this.editable,
  });

  final String tableId;

  /// Le MJ d'une table non archivée change ses packs.
  final bool editable;

  @override
  ConsumerState<TablePacksCard> createState() => _TablePacksState();
}

class _TablePacksState extends ConsumerState<TablePacksCard> {
  bool _busy = false;

  /// Envoie le fichier de [version], puis fige [packId] à cette version.
  Future<void> _activate(String packId, String version) async {
    final l10n = AppLocalizations.of(context);
    final db = ref.read(databaseProvider);
    final bytes = await PackLibrary(db).file(packId, version);
    if (bytes == null) return;
    setState(() => _busy = true);
    final sha = fileSha256(bytes);
    try {
      await ref.read(packStorageProvider)?.upload(sha, bytes);
      await ref
          .read(tableStoreProvider)
          .setPack(
            widget.tableId,
            packId: packId,
            version: version,
            fileSha256: sha,
          );
    } on Object {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(l10n.tablePacksUploadFailed)));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _choose(
    AppLocalizations l10n,
    Map<String, InstalledVersion> candidates,
  ) async {
    final chosen = await showModalBottomSheet<InstalledVersion>(
      context: context,
      builder: (sheet) => SafeArea(
        child: ListView(
          shrinkWrap: true,
          children: [
            ListTile(title: Text(l10n.tablePacksActivate)),
            if (candidates.isEmpty)
              ListTile(subtitle: Text(l10n.tablePacksNone)),
            for (final v in candidates.values)
              ListTile(
                title: Text(v.pack.manifest.name),
                subtitle: Text('v${v.version} · ${v.pack.manifest.author}'),
                onTap: () => Navigator.pop(sheet, v),
              ),
          ],
        ),
      ),
    );
    if (chosen != null) await _activate(chosen.packId, chosen.version);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final srd = ref.watch(srdPackProvider).value?.manifest;
    final active = [
      for (final p
          in ref.watch(activePacksProvider).value ?? const <ActivePack>[])
        if (p.tableId == widget.tableId && p.packId != srd?.id) p,
    ];
    final versions = ref.watch(importedPacksProvider).value ?? const [];
    List<InstalledVersion> of(String packId) => [
      for (final v in versions)
        if (v.packId == packId) v,
    ]..sort((a, b) => compareVersions(b.version, a.version));
    // Seul un pack gardé sous son identifiant d'origine se diffuse : un pack
    // distinct est renommé sur cet appareil seulement.
    final candidates = <String, InstalledVersion>{
      for (final v in [
        ...versions,
      ]..sort((a, b) => compareVersions(a.version, b.version)))
        if (v.packId == v.sourceId && !active.any((p) => p.packId == v.packId))
          v.packId: v,
    };

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.lock_outline),
          title: Text(l10n.srdPackName),
          subtitle: Text(l10n.tablePacksSrd),
        ),
        for (final p in active)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.inventory_2_outlined),
            title: Text(
              of(p.packId).firstOrNull?.pack.manifest.name ?? p.packId,
            ),
            subtitle: Text(l10n.tablePacksPinned(p.version)),
            trailing: widget.editable
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      PopupMenuButton<String>(
                        tooltip: l10n.tablePacksVersion,
                        enabled: !_busy,
                        onSelected: (v) => _activate(p.packId, v),
                        itemBuilder: (_) => [
                          for (final v in of(p.packId))
                            PopupMenuItem(
                              value: v.version,
                              child: Text(
                                v.version == p.version
                                    ? l10n.tablePacksCurrent(v.version)
                                    : v.version,
                              ),
                            ),
                        ],
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Icon(Icons.history),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.tablePacksRemove,
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: _busy
                            ? null
                            : () => ref
                                  .read(tableStoreProvider)
                                  .removePack(widget.tableId, p.packId),
                      ),
                    ],
                  )
                : null,
          ),
        if (widget.editable)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: _busy ? null : () => _choose(l10n, candidates),
              icon: const Icon(Icons.add),
              label: Text(l10n.tablePacksActivate),
            ),
          ),
        Text(l10n.tablePacksHint, style: text.bodySmall),
      ],
    );
  }
}
