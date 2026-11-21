// Publier une version d'un pack homebrew et l'exporter signé (US-29,
// EF-HB-04, EF-HB-05, EF-HB-11, [H06]). Publier signe le pack avec la clé
// de l'appareil et l'importe dans la base de l'appareil ; l'export partage
// ce fichier par la feuille de partage du système, sans réseau.
import 'dart:typed_data';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/data_backup.dart' show saveFileProvider;
import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import 'homebrew_page.dart';

/// Version publiée d'un pack : celle de la base de l'appareil.
final publishedPackProvider = FutureProvider.autoDispose
    .family<ContentPack?, String>(
      (ref, id) => PackStore(ref.watch(databaseProvider)).exportPack(id),
    );

class PublishPage extends ConsumerStatefulWidget {
  const PublishPage({super.key, required this.draftId});

  final String draftId;

  @override
  ConsumerState<PublishPage> createState() => _PublishPageState();
}

class _PublishPageState extends ConsumerState<PublishPage> {
  VersionBump _bump = VersionBump.minor;
  bool _attested = false;
  bool _busy = false;
  TextEditingController? _description;
  TextEditingController? _licence;

  @override
  void dispose() {
    _description?.dispose();
    _licence?.dispose();
    super.dispose();
  }

  /// Le manifeste de la version [version], avec la description et la
  /// licence saisies.
  Map<String, Object?> _manifest(HomebrewDraft draft, String version) => {
    ...draft.manifest,
    'version': version,
    'licence': _licence!.text.trim(),
    if (_description!.text.trim().isNotEmpty)
      'description': _description!.text.trim()
    else
      'description': null,
  }..removeWhere((key, value) => value == null);

