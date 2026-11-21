// Éditeurs de Classe et de Sous-classe (US-27 lot c, [H02], EF-HB-11) :
// progression 1 à 20, aptitudes par niveau, colonnes de la table ; une
// sous-classe place ses aptitudes aux niveaux que sa classe parente lui
// réserve. Une progression incomplète s'enregistre ; la vérification du
// pack la signale.
part of 'entity_editor.dart';

/// Colonnes de la table de classe que lit l'incantation.
bool _isSpellColumn(String key) =>
    key == 'cantrips' ||
    key == 'prepared_spells' ||
    key.startsWith('slot_') ||
    key.startsWith('pact_');

String _columnLabel(AppLocalizations l10n, String key) =>
    switch (RegExp(r'^slot_(\d)$').firstMatch(key)) {
      final m? => l10n.classColumnSlots(int.parse(m[1]!)),
      _ => switch (key) {
        'cantrips' => l10n.classColumnCantrips,
        'prepared_spells' => l10n.classColumnPrepared,
        'pact_slots' => l10n.classColumnPactSlots,
        'pact_slot_level' => l10n.classColumnPactLevel,
        _ => key.replaceAll('_', ' '),
      },
    };

extension _ClassForms on _EntityEditorState {
  /// Bonus de maîtrise du [level] : celui de la table des classes du
  /// contenu, le même pour toutes.
  int _proficiencyBonus(ActiveContent? content, int level) {
    for (final e in content?.entities ?? const <ContentEntity>[]) {
      if (e.data case ClassData(:final levels) when levels.length >= level) {
        return levels[level - 1].proficiencyBonus;
      }
    }
    return 0;
  }

  List<int> get _subclassLevels => [
    for (final l in _list(_data['subclass_feature_levels']))
      if (l is int) l,
  ];

  int get _subclassLevel => _data['subclass_level'] as int? ?? 3;

  /// Les aptitudes de sous-classe commencent au niveau où on la choisit.
  void _setSubclassLevels(int start, Iterable<int> others) =>
      _set('subclass_feature_levels', [
        start,
        ...({...others.where((l) => l > start && l <= 20)}.toList()..sort()),
      ]);

  Future<void> _editClassFeature(
    AppLocalizations l10n,
    ActiveContent content,
    int? index,
    int level,
  ) => _editFeature(
    content,
    index,
    title: l10n.classFeatureTitle(level, _name.text.trim()),
    saveLabel: l10n.classFeatureSave,
    level: level,
  );

  List<Widget> _levelFeatures(
    AppLocalizations l10n,
    ActiveContent content,
    int level,
  ) => [
    for (var i = 0; i < _features.length; i++)
      if (_features[i]['level'] == level)
        _featureTile(
          l10n,
          content,
          i,
          fromSrd: l10n.classFeatureSrd,
          removeLabel: l10n.classFeatureRemove,
          onEdit: () => _editClassFeature(l10n, content, i, level),
        ),
  ];

