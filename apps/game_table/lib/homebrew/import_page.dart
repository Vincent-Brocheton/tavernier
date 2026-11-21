// Import d'un pack (US-30 lot a, EF-HB-06 à 08, [H08], [H09]) : aperçu
// avant toute écriture, mise à jour seulement par le même auteur, pack
// distinct sinon, conflits de noms ; « Packs importés » et duplication.
import 'dart:typed_data';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import 'homebrew_page.dart';

/// Choisit un `.dndpack` ; rend son nom et ses octets, ou `null`.
final openPackFileProvider =
    Provider<Future<({String name, Uint8List bytes})?> Function()>(
      (ref) => () async {
        final file = await openFile(
          acceptedTypeGroups: const [
            XTypeGroup(label: 'dndpack', extensions: ['dndpack']),
          ],
        );
        if (file == null) return null;
        return (name: file.name, bytes: await file.readAsBytes());
      },
    );

/// Versions importées, gardées par l'appareil.
final importedPacksProvider =
    FutureProvider.autoDispose<List<InstalledVersion>>(
      (ref) => PackLibrary(ref.watch(databaseProvider)).installed(),
    );

/// « Importer un pack » : choisit le fichier, puis ouvre son aperçu.
Future<void> importPackFile(BuildContext context, WidgetRef ref) async {
  final file = await ref.read(openPackFileProvider)();
  if (file == null || !context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      fullscreenDialog: true,
      builder: (_) => ImportPage(fileName: file.name, bytes: file.bytes),
    ),
  );
}

/// « Dupliquer pour modifier » (EF-HB-08) : un brouillon à mon nom, dans
/// mon espace de noms, en 0.1.0. Rend l'identifiant du brouillon.
Future<String> forkPack(WidgetRef ref, ContentPack pack, String copyOf) async {
  final pseudonym = await ref.read(pseudonymProvider.future);
  final name = copyOf;
  final copy = rebrandPack(
    pack,
    id: uuidV7(),
    namespace: slugOf(name).isEmpty ? 'homebrew' : slugOf(name),
    name: name,
    author: pseudonym ?? pack.manifest.author,
    version: '0.1.0',
    origin: PackOrigin.local,
  );
  final store = ref.read(homebrewStoreProvider);
  final id = await store.create(copy.manifest.toJson());
  await store.save(
    id,
    manifest: copy.manifest.toJson(),
    entities: [for (final e in copy.entities) e.toJson()],
  );
  return id;
}

/// « Packs importés » de l'onglet Homebrew : la dernière version de chaque
/// pack, avec « Dupliquer pour modifier ».
class ImportedPacks extends ConsumerWidget {
  const ImportedPacks({super.key, required this.onFork});

  final ValueChanged<String> onFork;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final versions = ref.watch(importedPacksProvider).value ?? const [];
    final latest = <String, InstalledVersion>{};
    final counts = <String, int>{};
    for (final v in versions) {
      counts[v.packId] = (counts[v.packId] ?? 0) + 1;
      final known = latest[v.packId];
      if (known == null || compareVersions(v.version, known.version) > 0) {
        latest[v.packId] = v;
      }
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(l10n.packImportedPacks.toUpperCase(), style: text.labelMedium),
        if (latest.isEmpty)
          Text(l10n.packImportedNone, style: text.bodySmall)
        else
          for (final v in latest.values)
            Card(
              child: ListTile(
                leading: const Icon(Icons.inventory_2_outlined),
                title: Text(v.pack.manifest.name),
                subtitle: Text(
                  [
                    'v${v.version}',
                    l10n.packImportBy(v.pack.manifest.author),
                    l10n.packImportedVersions(counts[v.packId]!),
                  ].join(' · '),
                ),
                trailing: IconButton(
                  tooltip: l10n.packImportedFork,
                  icon: const Icon(Icons.copy_all_outlined),
                  onPressed: () async {
                    final id = await forkPack(
                      ref,
                      v.pack,
                      l10n.packImportedCopyName(v.pack.manifest.name),
                    );
                    onFork(id);
                  },
                ),
              ),
            ),
      ],
    );
  }
}

/// Lecture et aperçu d'un fichier : le pack, la signature, la bibliothèque.
typedef _Inspection = ({
  ContentPack? pack,
  String? error,
  ImportPreview? preview,
  List<InstalledVersion> installed,
});

class ImportPage extends ConsumerStatefulWidget {
  const ImportPage({super.key, required this.fileName, required this.bytes});

  final String fileName;
  final Uint8List bytes;

  @override
  ConsumerState<ImportPage> createState() => _ImportPageState();
}

