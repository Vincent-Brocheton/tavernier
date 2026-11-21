// Éditeur de Monstre (US-27 lot d, cahier §7.1) : le profil de jeu complet,
// dont la CA (armure portée et bouclier, ou naturelle avec un libellé),
// l'Intelligence obligatoire et les informations d'Étude par palier. PX, BM,
// PV moyens, JS, compétences et Perception passive se calculent à
// l'enregistrement, avec les tables du SRD de `dnd_content`.
part of 'entity_editor.dart';

/// Clés des caractéristiques d'un profil, dans l'ordre imprimé.
const monsterAbilityKeys = ['str', 'dex', 'con', 'int', 'wis', 'cha'];

/// Clé de profil d'une caractéristique du contenu : `srd:ability:wisdom` →
/// `wis`.
String _abilityKey(ContentId id) => '$id'.split(':').last.substring(0, 3);

int _modifierOf(int score) => ((score - 10) / 2).floor();

extension _MonsterForm on _EntityEditorState {
  Map<String, Object?> get _abilityScores => {
    ...?(_data['abilities'] as Map<String, Object?>?),
  };

  int _mod(String key) => _modifierOf(_abilityScores[key] as int? ?? 10);

  String get _cr => _data['cr'] as String? ?? '1';

  Set<String> _initialProficientSaves() {
    final pb = proficiencyBonusOfChallenge(_cr);
    final saves = (_data['saving_throws'] as Map?) ?? const {};
    return {
      for (final k in monsterAbilityKeys)
        if (saves[k] == _mod(k) + pb) k,
    };
  }

  /// Armure et bouclier lus dans la note de CA (« Harnois, Bouclier »).
  (String?, bool) _initialArmor() {
    final content = ref.read(contentProvider).value;
    final parts = '${_data['ac_note'] ?? ''}'.split(', ');
    String? armor;
    var shield = false;
    for (final e in content?.entities ?? const <ContentEntity>[]) {
      if (e.data case ArmorData(:final category)) {
        if (!parts.contains(e.name)) continue;
        if (category == ArmorCategory.shield) {
          shield = true;
        } else {
          armor = '${e.id}';
        }
      }
    }
    return (armor, armor != null && shield);
  }

  ArmorData? _armorData(ActiveContent content, String? id) =>
      switch (content.entity(id ?? '')?.data) {
        final ArmorData a => a,
        _ => null,
      };

  ContentEntity? _shieldOf(ActiveContent content) => [
    for (final e in content.entities)
      if (e.data case ArmorData(category: ArmorCategory.shield)) e,
  ].firstOrNull;

  /// CA portée : armure, Dextérité dans sa limite, bouclier ; et sa formule.
  (int, String)? _wornAc(ActiveContent content) {
    final armor = _armorData(content, _acArmor);
    if (armor == null) return null;
    final shield = _acShield ? _shieldOf(content) : null;
    final dex = _mod('dex');
    final ac =
        armor.baseAc +
        (armor.dexCap == null ? dex : min<int>(dex, armor.dexCap!)) +
        switch (shield?.data) {
          ArmorData(:final baseAc) => baseAc,
          _ => 0,
        };
    return (ac, [content.entity(_acArmor!)!.name, ?shield?.name].join(', '));
  }

  /// Valeurs calculées du profil, écrites à l'enregistrement.
  Map<String, Object?> _monsterComputed(ActiveContent content) {
    final pb = proficiencyBonusOfChallenge(_cr);
    final skills = {
      for (final id in _proficientSkills)
        if (content.entity(id)?.data case SkillData(:final ability))
          id: _mod(_abilityKey(ability)) + pb,
    };
    final worn = _wornAc(content);
    return {
      'saving_throws': {
        for (final k in monsterAbilityKeys)
          k: _mod(k) + (_proficientSaves.contains(k) ? pb : 0),
      },
      'skills': skills,
      'passive_perception':
          10 + (skills['srd:skill:perception'] ?? _mod('wis')),
      'xp': (xpByChallenge[_cr] ?? const [0]).last,
      'proficiency_bonus': pb,
      'hp': averageOfDice('${_data['hit_dice'] ?? ''}') ?? 0,
      'initiative': _data['initiative'] ?? _mod('dex'),
      if (worn != null) ...{'ac': worn.$1, 'ac_note': worn.$2},
    };
  }

  String _abilityName(ActiveContent content, String key) =>
      _ofType(
        content,
        'ability',
      ).where((e) => _abilityKey(e.id) == key).firstOrNull?.name ??
      key;

