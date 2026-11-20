// Onglet Homebrew (US-27, EF-HB-01, [H01]) : mes brouillons de packs, le
// SRD inclus, et la page d'un pack avec ses entités et sa vérification.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../l10n/app_localizations.dart';
import 'entity_editor.dart';

/// Seule voie d'écriture des brouillons (cahier §10).
final homebrewStoreProvider = Provider<HomebrewStore>(
  (ref) => HomebrewStore(ref.watch(databaseProvider)),
);

final draftsProvider = StreamProvider.autoDispose<List<HomebrewDraft>>(
  (ref) => ref.watch(homebrewStoreProvider).watchAll(),
);

final draftProvider = StreamProvider.autoDispose.family<HomebrewDraft?, String>(
  (ref, id) => ref.watch(homebrewStoreProvider).watch(id),
);

/// Les 8 types d'entités éditables (cahier §7.1), dans l'ordre de [H01].
const entityTypes = [
  'feat',
  'background',
  'species',
  'class',
  'subclass',
  'spell',
  'item',
  'monster',
];

/// Types dont l'éditeur est livré (lot a).
const editableTypes = {'feat', 'background'};

String typeLabel(AppLocalizations l10n, String type) => switch (type) {
  'feat' => l10n.typeFeat,
  'background' => l10n.typeBackground,
  'species' => l10n.typeSpecies,
  'class' => l10n.typeClass,
  'subclass' => l10n.typeSubclass,
  'spell' => l10n.typeSpell,
  'item' => l10n.typeItem,
  _ => l10n.typeMonster,
};

/// Le pack SRD de l'appareil.
PackManifest? srdManifestOf(ActiveContent content) => content.packs
    .where((p) => p.manifest.origin == PackOrigin.srd)
    .firstOrNull
    ?.manifest;

/// Problèmes du brouillon [draft], avec le contenu de l'appareil pour
/// résoudre les références.
List<ContentIssue> draftIssues(ActiveContent content, HomebrewDraft draft) =>
    checkDraft(draft.manifest, draft.entities, dependencies: content.entities);

/// Écrit [entity] dans [draft] : remplace l'entité de même identifiant, ou
/// l'ajoute.
Future<void> saveEntity(
  WidgetRef ref,
  HomebrewDraft draft,
  Map<String, Object?> entity, {
  String? previousId,
}) {
  final id = previousId ?? entity['id'];
  final known = draft.entities.any((e) => e['id'] == id);
  return ref
      .read(homebrewStoreProvider)
      .save(
        draft.id,
        manifest: draft.manifest,
        entities: [
          for (final e in draft.entities) e['id'] == id ? entity : e,
          if (!known) entity,
        ],
      );
}

/// Nouveau pack : son nom ; l'espace de noms en vient, l'auteur est le
/// pseudonyme. Rend l'identifiant du brouillon.
Future<String?> createPack(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context);
  final controller = TextEditingController();
  final name = await showDialog<String>(
    context: context,
    builder: (dialog) => AlertDialog(
      title: Text(l10n.homebrewNewPack),
      content: TextField(
        controller: controller,
        autofocus: true,
        decoration: InputDecoration(labelText: l10n.homebrewPackName),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(dialog),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(dialog, controller.text.trim()),
          child: Text(l10n.homebrewCreate),
        ),
      ],
    ),
  );
  // Pas de dispose : le champ vit encore pendant la fermeture animée.
  if (name == null || name.isEmpty || !context.mounted) return null;
  final content = await ref.read(contentProvider.future);
  final pseudonym = await ref.read(pseudonymProvider.future);
  final srd = srdManifestOf(content);
  if (srd == null) return null;
  final namespace = slugOf(name).isEmpty ? 'homebrew' : slugOf(name);
  return ref
      .read(homebrewStoreProvider)
      .create(
        newHomebrewManifest(
          id: uuidV7(),
          name: name,
          namespace: namespace,
          author: pseudonym ?? l10n.homebrewAuthor,
          srd: srd,
        ),
      );
}

void _openPack(BuildContext context, String id) =>
    Navigator.of(context)
        .push(MaterialPageRoute<void>(builder: (_) => PackPage(id: id)));

/// « Mes packs », « Inclus », « Créer une entité » ([H01]).
class HomebrewPage extends ConsumerWidget {
  const HomebrewPage({super.key});

