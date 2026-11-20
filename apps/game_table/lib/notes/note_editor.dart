// Éditeur d'une note (US-26, EF-NOT-01, 04, 06, [N5]) : rattachement, titre,
// texte avec gras, listes et liens ; partage ; fusion d'un conflit. La note
// d'un autre s'ouvre en lecture seule.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../account/account_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../sheet/conflicts.dart';
import 'note_markdown.dart';
import 'notes_view.dart';

class NoteEditor extends ConsumerStatefulWidget {
  const NoteEditor({
    super.key,
    required this.tableId,
    this.note,
    this.defaultSession,
    this.gm = false,
  });

  final String tableId;

  /// Note à modifier ; `null` pour une note neuve.
  final Note? note;

  /// Séance d'une note neuve ; sans elle, la note se rattache à la table.
  final String? defaultSession;
  final bool gm;

  @override
  ConsumerState<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends ConsumerState<NoteEditor> {
  late final _title = TextEditingController(text: widget.note?.title ?? '');
  late final _content = TextEditingController(text: widget.note?.content ?? '');
  late var _scope =
      widget.note?.scope ??
      (widget.defaultSession == null ? 'table' : 'session');
  late var _refId = widget.note?.refId ?? widget.defaultSession;
  late var _private = widget.note?.private ?? true;

  @override
  void dispose() {
    _title.dispose();
    _content.dispose();
    super.dispose();
  }

  NoteStore get _store => ref.read(noteStoreProvider);

  Future<void> _save() async {
    final note = widget.note;
    if (note == null) {
      final id = await _store.create(
        ownerUserId: ref.read(currentUserProvider).value!.id,
        tableId: widget.tableId,
        scope: _scope,
        refId: _refId,
        title: _title.text.trim(),
        content: _content.text,
      );
      if (!_private) await _store.update(id, private: false);
    } else {
      await _store.update(
        note.id,
        title: _title.text.trim(),
        content: _content.text,
        scope: _scope,
        refId: _refId ?? '',
        private: _private,
      );
    }
    if (mounted) Navigator.pop(context);
  }

  /// Entoure la sélection de `**`.
  void _bold() {
    final sel = _content.selection;
    if (!sel.isValid) return;
    final text = _content.text;
    final inner = sel.textInside(text);
    _content.value = TextEditingValue(
      text: text.replaceRange(sel.start, sel.end, '**$inner**'),
      selection: TextSelection.collapsed(offset: sel.end + 4),
    );
  }

  /// Fait de la ligne du curseur une ligne de liste.
  void _list() {
    final text = _content.text;
    final at = _content.selection.isValid
        ? _content.selection.start
        : text.length;
    final start = text.lastIndexOf('\n', at == 0 ? 0 : at - 1) + 1;
    if (text.startsWith('- ', start)) return;
    _content.value = TextEditingValue(
      text: text.replaceRange(start, start, '- '),
      selection: TextSelection.collapsed(offset: at + 2),
    );
  }

  Future<void> _link(NoteTargets targets) async {
    final picked = await showModalBottomSheet<(String, String, String)>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _LinkPicker(targets: targets),
    );
    if (picked == null) return;
    final (kind, id, name) = picked;
    final sel = _content.selection;
    final text = _content.text;
    final at = sel.isValid ? sel.start : text.length;
    final end = sel.isValid ? sel.end : text.length;
    final link = '[$name]($kind:$id)';
    _content.value = TextEditingValue(
      text: text.replaceRange(at, end, link),
      selection: TextSelection.collapsed(offset: at + link.length),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final note = widget.note;
    final me = ref.watch(currentUserProvider).value?.id;
    final targets = noteTargets(ref, widget.tableId);
    final attachment = attachmentLabel(l10n, targets, _scope, _refId);
    if (note != null && note.ownerUserId != me) {
      final author =
          ref.watch(pseudonymOfProvider(note.ownerUserId)).value ??
          l10n.notesSomeone;
      return Scaffold(
        appBar: AppBar(title: Text(l10n.notesSharedBy(author))),
        body: ListView(
          padding: EdgeInsets.all(AppSpacing.md),
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(label: Text(attachment)),
            ),
            Text(
              note.title.isEmpty ? l10n.notesUntitled : note.title,
              style: text.headlineSmall,
            ),
            SizedBox(height: AppSpacing.sm),
            NoteText(
              note.content,
              onLink: widget.gm
                  ? (link) => openNoteLink(context, widget.tableId, link)
                  : null,
            ),
          ],
        ),
      );
    }
    final options = [
      ('table', null, l10n.notesScopeTable),
      for (final s in targets.sessions)
        ('session', s.id, '${l10n.notesSessionLabel(s.number)} · ${s.title}'),
      for (final n in targets.npcs) ('npc', n.id, n.name),
      for (final e in targets.encounters) ('encounter', e.id, e.title),
    ];
    final selected = options.indexWhere(
      (o) => o.$1 == _scope && (o.$2 ?? '') == (_refId ?? ''),
    );
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(_private ? l10n.notePrivateHint : l10n.notesSharedChip),
        actions: [
          if (note != null)
            IconButton(
              tooltip: l10n.noteDelete,
              icon: const Icon(Icons.delete_outline),
              onPressed: () async {
                await _store.delete(note.id);
                if (context.mounted) Navigator.pop(context);
              },
            ),
          TextButton(onPressed: _save, child: Text(l10n.noteSave)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          if (note?.conflict case final other?) ...[
            Card(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.sm),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(l10n.noteConflictTitle, style: text.titleSmall),
                    SizedBox(height: AppSpacing.xs),
                    NoteText(other),
                    Wrap(
                      spacing: AppSpacing.xs,
                      children: [
                        TextButton(
                          onPressed: () async {
                            final merged = '${_content.text}\n\n$other';
                            _content.text = merged;
                            await _store.resolve(note!.id, merged);
                          },
                          child: Text(l10n.noteConflictAppend),
                        ),
                        TextButton(
                          onPressed: () =>
                              _store.resolve(note!.id, _content.text),
                          child: Text(l10n.noteConflictDiscard),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: AppSpacing.sm),
          ],
          DropdownButtonFormField<int>(
            initialValue: selected < 0 ? 0 : selected,
            decoration: InputDecoration(labelText: l10n.noteAttachment),
            isExpanded: true,
            items: [
              for (final (i, o) in options.indexed)
                DropdownMenuItem(value: i, child: Text(o.$3)),
            ],
            onChanged: (i) => setState(() {
              _scope = options[i!].$1;
              _refId = options[i].$2;
            }),
          ),
          SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: l10n.noteTitle),
            style: text.titleLarge,
          ),
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              IconButton(
                tooltip: l10n.noteBold,
                icon: const Icon(Icons.format_bold),
                onPressed: _bold,
              ),
              IconButton(
                tooltip: l10n.noteList,
                icon: const Icon(Icons.format_list_bulleted),
                onPressed: _list,
              ),
              IconButton(
                tooltip: l10n.noteLink,
                icon: const Icon(Icons.link),
                onPressed: () => _link(targets),
              ),
            ],
          ),
          TextField(
            controller: _content,
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            decoration: InputDecoration(labelText: l10n.noteContent),
          ),
          SizedBox(height: AppSpacing.sm),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.noteShare),
            subtitle: Text(
              _private ? l10n.notePrivateHint : l10n.noteShareHint,
            ),
            value: !_private,
            onChanged: (shared) => setState(() => _private = !shared),
          ),
        ],
      ),
    );
  }
}

