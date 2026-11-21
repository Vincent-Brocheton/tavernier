// Éditeur d'une entité homebrew (US-27, EF-HB-01) : enveloppe commune (nom,
// texte, effets) et formulaire du type, avec les contraintes 2024 (cahier
// §7.1). Lot a : Don et Historique ; lot b : Sort, Objet ([H05]), variante
// d'une entité du SRD (EF-HB-02) et Espèce ; lot c : Classe et Sous-classe
// ([H02], EF-HB-11) ; lot d : Monstre. Les traits d'une espèce et les aptitudes d'une classe
// ou d'une sous-classe sont des entités `feature` du pack, de source leur
// propriétaire. Un brouillon incomplet s'enregistre ; la
// vérification du pack dit ce qui manque pour publier.
import 'dart:math';

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
import 'sandbox_page.dart';

part 'class_editor.dart';
part 'monster_editor.dart';

/// Ouvre l'éditeur d'une entité [type] de [draft] ; neuve sans identifiant
/// dans [entity] (une variante arrive sans identifiant, avec `extends_id`).
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

/// Les genres d'objet ([H05]), chacun un type d'entité.
const itemTypes = ['weapon', 'armor', 'magic-item', 'item'];

/// Données d'une entité neuve de [type] : les booléens obligatoires à faux.
Map<String, Object?> _defaults(String type) => switch (type) {
  // L'équipement A part vide ; il se complète avec les objets.
  'background' => {'equipment_a': <Object?>[]},
  'spell' => {
    'ritual': false,
    'components': {'verbal': false, 'somatic': false},
    'material_consumed': false,
    'concentration': false,
  },
  'magic-item' => {'attunement': false},
  'species' => {'creature_type': 'humanoid', 'speed_feet': 30},
  'class' => {
    'primary_abilities': <Object?>[],
    'saving_throws': <Object?>[],
    'skill_choice_count': 2,
    'skill_choices': <Object?>[],
    'weapon_proficiencies': <Object?>[],
    'armor_training': <Object?>[],
    'subclass_level': 3,
    'subclass_feature_levels': [3],
  },
  'monster' => {
    'sizes': ['medium'],
    'creature_type': 'beast',
    'abilities': {for (final k in monsterAbilityKeys) k: 10},
    'speed': {'walk': 30},
    'hover': false,
    'cr': '1',
  },
  _ => {},
};

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
  late String _type = widget.type;
  late final String? _previousId = widget.entity?['id'] as String?;
  late final String? _extends = widget.entity?['extends_id'] as String?;
  late Map<String, Object?> _data = {
    ..._defaults(_type),
    ...?(widget.entity?['data'] as Map<String, Object?>?),
  };
  late List<EffectJson> _effects = [
    for (final e in (widget.entity?['effects'] as List?) ?? const [])
      Map<String, Object?>.from(e as Map),
  ];

  /// Traits d'une espèce, aptitudes d'une classe ou d'une sous-classe, avec
  /// leur `level` : celles du brouillon (nom, texte, effets, modifiables),
  /// ou `{ref}`, une aptitude d'un autre pack (variante du SRD).
  late List<Map<String, Object?>> _features = _initialFeatures();

  /// Colonnes de la table de classe : clé → valeur de chaque niveau.
  late final Map<String, List<int?>> _columns = () {
    final columns = <String, List<int?>>{};
    for (final row in _list(_data['levels'])) {
      if (row
          case {
            'level': final int level,
            'columns': final Map<Object?, Object?> values,
          }
          when level >= 1 && level <= 20) {
        for (final MapEntry(:key, :value) in values.entries) {
          columns.putIfAbsent(
            '$key',
            () => List<int?>.filled(20, null),
          )[level - 1] = value as int?;
        }
      }
    }
    return columns;
  }();

  List<Object?> _list(Object? value) => value is List ? value : const [];

  List<Map<String, Object?>> _initialFeatures() {
    final content = ref.read(contentProvider).value;
    Map<String, Object?> of(Object? id, int? level) {
      final own = widget.draft.entities.where((e) => e['id'] == id).firstOrNull;
      final ownLevel = (own?['data'] as Map?)?['level'] as int?;
      final otherLevel = switch (content?.entity('$id')?.data) {
        FeatureData(:final level) => level,
        _ => null,
      };
      final at = level ?? ownLevel ?? otherLevel ?? 1;
      return own == null
          ? {'ref': '$id', 'level': at}
          : {
              'id': own['id'],
              'name': own['name'],
              'text': ?own['text'],
              'effects': ?own['effects'],
              'level': at,
            };
    }

    return switch (_type) {
      'species' => [for (final id in _list(_data['traits'])) of(id, 1)],
      'subclass' => [for (final id in _list(_data['features'])) of(id, null)],
      'class' => [
        for (final row in _list(_data['levels']))
          if (row case {
            'level': final int level,
            'features': final List<Object?> ids,
          })
            for (final id in ids) of(id, level),
      ],
      _ => [],
    };
  }

  String get _namespace => '${widget.draft.manifest['namespace']}';

  /// Identifiant d'une ressource neuve : `{namespace}:resource:{nom}`.
  String get _resourceId =>
      '$_namespace:resource:${slugOf(_name.text).isEmpty ? _type : slugOf(_name.text)}';

  /// Une aptitude du brouillon qui appartient à [ownerId].
  bool _ownFeature(Map<String, Object?> e, String ownerId) =>
      e['type'] == 'feature' && (e['data'] as Map?)?['source'] == ownerId;

  /// Monstre : JS et compétences maîtrisés, armure portée (`null` : CA
  /// naturelle) et bouclier ; les valeurs se recalculent à l'enregistrement.
  late final Set<String> _proficientSaves = _initialProficientSaves();
  late final Set<String> _proficientSkills = {
    for (final k in ((_data['skills'] as Map?) ?? const {}).keys) '$k',
  };
  late String? _acArmor = _initialArmor().$1;
  late bool _acShield = _initialArmor().$2;

  /// `setState` pour les formulaires de `class_editor.dart`.
  void _update(VoidCallback change) => setState(change);

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

  /// Le genre d'un objet neuf se change ; ses données repartent de zéro.
  void _setType(String type) => setState(() {
    _type = type;
    _data = _defaults(type);
    _effects = [];
  });

  /// Les effets d'une arme ou d'une armure n'agissent que si elle est
  /// magique (moteur : objet équipé, harmonisé s'il le demande).
  bool get _hasEffects => switch (_type) {
    'background' ||
    'spell' ||
    'item' ||
    'species' ||
    'class' ||
    'subclass' ||
    'monster' => false,
    'weapon' || 'armor' => _data['rarity'] != null,
    _ => true,
  };

  /// Le brouillon tel qu'il serait enregistré, et l'identifiant de
  /// l'entité : `_save` l'écrit, le bac à sable ([H04]) le lit.
  (List<Map<String, Object?>>, String) _draftEntities() {
    final content = ref.read(contentProvider).value;
    final taken = [for (final e in widget.draft.entities) '${e['id']}'];
    final id =
        _previousId ?? homebrewEntityId(_namespace, _type, _name.text, taken);
    // Les aptitudes du brouillon deviennent des entités `feature` de source
    // leur propriétaire, nommées `{propriétaire}-{aptitude}` comme au SRD.
    final owned = <Map<String, Object?>>[];
    final placed = <(int, String)>[];
    for (final f in _features) {
      final level = f['level']! as int;
      if (f['ref'] case final String other) {
        placed.add((level, other));
        continue;
      }
      final featureId =
          (f['id'] as String?) ??
          homebrewEntityId(
            _namespace,
            'feature',
            '${id.split(':').last} ${f['name']}',
            [...taken, for (final (_, p) in placed) p],
          );
      placed.add((level, featureId));
      owned.add({
        'id': featureId,
        'type': 'feature',
        'name': f['name'],
        'text': ?f['text'],
        'effects': ?f['effects'],
        'data': {'source': id, 'level': level},
      });
    }
    List<String> at(bool Function(int) test) => [
      for (final (level, f) in placed)
        if (test(level)) f,
    ];
    final data = {
      ..._data,
      if (_type == 'species') 'traits': at((_) => true),
      if (_type == 'subclass')
        'features': [
          for (final (_, f) in [...placed]..sort((a, b) => a.$1 - b.$1)) f,
        ],
      if (_type == 'monster') ..._monsterComputed(content!),
      if (_type == 'class')
        'levels': [
          for (var level = 1; level <= 20; level++)
            {
              'level': level,
              'proficiency_bonus': _proficiencyBonus(content, level),
              'features': at((l) => l == level),
              'columns': {
                for (final MapEntry(:key, :value) in _columns.entries)
                  if (value[level - 1] case final int v) key: v,
              },
            },
        ],
    };
    final entity = {
      'id': id,
      'type': _type,
      'name': _name.text.trim(),
      'extends_id': ?_extends,
      'data': data,
      if (_hasEffects && _effects.isNotEmpty) 'effects': _effects,
      if (_text.text.trim().isNotEmpty) 'text': {'fr': _text.text.trim()},
    };
    return (
      [
        for (final e in widget.draft.entities)
          if (e['id'] == _previousId) ...[
            entity,
            ...owned,
          ] else if (!_ownFeature(e, id))
            e,
        if (_previousId == null) ...[entity, ...owned],
      ],
      id,
    );
  }

  Future<void> _save() async {
    final (entities, _) = _draftEntities();
    await ref
        .read(homebrewStoreProvider)
        .save(
          widget.draft.id,
          manifest: widget.draft.manifest,
          entities: entities,
        );
    if (mounted) Navigator.pop(context);
  }

  /// « Tester sur un personnage » ([H04], US-28) : l'entité telle qu'elle
  /// est à l'écran, sans enregistrer.
  Future<void> _test() {
    final (entities, id) = _draftEntities();
    return Navigator.of(context).push(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => SandboxPage(
          manifest: widget.draft.manifest,
          entities: entities,
          entityId: id,
        ),
      ),
    );
  }

  /// Supprimer une espèce, une classe ou une sous-classe retire aussi ses
  /// aptitudes.
  Future<void> _delete() async {
    await ref
        .read(homebrewStoreProvider)
        .save(
          widget.draft.id,
          manifest: widget.draft.manifest,
          entities: [
            for (final e in widget.draft.entities)
              if (e['id'] != _previousId && !_ownFeature(e, '$_previousId')) e,
          ],
        );
    if (mounted) Navigator.pop(context);
  }

  /// Ouvre l'aptitude [index] (ou une neuve, au niveau [level]).
  Future<void> _editFeature(
    ActiveContent content,
    int? index, {
    required String title,
    required String saveLabel,
    int level = 1,
  }) async {
    final edited = await Navigator.of(context).push(
      MaterialPageRoute<Map<String, Object?>>(
        fullscreenDialog: true,
        builder: (_) => _FeaturePage(
          content: content,
          title: title,
          saveLabel: saveLabel,
          resourceId: '$_resourceId-${_features.length + 1}',
          feature: index == null ? null : _features[index],
        ),
      ),
    );
    if (edited == null) return;
    setState(() {
      _features = [
        for (final (i, f) in _features.indexed)
          i == index ? {...edited, 'level': f['level']} : f,
        if (index == null) {...edited, 'level': level},
      ];
    });
  }

  /// Une aptitude de la liste : son nom et le résumé de ses effets ; une
  /// aptitude d'un autre pack se retire sans se modifier.
  Widget _featureTile(
    AppLocalizations l10n,
    ActiveContent content,
    int index, {
    required VoidCallback onEdit,
    required String fromSrd,
    required String removeLabel,
  }) {
    final f = _features[index];
    final other = f['ref'] as String?;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(other != null ? namesOf(content, [other]) : '${f['name']}'),
      subtitle: Text(switch (f) {
        {'ref': String()} => fromSrd,
        {'effects': final List<Object?> effects} => [
          for (final e in effects)
            describeEffect(l10n, content, Map<String, Object?>.from(e! as Map)),
        ].join(' · '),
        _ => '',
      }),
      onTap: other != null ? null : onEdit,
      trailing: IconButton(
        tooltip: removeLabel,
        icon: const Icon(Icons.delete_outline),
        onPressed: () =>
            setState(() => _features = [..._features]..removeAt(index)),
      ),
    );
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
    final parent = content.entity(_extends ?? '');
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${widget.draft.manifest['name']}', style: text.bodySmall),
            Text(typeLabel(l10n, _type), style: text.titleLarge),
          ],
        ),
        actions: [
          if (_previousId != null)
            IconButton(
              tooltip: l10n.homebrewDeleteEntity,
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          if (sandboxTypes.contains(_type))
            IconButton(
              tooltip: l10n.sandboxTest,
              icon: const Icon(Icons.science_outlined),
              onPressed: _test,
            ),
          TextButton(onPressed: _save, child: Text(l10n.noteSave)),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          if (parent != null) ...[
            Text(l10n.homebrewVariantOf(parent.name), style: text.bodySmall),
            SizedBox(height: AppSpacing.sm),
          ],
          if (itemTypes.contains(_type) &&
              _previousId == null &&
              _extends == null) ...[
            _choice(l10n.itemKind, _type, [
              ('weapon', l10n.itemKindWeapon),
              ('armor', l10n.itemKindArmor),
              ('magic-item', l10n.itemKindMagicItem),
              ('item', l10n.itemKindGear),
            ], (v) => _setType(v!)),
            SizedBox(height: AppSpacing.sm),
          ],
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
          // Une clé par genre : changer de genre vide les champs.
          Column(
            key: ValueKey(_type),
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              for (final field in switch (_type) {
                'feat' => _feat(l10n),
                'background' => _background(l10n, content, draftFeats),
                'spell' => _spell(l10n, content),
                'weapon' => _weapon(l10n, content, parent),
                'armor' => _armor(l10n),
                'magic-item' => _magicItem(l10n),
                'item' => _gear(l10n),
                'species' => _species(l10n, content),
                'class' => _class(l10n, content),
                'subclass' => _subclass(l10n, content),
                'monster' => _monster(l10n, content),
                _ => const <Widget>[],
              }) ...[field, SizedBox(height: AppSpacing.sm)],
            ],
          ),
          if (_hasEffects) ...[
            SizedBox(height: AppSpacing.sm),
            EffectList(
              content: content,
              resourceId: _resourceId,
              effects: _effects,
              onChanged: (e) => setState(() => _effects = e),
            ),
          ],
        ],
      ),
    );
  }

  // Champs communs.

  Widget _number(String label, Object? value, ValueChanged<int?> onChanged) =>
      TextFormField(
        initialValue: '${value ?? ''}',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(labelText: label),
        onChanged: (v) => onChanged(int.tryParse(v)),
      );

  /// Nombre à virgule (poids, prix en po).
  Widget _decimal(String label, num? value, ValueChanged<double?> onChanged) =>
      TextFormField(
        initialValue: value == null ? '' : '$value'.replaceAll('.', ','),
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9.,]'))],
        decoration: InputDecoration(labelText: label),
        onChanged: (v) => onChanged(double.tryParse(v.replaceAll(',', '.'))),
      );

  /// Prix saisi en po, stocké en pc.
  Widget _cost(String label) => _decimal(label, switch (_data['cost_cp']) {
    final int cp => cp / 100,
    _ => null,
  }, (gp) => _set('cost_cp', gp == null ? null : (gp * 100).round()));

  Widget _string(String label, String key) => TextFormField(
    initialValue: '${_data[key] ?? ''}',
    decoration: InputDecoration(labelText: label),
    onChanged: (v) => _set(key, v.trim().isEmpty ? null : v.trim()),
  );

  Widget _switch(String label, String key, {bool nullWhenOff = false}) =>
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(label),
        value: _data[key] == true,
        onChanged: (v) => _set(key, v || !nullWhenOff ? v : null),
      );

  Widget _choice<T>(
    String label,
    T? value,
    List<(T, String)> options,
    ValueChanged<T?> onChanged,
  ) => DropdownButtonFormField<T>(
    initialValue: options.any((o) => o.$1 == value) ? value : null,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      for (final (v, l) in options) DropdownMenuItem(value: v, child: Text(l)),
    ],
    onChanged: onChanged,
  );

  List<ContentEntity> _ofType(ActiveContent content, String type) => [
    for (final e in content.entities)
      if (e.id.type == type) e,
  ]..sort((a, b) => foldAccents(a.name).compareTo(foldAccents(b.name)));

  List<String> _listOf(String key) => [
    for (final v in (_data[key] as List?) ?? const []) '$v',
  ];

  /// Puces à choix multiple de [key], au plus [max].
  Widget _picks(
    String title,
    String key,
    List<(String, String)> options, {
    int? max,
  }) => _chips(title, _listOf(key), options, (v) => _set(key, v), max: max);

  Widget _chips(
    String title,
    List<String> chosen,
    List<(String, String)> options,
    ValueChanged<List<String>> onChanged, {
    int? max,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleSmall),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: [
            for (final (id, label) in options)
              FilterChip(
                label: Text(label),
                selected: chosen.contains(id),
                onSelected: (on) {
                  if (on && max != null && chosen.length >= max) return;
                  final next = [
                    for (final c in chosen)
                      if (c != id) c,
                    if (on) id,
                  ];
                  onChanged(next);
                },
              ),
          ],
        ),
      ],
    );
  }

  // Don et Historique (lot a).

  List<Widget> _feat(AppLocalizations l10n) {
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
      _choice(l10n.homebrewFeatCategory, _data['category'] as String?, [
        ('origin', l10n.featOrigin),
        ('general', l10n.featGeneral),
        ('fighting_style', l10n.featFightingStyle),
        ('epic_boon', l10n.featEpicBoon),
      ], (v) => _set('category', v)),
      _number(
        l10n.homebrewFeatMinLevel,
        prerequisites['min_level'],
        (v) => setPrerequisite('min_level', v),
      ),
      _switch(l10n.homebrewFeatRepeatable, 'repeatable', nullWhenOff: true),
    ];
  }

  List<Widget> _background(
    AppLocalizations l10n,
    ActiveContent content,
    List<(String, String)> draftFeats,
  ) {
    final text = Theme.of(context).textTheme;
    List<(String, String)> options(String type) => [
      for (final e in _ofType(content, type)) ('${e.id}', e.name),
    ];
    // Seuls les dons d'origine sont proposés (cahier §7.1).
    final originFeats = [
      for (final e in _ofType(content, 'feat'))
        if (e.data case FeatData(category: FeatCategory.origin))
          ('${e.id}', e.name),
      ...draftFeats,
    ];
    final abilities = _listOf('abilities').length;
    final skills = _listOf('skill_proficiencies').length;
    return [
      _picks(
        l10n.homebrewPickCount(l10n.homebrewBackgroundAbilities, abilities, 3),
        'abilities',
        options('ability'),
        max: 3,
      ),
      if (abilities != 3)
        Text(l10n.homebrewBackgroundAbilitiesRule, style: text.bodySmall),
      _choice(
        l10n.homebrewOriginFeat,
        _data['origin_feat'] as String?,
        originFeats,
        (v) => _set('origin_feat', v),
      ),
      _picks(
        l10n.homebrewPickCount(l10n.homebrewBackgroundSkills, skills, 2),
        'skill_proficiencies',
        options('skill'),
        max: 2,
      ),
      if (skills != 2)
        Text(l10n.homebrewBackgroundSkillsRule, style: text.bodySmall),
      _choice(
        l10n.homebrewBackgroundTool,
        _data['tool_proficiency'] as String?,
        options('tool'),
        (v) => _set('tool_proficiency', v),
      ),
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

  // Sort (lot b).

  List<Widget> _spell(AppLocalizations l10n, ActiveContent content) {
    final range = {...?(_data['range'] as Map<String, Object?>?)};
    final components = {...?(_data['components'] as Map<String, Object?>?)};
    void setComponent(String key, Object? value) {
      if (value == null) {
        components.remove(key);
      } else {
        components[key] = value;
      }
      _set('components', components);
    }

    return [
      _choice(l10n.spellLevel, _data['level'] as int?, [
        (0, l10n.spellCantrip),
        for (var level = 1; level <= 9; level++)
          (level, l10n.spellLevelName(level)),
      ], (v) => _set('level', v)),
      _choice(l10n.spellSchool, _data['school'] as String?, [
        ('abjuration', l10n.schoolAbjuration),
        ('conjuration', l10n.schoolConjuration),
        ('divination', l10n.schoolDivination),
        ('enchantment', l10n.schoolEnchantment),
        ('evocation', l10n.schoolEvocation),
        ('illusion', l10n.schoolIllusion),
        ('necromancy', l10n.schoolNecromancy),
        ('transmutation', l10n.schoolTransmutation),
      ], (v) => _set('school', v)),
      _string(l10n.spellCastingTime, 'casting_time'),
      _switch(l10n.ritual, 'ritual'),
      _choice(
        l10n.spellEditRange,
        range['kind'] as String?,
        [
          ('self', l10n.rangeSelf),
          ('touch', l10n.rangeTouch),
          ('feet', l10n.rangeFeetKind),
          ('sight', l10n.rangeSight),
          ('unlimited', l10n.rangeUnlimited),
          ('special', l10n.rangeSpecial),
        ],
        (v) =>
            _set('range', {'kind': v, if (v == 'feet') 'feet': ?range['feet']}),
      ),
      if (range['kind'] == 'feet')
        _number(
          l10n.effectFieldFeet,
          range['feet'],
          (v) => _set('range', {'kind': 'feet', 'feet': ?v}),
        ),
      Text(l10n.spellComponents, style: Theme.of(context).textTheme.titleSmall),
      Wrap(
        spacing: AppSpacing.xs,
        children: [
          for (final (key, label) in [
            ('verbal', l10n.componentVerbalName),
            ('somatic', l10n.componentSomaticName),
          ])
            FilterChip(
              label: Text(label),
              selected: components[key] == true,
              onSelected: (on) => setComponent(key, on),
            ),
        ],
      ),
      TextFormField(
        initialValue: '${components['material'] ?? ''}',
        decoration: InputDecoration(labelText: l10n.spellMaterial),
        onChanged: (v) =>
            setComponent('material', v.trim().isEmpty ? null : v.trim()),
      ),
      if (components['material'] != null) ...[
        _decimal(
          l10n.spellMaterialCost,
          switch (_data['material_cost_cp']) {
            final int cp => cp / 100,
            _ => null,
          },
          (gp) =>
              _set('material_cost_cp', gp == null ? null : (gp * 100).round()),
        ),
        _switch(l10n.spellMaterialConsumed, 'material_consumed'),
      ],
      _string(l10n.spellEditDuration, 'duration'),
      _switch(l10n.concentration, 'concentration'),
      _picks(l10n.spellClasses, 'classes', [
        for (final c in _ofType(content, 'class'))
          if (content.spellList('${c.id}').isNotEmpty) ('${c.id}', c.name),
      ]),
      Text(
        l10n.spellHigherLevelHint,
        style: Theme.of(context).textTheme.bodySmall,
      ),
    ];
  }

  // Objets (lot b, [H05]).

  /// Rareté d'une arme ou d'une armure : sans rareté, elle est ordinaire.
  List<Widget> _rarity(AppLocalizations l10n, {bool required = false}) => [
    DropdownButtonFormField<String>(
      initialValue: _data['rarity'] as String?,
      isExpanded: true,
      decoration: InputDecoration(
        labelText: required ? '${l10n.itemRarity} *' : l10n.itemRarity,
      ),
      items: [
        if (!required) DropdownMenuItem(child: Text(l10n.rarityNone)),
        for (final (value, label) in [
          ('common', l10n.rarityCommon),
          ('uncommon', l10n.rarityUncommon),
          ('rare', l10n.rarityRare),
          ('very_rare', l10n.rarityVeryRare),
          ('legendary', l10n.rarityLegendary),
          ('artifact', l10n.rarityArtifact),
        ])
          DropdownMenuItem(value: value, child: Text(label)),
      ],
      onChanged: (v) => setState(() {
        if (v == null) {
          _data
            ..remove('rarity')
            ..remove('attunement');
        } else {
          _data['rarity'] = v;
        }
      }),
    ),
    if (required || _data['rarity'] != null)
      _switch(l10n.itemAttunement, 'attunement', nullWhenOff: !required),
  ];

  List<Widget> _weapon(
    AppLocalizations l10n,
    ActiveContent content,
    ContentEntity? parent,
  ) {
    final text = Theme.of(context).textTheme;
    final properties = _listOf('properties');
    final range = [for (final v in (_data['range_feet'] as List?) ?? []) v];
    void setRange(int index, int? value) {
      final next = [range.elementAtOrNull(0), range.elementAtOrNull(1)];
      next[index] = value;
      _set('range_feet', next.contains(null) ? null : next);
    }

    final parentMastery = switch (parent?.data) {
      WeaponData(:final mastery) => content.entity('$mastery'),
      _ => null,
    };
    return [
      _choice(l10n.itemCategory, _data['category'] as String?, [
        ('simple', l10n.weaponCategorySimple),
        ('martial', l10n.weaponCategoryMartial),
      ], (v) => _set('category', v)),
      _choice(l10n.weaponKind, _data['kind'] as String?, [
        ('melee', l10n.weaponKindMelee),
        ('ranged', l10n.weaponKindRanged),
      ], (v) => _set('kind', v)),
      _string(l10n.weaponDamage, 'damage'),
      _choice(l10n.weaponDamageType, _data['damage_type'] as String?, [
        for (final e in _ofType(content, 'damage-type')) ('${e.id}', e.name),
      ], (v) => _set('damage_type', v)),
      _picks(l10n.weaponProperties, 'properties', [
        ('ammunition', l10n.propertyAmmunition),
        ('finesse', l10n.propertyFinesse),
        ('heavy', l10n.propertyHeavy),
        ('light', l10n.propertyLight),
        ('loading', l10n.propertyLoading),
        ('reach', l10n.propertyReach),
        ('thrown', l10n.propertyThrown),
        ('two_handed', l10n.propertyTwoHanded),
        ('versatile', l10n.propertyVersatile),
      ]),
      if (properties.contains('versatile'))
        _string(l10n.weaponVersatileDamage, 'versatile_damage'),
      if (_data['kind'] == 'ranged' || properties.contains('thrown'))
        Row(
          children: [
            Expanded(
              child: _number(
                l10n.weaponRangeNormal,
                range.elementAtOrNull(0),
                (v) => setRange(0, v),
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: _number(
                l10n.weaponRangeLong,
                range.elementAtOrNull(1),
                (v) => setRange(1, v),
              ),
            ),
          ],
        ),
      _choice(l10n.weaponMastery, _data['mastery'] as String?, [
        for (final e in _ofType(content, 'mastery')) ('${e.id}', e.name),
      ], (v) => _set('mastery', v)),
      if (_data['mastery'] == null) ...[
        Text(l10n.weaponMasteryRule, style: text.bodySmall),
        if (parentMastery != null)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _set('mastery', '${parentMastery.id}'),
              child: Text(
                l10n.weaponMasteryReuse(parent!.name, parentMastery.name),
              ),
            ),
          ),
      ],
      _decimal(
        l10n.itemWeight,
        _data['weight_kg'] as num?,
        (v) => _set('weight_kg', v),
      ),
      _cost(l10n.itemCost),
      ..._rarity(l10n),
      if (_data['rarity'] != null)
        Text(l10n.weaponBonusHint, style: text.bodySmall),
    ];
  }

  List<Widget> _armor(AppLocalizations l10n) => [
    _choice(l10n.itemCategory, _data['category'] as String?, [
      ('light', l10n.armorCategoryLight),
      ('medium', l10n.armorCategoryMedium),
      ('heavy', l10n.armorCategoryHeavy),
      ('shield', l10n.armorCategoryShield),
    ], (v) => _set('category', v)),
    _number(l10n.armorBaseAc, _data['base_ac'], (v) => _set('base_ac', v)),
    _number(l10n.armorDexCap, _data['dex_cap'], (v) => _set('dex_cap', v)),
    _number(
      l10n.armorStrength,
      _data['str_requirement'],
      (v) => _set('str_requirement', v),
    ),
    _switch(l10n.armorStealth, 'stealth_disadvantage', nullWhenOff: true),
    _decimal(
      '${l10n.itemWeight} *',
      _data['weight_kg'] as num?,
      (v) => _set('weight_kg', v),
    ),
    _cost(l10n.itemCost),
    ..._rarity(l10n),
  ];

  List<Widget> _magicItem(AppLocalizations l10n) => [
    _choice(l10n.itemCategory, _data['category'] as String?, [
      ('wondrous', l10n.magicWondrous),
      ('armor', l10n.magicArmor),
      ('weapon', l10n.magicWeapon),
      ('ring', l10n.magicRing),
      ('wand', l10n.magicWand),
      ('staff', l10n.magicStaff),
      ('potion', l10n.magicPotion),
      ('scroll', l10n.magicScroll),
      ('rod', l10n.magicRod),
    ], (v) => _set('category', v)),
    _string(l10n.magicTypeLine, 'type_line'),
    ..._rarity(l10n, required: true),
  ];

  // Espèce (lot b2).

  Future<void> _editTrait(ActiveContent content, int? index) {
    final l10n = AppLocalizations.of(context);
    return _editFeature(
      content,
      index,
      title: l10n.speciesTraitTitle(_name.text.trim()),
      saveLabel: l10n.speciesTraitSave,
    );
  }

  List<Widget> _species(AppLocalizations l10n, ActiveContent content) {
    final text = Theme.of(context).textTheme;
    return [
      _choice(l10n.speciesCreatureType, _data['creature_type'] as String?, [
        for (final t in CreatureType.values)
          (t.name, l10n.creatureType(t.name)),
      ], (v) => _set('creature_type', v)),
      _picks(l10n.speciesSizes, 'sizes', [
        ('P', l10n.sizeSmall),
        ('M', l10n.sizeMedium),
      ]),
      _number(
        l10n.speciesSpeed,
        _data['speed_feet'],
        (v) => _set('speed_feet', v),
      ),
      Text(l10n.speciesNoAbilities, style: text.bodySmall),
      Text(l10n.speciesTraits, style: text.titleMedium),
      for (var i = 0; i < _features.length; i++)
        _featureTile(
          l10n,
          content,
          i,
          fromSrd: l10n.speciesTraitSrd,
          removeLabel: l10n.speciesTraitRemove,
          onEdit: () => _editTrait(content, i),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _editTrait(content, null),
          icon: const Icon(Icons.add),
          label: Text(l10n.speciesTraitAdd),
        ),
      ),
      Text(l10n.speciesLineageHint, style: text.bodySmall),
    ];
  }

  List<Widget> _gear(AppLocalizations l10n) => [
    _decimal(
      l10n.itemWeight,
      _data['weight_kg'] as num?,
      (v) => _set('weight_kg', v),
    ),
    _cost(l10n.itemCostOptional),
  ];
}

