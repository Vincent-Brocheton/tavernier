// Éditeur d'une entité homebrew (US-27, EF-HB-01) : enveloppe commune (nom,
// texte, effets) et formulaire du type. Lot a : Don et Historique, avec les
// contraintes 2024 (cahier §7.1). Un brouillon incomplet s'enregistre ; la
// vérification du pack dit ce qui manque pour publier.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';

import '../creation/creation_providers.dart';
import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';
import 'effect_editor.dart';
import 'homebrew_page.dart';

/// Ouvre l'éditeur d'une entité [type] de [draft] ; neuve sans [entity].
Future<void> openEntityEditor(
  BuildContext context, {
  required HomebrewDraft draft,
  required String type,
  Map<String, Object?>? entity,
}) => Navigator.of(context).push(
  MaterialPageRoute<void>(
    fullscreenDialog: true,
    builder: (_) => EntityEditorPage(draft: draft, type: type, entity: entity),
  ),
);

class EntityEditorPage extends ConsumerStatefulWidget {
  const EntityEditorPage({
    super.key,
    required this.draft,
    required this.type,
    this.entity,
  });

  final HomebrewDraft draft;
  final String type;
  final Map<String, Object?>? entity;

  @override
  ConsumerState<EntityEditorPage> createState() => _EntityEditorState();
}

class _EntityEditorState extends ConsumerState<EntityEditorPage> {
  late final _name = TextEditingController(
    text: '${widget.entity?['name'] ?? ''}',
  );
  late final _text = TextEditingController(
    text: '${(widget.entity?['text'] as Map?)?['fr'] ?? ''}',
  );
  late final Map<String, Object?> _data = {
    // L'équipement A part vide ; il se complète avec les objets (lot b).
    if (widget.type == 'background') 'equipment_a': <Object?>[],
    ...?(widget.entity?['data'] as Map<String, Object?>?),
  };
  late List<EffectJson> _effects = [
    for (final e in (widget.entity?['effects'] as List?) ?? const [])
      Map<String, Object?>.from(e as Map),
  ];

  @override
  void dispose() {
    _name.dispose();
    _text.dispose();
    super.dispose();
  }

  void _set(String key, Object? value) => setState(() {
    if (value == null) {
      _data.remove(key);
    } else {
      _data[key] = value;
    }
  });

