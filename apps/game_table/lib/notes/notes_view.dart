// Notes d'une table (US-26, EF-NOT-01 à 05, [N3], [N4], [N6], [N7]) :
// recherche hors-ligne, filtres et groupes par rattachement, notes partagées
// par d'autres en lecture seule.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../encounters/encounters_providers.dart';
import '../l10n/app_localizations.dart';
import '../npcs/npcs_providers.dart';
import '../sessions/sessions_providers.dart';
import '../sheet/conflicts.dart';
import 'note_editor.dart';
import 'note_markdown.dart';

/// Seule voie d'écriture des notes (cahier §10).
final noteStoreProvider = Provider<NoteStore>(
  (ref) => NoteStore(ref.watch(databaseProvider)),
);

/// Notes que l'utilisateur voit sur une table : les siennes et celles
/// partagées.
final tableNotesProvider = StreamProvider.autoDispose
    .family<List<Note>, String>((ref, tableId) {
      final me = ref.watch(currentUserProvider.select((u) => u.value?.id));
      if (me == null) return Stream.value(const []);
      return ref.watch(noteStoreProvider).watchVisible(me, tableId: tableId);
    });

/// Ce à quoi une note peut se rattacher sur une table : séances, PNJ et
/// rencontres présents sur l'appareil.
typedef NoteTargets = ({
  List<GameSession> sessions,
  List<Npc> npcs,
  List<Encounter> encounters,
});

NoteTargets noteTargets(WidgetRef ref, String tableId) => (
  sessions: ref.watch(tableSessionsProvider(tableId)).value ?? const [],
  npcs: ref.watch(tableNpcsProvider(tableId)).value ?? const [],
  encounters: ref.watch(tableEncountersProvider(tableId)).value ?? const [],
);

/// Libellé du rattachement : « Séance 11 », le PNJ, la rencontre, « Table ».
String attachmentLabel(
  AppLocalizations l10n,
  NoteTargets targets,
  String scope,
  String? refId,
) => switch (scope) {
  'session' => switch (targets.sessions.where((s) => s.id == refId)) {
    final found when found.isNotEmpty => l10n.notesSessionLabel(
      found.first.number,
    ),
    _ => l10n.notesScopeSessions,
  },
  'npc' =>
    targets.npcs.where((n) => n.id == refId).firstOrNull?.name ??
        l10n.notesScopeNpcs,
  'encounter' =>
    targets.encounters.where((e) => e.id == refId).firstOrNull?.title ??
        l10n.notesScopeEncounters,
  _ => l10n.notesScopeTable,
};

/// Filtres de la liste, par rattachement.
const _filters = ['session', 'npc', 'encounter', 'table'];

String _filterLabel(AppLocalizations l10n, String scope) => switch (scope) {
  'session' => l10n.notesScopeSessions,
  'npc' => l10n.notesScopeNpcs,
  'encounter' => l10n.notesScopeEncounters,
  _ => l10n.notesScopeTable,
};

/// Ouvre l'éditeur d'une note de [tableId] : neuve si [note] est nul.
Future<void> openNote(
  BuildContext context, {
  required String tableId,
  Note? note,
  String? defaultSession,
  bool gm = false,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (_) => NoteEditor(
      tableId: tableId,
      note: note,
      defaultSession: defaultSession,
      gm: gm,
    ),
  ),
);

/// Notes de [tableId] : recherche, filtres, groupes et « Nouvelle note ».
/// [gm] rend actifs les liens vers les PNJ et les rencontres.
class NotesView extends ConsumerStatefulWidget {
  const NotesView({super.key, required this.tableId, this.gm = false});

  final String tableId;
  final bool gm;

  @override
  ConsumerState<NotesView> createState() => _NotesViewState();
}

class _NotesViewState extends ConsumerState<NotesView> {
  final _search = TextEditingController();
  String? _filter;

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final me = ref.watch(currentUserProvider).value?.id;
    final notes = ref.watch(tableNotesProvider(widget.tableId)).value;
    final targets = noteTargets(ref, widget.tableId);
    if (notes == null) return const Center(child: CircularProgressIndicator());
    final query = foldAccents(_search.text.trim());
    final found = [
      for (final n in notes)
        if (query.isEmpty ||
            foldAccents('${n.title} ${notePlainText(n.content)}')
                .contains(query))
          n,
    ];
    final shown = [
      for (final n in found)
        if (_filter == null || n.scope == _filter) n,
    ];
    // La séance en cours, ou la dernière, reçoit une note neuve.
    final session = targets.sessions
        .where((s) => s.status == SessionStatus.inProgress)
        .firstOrNull;
    final groups = <String, List<Note>>{};
    for (final n in shown) {
      final key = n.scope == 'session' ? 'session:${n.refId}' : n.scope;
      (groups[key] ??= []).add(n);
    }
    String header(String key) {
      if (!key.startsWith('session:')) return _filterLabel(l10n, key);
      final s = targets.sessions.where((s) => 'session:${s.id}' == key);
      return s.isEmpty
          ? l10n.notesScopeSessions
          : l10n.notesSessionHeader(s.first.number, s.first.date);
    }