/// Un trait d'espèce ou une aptitude : nom, texte et effets. Le bouton
/// d'enregistrement la rend à l'éditeur de son propriétaire, qui
/// l'enregistre avec lui.
class _FeaturePage extends StatefulWidget {
  const _FeaturePage({
    required this.content,
    required this.title,
    required this.saveLabel,
    required this.resourceId,
    this.feature,
  });

  final ActiveContent content;
  final String title;
  final String saveLabel;
  final String resourceId;
  final Map<String, Object?>? feature;

  @override
  State<_FeaturePage> createState() => _FeaturePageState();
}

class _FeaturePageState extends State<_FeaturePage> {
  late final _name = TextEditingController(
    text: '${widget.feature?['name'] ?? ''}',
  );
  late final _text = TextEditingController(
    text: '${(widget.feature?['text'] as Map?)?['fr'] ?? ''}',
  );
  late List<EffectJson> _effects = [
    for (final e in (widget.feature?['effects'] as List?) ?? const [])
      Map<String, Object?>.from(e as Map),
  ];

  @override
  void dispose() {
    _name.dispose();
    _text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, {
              'id': ?widget.feature?['id'],
              'name': _name.text.trim(),
              if (_text.text.trim().isNotEmpty)
                'text': {'fr': _text.text.trim()},
              if (_effects.isNotEmpty) 'effects': _effects,
            }),
            child: Text(widget.saveLabel),
          ),
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
          EffectList(
            content: widget.content,
            resourceId: widget.resourceId,
            effects: _effects,
            onChanged: (e) => setState(() => _effects = e),
          ),
        ],
      ),
    );
  }
}

/// Petit formulaire en dialogue : ses champs (libellé, numérique) ; rend
/// leurs textes, ou `null` à l'annulation. Il garde ses contrôleurs jusqu'à
/// la fin de son animation de fermeture.
class _FieldsDialog extends StatefulWidget {
  const _FieldsDialog({required this.title, required this.fields});

  final String title;
  final List<(String, bool)> fields;

  @override
  State<_FieldsDialog> createState() => _FieldsDialogState();
}

class _FieldsDialogState extends State<_FieldsDialog> {
  late final _controllers = [
    for (final _ in widget.fields) TextEditingController(),
  ];

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (final (i, (label, numeric)) in widget.fields.indexed)
            TextField(
              controller: _controllers[i],
              autofocus: i == 0,
              keyboardType: numeric ? TextInputType.number : null,
              inputFormatters: numeric
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : null,
              minLines: 1,
              maxLines: numeric ? 1 : null,
              decoration: InputDecoration(labelText: label),
            ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () =>
              Navigator.pop(context, [for (final c in _controllers) c.text]),
          child: Text(widget.title),
        ),
      ],
    );
  }
}
