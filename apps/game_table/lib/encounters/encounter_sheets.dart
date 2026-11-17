// Feuilles de l'onglet Rencontres (US-19, [F5]) : nouvelle rencontre, et
// choix d'une séance.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';
import '../sessions/sessions_providers.dart';
import 'encounters_providers.dart';

/// Séances où ranger une rencontre : celles qui ne sont pas closes, par date.
List<GameSession> _openSessions(WidgetRef ref, String tableId) => [
  for (final s
      in (ref.read(tableSessionsProvider(tableId)).value ?? const []).reversed)
    if (s.status != SessionStatus.closed) s,
];

String _sessionLabel(AppLocalizations l10n, GameSession s) =>
    '${l10n.sessionNumber(s.number)} · ${s.title}';

/// Demande un titre et une séance, crée la rencontre en brouillon et ouvre
/// sa page.
Future<void> createEncounter(
  BuildContext context,
  WidgetRef ref,
  String tableId,
) async {
  final result = await showModalBottomSheet<(String, String?)>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _NewEncounterSheet(sessions: _openSessions(ref, tableId)),
  );
  if (result == null) return;
  final id = await ref
      .read(encounterStoreProvider)
      .create(tableId: tableId, title: result.$1, sessionId: result.$2);
  if (context.mounted) await context.push('/tables/$tableId/rencontres/$id');
}

class _NewEncounterSheet extends StatefulWidget {
  const _NewEncounterSheet({required this.sessions});

  final List<GameSession> sessions;

  @override
  State<_NewEncounterSheet> createState() => _NewEncounterSheetState();
}

class _NewEncounterSheetState extends State<_NewEncounterSheet> {
  final _title = TextEditingController();
  late String? _session = widget.sessions.firstOrNull?.id;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: EdgeInsets.only(
        left: AppSpacing.md,
        right: AppSpacing.md,
        top: AppSpacing.md,
        bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.encounterNew, style: text.titleLarge),
          SizedBox(height: AppSpacing.md),
          TextField(
            controller: _title,
            decoration: InputDecoration(labelText: l10n.sessionTitleLabel),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String?>(
            initialValue: _session,
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.encounterSession),
            items: [
              for (final s in widget.sessions)
                DropdownMenuItem(
                  value: s.id,
                  child: Text(
                    _sessionLabel(l10n, s),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              DropdownMenuItem(child: Text(l10n.encounterReserve)),
            ],
            onChanged: (v) => setState(() => _session = v),
          ),
          SizedBox(height: AppSpacing.md),
          // Sur un téléphone étroit, les boutons passent l'un sous l'autre.
          OverflowBar(
            alignment: MainAxisAlignment.end,
            spacing: AppSpacing.sm,
            overflowAlignment: OverflowBarAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              FilledButton(
                onPressed: _title.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, (
                        _title.text.trim(),
                        _session,
                      )),
                child: Text(l10n.encounterCreate),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Choisit une séance pas encore close ; `null` si le MJ annule.
Future<String?> chooseSession(
  BuildContext context,
  WidgetRef ref,
  String tableId,
) {
  final sessions = _openSessions(ref, tableId);
  final l10n = AppLocalizations.of(context);
  return showModalBottomSheet<String>(
    context: context,
    builder: (context) => SafeArea(
      child: ListView(
        shrinkWrap: true,
        children: [
          ListTile(title: Text(l10n.encounterMove)),
          for (final s in sessions)
            ListTile(
              title: Text(_sessionLabel(l10n, s)),
              subtitle: Text(l10n.sessionDate(s.date)),
              onTap: () => Navigator.pop(context, s.id),
            ),
        ],
      ),
    ),
  );
}
