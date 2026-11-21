// Packs d'une table (US-30 lot b, EF-HB-09, EF-HB-10) : le SRD verrouillé,
// et les packs activés par le MJ, chacun à sa version figée. Activer envoie
// le fichier au stockage, puis l'inscrit dans `table_pack`.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart' show foldAccents;
import '../homebrew/homebrew_page.dart' show typeLabel;
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

  /// La version figée et la plus récente de la bibliothèque, si elle est
  /// plus récente.
  (InstalledVersion, InstalledVersion)? _newer(
    List<InstalledVersion> versions,
    String pinned,
  ) {
    final current = versions.where((v) => v.version == pinned).firstOrNull;
    final newest = versions.firstOrNull;
    if (current == null ||
        newest == null ||
        compareVersions(newest.version, pinned) <= 0) {
      return null;
    }
    return (current, newest);
  }

  /// « Bannir une entité » : une entité du SRD, cherchée par son nom.
  Future<void> _ban(ActiveContent content, List<String> banned) async {
    final id = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _BanPicker(content: content, banned: banned.toSet()),
    );
    if (id != null) {
      await ref.read(tableStoreProvider).banEntity(widget.tableId, id);
    }
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
    final content = ref.watch(contentProvider).value;
    final banned = [...?ref.watch(bannedProvider(widget.tableId)).value]
      ..sort();
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
        // Entités bannies pour la table (EF-HB-10).
        if (banned.isNotEmpty)
          Text(l10n.tablePacksBanned, style: text.bodySmall),
        for (final id in banned)
          ListTile(
            contentPadding: EdgeInsets.zero,
            dense: true,
            leading: const Icon(Icons.block),
            title: Text(content?.entity(id)?.name ?? id),
            trailing: widget.editable
                ? TextButton(
                    onPressed: () => ref
                        .read(tableStoreProvider)
                        .unbanEntity(widget.tableId, id),
                    child: Text(l10n.tablePacksUnban),
                  )
                : null,
          ),
        if (widget.editable && content != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton.icon(
              onPressed: () => _ban(content, banned),
              icon: const Icon(Icons.block),
              label: Text(l10n.tablePacksBan),
            ),
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
        // Une version plus récente dans la bibliothèque ([H9], EF-PJ-14).
        for (final p in active)
          if (_newer(of(p.packId), p.version) case (final pinned, final newest))
            _NewVersion(
              tableId: widget.tableId,
              pinned: pinned,
              newest: newest,
              onSwitch: widget.editable && !_busy
                  ? () => _activate(p.packId, newest.version)
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

/// Types d'entités qu'un MJ bannit pour sa table.
const _bannableTypes = {
  'spell',
  'feat',
  'species',
  'background',
  'class',
  'subclass',
  'weapon',
  'armor',
  'magic-item',
  'item',
  'monster',
};

/// Recherche d'une entité du SRD à bannir.
class _BanPicker extends StatefulWidget {
  const _BanPicker({required this.content, required this.banned});

  final ActiveContent content;
  final Set<String> banned;

  @override
  State<_BanPicker> createState() => _BanPickerState();
}

class _BanPickerState extends State<_BanPicker> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = foldAccents(_query.trim());
    final matches = query.isEmpty
        ? const <ContentEntity>[]
        : ([
            for (final e in widget.content.entities)
              if (e.id.namespace == 'srd' &&
                  _bannableTypes.contains(e.type) &&
                  !widget.banned.contains('${e.id}') &&
                  foldAccents(e.name).contains(query))
                e,
          ]..sort((a, b) => a.name.compareTo(b.name))).take(30).toList();
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                autofocus: true,
                decoration: InputDecoration(
                  labelText: l10n.tablePacksBanSearch,
                ),
                onChanged: (v) => setState(() => _query = v),
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                children: [
                  for (final e in matches)
                    ListTile(
                      title: Text(e.name),
                      subtitle: Text(typeLabel(l10n, e.type)),
                      onTap: () => Navigator.pop(context, '${e.id}'),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Fiches de la table qui citent des entités d'un pack : clé
/// `{table}|{pack}|{id,id…}`.
final _affectedProvider = FutureProvider.autoDispose
    .family<List<({String id, String name})>, String>((ref, key) {
      final [tableId, packId, ids] = key.split('|');
      return ref
          .watch(characterStoreProvider)
          .charactersUsing(tableId, packId, ids.split(',').toSet());
    });

/// « Version N disponible » : ajouts, modifications, fiches touchées, et
/// « Passer en N » pour le MJ ([H9]).
class _NewVersion extends ConsumerWidget {
  const _NewVersion({
    required this.tableId,
    required this.pinned,
    required this.newest,
    required this.onSwitch,
  });

  final String tableId;
  final InstalledVersion pinned;
  final InstalledVersion newest;
  final VoidCallback? onSwitch;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final changes = packChanges(pinned.pack.entities, newest.pack.entities);
    // Une aptitude modifiée touche son propriétaire (sous-classe, espèce…).
    final touched = {
      for (final e in [...changes.modified, ...changes.removed]) ...[
        '${e.id}',
        if (e.data case FeatureData(:final source)) '$source',
      ],
    };
    final affected = touched.isEmpty
        ? const <({String id, String name})>[]
        : ref
                  .watch(
                    _affectedProvider(
                      '$tableId|${pinned.packId}|${(touched.toList()..sort()).join(',')}',
                    ),
                  )
                  .value ??
              const [];
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.tablePacksNewVersion(
                pinned.pack.manifest.name,
                newest.version,
                changes.added.length,
                changes.modified.length,
              ),
              style: text.bodyMedium,
            ),
            if (affected.isNotEmpty)
              Text(
                l10n.tablePacksAffects(
                  affected.length,
                  newest.version,
                  affected.map((c) => c.name).join(', '),
                ),
                style: text.bodySmall,
              ),
            if (onSwitch != null)
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton(
                  onPressed: onSwitch,
                  child: Text(l10n.tablePacksSwitch(newest.version)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