  Widget _addFeature(AppLocalizations l10n, ActiveContent content, int level) =>
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _editClassFeature(l10n, content, null, level),
          icon: const Icon(Icons.add),
          label: Text(l10n.classFeatureAdd(level)),
        ),
      );

  // Classe.

  List<Widget> _class(AppLocalizations l10n, ActiveContent content) {
    final text = Theme.of(context).textTheme;
    List<(String, String)> of(String type) => [
      for (final e in _ofType(content, type)) ('${e.id}', e.name),
    ];
    final classes = [
      for (final c in _ofType(content, 'class'))
        if (c.data case final ClassData data) (c, data),
    ];
    final multiclass = {...?(_data['multiclass'] as Map<String, Object?>?)};
    void setMulticlass(String key, Object? value) {
      if (value == null || value == 0 || (value is List && value.isEmpty)) {
        multiclass.remove(key);
      } else {
        multiclass[key] = value;
      }
      _set('multiclass', multiclass.isEmpty ? null : multiclass);
    }

    List<String> multiclassList(String key) => [
      for (final v in _list(multiclass[key])) '$v',
    ];
    final weapons = [
      ('simple', l10n.weaponSimple),
      ('martial', l10n.weaponMartial),
      ('martial_light', l10n.weaponMartialLight),
      ('martial_finesse_or_light', l10n.weaponMartialFinesseOrLight),
    ];
    final armors = [
      ('light', l10n.armorLight),
      ('medium', l10n.armorMedium),
      ('heavy', l10n.armorHeavy),
      ('shield', l10n.armorShield),
    ];
    final equipment = _list(_data['starting_equipment']);
    final goldOnly = equipment.every(
      (o) => o is Map && _list(o['items']).isEmpty,
    );
    final saves = _listOf('saving_throws').length;

    /// Reprend les colonnes d'incantation et la part de multiclassage d'une
    /// classe du contenu.
    void copySlots(String? classId) {
      final source = classes.where((c) => '${c.$1.id}' == classId).firstOrNull;
      if (source == null) return;
      final (_, data) = source;
      _update(() {
        _columns.removeWhere((key, _) => _isSpellColumn(key));
        for (final row in data.levels) {
          for (final MapEntry(:key, :value) in row.columns.entries) {
            if (!_isSpellColumn(key) || row.level > 20) continue;
            _columns.putIfAbsent(
              key,
              () => List<int?>.filled(20, null),
            )[row.level - 1] = value;
          }
        }
      });
      setMulticlass('caster_divisor', data.multiclass.casterDivisor);
      if (_data['prepared_change'] == null && data.preparedChange != null) {
        _set('prepared_change', switch (data.preparedChange!) {
          PreparedChange.longRestAll => 'long_rest_all',
          PreparedChange.longRestOne => 'long_rest_one',
          PreparedChange.levelUpOne => 'level_up_one',
        });
      }
    }

    return [
      _choice('${l10n.classHitDieField} *', _data['hit_die'] as int?, [
        for (final d in [6, 8, 10, 12]) (d, 'd$d'),
      ], (v) => _set('hit_die', v)),
      _picks(l10n.classPrimaryAbilities, 'primary_abilities', of('ability')),
      if (_listOf('primary_abilities').length > 1)
        _switch(
          l10n.classPrimaryAny,
          'primary_abilities_any',
          nullWhenOff: true,
        ),
      _picks(
        l10n.homebrewPickCount(l10n.classSavingThrows, saves, 2),
        'saving_throws',
        of('ability'),
        max: 2,
      ),
      _number(
        l10n.classSkillCount,
        _data['skill_choice_count'],
        (v) => _set('skill_choice_count', v),
      ),
      _picks(l10n.classSkillChoices, 'skill_choices', of('skill')),
      _picks(l10n.classWeapons, 'weapon_proficiencies', weapons),
      _picks(l10n.classArmor, 'armor_training', armors),
      _picks(l10n.classTools, 'tool_proficiencies', of('tool')),
      if (goldOnly)
        _number(
          l10n.classStartingGold,
          switch (equipment.firstOrNull) {
            {'gold': final int gold} => gold,
            _ => null,
          },
          (v) => _set(
            'starting_equipment',
            v == null
                ? null
                : [
                    {
                      'items': <Object?>[],
                      'tool_choice': <Object?>[],
                      'gold': v,
                    },
                  ],
          ),
        )
      else
        Text(l10n.classStartingEquipmentKept, style: text.bodySmall),

      // Sous-classe.
      Text(l10n.classSubclassTitle, style: text.titleMedium),
      _number(l10n.classSubclassLevel, _subclassLevel, (v) {
        if (v == null || v < 1 || v > 20) return;
        _set('subclass_level', v);
        _setSubclassLevels(v, _subclassLevels);
      }),
      _chips(
        l10n.classSubclassLevels,
        [for (final l in _subclassLevels) '$l'],
        [for (var l = _subclassLevel; l <= 20; l++) ('$l', '$l')],
        (v) => _setSubclassLevels(_subclassLevel, v.map(int.parse)),
      ),
      Text(l10n.classSubclassLevelsHint, style: text.bodySmall),

      // Incantation.
      Text(l10n.classSpellcasting, style: text.titleMedium),
      _choice<String?>(
        l10n.classSpellcastingAbility,
        _data['spellcasting_ability'] as String?,
        [(null, l10n.classNoSpellcasting), ...of('ability')],
        (v) => _set('spellcasting_ability', v),
      ),
      if (_data['spellcasting_ability'] != null) ...[
        _choice(l10n.classPreparedChange, _data['prepared_change'] as String?, [
          ('long_rest_all', l10n.classPreparedLongRestAll),
          ('long_rest_one', l10n.classPreparedLongRestOne),
          ('level_up_one', l10n.classPreparedLevelUpOne),
        ], (v) => _set('prepared_change', v)),
        _choice<String>(l10n.classSlotsLike, null, [
          for (final (c, data) in classes)
            if (data.levels.any((l) => l.columns.keys.any(_isSpellColumn)))
              ('${c.id}', c.name),
        ], copySlots),
        _choice<String>(
          l10n.classSpellListLike,
          null,
          [
            for (final (c, _) in classes)
              if (content.spellList('${c.id}').isNotEmpty) ('${c.id}', c.name),
          ],
          (v) {
            if (v == null) return;
            _set('spell_list', [for (final s in content.spellList(v)) '$s']);
          },
        ),
        if (_list(_data['spell_list']).isNotEmpty)
          Text(
            l10n.classSpellListCount(_list(_data['spell_list']).length),
            style: text.bodySmall,
          ),
        _choice<int?>(
          l10n.classCasterDivisor,
          multiclass['caster_divisor'] as int?,
          [
            (null, l10n.classCasterNone),
            (1, l10n.classCasterFull),
            (2, l10n.classCasterHalf),
          ],
          (v) => setMulticlass('caster_divisor', v),
        ),
      ],

      // Multiclassage.
      Text(l10n.classMulticlassTitle, style: text.titleMedium),
      _chips(
        l10n.classWeapons,
        multiclassList('weapon_proficiencies'),
        weapons,
        (v) => setMulticlass('weapon_proficiencies', v),
      ),
      _chips(
        l10n.classArmor,
        multiclassList('armor_training'),
        armors,
        (v) => setMulticlass('armor_training', v),
      ),
      _number(
        l10n.classSkillCount,
        multiclass['skill_choice_count'],
        (v) => setMulticlass('skill_choice_count', v),
      ),

      // Colonnes de la table.
      Text(l10n.classColumnsTitle, style: text.titleMedium),
      for (final key in _columns.keys)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(_columnLabel(l10n, key)),
          subtitle: Text([for (final v in _columns[key]!) v ?? '—'].join(' ')),
          onTap: () => _editColumn(l10n, key),
          trailing: IconButton(
            tooltip: l10n.classColumnRemove,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _update(() => _columns.remove(key)),
          ),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _addColumn(l10n),
          icon: const Icon(Icons.add),
          label: Text(l10n.classColumnAdd),
        ),
      ),

      // Progression.
      Text(l10n.classProgressionTitle, style: text.titleMedium),
      for (var level = 1; level <= 20; level++) ...[
        Text(
          l10n.classLevelHeader(level, _proficiencyBonus(content, level)),
          style: text.titleSmall,
        ),
        if (_subclassLevels.contains(level))
          Text(l10n.classSubclassFeatureHere, style: text.bodySmall),
        if ([
              for (final MapEntry(:key, :value) in _columns.entries)
                if (value[level - 1] case final int v)
                  '${_columnLabel(l10n, key)} $v',
            ].join(' · ')
            case final columns when columns.isNotEmpty)
          Text(columns, style: text.bodySmall),
        ..._levelFeatures(l10n, content, level),
        _addFeature(l10n, content, level),
      ],
    ];
  }

  Future<void> _addColumn(AppLocalizations l10n) async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (dialog) => AlertDialog(
        title: Text(l10n.classColumnAdd),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: InputDecoration(labelText: l10n.classColumnName),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialog),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialog, controller.text),
            child: Text(l10n.classColumnAdd),
          ),
        ],
      ),
    );
    controller.dispose();
    final key = slugOf(name ?? '').replaceAll('-', '_');
    if (key.isEmpty || _columns.containsKey(key)) return;
    _update(() => _columns[key] = List<int?>.filled(20, null));
    await _editColumn(l10n, key);
  }

  Future<void> _editColumn(AppLocalizations l10n, String key) async {
    final values = await Navigator.of(context).push(
      MaterialPageRoute<List<int?>>(
        fullscreenDialog: true,
        builder: (_) =>
            _ColumnPage(title: _columnLabel(l10n, key), values: _columns[key]!),
      ),
    );
    if (values != null) _update(() => _columns[key] = values);
  }

  // Sous-classe ([H02]).

  /// Nom et niveaux d'aptitude de sous-classe de [classId], du contenu ou
  /// du brouillon ; à défaut de niveaux, celui où on la choisit.
  (String, List<int>) _parentLevels(ActiveContent content, String classId) {
    if (content.entity(classId) case ContentEntity(
      :final name,
      data: final ClassData c,
    )) {
      return (
        name,
        c.subclassFeatureLevels.isEmpty
            ? [c.subclassLevel]
            : c.subclassFeatureLevels,
      );
    }
    final own = widget.draft.entities
        .where((e) => e['id'] == classId)
        .firstOrNull;
    final data = (own?['data'] as Map?) ?? const {};
    final levels = [
      for (final l in _list(data['subclass_feature_levels']))
        if (l is int) l,
    ];
    return (
      '${own?['name'] ?? classId}',
      levels.isEmpty ? [data['subclass_level'] as int? ?? 3] : levels,
    );
  }

  List<Widget> _subclass(AppLocalizations l10n, ActiveContent content) {
    final text = Theme.of(context).textTheme;
    final parentId = _data['parent_class'] as String?;
    final parents = [
      for (final c in _ofType(content, 'class')) ('${c.id}', c.name),
      for (final e in widget.draft.entities)
        if (e['type'] == 'class') ('${e['id']}', '${e['name']}'),
    ];
    final (parentName, allowed) = parentId == null
        ? ('', const <int>[])
        : _parentLevels(content, parentId);
    final levels = {
      ...allowed,
      for (final f in _features) f['level']! as int,
    }.toList()..sort();
    void move(int index, int level) => _update(
      () => _features = [
        for (final (i, f) in _features.indexed)
          i == index ? {...f, 'level': level} : f,
      ],
    );

    return [
      _choice(
        '${l10n.subclassParent} *',
        parentId,
        parents,
        (v) => _set('parent_class', v),
      ),
      if (parentId != null) ...[
        Text(
          l10n.subclassLevelsOf(parentName, allowed.join(', ')),
          style: text.bodySmall,
        ),
        for (final level in levels) ...[
          Text(l10n.subclassLevel(level), style: text.titleSmall),
          if (allowed.contains(level)) ...[
            ..._levelFeatures(l10n, content, level),
            _addFeature(l10n, content, level),
          ] else
            for (var i = 0; i < _features.length; i++)
              if (_features[i]['level'] == level) ...[
                _featureTile(
                  l10n,
                  content,
                  i,
                  fromSrd: l10n.classFeatureSrd,
                  removeLabel: l10n.classFeatureRemove,
                  onEdit: () => _editClassFeature(l10n, content, i, level),
                ),
                Text(
                  l10n.subclassWrongLevel(parentName, level),
                  style: text.bodySmall,
                ),
                Wrap(
                  spacing: AppSpacing.xs,
                  children: [
                    if (allowed.where((l) => l >= level).firstOrNull ??
                            allowed.lastOrNull
                        case final next?)
                      TextButton(
                        onPressed: () => move(i, next),
                        child: Text(l10n.subclassMoveTo(next)),
                      ),
                    PopupMenuButton<int>(
                      tooltip: l10n.subclassOtherLevel,
                      onSelected: (l) => move(i, l),
                      itemBuilder: (_) => [
                        for (final l in allowed)
                          PopupMenuItem(
                            value: l,
                            child: Text(l10n.subclassLevel(l)),
                          ),
                      ],
                      child: Padding(
                        padding: EdgeInsets.all(AppSpacing.sm),
                        child: Text(l10n.subclassOtherLevel),
                      ),
                    ),
                  ],
                ),
              ],
        ],
      ],
    ];
  }
}

/// Valeurs d'une colonne de la table de classe, niveau par niveau.
class _ColumnPage extends StatefulWidget {
  const _ColumnPage({required this.title, required this.values});

  final String title;
  final List<int?> values;

  @override
  State<_ColumnPage> createState() => _ColumnPageState();
}

class _ColumnPageState extends State<_ColumnPage> {
  late final _values = [...widget.values];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(widget.title),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, _values),
            child: Text(l10n.noteSave),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          for (var i = 0; i < 20; i++)
            Padding(
              padding: EdgeInsets.only(bottom: AppSpacing.xs),
              child: TextFormField(
                initialValue: '${_values[i] ?? ''}',
                keyboardType: TextInputType.number,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  labelText: l10n.subclassLevel(i + 1),
                ),
                onChanged: (v) => _values[i] = int.tryParse(v),
              ),
            ),
        ],
      ),
    );
  }
}