/// Choix d'un PNJ ou d'une rencontre à lier ([N5]) : rend (type, id, nom).
class _LinkPicker extends StatefulWidget {
  const _LinkPicker({required this.targets});

  final NoteTargets targets;

  @override
  State<_LinkPicker> createState() => _LinkPickerState();
}

class _LinkPickerState extends State<_LinkPicker> {
  var _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    bool match(String name) => foldAccents(name).contains(foldAccents(_query));
    final npcs = [
      for (final n in widget.targets.npcs)
        if (match(n.name)) n,
    ];
    final encounters = [
      for (final e in widget.targets.encounters)
        if (match(e.title)) e,
    ];
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: ListView(
          shrinkWrap: true,
          children: [
            Text(l10n.noteLinkTitle, style: text.titleLarge),
            TextField(
              autofocus: true,
              onChanged: (v) => setState(() => _query = v),
              decoration: const InputDecoration(prefixIcon: Icon(Icons.search)),
            ),
            if (npcs.isNotEmpty) ...[
              SizedBox(height: AppSpacing.sm),
              Text(l10n.notesScopeNpcs.toUpperCase(), style: text.labelMedium),
              for (final n in npcs)
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(n.name),
                  onTap: () => Navigator.pop(context, ('npc', n.id, n.name)),
                ),
            ],
            if (encounters.isNotEmpty) ...[
              SizedBox(height: AppSpacing.sm),
              Text(
                l10n.notesScopeEncounters.toUpperCase(),
                style: text.labelMedium,
              ),
              for (final e in encounters)
                ListTile(
                  leading: const Icon(Icons.flag_outlined),
                  title: Text(e.title),
                  onTap: () =>
                      Navigator.pop(context, ('encounter', e.id, e.title)),
                ),
            ],
            SizedBox(height: AppSpacing.sm),
            Text(l10n.noteLinkHint, style: text.bodySmall),
            SizedBox(height: AppSpacing.md),
          ],
        ),
      ),
    );
  }
}