class _ImportPageState extends ConsumerState<ImportPage> {
  late final Future<_Inspection> _inspection = _inspect();
  final _renames = <String, TextEditingController>{};
  TextEditingController? _libraryName;
  bool _busy = false;

  @override
  void dispose() {
    for (final c in _renames.values) {
      c.dispose();
    }
    _libraryName?.dispose();
    super.dispose();
  }

  Future<_Inspection> _inspect() async {
    final content = await ref.read(contentProvider.future);
    final installed = await PackLibrary(ref.read(databaseProvider)).installed();
    final ContentPack pack;
    try {
      pack = readDndpack(widget.bytes);
    } on DndpackException catch (e) {
      return (
        pack: null,
        error: e.message,
        preview: null,
        installed: installed,
      );
    }
    final latest = <String, ContentPack>{
      for (final v in [
        ...installed,
      ]..sort((a, b) => compareVersions(a.version, b.version)))
        v.packId: v.pack,
    };
    return (
      pack: pack,
      error: null,
      preview: inspectImport(
        pack,
        signatureValid: await verifyPackSignature(pack.manifest),
        installed: installed,
        available: [...content.packs, ...latest.values],
      ),
      installed: installed,
    );
  }

  /// Espace de noms d'un pack distinct : `{espace}-{auteur}`, unique.
  String _namespace(ContentPack pack, List<InstalledVersion> installed) {
    final taken = {for (final v in installed) v.pack.manifest.namespace};
    final base = '${pack.manifest.namespace}-${slugOf(pack.manifest.author)}';
    var namespace = base;
    for (var n = 2; taken.contains(namespace); n++) {
      namespace = '$base-$n';
    }
    return namespace;
  }