    final noneMine = notes.where((n) => n.ownerUserId == me).isEmpty;
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => openNote(
          context,
          tableId: widget.tableId,
          defaultSession: session?.id,
        ),
        icon: const Icon(Icons.add),
        label: Text(l10n.notesNew),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl * 3,
        ),
        children: [
          TextField(
            controller: _search,
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              prefixIcon: const Icon(Icons.search),
              hintText: l10n.notesSearch,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              ChoiceChip(
                label: Text('${l10n.notesFilterAll} · ${found.length}'),
                selected: _filter == null,
                onSelected: (_) => setState(() => _filter = null),
              ),
              for (final scope in _filters)
                if (found.where((n) => n.scope == scope).length case final count
                    when count > 0)
                  ChoiceChip(
                    label: Text('${_filterLabel(l10n, scope)} · $count'),
                    selected: _filter == scope,
                    onSelected: (_) => setState(() => _filter = scope),
                  ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            query.isEmpty
                ? l10n.notesCount(notes.length)
                : l10n.notesResults(found.length),
            style: text.bodySmall,
          ),
          Text(l10n.notesPrivacyHint, style: text.bodySmall),
          if (noneMine && query.isEmpty) ...[
            SizedBox(height: AppSpacing.md),
            Text(l10n.notesEmptyTitle, style: text.titleMedium),
            Text(l10n.notesEmptyBody, style: text.bodyMedium),
          ],
          for (final MapEntry(:key, value: group) in groups.entries) ...[
            SizedBox(height: AppSpacing.md),
            Text(header(key).toUpperCase(), style: text.labelMedium),
            for (final note in group)
              _NoteCard(
                note: note,
                mine: note.ownerUserId == me,
                attachment: attachmentLabel(
                  l10n,
                  targets,
                  note.scope,
                  note.refId,
                ),
                onTap: () => openNote(
                  context,
                  tableId: widget.tableId,
                  note: note,
                  gm: widget.gm,
                ),
              ),
          ],
        ],
      ),
    );
  }
}

class _NoteCard extends ConsumerWidget {
  const _NoteCard({
    required this.note,
    required this.mine,
    required this.attachment,
    required this.onTap,
  });

  final Note note;
  final bool mine;
  final String attachment;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final author = mine
        ? null
        : ref.watch(pseudonymOfProvider(note.ownerUserId)).value ??
              l10n.notesSomeone;
    final at = note.updatedAt?.toLocal();
    final now = DateTime.now();
    final date = at == null
        ? ''
        : DateUtils.isSameDay(at, now)
        ? l10n.notesToday
        : l10n.notesDate(at);
    return Card(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.sm),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      note.title.isEmpty ? l10n.notesUntitled : note.title,
                      style: text.titleMedium,
                    ),
                  ),
                  Text(date, style: text.bodySmall),
                ],
              ),
              Text(
                notePlainText(note.content),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: text.bodyMedium,
              ),
              SizedBox(height: AppSpacing.xs),
              Wrap(
                spacing: AppSpacing.xs,
                runSpacing: AppSpacing.xs,
                children: [
                  Chip(label: Text(attachment)),
                  if (author != null)
                    Chip(label: Text(l10n.notesSharedBy(author)))
                  else if (!note.private)
                    Chip(label: Text(l10n.notesSharedChip)),
                  if (mine && note.conflict != null)
                    Chip(
                      avatar: const Icon(Icons.call_split),
                      label: Text(l10n.notesConflictChip),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Ouvre la cible d'un lien, pour le MJ : la page du PNJ ou de la rencontre.
void openNoteLink(BuildContext context, String tableId, NoteLink link) =>
    context.push(
      link.kind == 'npc'
          ? '/tables/$tableId/pnj/${link.id}'
          : '/tables/$tableId/rencontres/${link.id}',
    );

/// Table de la fiche [id] ; `null` hors table.
final characterTableProvider = FutureProvider.autoDispose
    .family<String?, String>(
      (ref, id) async =>
          (await ref.watch(characterStoreProvider).access(id))?.tableId,
    );

/// Onglet Notes de la fiche ([N4], [N7], EF-NOT-05) : les notes de sa table.
class SheetNotesTab extends ConsumerWidget {
  const SheetNotesTab({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final table = ref.watch(characterTableProvider(id));
    return switch (table) {
      AsyncData(value: final tableId?) => NotesView(tableId: tableId),
      AsyncData() => Center(
        child: Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Text(AppLocalizations.of(context).notesNoTable),
        ),
      ),
      _ => const Center(child: CircularProgressIndicator()),
    };
  }
}