  void _setIn(String key, String field, Object? value) {
    final map = {...?(_data[key] as Map<String, Object?>?)};
    if (value == null) {
      map.remove(field);
    } else {
      map[field] = value;
    }
    _set(key, map);
  }

  List<Widget> _monster(AppLocalizations l10n, ActiveContent content) {
    final text = Theme.of(context).textTheme;
    final speed = {...?(_data['speed'] as Map<String, Object?>?)};
    final senses = {...?(_data['senses'] as Map<String, Object?>?)};
    final actions = [
      for (final a in _list(_data['actions']))
        Map<String, Object?>.from(a! as Map),
    ];
    final reveals = [
      for (final r in _list(_data['study_reveals']))
        Map<String, Object?>.from(r! as Map),
    ];
    final pb = proficiencyBonusOfChallenge(_cr);
    final worn = _wornAc(content);
    List<(String, String)> of(String type) => [
      for (final e in _ofType(content, type)) ('${e.id}', e.name),
    ];
    Widget ability(String k) => _number(
      k == 'int' ? '${_abilityName(content, k)} *' : _abilityName(content, k),
      _abilityScores[k],
      (v) => _setIn('abilities', k, v),
    );
    Widget pair(Widget a, Widget b) => Row(
      children: [
        Expanded(child: a),
        SizedBox(width: AppSpacing.sm),
        Expanded(child: b),
      ],
    );

    return [
      _picks(l10n.monsterSizes, 'sizes', [
        for (final s in MonsterSize.values)
          (s.name, l10n.monsterSizeName(s.name)),
      ]),
      _choice(l10n.speciesCreatureType, _data['creature_type'] as String?, [
        for (final t in CreatureType.values)
          (t.name, l10n.creatureType(t.name)),
      ], (v) => _set('creature_type', v)),
      TextFormField(
        initialValue: [for (final t in _list(_data['type_tags'])) '$t']
            .join(', '),
        decoration: InputDecoration(labelText: l10n.monsterTypeTags),
        onChanged: (v) => _set('type_tags', [
          for (final t in v.split(','))
            if (t.trim().isNotEmpty) t.trim(),
        ]),
      ),
      _string('${l10n.monsterAlignment} *', 'alignment'),

      // Classe d'armure.
      Text(l10n.monsterAcTitle, style: text.titleMedium),
      _choice<String?>(l10n.monsterArmor, _acArmor, [
        (null, l10n.monsterNaturalAc),
        for (final e in _ofType(content, 'armor'))
          if (e.data case ArmorData(:final category)
              when category != ArmorCategory.shield)
            ('${e.id}', e.name),
      ], (v) => _update(() => _acArmor = v)),
      if (worn != null) ...[
        SwitchListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(_shieldOf(content)?.name ?? ''),
          value: _acShield,
          onChanged: (v) => _update(() => _acShield = v),
        ),
        Text(l10n.monsterAcWorn(worn.$1, worn.$2), style: text.bodyMedium),
      ] else
        pair(
          _number('${l10n.statAc} *', _data['ac'], (v) => _set('ac', v)),
          _string(l10n.monsterAcLabel, 'ac_note'),
        ),

      // Points de vie et déplacement.
      _number(
        l10n.statInitiative,
        _data['initiative'],
        (v) => _set('initiative', v),
      ),
      Text(l10n.monsterInitiativeHint(_mod('dex')), style: text.bodySmall),
      _string('${l10n.monsterHitDice} *', 'hit_dice'),
      Text(switch (averageOfDice('${_data['hit_dice'] ?? ''}')) {
        final hp? => l10n.monsterHpAverage(hp),
        null => l10n.monsterHitDiceHint,
      }, style: text.bodySmall),
      Text(l10n.statSpeed, style: text.titleMedium),
      pair(
        _number(
          l10n.monsterSpeedWalk,
          speed['walk'],
          (v) => _setIn('speed', 'walk', v),
        ),
        _number(
          l10n.monsterSpeedFly,
          speed['fly'],
          (v) => _setIn('speed', 'fly', v),
        ),
      ),
      pair(
        _number(
          l10n.monsterSpeedSwim,
          speed['swim'],
          (v) => _setIn('speed', 'swim', v),
        ),
        _number(
          l10n.monsterSpeedClimb,
          speed['climb'],
          (v) => _setIn('speed', 'climb', v),
        ),
      ),
      _number(
        l10n.monsterSpeedBurrow,
        speed['burrow'],
        (v) => _setIn('speed', 'burrow', v),
      ),
      if (speed['fly'] != null) _switch(l10n.monsterHover, 'hover'),

      // Caractéristiques, JS et compétences.
      Text(l10n.monsterAbilities, style: text.titleMedium),
      for (final row in [
        ['str', 'dex'],
        ['con', 'int'],
        ['wis', 'cha'],
      ])
        pair(ability(row[0]), ability(row[1])),
      Text(l10n.monsterIntelligenceHint, style: text.bodySmall),
      _chips(
        l10n.monsterSaves(pb),
        [..._proficientSaves],
        [for (final k in monsterAbilityKeys) (k, _abilityName(content, k))],
        (v) => _update(
          () => _proficientSaves
            ..clear()
            ..addAll(v),
        ),
      ),
      _chips(
        l10n.monsterSkills(pb),
        [..._proficientSkills],
        of('skill'),
        (v) => _update(
          () => _proficientSkills
            ..clear()
            ..addAll(v),
        ),
      ),
      _picks(l10n.statVulnerabilities, 'vulnerabilities', of('damage-type')),
      _picks(l10n.statResistances, 'resistances', of('damage-type')),
      _picks(l10n.statImmunities, 'immunities', of('damage-type')),
      _picks(
        l10n.monsterConditionImmunities,
        'condition_immunities',
        of('condition'),
      ),

      // Sens et langues.
      Text(l10n.statSenses, style: text.titleMedium),
      pair(
        _number(
          l10n.monsterDarkvision,
          senses['darkvision'],
          (v) => _setIn('senses', 'darkvision', v),
        ),
        _number(
          l10n.monsterBlindsight,
          senses['blindsight'],
          (v) => _setIn('senses', 'blindsight', v),
        ),
      ),
      pair(
        _number(
          l10n.monsterTremorsense,
          senses['tremorsense'],
          (v) => _setIn('senses', 'tremorsense', v),
        ),
        _number(
          l10n.monsterTruesight,
          senses['truesight'],
          (v) => _setIn('senses', 'truesight', v),
        ),
      ),
      _string('${l10n.statLanguages} *', 'languages'),

      // FP.
      _choice('${l10n.monsterCr} *', _data['cr'] as String?, [
        for (final cr in xpByChallenge.keys) (cr, cr),
      ], (v) => _set('cr', v)),
      Text(
        l10n.monsterCrHint((xpByChallenge[_cr] ?? const [0]).last, pb),
        style: text.bodySmall,
      ),

      // Traits et actions.
      Text(l10n.monsterActionsTitle, style: text.titleMedium),
      for (final (i, a) in actions.indexed)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text('${a['name']}'),
          subtitle: Text(_actionKindLabel(l10n, '${a['kind']}')),
          onTap: () => _editAction(content, i),
          trailing: IconButton(
            tooltip: l10n.monsterActionRemove,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _set('actions', [...actions]..removeAt(i)),
          ),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _editAction(content, null),
          icon: const Icon(Icons.add),
          label: Text(l10n.monsterActionAdd),
        ),
      ),
      if (actions.any((a) => a['kind'] == 'legendary'))
        _number(
          l10n.monsterLegendaryUses,
          _data['legendary_uses'],
          (v) => _set('legendary_uses', v),
        ),

      // Étude.
      Text(l10n.monsterStudyTitle, style: text.titleMedium),
      Text(l10n.monsterStudyHint, style: text.bodySmall),
      for (final (i, r) in reveals.indexed)
        ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(l10n.monsterStudyDc(r['dc']! as int)),
          subtitle: Text('${r['text']}'),
          trailing: IconButton(
            tooltip: l10n.monsterStudyRemove,
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _set('study_reveals', [...reveals]..removeAt(i)),
          ),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => _addReveal(l10n, reveals),
          icon: const Icon(Icons.add),
          label: Text(l10n.monsterStudyAdd),
        ),
      ),
    ];
  }

  Future<void> _editAction(ActiveContent content, int? index) async {
    final actions = [
      for (final a in _list(_data['actions']))
        Map<String, Object?>.from(a! as Map),
    ];
    final edited = await Navigator.of(context).push(
      MaterialPageRoute<Map<String, Object?>>(
        fullscreenDialog: true,
        builder: (_) => _MonsterActionPage(
          content: content,
          action: index == null ? null : actions[index],
        ),
      ),
    );
    if (edited == null) return;
    _set('actions', [
      for (final (i, a) in actions.indexed) i == index ? edited : a,
      if (index == null) edited,
    ]);
  }

  /// Un palier : son DD et ce qu'il révèle ; les paliers restent triés.
  Future<void> _addReveal(
    AppLocalizations l10n,
    List<Map<String, Object?>> reveals,
  ) async {
    final values = await showDialog<List<String>>(
      context: context,
      builder: (_) => _FieldsDialog(
        title: l10n.monsterStudyAdd,
        fields: [
          (l10n.monsterStudyDcField, true),
          (l10n.monsterStudyText, false),
        ],
      ),
    );
    if (values == null) return;
    final value = int.tryParse(values[0]);
    final revealed = values[1].trim();
    if (value == null || revealed.isEmpty) return;
    _set(
      'study_reveals',
      [
        ...reveals,
        {'dc': value, 'text': revealed},
      ]..sort((a, b) => (a['dc']! as int) - (b['dc']! as int)),
    );
  }
}