  Future<void> _install(_Inspection inspection) async {
    final l10n = AppLocalizations.of(context);
    final pack = inspection.pack!;
    final distinct = inspection.preview!.kind == ImportKind.distinct;
    setState(() => _busy = true);
    await PackLibrary(ref.read(databaseProvider)).install(
      widget.bytes,
      packId: distinct ? uuidV7() : null,
      namespace: distinct ? _namespace(pack, inspection.installed) : null,
      name: distinct ? _libraryName!.text.trim() : null,
      renames: {
        for (final MapEntry(:key, :value) in _renames.entries)
          if (value.text.trim().isNotEmpty) key: value.text.trim(),
      },
    );
    ref.invalidate(importedPacksProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.packImportDone(pack.manifest.name, pack.manifest.version),
        ),
      ),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.packImportFileSize(
                widget.fileName,
                _mb(widget.bytes.length),
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            Text(l10n.packImportTitle),
          ],
        ),
      ),
      body: FutureBuilder<_Inspection>(
        future: _inspection,
        builder: (context, snapshot) {
          final inspection = snapshot.data;
          if (inspection == null) {
            return const Center(child: CircularProgressIndicator());
          }
          return ListView(
            padding: EdgeInsets.all(AppSpacing.md),
            children: inspection.pack == null
                ? [
                    ListTile(
                      leading: const Icon(Icons.error_outline),
                      title: Text(l10n.packImportRefused(inspection.error!)),
                    ),
                  ]
                : _preview(l10n, inspection),
          );
        },
      ),
    );
  }

  static String _mb(int bytes) =>
      (bytes / (1024 * 1024)).toStringAsFixed(1).replaceAll('.', ',');

  List<Widget> _preview(AppLocalizations l10n, _Inspection inspection) {
    final text = Theme.of(context).textTheme;
    final pack = inspection.pack!;
    final preview = inspection.preview!;
    final m = pack.manifest;
    final distinct = preview.kind == ImportKind.distinct;
    _libraryName ??= TextEditingController(
      text: l10n.packImportDistinctName(m.name, m.author),
    );
    final changes = preview.changes;
    final added = changes?.added ?? pack.entities;
    final modified = changes?.modified ?? const <ContentEntity>[];
    final unchanged = pack.entities.length - added.length - modified.length;
    String names(List<PackDependency> deps) => [
      for (final d in deps)
        ref
                .read(contentProvider)
                .value
                ?.packs
                .where((p) => p.manifest.id == d.id)
                .firstOrNull
                ?.manifest
                .name ??
            d.id,
    ].join(', ');

    Widget check(bool ok, String title, String subtitle) => ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(ok ? Icons.check_circle_outline : Icons.error_outline),
      title: Text(title),
      subtitle: Text(subtitle),
    );

    return [
      Text(m.name, style: text.headlineSmall),
      Text(
        [
          l10n.packImportBy(m.author),
          m.licence,
          if (m.dependencies.isNotEmpty)
            l10n.packImportDependsOn(names(m.dependencies)),
        ].join(' · '),
        style: text.bodySmall,
      ),
      if (preview.previous case final previous?)
        Text(l10n.packImportInstalled(previous.version), style: text.bodySmall),
      Text(m.version, style: text.titleLarge),
      if (distinct) ...[
        SizedBox(height: AppSpacing.sm),
        Text(l10n.packImportNotUpdate, style: text.titleMedium),
        Text(l10n.packImportDistinctHint(m.name, m.author)),
        TextField(
          controller: _libraryName,
          decoration: InputDecoration(labelText: l10n.packImportLibraryName),
        ),
      ],
      SizedBox(height: AppSpacing.sm),
      Text(
        l10n.packImportContent(pack.entities.length),
        style: text.titleMedium,
      ),
      for (final (label, list) in [
        (l10n.packImportNew, added),
        (l10n.publishModified, modified),
      ])
        for (final e in list)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Text(label, style: text.labelMedium),
            title: Text(e.name),
            subtitle: Text(typeLabel(l10n, e.type)),
          ),
      if (unchanged > 0) Text(l10n.packImportUnchanged(unchanged)),

      // Conflits de noms.
      for (final c in preview.conflicts) ...[
        SizedBox(height: AppSpacing.sm),
        Text(l10n.packImportConflict(c.incoming.name), style: text.titleSmall),
        Text(
          l10n.packImportConflictHint(
            c.packName,
            typeLabel(l10n, c.existing.type),
            typeLabel(l10n, c.incoming.type),
          ),
        ),
        RadioGroup<bool>(
          groupValue: _renames.containsKey('${c.incoming.id}'),
          onChanged: (rename) => setState(() {
            if (rename ?? false) {
              _renames['${c.incoming.id}'] = TextEditingController();
            } else {
              _renames.remove('${c.incoming.id}')?.dispose();
            }
          }),
          child: Column(
            children: [
              RadioListTile<bool>(
                contentPadding: EdgeInsets.zero,
                value: false,
                title: Text(l10n.packImportKeepBoth),
                subtitle: Text(l10n.packImportKeepBothHint),
              ),
              RadioListTile<bool>(
                contentPadding: EdgeInsets.zero,
                value: true,
                title: Text(
                  l10n.packImportRename(typeLabel(l10n, c.incoming.type)),
                ),
                subtitle: Text(l10n.packImportRenameHint),
              ),
            ],
          ),
        ),
        if (_renames['${c.incoming.id}'] case final controller?)
          TextField(
            controller: controller,
            decoration: InputDecoration(labelText: l10n.packImportNewName),
          ),
      ],

      // Vérifications.
      SizedBox(height: AppSpacing.md),
      Text(l10n.packImportChecks, style: text.titleMedium),
      check(
        true,
        l10n.packImportSize(_mb(widget.bytes.length)),
        l10n.packImportSizeMax,
      ),
      check(
        preview.signatureValid,
        preview.signatureValid
            ? l10n.packImportSignature(m.author)
            : l10n.packImportSignatureInvalid,
        switch (preview.kind) {
          ImportKind.update => l10n.packImportSameAuthor,
          ImportKind.distinct => l10n.packImportOtherAuthor,
          ImportKind.alreadyInstalled => l10n.packImportAlready(m.version),
          ImportKind.newPack => l10n.packImportNewPack,
        },
      ),
      check(
        preview.issues.isEmpty,
        l10n.packImportFormat,
        preview.issues.isEmpty
            ? l10n.packImportFormatOk(pack.entities.length)
            : preview.issues.map((i) => i.message).join(' ; '),
      ),
      check(
        preview.missingDependencies.isEmpty,
        l10n.packImportDependencies,
        preview.missingDependencies.isEmpty
            ? names(m.dependencies)
            : l10n.packImportMissing(
                preview.missingDependencies.map((d) => d.id).join(', '),
              ),
      ),
      if (preview.kind == ImportKind.update)
        Text(l10n.packImportFrozen(preview.previous!.version, m.version)),
      SizedBox(height: AppSpacing.md),
      if (!preview.blocked)
        FilledButton(
          onPressed: _busy ? null : () => _install(inspection),
          child: Text(switch (preview.kind) {
            ImportKind.update => l10n.packImportUpdate,
            ImportKind.distinct => l10n.packImportDistinct,
            _ => l10n.packImportButton,
          }),
        ),
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: Text(distinct ? l10n.packImportDont : l10n.cancel),
      ),
    ];
  }
}
