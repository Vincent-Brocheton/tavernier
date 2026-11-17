// Feuilles de la fiche d'un PNJ (US-18, EF-PNJ-02, EF-PNJ-03, [C2]) : un
// palier d'information cachée, puis le nom et le dossier.
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:material_ui/material_ui.dart';

import '../l10n/app_localizations.dart';

/// Ce que rend la feuille d'un palier : le palier enregistré, ou sa
/// suppression.
sealed class HiddenInfoEdit {}

final class HiddenInfoSaved extends HiddenInfoEdit {
  HiddenInfoSaved(this.info);

  final HiddenInfo info;
}

final class HiddenInfoDeleted extends HiddenInfoEdit {}

/// Ouvre la feuille d'un palier ; [initial] : celui qu'on modifie, dont
/// l'état de révélation est gardé. `null` si le MJ annule.
Future<HiddenInfoEdit?> editHiddenInfo(
  BuildContext context, {
  HiddenInfo? initial,
}) => showModalBottomSheet<HiddenInfoEdit>(
  context: context,
  isScrollControlled: true,
  builder: (_) => _HiddenInfoSheet(initial: initial),
);

class _HiddenInfoSheet extends StatefulWidget {
  const _HiddenInfoSheet({this.initial});

  final HiddenInfo? initial;

  @override
  State<_HiddenInfoSheet> createState() => _HiddenInfoSheetState();
}

class _HiddenInfoSheetState extends State<_HiddenInfoSheet> {
  late final _dc = TextEditingController(
    text: widget.initial?.dc.toString() ?? '',
  );
  late final _text = TextEditingController(text: widget.initial?.text ?? '');

  @override
  void dispose() {
    _dc.dispose();
    _text.dispose();
    super.dispose();
  }

  int? get _dcValue => switch (int.tryParse(_dc.text)) {
    final dc? when dc >= 1 && dc <= 30 => dc,
    _ => null,
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final valid = _dcValue != null && _text.text.trim().isNotEmpty;
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
          Text(
            widget.initial == null ? l10n.hiddenInfoAdd : l10n.hiddenInfoEdit,
            style: text.titleLarge,
          ),
          SizedBox(height: AppSpacing.md),
          TextField(
            controller: _dc,
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            decoration: InputDecoration(
              labelText: l10n.hiddenInfoDc,
              helperText: l10n.hiddenInfoDcHelp,
            ),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.md),
          TextField(
            controller: _text,
            minLines: 2,
            maxLines: 5,
            decoration: InputDecoration(labelText: l10n.hiddenInfoText),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.md),
          // Trois boutons ne tiennent pas sur une ligne de téléphone :
          // « Supprimer » à part, à gauche.
          if (widget.initial != null)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => Navigator.pop(context, HiddenInfoDeleted()),
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.hiddenInfoDelete),
              ),
            ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: valid
                    ? () => Navigator.pop(
                        context,
                        HiddenInfoSaved(
                          HiddenInfo(
                            dc: _dcValue!,
                            text: _text.text.trim(),
                            revealed: widget.initial?.revealed ?? false,
                          ),
                        ),
                      )
                    : null,
                child: Text(l10n.hiddenInfoSave),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Nom et dossier d'un PNJ ; rend `(nom, dossier)`, dossier vide pour
/// « sans dossier », ou `null` si le MJ annule.
Future<(String, String)?> editNpcIdentity(BuildContext context, Npc npc) =>
    showModalBottomSheet<(String, String)>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _IdentitySheet(npc: npc),
    );

class _IdentitySheet extends StatefulWidget {
  const _IdentitySheet({required this.npc});

  final Npc npc;

  @override
  State<_IdentitySheet> createState() => _IdentitySheetState();
}

class _IdentitySheetState extends State<_IdentitySheet> {
  late final _name = TextEditingController(text: widget.npc.name);
  late final _folder = TextEditingController(text: widget.npc.folder ?? '');

  @override
  void dispose() {
    _name.dispose();
    _folder.dispose();
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
          Text(l10n.npcEdit, style: text.titleLarge),
          SizedBox(height: AppSpacing.md),
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l10n.npcName),
            onChanged: (_) => setState(() {}),
          ),
          SizedBox(height: AppSpacing.md),
          TextField(
            controller: _folder,
            decoration: InputDecoration(labelText: l10n.npcFolder),
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.cancel),
              ),
              SizedBox(width: AppSpacing.sm),
              FilledButton(
                onPressed: _name.text.trim().isEmpty
                    ? null
                    : () => Navigator.pop(context, (
                        _name.text.trim(),
                        _folder.text.trim(),
                      )),
                child: Text(l10n.hiddenInfoSave),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