  Future<void> _newEntity(
    BuildContext context,
    WidgetRef ref,
    String type,
    List<HomebrewDraft> drafts,
  ) async {
    final l10n = AppLocalizations.of(context);
    // Le pack qui recevra l'entité : le seul, ou au choix.
    final String? id;
    if (drafts.isEmpty) {
      id = await createPack(context, ref);
    } else if (drafts.length == 1) {
      id = drafts.single.id;
    } else {
      id = await showModalBottomSheet<String>(
        context: context,
        builder: (sheet) => SafeArea(
          child: ListView(
            shrinkWrap: true,
            children: [
              ListTile(title: Text(l10n.homebrewChoosePack)),
              for (final d in drafts)
                ListTile(
                  title: Text('${d.manifest['name']}'),
                  onTap: () => Navigator.pop(sheet, d.id),
                ),
            ],
          ),
        ),
      );
    }
    if (id == null || !context.mounted) return;
    final draft = await ref.read(draftProvider(id).future);
    if (draft == null || !context.mounted) return;
    await openEntityEditor(context, draft: draft, type: type);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final drafts = ref.watch(draftsProvider).value;
    final content = ref.watch(contentProvider).value;
    if (drafts == null || content == null) {
      return const Center(child: CircularProgressIndicator());
    }
    final srd = srdManifestOf(content);
    return ListView(
      padding: EdgeInsets.all(AppSpacing.md),
      children: [
        Text(l10n.navHomebrew, style: text.headlineSmall),
        SizedBox(height: AppSpacing.sm),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: () async {
              final id = await createPack(context, ref);
              if (id != null && context.mounted) _openPack(context, id);
            },
            icon: const Icon(Icons.add),
            label: Text(l10n.homebrewNewPack),
          ),
        ),
        SizedBox(height: AppSpacing.md),
        Text(l10n.homebrewMyPacks.toUpperCase(), style: text.labelMedium),
        if (drafts.isEmpty) Text(l10n.homebrewNoPack, style: text.bodySmall),
        for (final d in drafts)
          Card(
            child: ListTile(
              title: Text('${d.manifest['name']}'),
              subtitle: Text(
                [
                  'v${d.manifest['version']}',
                  l10n.homebrewDraft,
                  l10n.homebrewEntityCount(d.entities.length),
                  switch (draftIssues(content, d).length) {
                    0 => l10n.homebrewReady,
                    final n => l10n.homebrewIssueCount(n),
                  },
                ].join(' · '),
              ),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openPack(context, d.id),
            ),
          ),
        if (srd != null) ...[
          SizedBox(height: AppSpacing.md),
          Text(l10n.homebrewIncluded.toUpperCase(), style: text.labelMedium),
          Card(
            child: ListTile(
              leading: const Icon(Icons.lock_outline),
              title: Text(srd.name),
              subtitle: Text(
                'v${srd.version} · ${srd.licence} · ${l10n.homebrewLocked}',
              ),
            ),
          ),
        ],
        SizedBox(height: AppSpacing.md),
        Text(l10n.homebrewCreateEntity, style: text.titleMedium),
        Text(l10n.homebrewCreateEntityHint, style: text.bodySmall),
        SizedBox(height: AppSpacing.xs),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final type in entityTypes)
              ActionChip(
                label: Text(typeLabel(l10n, type)),
                onPressed: editableTypes.contains(type)
                    ? () => _newEntity(context, ref, type, drafts)
                    : null,
              ),
          ],
        ),
      ],
    );
  }
}

/// Page d'un brouillon : ses entités par type, « Ajouter une entité » et la
/// vérification ([H02]).
class PackPage extends ConsumerWidget {
  const PackPage({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final draft = ref.watch(draftProvider(id)).value;
    final content = ref.watch(contentProvider).value;
    if (draft == null || content == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final issues = draftIssues(content, draft);
    String where(ContentIssue issue) {
      final match = RegExp(r'^entities\[(\d+)\]').firstMatch(issue.path);
      final index = match == null ? null : int.parse(match.group(1)!);
      return index == null || index >= draft.entities.length
          ? l10n.homebrewManifest
          : '${draft.entities[index]['name'] ?? draft.entities[index]['id']}';
    }

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'v${draft.manifest['version']} · ${l10n.homebrewDraft}',
              style: text.bodySmall,
            ),
            Text('${draft.manifest['name']}', style: text.titleLarge),
          ],
        ),
        actions: [
          IconButton(
            tooltip: l10n.homebrewDeletePack,
            icon: const Icon(Icons.delete_outline),
            onPressed: () async {
              final sure = await showDialog<bool>(
                context: context,
                builder: (dialog) => AlertDialog(
                  title: Text(l10n.homebrewDeletePack),
                  content: Text(l10n.homebrewDeletePackHint),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(dialog, false),
                      child: Text(l10n.cancel),
                    ),
                    FilledButton(
                      onPressed: () => Navigator.pop(dialog, true),
                      child: Text(l10n.homebrewDeletePack),
                    ),
                  ],
                ),
              );
              if (sure != true) return;
              await ref.read(homebrewStoreProvider).delete(id);
              if (context.mounted) Navigator.pop(context);
            },
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Text(l10n.homebrewSavedOnDevice, style: text.bodySmall),
          for (final type in entityTypes)
            if (draft.entities.where((e) => e['type'] == type).toList()
                case final ofType when ofType.isNotEmpty) ...[
              SizedBox(height: AppSpacing.sm),
              Text(
                typeLabel(l10n, type).toUpperCase(),
                style: text.labelMedium,
              ),
              for (final e in ofType)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text('${e['name'] ?? e['id']}'),
                  subtitle: Text('${e['id']}'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: editableTypes.contains(type)
                      ? () => openEntityEditor(
                          context,
                          draft: draft,
                          type: type,
                          entity: e,
                        )
                      : null,
                ),
            ],
          SizedBox(height: AppSpacing.md),
          Text(l10n.homebrewAddEntity, style: text.titleMedium),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final type in entityTypes)
                ActionChip(
                  label: Text(typeLabel(l10n, type)),
                  onPressed: editableTypes.contains(type)
                      ? () =>
                            openEntityEditor(context, draft: draft, type: type)
                      : null,
                ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Text(l10n.homebrewCheckTitle, style: text.titleMedium),
          if (issues.isEmpty)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.check_circle_outline),
              title: Text(l10n.homebrewReady),
              subtitle: Text(l10n.homebrewReadyHint),
            )
          else
            for (final issue in issues)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.error_outline),
                title: Text(issue.message),
                subtitle: Text(where(issue)),
              ),
          Text(l10n.homebrewCheckHint, style: text.bodySmall),
        ],
      ),
    );
  }
}
