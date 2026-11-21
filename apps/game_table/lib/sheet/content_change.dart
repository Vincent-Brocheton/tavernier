// Contenu homebrew figé par fiche (US-30 lot c2, EF-PJ-14, [H10]) : la
// fiche de son propriétaire enregistre ses références de contenu, signale
// une entité modifiée par la nouvelle version de la table, et laisse le
// joueur migrer ou garder. Le MJ ne décide pas à sa place.
import 'dart:async';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../homebrew/effect_editor.dart' show describeEffect;
import '../l10n/app_localizations.dart';
import 'sheet_page.dart' show characterProvider;

/// Le joueur propriétaire de la fiche [id] (ou l'utilisateur local, hors
/// compte) : lui seul choisit pour son contenu.
final sheetOwnerProvider = FutureProvider.autoDispose.family<bool, String>((
  ref,
  id,
) async {
  final me = ref.watch(currentUserProvider).value?.id;
  final access = await ref.watch(characterStoreProvider).access(id);
  return access != null && access.ownerUserId == me;
});

/// Enregistre les références de contenu de la fiche [id] : nouvelles
/// entités homebrew, entités inchangées qui suivent la version, entités
/// quittées. Rend `true` si quelque chose a changé.
Future<bool> recordContentRefs(WidgetRef ref, String id) async {
  final store = ref.read(characterStoreProvider);
  final character = await store.load(id);
  if (character == null) return false;
  final tableId = (await store.access(id))?.tableId;
  final content = await ref.read(tableContentProvider(tableId).future);
  final record = contentRefsToRecord(
    character,
    content,
    await store.contentRefs(id),
  );
  for (final r in [...record.create, ...record.follow]) {
    await store.saveContentRef(id, r);
  }
  for (final entityId in record.remove) {
    await store.removeContentRef(id, entityId);
  }
  return record.create.isNotEmpty ||
      record.follow.isNotEmpty ||
      record.remove.isNotEmpty;
}

/// Bannières « Contenu modifié » de la fiche [id], pour son propriétaire.
class ContentChangeBanners extends ConsumerStatefulWidget {
  const ContentChangeBanners({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ContentChangeBanners> createState() =>
      _ContentChangeBannersState();
}

class _ContentChangeBannersState extends ConsumerState<ContentChangeBanners> {
  bool _recorded = false;

  void _record() {
    if (_recorded) return;
    _recorded = true;
    unawaited(
      recordContentRefs(ref, widget.id)
          .then((changed) {
            if (changed && mounted) {
              ref
                ..invalidate(contentChangesProvider(widget.id))
                ..invalidate(characterContentProvider(widget.id));
            }
          })
          .catchError((Object _) {}),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (ref.watch(sheetOwnerProvider(widget.id)).value != true) {
      return const SizedBox.shrink();
    }
    _record();
    final changes =
        ref.watch(contentChangesProvider(widget.id)).value ??
        const <ContentChange>[];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (final c in changes)
          MaterialBanner(
            leading: const Icon(Icons.update),
            content: Text(l10n.contentChangedBanner(c.before.name)),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    fullscreenDialog: true,
                    builder: (_) => ContentChangePage(id: widget.id, change: c),
                  ),
                ),
                child: Text(l10n.contentChangedOpen),
              ),
            ],
          ),
      ],
    );
  }
}

/// « Contenu modifié » ([H10]) : l'ancienne et la nouvelle version, et le
/// choix du joueur.
class ContentChangePage extends ConsumerStatefulWidget {
  const ContentChangePage({super.key, required this.id, required this.change});

  final String id;
  final ContentChange change;

  @override
  ConsumerState<ContentChangePage> createState() => _ContentChangePageState();
}

class _ContentChangePageState extends ConsumerState<ContentChangePage> {
  bool _busy = false;

  Future<void> _resolve({required bool migrate}) async {
    setState(() => _busy = true);
    final store = ref.read(characterStoreProvider);
    final tableId = (await store.access(widget.id))?.tableId;
    final content = await ref.read(tableContentProvider(tableId).future);
    await store.resolveContentChange(
      widget.id,
      widget.change,
      migrate: migrate,
      snapshot: entitySnapshot(content, widget.change.entityId),
      authorUserId: ref.read(currentUserProvider).value?.id,
    );
    ref
      ..invalidate(contentChangesProvider(widget.id))
      ..invalidate(characterContentProvider(widget.id))
      ..invalidate(characterProvider(widget.id));
    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value;
    final c = widget.change;
    if (content == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final before = [
      for (final json
          in (c.ref.snapshot['entities'] as List<Object?>?) ?? const [])
        ?parseEntity(json, 'snapshot').entity,
    ];
    final after = [
      for (final json
          in (entitySnapshot(content, c.entityId)['entities']!
              as List<Object?>))
        ?parseEntity(json, 'current').entity,
    ];
    final packName =
        content.packs
            .where((p) => p.manifest.id == c.ref.packId)
            .firstOrNull
            ?.manifest
            .name ??
        c.ref.packId;

    Widget version(String title, List<ContentEntity> entities) => Card(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(title, style: text.titleMedium),
            for (final e in entities) ...[
              SizedBox(height: AppSpacing.xs),
              Text(e.name, style: text.titleSmall),
              if (e.textFr case final t? when t.isNotEmpty)
                Text(t, style: text.bodyMedium),
              for (final effect in e.effects)
                Text(
                  '· ${describeEffect(l10n, content, effect.toJson())}',
                  style: text.bodySmall,
                ),
            ],
          ],
        ),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.contentChangedTitle),
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            l10n.contentChangedHeading(c.before.name),
            style: text.titleLarge,
          ),
          Text(
            l10n.contentChangedPack(packName, c.fromVersion, c.toVersion),
            style: text.bodySmall,
          ),
          SizedBox(height: AppSpacing.sm),
          version(l10n.contentChangedYours(c.fromVersion), before),
          version(l10n.contentChangedNew(c.toVersion), after),
          SizedBox(height: AppSpacing.sm),
          Text(l10n.contentChangedHint, style: text.bodySmall),
          SizedBox(height: AppSpacing.md),
          FilledButton(
            onPressed: _busy ? null : () => _resolve(migrate: true),
            child: Text(l10n.contentChangedMigrate),
          ),
          SizedBox(height: AppSpacing.xs),
          OutlinedButton(
            onPressed: _busy ? null : () => _resolve(migrate: false),
            child: Text(l10n.contentChangedKeep(c.fromVersion)),
          ),
        ],
      ),
    );
  }
}