String _actionKindLabel(AppLocalizations l10n, String kind) => switch (kind) {
  'trait' => l10n.statTraits,
  'bonus' => l10n.statBonusActions,
  'reaction' => l10n.statReactions,
  'legendary' => l10n.statLegendaryActions,
  _ => l10n.statActions,
};

/// Un trait ou une action du profil : section, nom, texte, usages, jet
/// d'attaque et jet de sauvegarde. Les dégâts moyens se calculent.
class _MonsterActionPage extends StatefulWidget {
  const _MonsterActionPage({required this.content, this.action});

  final ActiveContent content;
  final Map<String, Object?>? action;

  @override
  State<_MonsterActionPage> createState() => _MonsterActionPageState();
}

class _MonsterActionPageState extends State<_MonsterActionPage> {
  late final Map<String, Object?> _a = {'kind': 'action', ...?widget.action};
  late final _name = TextEditingController(text: '${_a['name'] ?? ''}');
  late final _text = TextEditingController(text: '${_a['text'] ?? ''}');

  Map<String, Object?>? get _attack => _a['attack'] as Map<String, Object?>?;
  Map<String, Object?>? get _save => _a['save'] as Map<String, Object?>?;
  Map<String, Object?> get _damage => {
    ...?(_list(_attack?['damage']).firstOrNull as Map<String, Object?>?),
  };