  Future<void> _save() async {
    final previous = widget.entity?['id'] as String?;
    final id =
        previous ??
        homebrewEntityId(
          '${widget.draft.manifest['namespace']}',
          widget.type,
          _name.text,
          [for (final e in widget.draft.entities) '${e['id']}'],
        );
    await saveEntity(ref, widget.draft, {
      'id': id,
      'type': widget.type,
      'name': _name.text.trim(),
      'data': _data,
      if (_effects.isNotEmpty) 'effects': _effects,
      if (_text.text.trim().isNotEmpty) 'text': {'fr': _text.text.trim()},
    }, previousId: previous);
    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final previous = widget.entity?['id'];
    await ref
        .read(homebrewStoreProvider)
        .save(
          widget.draft.id,
          manifest: widget.draft.manifest,
          entities: [
            for (final e in widget.draft.entities)
              if (e['id'] != previous) e,
          ],
        );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final content = ref.watch(contentProvider).value;
    if (content == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    // Les dons du brouillon comptent pour l'Historique : un pack peut
    // apporter son propre don d'origine.
    final draftFeats = [
      for (final e in widget.draft.entities)
        if (e['type'] == 'feat' && (e['data'] as Map?)?['category'] == 'origin')
          ('${e['id']}', '${e['name']}'),
    ];
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.draft.manifest['name']}', style: text.bodySmall),
            Text(typeLabel(l10n, widget.type), style: text.titleLarge),
          ],
        ),
        actions: [
          if (widget.entity != null)
            IconButton(
              tooltip: l10n.homebrewDeleteEntity,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          TextButton(onPressed: _save, child: Text(l10n.noteSave)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l10n.homebrewFieldName),
          ),
          SizedBox(height: AppSpacing.sm),
          TextField(
            controller: _text,
            minLines: 3,
            maxLines: null,
            decoration: InputDecoration(labelText: l10n.homebrewFieldText),
          ),
          SizedBox(height: AppSpacing.md),
          ...switch (widget.type) {
            'feat' => _feat(l10n, content),
            'background' => _background(l10n, content, draftFeats),
            _ => const <Widget>[],
          },
          if (widget.type != 'background') ...[
            SizedBox(height: AppSpacing.md),
            EffectList(
              content: content,
              effects: _effects,
              onChanged: (e) => setState(() => _effects = e),
            ),
          ],
        ],
      ),
    );
  }

  Widget _number(String label, Object? value, ValueChanged<int?> onChanged) =>
      TextFormField(
        initialValue: '${value ?? ''}',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: label),
        onChanged: (v) => onChanged(int.tryParse(v)),
      );

  List<Widget> _feat(AppLocalizations l10n, ActiveContent content) {
    final prerequisites = {
      ...?(_data['prerequisites'] as Map<String, Object?>?),
    };
    void setPrerequisite(String key, Object? value) {
      if (value == null) {
        prerequisites.remove(key);
      } else {
        prerequisites[key] = value;
      }
      _set('prerequisites', prerequisites.isEmpty ? null : prerequisites);
    }

    return [
      DropdownButtonFormField<String>(
        initialValue: _data['category'] as String?,
        decoration: InputDecoration(labelText: l10n.homebrewFeatCategory),
        items: [
          for (final (value, label) in [
            ('origin', l10n.featOrigin),
            ('general', l10n.featGeneral),
            ('fighting_style', l10n.featFightingStyle),
            ('epic_boon', l10n.featEpicBoon),
          ])
            DropdownMenuItem(value: value, child: Text(label)),
        ],
        onChanged: (v) => _set('category', v),
      ),
      SizedBox(height: AppSpacing.sm),
      _number(
        l10n.homebrewFeatMinLevel,
        prerequisites['min_level'],
        (v) => setPrerequisite('min_level', v),
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.homebrewFeatRepeatable),
        value: _data['repeatable'] == true,
        onChanged: (v) => _set('repeatable', v ? true : null),
      ),
    ];
  }

  List<Widget> _background(
    AppLocalizations l10n,
    ActiveContent content,
    List<(String, String)> draftFeats,
  ) {
    final text = Theme.of(context).textTheme;
    List<String> listOf(String key) => [
      for (final v in (_data[key] as List?) ?? const []) '$v',
    ];
    final chosenAbilities = listOf('abilities');
    final chosenSkills = listOf('skill_proficiencies');
    List<ContentEntity> ofType(String type) => [
      for (final e in content.entities)
        if (e.id.type == type) e,
    ]..sort((a, b) => foldAccents(a.name).compareTo(foldAccents(b.name)));
    // Seuls les dons d'origine sont proposés (cahier §7.1).
    final originFeats = [
      for (final e in ofType('feat'))
        if (e.data case FeatData(category: FeatCategory.origin))
          ('${e.id}', e.name),
      ...draftFeats,
    ];

    Widget picks(
      String title,
      String key,
      List<ContentEntity> options,
      int max,
    ) {
      final chosen = listOf(key);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.homebrewPickCount(title, chosen.length, max),
            style: text.titleSmall,
          ),
          Wrap(
            spacing: AppSpacing.xs,
            runSpacing: AppSpacing.xs,
            children: [
              for (final e in options)
                FilterChip(
                  label: Text(e.name),
                  selected: chosen.contains('${e.id}'),
                  onSelected: (on) {
                    if (on && chosen.length >= max) return;
                    _set(key, [
                      for (final c in chosen)
                        if (c != '${e.id}') c,
                      if (on) '${e.id}',
                    ]);
                  },
                ),
            ],
          ),
        ],
      );
    }

    return [
      picks(
        l10n.homebrewBackgroundAbilities,
        'abilities',
        ofType('ability'),
        3,
      ),
      if (chosenAbilities.length != 3)
        Text(l10n.homebrewBackgroundAbilitiesRule, style: text.bodySmall),
      SizedBox(height: AppSpacing.sm),
      DropdownButtonFormField<String>(
        initialValue: originFeats.any((f) => f.$1 == _data['origin_feat'])
            ? _data['origin_feat'] as String?
            : null,
        isExpanded: true,
        decoration: InputDecoration(labelText: l10n.homebrewOriginFeat),
        items: [
          for (final (id, name) in originFeats)
            DropdownMenuItem(value: id, child: Text(name)),
        ],
        onChanged: (v) => _set('origin_feat', v),
      ),
      SizedBox(height: AppSpacing.sm),
      picks(
        l10n.homebrewBackgroundSkills,
        'skill_proficiencies',
        ofType('skill'),
        2,
      ),
      if (chosenSkills.length != 2)
        Text(l10n.homebrewBackgroundSkillsRule, style: text.bodySmall),
      SizedBox(height: AppSpacing.sm),
      DropdownButtonFormField<String>(
        initialValue: _data['tool_proficiency'] as String?,
        isExpanded: true,
        decoration: InputDecoration(labelText: l10n.homebrewBackgroundTool),
        items: [
          for (final e in ofType('tool'))
            DropdownMenuItem(value: '${e.id}', child: Text(e.name)),
        ],
        onChanged: (v) => _set('tool_proficiency', v),
      ),
      SizedBox(height: AppSpacing.sm),
      Row(
        children: [
          Expanded(
            child: _number(
              l10n.homebrewGoldA,
              _data['gold_a'],
              (v) => _set('gold_a', v),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _number(
              l10n.homebrewGoldB,
              _data['gold_b'],
              (v) => _set('gold_b', v),
            ),
          ),
        ],
      ),
    ];
  }
}