  Future<void> _publish(
    HomebrewDraft draft,
    List<ContentEntity> entities,
    String version,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _busy = true);
    final db = ref.read(databaseProvider);
    final manifestJson = _manifest(draft, version);
    final seed = await AuthorKeyStore(db).seed();
    final signed = await signPack(
      ContentPack(
        manifest: PackManifest.parse(manifestJson).manifest!,
        entities: entities,
      ),
      await authorKeyPair(seed),
    );
    // Dans la bibliothèque, comme un pack importé : elle s'active sur une
    // table (US-30) et met les tables de contenu à jour.
    await PackLibrary(db).install(writeDndpack(signed));
    await ref
        .read(homebrewStoreProvider)
        .save(draft.id, manifest: manifestJson, entities: draft.entities);
    ref.invalidate(publishedPackProvider(signed.manifest.id));
    if (!mounted) return;
    setState(() {
      _busy = false;
      _attested = false;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(l10n.publishDone(version))));
  }

  Future<void> _export(ContentPack published) async {
    final m = published.manifest;
    await ref.read(saveFileProvider)(
      '${m.namespace}-${m.version}.dndpack',
      Uint8List.fromList(writeDndpack(published)),
      'application/zip',
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final draft = ref.watch(draftProvider(widget.draftId)).value;
    final content = ref.watch(contentProvider).value;
    final id = draft?.manifest['id'] as String?;
    final published = id == null ? null : ref.watch(publishedPackProvider(id));
    if (draft == null ||
        content == null ||
        published is! AsyncData<ContentPack?>) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final previous = published.value;
    _description ??= TextEditingController(
      text: '${draft.manifest['description'] ?? ''}',
    );
    _licence ??= TextEditingController(
      text: '${draft.manifest['licence'] ?? ''}',
    );

    final entities = [
      for (final json in draft.entities) ?parseEntity(json, 'draft').entity,
    ];
    final issues = draftIssues(content, draft);
    final broken = {
      for (final i in issues)
        if (RegExp(r'^entities\[(\d+)\]').firstMatch(i.path)?[1] case final n?)
          int.parse(n),
    };
    final base = previous?.manifest.version;
    final version = base == null
        ? '${draft.manifest['version']}'
        : nextVersion(base, _bump);
    final changes = previous == null
        ? null
        : packChanges(previous.entities, entities);
    final manifest = PackManifest.parse(_manifest(draft, version)).manifest;
    final size = manifest == null
        ? 0
        : writeDndpack(ContentPack(manifest: manifest, entities: entities))
              .length;
    final dependencies = [
      for (final d in (draft.manifest['dependencies'] as List?) ?? const [])
        content.packs
                .where((p) => p.manifest.id == (d as Map)['id'])
                .firstOrNull
                ?.manifest
                .name ??
            '${(d as Map)['id']}',
    ];
    final ready =
        issues.isEmpty &&
        _attested &&
        _licence!.text.trim().isNotEmpty &&
        !_busy &&
        version != base;

    String sizeMb(int bytes) =>
        (bytes / (1024 * 1024)).toStringAsFixed(1).replaceAll('.', ',');

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(l10n.publishTitle, style: text.bodySmall),
            Text('${draft.manifest['name']}', style: text.titleLarge),
          ],
        ),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            base == null
                ? l10n.publishFirst(version)
                : l10n.publishFromTo(base, version),
            style: text.titleMedium,
          ),
          SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _description,
            minLines: 2,
            maxLines: null,
            decoration: InputDecoration(labelText: l10n.publishDescription),
          ),
          SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _licence,
            decoration: InputDecoration(labelText: '${l10n.publishLicence} *'),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.sm),
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.key_outlined),
            title: Text(l10n.publishAuthor),
            subtitle: Text(
              l10n.publishAuthorValue('${draft.manifest['author']}'),
            ),
          ),

          // Type de version (EF-HB-11).
          if (base != null) ...[
            Text(l10n.publishBump, style: text.titleMedium),
            RadioGroup<VersionBump>(
              groupValue: _bump,
              onChanged: (v) => setState(() => _bump = v!),
              child: Column(
                children: [
                  for (final (bump, label, hint) in [
                    (
                      VersionBump.patch,
                      l10n.publishPatch,
                      l10n.publishPatchHint,
                    ),
                    (
                      VersionBump.minor,
                      l10n.publishMinor,
                      l10n.publishMinorHint,
                    ),
                    (
                      VersionBump.major,
                      l10n.publishMajor,
                      l10n.publishMajorHint,
                    ),
                  ])
                    RadioListTile<VersionBump>(
                      contentPadding: EdgeInsets.zero,
                      value: bump,
                      title: Text('$label · ${nextVersion(base, bump)}'),
                      subtitle: Text(hint),
                    ),
                ],
              ),
            ),
            Text(l10n.publishChangesSince(base), style: text.titleMedium),
            if (changes case (:final added, :final modified, :final removed)
                when added.isEmpty && modified.isEmpty && removed.isEmpty)
              Text(l10n.publishNoChange, style: text.bodySmall)
            else if (changes != null)
              for (final (label, list) in [
                (l10n.publishAdded, changes.added),
                (l10n.publishModified, changes.modified),
                (l10n.publishRemoved, changes.removed),
              ])
                for (final e in list)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: Text(label, style: text.labelMedium),
                    title: Text(e.name),
                    subtitle: Text(typeLabel(l10n, e.type)),
                  ),
          ],

          // Attestation (cahier §15).
          CheckboxListTile(
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.leading,
            value: _attested,
            onChanged: (v) => setState(() => _attested = v ?? false),
            title: Text('${l10n.publishAttestation} *'),
          ),

          // Contrôles.
          Text(l10n.publishChecks, style: text.titleMedium),
          for (final (ok, label, value) in [
            (
              size <= maxPackBytes,
              l10n.publishSize,
              l10n.publishSizeValue(sizeMb(size)),
            ),
            (
              entities.length <= maxPackEntities,
              l10n.publishEntities,
              l10n.publishEntitiesValue(entities.length),
            ),
            (
              issues.isEmpty,
              l10n.publishRules,
              l10n.publishRulesValue(
                draft.entities.length - broken.length,
                draft.entities.length,
              ),
            ),
            (true, l10n.publishDependency, dependencies.join(', ')),
          ])
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(
                ok ? Icons.check_circle_outline : Icons.error_outline,
              ),
              title: Text(label),
              subtitle: Text(value),
            ),
          if (issues.isNotEmpty)
            Text(l10n.publishBlocked(issues.length), style: text.bodySmall),
          SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: ready ? () => _publish(draft, entities, version) : null,
            child: Text(l10n.publishButton(version)),
          ),
          SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: previous == null ? null : () => _export(previous),
            icon: const Icon(Icons.ios_share),
            label: Text(
              previous == null
                  ? l10n.publishExportNone
                  : l10n.publishExport(previous.manifest.version),
            ),
          ),
          Text(l10n.publishExportHint, style: text.bodySmall),
        ],
      ),
    );
  }
}