  List<Object?> _list(Object? value) => value is List ? value : const [];

  @override
  void dispose() {
    _name.dispose();
    _text.dispose();
    super.dispose();
  }

  void _setAttack(String key, Object? value) => setState(() {
    final attack = {...?_attack};
    if (value == null) {
      attack.remove(key);
    } else {
      attack[key] = value;
    }
    _a['attack'] = attack;
  });

  void _setDamage(String key, Object? value) {
    final damage = {..._damage};
    if (value == null) {
      damage.remove(key);
    } else {
      damage[key] = value;
    }
    final average = averageOfDice('${damage['dice'] ?? ''}');
    _setAttack('damage', [
      if (damage['dice'] != null || damage['type'] != null)
        {...damage, 'average': ?average},
    ]);
  }

  Widget _number(String label, Object? value, ValueChanged<int?> onChanged) =>
      TextFormField(
        initialValue: '${value ?? ''}',
        keyboardType: TextInputType.number,
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp('[0-9-]'))],
        decoration: InputDecoration(labelText: label),
        onChanged: (v) => onChanged(int.tryParse(v)),
      );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = widget.content;
    final attack = _attack;
    final save = _save;
    final uses = (_a['uses'] as Map<String, Object?>?) ?? const {};
    final usesKind = uses['per_day'] != null
        ? 'per_day'
        : uses['recharge'] != null
        ? 'recharge'
        : null;
    final range = _list(attack?['range']);
    final gap = SizedBox(height: AppSpacing.sm);
    return Scaffold(
      appBar: AppBar(
        leading: const CloseButton(),
        title: Text(l10n.monsterActionTitle),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, {
              ..._a,
              'name': _name.text.trim(),
              'text': _text.text.trim(),
            }),
            child: Text(l10n.monsterActionSave),
          ),
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(AppSpacing.md),
        children: [
          DropdownButtonFormField<String>(
            initialValue: '${_a['kind']}',
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.monsterActionKind),
            items: [
              for (final k in [
                'trait',
                'action',
                'bonus',
                'reaction',
                'legendary',
              ])
                DropdownMenuItem(
                  value: k,
                  child: Text(_actionKindLabel(l10n, k)),
                ),
            ],
            onChanged: (v) => setState(() => _a['kind'] = v),
          ),
          gap,
          TextField(
            controller: _name,
            decoration: InputDecoration(labelText: l10n.homebrewFieldName),
          ),
          gap,
          TextField(
            controller: _text,
            minLines: 3,
            maxLines: null,
            decoration: InputDecoration(labelText: l10n.homebrewFieldText),
          ),
          gap,
          DropdownButtonFormField<String?>(
            initialValue: usesKind,
            isExpanded: true,
            decoration: InputDecoration(labelText: l10n.monsterUses),
            items: [
              DropdownMenuItem(child: Text(l10n.monsterUsesNone)),
              DropdownMenuItem(
                value: 'per_day',
                child: Text(l10n.monsterUsesPerDay),
              ),
              DropdownMenuItem(
                value: 'recharge',
                child: Text(l10n.monsterUsesRecharge),
              ),
            ],
            onChanged: (v) => setState(() {
              if (v == null) {
                _a.remove('uses');
              } else {
                _a['uses'] = {v: v == 'per_day' ? 1 : '6'};
              }
            }),
          ),
          if (usesKind == 'per_day')
            _number(
              l10n.monsterUsesPerDayCount,
              uses['per_day'],
              (v) => setState(() => _a['uses'] = {'per_day': ?v}),
            ),
          if (usesKind == 'recharge')
            TextFormField(
              initialValue: '${uses['recharge'] ?? ''}',
              decoration: InputDecoration(
                labelText: l10n.monsterUsesRechargeRange,
              ),
              onChanged: (v) =>
                  setState(() => _a['uses'] = {'recharge': v.trim()}),
            ),
          gap,

          // Jet d'attaque.
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.monsterAttack),
            value: attack != null,
            onChanged: (on) => setState(() {
              if (on) {
                _a['attack'] = {'kind': 'melee', 'bonus': 0, 'reach': 5};
              } else {
                _a.remove('attack');
              }
            }),
          ),
          if (attack != null) ...[
            DropdownButtonFormField<String>(
              initialValue: '${attack['kind']}',
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.monsterAttackKind),
              items: [
                DropdownMenuItem(
                  value: 'melee',
                  child: Text(l10n.weaponKindMelee),
                ),
                DropdownMenuItem(
                  value: 'ranged',
                  child: Text(l10n.weaponKindRanged),
                ),
              ],
              onChanged: (v) => setState(() {
                _a['attack'] = {
                  'kind': v,
                  'bonus': attack['bonus'],
                  if (v == 'melee') 'reach': 5 else 'range': [80, 320],
                  'damage': ?attack['damage'],
                };
              }),
            ),
            _number(
              l10n.monsterAttackBonus,
              attack['bonus'],
              (v) => _setAttack('bonus', v ?? 0),
            ),
            if (attack['kind'] == 'melee')
              _number(
                l10n.monsterAttackReach,
                attack['reach'],
                (v) => _setAttack('reach', v),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: _number(
                      l10n.weaponRangeNormal,
                      range.elementAtOrNull(0),
                      (v) =>
                          _setAttack('range', [?v, ?range.elementAtOrNull(1)]),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: _number(
                      l10n.weaponRangeLong,
                      range.elementAtOrNull(1),
                      (v) =>
                          _setAttack('range', [?range.elementAtOrNull(0), ?v]),
                    ),
                  ),
                ],
              ),
            TextFormField(
              initialValue: '${_damage['dice'] ?? ''}',
              decoration: InputDecoration(labelText: l10n.monsterDamageDice),
              onChanged: (v) =>
                  _setDamage('dice', v.trim().isEmpty ? null : v.trim()),
            ),
            DropdownButtonFormField<String>(
              initialValue: _damage['type'] as String?,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.weaponDamageType),
              items: [
                for (final e in content.entities)
                  if (e.type == 'damage-type')
                    DropdownMenuItem(value: '${e.id}', child: Text(e.name)),
              ],
              onChanged: (v) => _setDamage('type', v),
            ),
            if (_damage['average'] case final int average)
              Text(
                l10n.monsterDamageAverage(average),
                style: Theme.of(context).textTheme.bodySmall,
              ),
          ],

          // Jet de sauvegarde.
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.monsterSaveTitle),
            value: save != null,
            onChanged: (on) => setState(() {
              if (on) {
                _a['save'] = {'ability': 'dex', 'dc': 10};
              } else {
                _a.remove('save');
              }
            }),
          ),
          if (save != null)
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: '${save['ability']}',
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.monsterSaveAbility,
                    ),
                    items: [
                      for (final e in content.entities)
                        if (e.type == 'ability')
                          DropdownMenuItem(
                            value: _abilityKey(e.id),
                            child: Text(e.name),
                          ),
                    ],
                    onChanged: (v) =>
                        setState(() => _a['save'] = {...save, 'ability': v}),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: _number(
                    l10n.monsterSaveDc,
                    save['dc'],
                    (v) =>
                        setState(() => _a['save'] = {...save, 'dc': v ?? 10}),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
