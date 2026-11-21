// Éditeur d'une entité homebrew (US-27, EF-HB-01) : enveloppe commune (nom,
// texte, effets) et formulaire du type, avec les contraintes 2024 (cahier
// §7.1). Lot a : Don et Historique ; lot b : Sort, Objet ([H05]), variante
// d'une entité du SRD (EF-HB-02) et Espèce, dont chaque trait est une entité
// `feature` du pack. Un brouillon incomplet s'enregistre ; la
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

  /// Traits d'une espèce : ceux du brouillon (JSON, modifiables), ou
  /// l'identifiant d'un trait d'un autre pack (variante du SRD).
  late List<Object> _traits = [
    for (final id in (_data['traits'] as List?) ?? const [])
      widget.draft.entities.where((e) => e['id'] == id).firstOrNull ?? '$id',
  ];

  String get _namespace => '${widget.draft.manifest['namespace']}';

  /// Identifiant d'une ressource neuve : `{namespace}:resource:{nom}`.
  String get _resourceId =>
      '$_namespace:resource:${slugOf(_name.text).isEmpty ? _type : slugOf(_name.text)}';

  bool _ownTrait(Map<String, Object?> e, String speciesId) =>
      e['type'] == 'feature' && (e['data'] as Map?)?['source'] == speciesId;

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
    'background' || 'spell' || 'item' || 'species' => false,
    'weapon' || 'armor' => _data['rarity'] != null,
    _ => true,
  };

  Future<void> _save() async {
    final taken = [for (final e in widget.draft.entities) '${e['id']}'];
    final id =
        _previousId ?? homebrewEntityId(_namespace, _type, _name.text, taken);
    // Les traits du brouillon deviennent des entités `feature` de source
    // l'espèce, nommées `{espèce}-{trait}` comme au SRD.
    final traits = <Map<String, Object?>>[];
    final traitIds = <String>[];
    if (_type == 'species') {
      for (final t in _traits) {
        if (t is String) {
          traitIds.add(t);
          continue;
        }
        final trait = t as Map<String, Object?>;
        final traitId =
            (trait['id'] as String?) ??
            homebrewEntityId(
              _namespace,
              'feature',
              '${id.split(':').last} ${trait['name']}',
              [...taken, ...traitIds],
            );
        traitIds.add(traitId);
        traits.add({
          ...trait,
          'id': traitId,
          'type': 'feature',
          'data': {'source': id, 'level': 1},
        });
      }
    }
    final entity = {
      'id': id,
      'type': _type,
      'name': _name.text.trim(),
      'extends_id': ?_extends,
      'data': {..._data, if (_type == 'species') 'traits': traitIds},
      if (_hasEffects && _effects.isNotEmpty) 'effects': _effects,
      if (_text.text.trim().isNotEmpty) 'text': {'fr': _text.text.trim()},
    };
    await ref
        .read(homebrewStoreProvider)
        .save(
          widget.draft.id,
          manifest: widget.draft.manifest,
          entities: [
            for (final e in widget.draft.entities)
              if (e['id'] == _previousId) ...[
                entity,
                ...traits,
              ] else if (!_ownTrait(e, id))
                e,
            if (_previousId == null) ...[entity, ...traits],
          ],
        );
    if (mounted) Navigator.pop(context);
  }

  /// Supprimer une espèce retire aussi ses traits.
  Future<void> _delete() async {
    await ref
        .read(homebrewStoreProvider)
        .save(
          widget.draft.id,
          manifest: widget.draft.manifest,
          entities: [
            for (final e in widget.draft.entities)
              if (e['id'] != _previousId && !_ownTrait(e, '$_previousId')) e,
          ],
        );
    if (mounted) Navigator.pop(context);
  }

  Future<void> _editTrait(ActiveContent content, int? index) async {
    final edited = await Navigator.of(context).push(
      MaterialPageRoute<Map<String, Object?>>(
        fullscreenDialog: true,
        builder: (_) => _TraitPage(
          content: content,
          species: _name.text.trim(),
          resourceId: '$_resourceId-${_traits.length + 1}',
          trait: index == null ? null : _traits[index] as Map<String, Object?>,
        ),
      ),
    );
    if (edited == null) return;
    setState(() {
      _traits = [
        for (final (i, t) in _traits.indexed) i == index ? edited : t,
        if (index == null) edited,
      ];
    });
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
  }) {
    final chosen = _listOf(key);
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
                  _set(key, next);
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
        l10n.spellRange,
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
      _string(l10n.spellDuration, 'duration'),
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
      for (final (i, t) in _traits.indexed)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(
            t is String ? namesOf(content, [t]) : '${(t as Map)['name']}',
          ),
          subtitle: Text(switch (t) {
            String() => l10n.speciesTraitSrd,
            {'effects': final List<Object?> effects} => [
              for (final e in effects)
                describeEffect(
                  l10n,
                  content,
                  Map<String, Object?>.from(e! as Map),
                ),
            ].join(' · '),
            _ => '',
          }),
          onTap: t is String ? null : () => _editTrait(content, i),
          trailing: IconButton(
            tooltip: l10n.speciesTraitRemove,
            icon: const Icon(Icons.delete_outline),
            onPressed: () =>
                setState(() => _traits = [..._traits]..removeAt(i)),
          ),
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

/// Un trait d'espèce : nom, texte et effets. « Enregistrer le trait » le
/// rend à l'éditeur d'Espèce, qui l'enregistre avec elle.
class _TraitPage extends StatefulWidget {
  const _TraitPage({
    required this.content,
    required this.species,
    required this.resourceId,
    this.trait,
  });

  final ActiveContent content;
  final String species;
  final String resourceId;
  final Map<String, Object?>? trait;

  @override
  State<_TraitPage> createState() => _TraitPageState();
}

class _TraitPageState extends State<_TraitPage> {
  late final _name = TextEditingController(
    text: '${widget.trait?['name'] ?? ''}',
  );
  late final _text = TextEditingController(
    text: '${(widget.trait?['text'] as Map?)?['fr'] ?? ''}',
  );
  late List<EffectJson> _effects = [
    for (final e in (widget.trait?['effects'] as List?) ?? const [])
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
        title: Text(l10n.speciesTraitTitle(widget.species)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, {
              'id': ?widget.trait?['id'],
              'name': _name.text.trim(),
              if (_text.text.trim().isNotEmpty)
                'text': {'fr': _text.text.trim()},
              if (_effects.isNotEmpty) 'effects': _effects,
            }),
            child: Text(l10n.speciesTraitSave),
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
