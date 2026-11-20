// Préparer une séance (US-35, EF-SEA-02, [S2]) : titre, date, présences
// prévues, enregistrés au fil de la saisie ; « Ouvrir la séance ».
import 'dart:async';

import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import '../tables/tables_providers.dart';
import 'group_rest.dart';
import 'sessions_providers.dart';

class SessionPage extends ConsumerStatefulWidget {
  const SessionPage({super.key, required this.tableId, required this.id});

  final String tableId;
  final String id;

  @override
  ConsumerState<SessionPage> createState() => _SessionPageState();
}

class _SessionPageState extends ConsumerState<SessionPage> {
  TextEditingController? _title;
  late final SessionStore _store;

  /// Titre saisi, enregistré une demi-seconde après la dernière frappe (ou
  /// en quittant l'écran) : une seule écriture à synchroniser.
  Timer? _titleTimer;
  String? _pendingTitle;

  @override
  void initState() {
    super.initState();
    _store = ref.read(sessionStoreProvider);
  }

  void _saveTitle() {
    _titleTimer?.cancel();
    if (_pendingTitle case final title?) {
      _pendingTitle = null;
      unawaited(_store.update(widget.id, title: title));
    }
  }

  void _onTitle(String value) {
    _titleTimer?.cancel();
    // Le serveur refuse un titre vide : on garde le dernier.
    _pendingTitle = value.trim().isEmpty ? null : value.trim();
    _titleTimer = Timer(const Duration(milliseconds: 500), _saveTitle);
  }

  @override
  void dispose() {
    _saveTitle();
    _title?.dispose();
    super.dispose();
  }

  Future<void> _pickDate(GameSession session) async {
    final date = await showDatePicker(
      context: context,
      initialDate: session.date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (date != null) await _store.update(session.id, date: date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final scheme = Theme.of(context).colorScheme;
    final table = ref.watch(tableProvider(widget.tableId)).value;
    final session = [
      for (final s
          in ref.watch(tableSessionsProvider(widget.tableId)).value ??
              const <GameSession>[])
        if (s.id == widget.id) s,
    ].firstOrNull;
    if (table == null || session == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final title = _title ??= TextEditingController(text: session.title);
    final content = ref.watch(contentProvider).value;
    final group =
        ref.watch(tableGroupProvider(widget.tableId)).value ??
        const <CharacterSummary>[];
    final members = {
      for (final m
          in ref.watch(tableMembersProvider(widget.tableId)).value ??
              const <TableMemberInfo>[])
        m.userId: m.pseudonym,
    };
    final present =
        ref.watch(sessionAttendanceProvider(widget.id)).value ?? const {};
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () => context.canPop()
              ? context.pop()
              : context.go('/tables/${widget.tableId}'),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.sessionPrepHeader(table.settings.name, session.number),
              style: text.bodySmall,
            ),
            Text(
              l10n.sessionPrepTitle,
              style: text.titleLarge!.copyWith(color: scheme.tertiary),
            ),
          ],
        ),
        actions: [
          Icon(Icons.cloud_done_outlined, size: 18, color: scheme.onSurface),
          SizedBox(width: AppSpacing.xs),
          Text(l10n.sessionSaved, style: text.labelMedium),
          SizedBox(width: AppSpacing.md),
        ],
      ),
      // Sous le contenu : sur téléphone, la barre du haut n'a pas la place.
      bottomNavigationBar: session.status == SessionStatus.planned
          ? SafeArea(
              child: Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: FilledButton(
                  onPressed: () => _store.update(
                    session.id,
                    status: SessionStatus.inProgress,
                  ),
                  child: Text(l10n.sessionOpen),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: EdgeInsets.all(AppSpacing.md),
              children: [
                TextField(
                  controller: title,
                  decoration: InputDecoration(
                    labelText: l10n.sessionTitleLabel,
                  ),
                  onChanged: _onTitle,
                ),
                SizedBox(height: AppSpacing.md),
                InkWell(
                  onTap: () => _pickDate(session),
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: l10n.sessionDateLabel,
                      suffixIcon: const Icon(Icons.calendar_today_outlined),
                    ),
                    child: Text(l10n.sessionDate(session.date)),
                  ),
                ),
                SizedBox(height: AppSpacing.lg),
                Text(l10n.sessionAttendanceTitle, style: text.titleMedium),
                Text(l10n.sessionAttendanceHelp, style: text.bodySmall),
                SizedBox(height: AppSpacing.sm),
                if (session.status == SessionStatus.inProgress) ...[
                  GroupRestPanel(
                    tableId: widget.tableId,
                    sessionId: session.id,
                    present: present,
                    group: group,
                  ),
                  SizedBox(height: AppSpacing.lg),
                ],
                Card(
                  margin: EdgeInsets.zero,
                  child: Column(
                    children: [
                      for (final pc in group)
                        SwitchListTile(
                          value: present.contains(pc.id),
                          onChanged: (on) =>
                              _store.setPresent(session.id, pc.id, present: on),
                          title: Text(pc.name),
                          subtitle: Text(
                            [
                              ?members[pc.ownerUserId],
                              if (content != null)
                                for (final c in pc.classes)
                                  l10n.classLevel(
                                    namesOf(content, [c.classId]),
                                    c.level,
                                  ),
                            ].join(' · '),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
