// Éditeur d'effets (US-27, EF-HB-01, [H03]) : liste fermée des opérations
// du DSL v1, chacune par un formulaire guidé ; pas de formule libre, pas de
// code. Lot a : les opérations à champs simples ; lot b2 : les autres, dont
// le choix (options imbriquées), la ressource, le sort accordé et les
// valeurs calculées (référence, table par niveau).
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:material_ui/material_ui.dart';

import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';

/// Effet en JSON : `{op, …champs, when?}`.
typedef EffectJson = Map<String, Object?>;

/// Les 22 opérations du DSL v1, dans l'ordre de l'éditeur.
const editableOps = [
  'ability_bonus',
  'grant_proficiency',
  'grant_expertise',
  'grant_feat',
  'modify_ac',
  'ac_formula',
  'modify_speed',
  'modify_hp_max',
  'grant_sense',
  'grant_defense',
  'modify_initiative',
  'grant_advantage',
  'modify_check',
  'set_attacks_per_action',
  'set_crit_range',
  'grant_mastery_slots',
  'modify_damage',
  'grant_resource',
  'grant_spell',
  'grant_spell_list_access',
  'consumable_heal',
  'modify_attunement_slots',
  'choice',
];

const _abilitySlugs = {
  'str': 'strength',
  'dex': 'dexterity',
  'con': 'constitution',
  'int': 'intelligence',
  'wis': 'wisdom',
  'cha': 'charisma',
};

String _ability(ActiveContent content, String code) =>
    namesOf(content, ['srd:ability:${_abilitySlugs[code] ?? code}']);

String opLabel(AppLocalizations l10n, String op) => switch (op) {
  'ability_bonus' => l10n.opAbilityBonus,
  'grant_proficiency' => l10n.opGrantProficiency,
  'grant_expertise' => l10n.opGrantExpertise,
  'grant_feat' => l10n.opGrantFeat,
  'modify_ac' => l10n.opModifyAc,
  'ac_formula' => l10n.opAcFormula,
  'modify_speed' => l10n.opModifySpeed,
  'modify_hp_max' => l10n.opModifyHpMax,
  'grant_sense' => l10n.opGrantSense,
  'grant_defense' => l10n.opGrantDefense,
  'modify_initiative' => l10n.opModifyInitiative,
  'grant_advantage' => l10n.opGrantAdvantage,
  'modify_check' => l10n.opModifyCheck,
  'set_attacks_per_action' => l10n.opSetAttacks,
  'set_crit_range' => l10n.opSetCritRange,
  'grant_mastery_slots' => l10n.opGrantMasterySlots,
  'modify_damage' => l10n.opModifyDamage,
  'grant_resource' => l10n.opGrantResource,
  'grant_spell' => l10n.opGrantSpell,
  'grant_spell_list_access' => l10n.opGrantSpellListAccess,
  'consumable_heal' => l10n.opConsumableHeal,
  'modify_attunement_slots' => l10n.opModifyAttunement,
  'choice' => l10n.opChoice,
  _ => op,
};

String _speedMode(AppLocalizations l10n, Object? mode) => switch (mode) {
  'climb' => l10n.speedClimb,
  'swim' => l10n.speedSwim,
  'fly' => l10n.speedFly,
  _ => l10n.speedWalk,
};

String _sense(AppLocalizations l10n, Object? sense, int range) =>
    switch (sense) {
      'blindsight' => l10n.statBlindsight(formatFeet(range)),
      'tremorsense' => l10n.statTremorsense(formatFeet(range)),
      'truesight' => l10n.statTruesight(formatFeet(range)),
      _ => l10n.statDarkvision(formatFeet(range)),
    };

String _featCategory(AppLocalizations l10n, Object? category) =>
    switch (category) {
      'origin' => l10n.featOrigin,
      'general' => l10n.featGeneral,
      'fighting_style' => l10n.featFightingStyle,
      _ => l10n.featEpicBoon,
    };

String _spellLevel(AppLocalizations l10n, int level) =>
    level == 0 ? l10n.spellCantrip : l10n.spellLevelName(level);

String _proficiencyTarget(
  AppLocalizations l10n,
  ActiveContent content,
  Object? kind,
  Object? ref,
) => switch ((kind, ref)) {
  ('weapon_category', 'simple') => l10n.weaponSimple,
  ('weapon_category', _) => l10n.weaponMartial,
  ('armor', 'light') => l10n.armorLight,
  ('armor', 'medium') => l10n.armorMedium,
  ('armor', 'heavy') => l10n.armorHeavy,
  ('armor', _) => l10n.armorShield,
  ('saving_throw', 'all') => l10n.effectAllSaves,
  ('saving_throw', final String a) => l10n.effectSavingThrow(
    _ability(content, a),
  ),
  (_, final String id) => namesOf(content, [id]),
  _ => '',
};

String _advantageTarget(
  AppLocalizations l10n,
  ActiveContent content,
  Object? on,
) => switch (on) {
  'initiative' => l10n.effectInitiative,
  'death_saves' => l10n.combatDeathSaves,
  final String s when s.startsWith('saving_throw:') => l10n.effectSavingThrow(
    _ability(content, s.substring(13)),
  ),
  final String s when s.startsWith('skill:') => namesOf(content, [
    'srd:skill:${s.substring(6)}',
  ]),
  _ => '',
};

/// Jets que vise `modify_check`.
List<(String, String)> _checkScopes(
  AppLocalizations l10n,
  ActiveContent content,
) => [
  ('unproficient_ability_checks', l10n.scopeUnproficientChecks),
  ('saving_throws', l10n.scopeSavingThrows),
  for (final code in _abilitySlugs.keys)
    ('saving_throw:$code', l10n.scopeSavingThrow(_ability(content, code))),
  ('melee_weapon_attack', l10n.scopeMeleeAttack),
  ('ranged_weapon_attack', l10n.scopeRangedAttack),
  ('spell_attack', l10n.scopeSpellAttack),
  for (final s in _sorted(content, 'skill'))
    ('skill:${s.id.slug}', l10n.scopeSkill(s.name)),
];

List<(String, String)> _damageScopes(AppLocalizations l10n) => [
  ('melee_weapon', l10n.scopeMeleeWeapon),
  ('ranged_weapon', l10n.scopeRangedWeapon),
  ('unarmed', l10n.scopeUnarmed),
];

List<(String, String)> _rechargeOns(AppLocalizations l10n) => [
  ('short_rest', l10n.onShortRest),
  ('long_rest', l10n.onLongRest),
  ('initiative', l10n.onInitiative),
  ('dawn', l10n.onDawn),
];

List<ContentEntity> _sorted(ActiveContent content, String type) => [
  for (final e in content.entities)
    if (e.id.type == type) e,
]..sort((a, b) => foldAccents(a.name).compareTo(foldAccents(b.name)));

/// Valeur du DSL en français : nombre, référence ou table par niveau.
String describeValue(
  AppLocalizations l10n,
  ActiveContent content,
  Object? value,
) {
  if (value is! Map<String, Object?>) return '${value ?? 0}';
  if (value['by_level'] case final Map<String, Object?> table) {
    return l10n.valueByLevelText(
      [
        for (final MapEntry(:key, value: v) in table.entries)
          l10n.valueAtLevel('$v', int.tryParse(key) ?? 1),
      ].join(', '),
    );
  }
  final base = switch (value['ref']) {
    'proficiency_bonus' => l10n.valueProficiencyText,
    'character_level' => l10n.valueCharacterLevelText,
    'class_level' => l10n.valueClassLevelText(
      namesOf(content, ['${value['class'] ?? ''}']),
    ),
    _ => l10n.valueAbilityModText(_ability(content, '${value['ability']}')),
  };
  final withMin = switch (value['min']) {
    final int min => l10n.valueMinText(base, min),
    _ => base,
  };
  return switch (value['times']) {
    final int times => l10n.valueTimesText(times, withMin),
    _ => withMin,
  };
}

String _recharges(AppLocalizations l10n, Object? recharges) => [
  for (final r in (recharges as List?) ?? const [])
    if (r case {'on': final String on, 'amount': final amount})
      l10n.rechargeEntry(
        amount == 'all' ? l10n.rechargeAll : '$amount',
        l10n.rechargeAt(on),
      ),
].join(', ');

/// Phrase que le joueur lira pour [effect] ([H03]).
String describeEffect(
  AppLocalizations l10n,
  ActiveContent content,
  EffectJson effect,
) {
  String value(String key) => describeValue(l10n, content, effect[key]);
  final when = effect['when'] as Map<String, Object?>?;
  final conditions = [
    switch (when) {
      {'armor': 'none'} => l10n.effectWhenNoArmor,
      {'armor': _} => l10n.effectWhenArmor,
      {'shield': true} => l10n.effectWhenShield,
      _ => null,
    },
    if (when?['level'] case final int level) l10n.effectWhenLevel(level),
  ].nonNulls;
  final text = switch (effect['op']) {
    'ability_bonus' => l10n.effectAbilityBonus(
      value('value'),
      _ability(content, '${effect['ability']}'),
      (effect['max'] as int?) ?? 20,
    ),
    'grant_proficiency' => l10n.effectProficiency(
      _proficiencyTarget(l10n, content, effect['kind'], effect['ref']),
    ),
    'grant_expertise' => l10n.effectExpertise(
      namesOf(content, ['${effect['ref']}']),
    ),
    'grant_feat' when effect['feat'] != null => l10n.effectFeat(
      namesOf(content, ['${effect['feat']}']),
    ),
    'grant_feat' => l10n.effectFeatCategory(
      _featCategory(l10n, effect['category']),
    ),
    'modify_ac' => l10n.effectAc(value('value')),
    'ac_formula' => l10n.effectAcFormula(
      [
        '${effect['base'] ?? 10}',
        for (final a in (effect['abilities'] as List?) ?? const [])
          _ability(content, '$a'),
      ].join(' + '),
      effect['allows_shield'] == true ? 'yes' : 'no',
    ),
    'modify_speed' when effect['equal_to'] != null => l10n.effectSpeedEqual(
      _speedMode(l10n, effect['mode']),
    ),
    'modify_speed' => l10n.effectSpeed(switch (effect['value']) {
      final int feet => formatFeet(feet),
      final other => describeValue(l10n, content, other),
    }, _speedMode(l10n, effect['mode'])),
    'modify_hp_max' when effect['per_level'] != null => l10n.effectHpPerLevel(
      value('per_level'),
    ),
    'modify_hp_max' => l10n.effectHpFlat(value('flat')),
    'grant_sense' => _sense(
      l10n,
      effect['sense'],
      (effect['range'] as int?) ?? 60,
    ),
    'grant_defense' => l10n.effectDefense(
      effect['kind'] == 'immunity'
          ? l10n.effectImmunity
          : l10n.effectResistance,
      namesOf(content, ['${effect['damage_type'] ?? effect['condition']}']),
    ),
    'modify_initiative' when effect['advantage'] == true =>
      l10n.effectAdvantage(l10n.effectInitiative),
    'modify_initiative' => l10n.effectInitiativeBonus(value('add')),
    'grant_advantage' => l10n.effectAdvantage(
      _advantageTarget(l10n, content, effect['on']),
    ),
    'modify_check' => l10n.effectCheck(
      value('add'),
      _checkScopes(
            l10n,
            content,
          ).where((s) => s.$1 == effect['scope']).firstOrNull?.$2 ??
          '',
    ),
    'set_attacks_per_action' => l10n.effectAttacks(
      (effect['count'] as int?) ?? 1,
    ),
    'set_crit_range' => l10n.effectCritRange((effect['min'] as int?) ?? 20),
    'grant_mastery_slots' => l10n.effectMasterySlots(
      value('count'),
      effect['melee_only'] == true ? 'yes' : 'no',
    ),
    'modify_damage' => l10n.effectDamage(
      switch (effect['value']) {
        final String dice => dice,
        final other => describeValue(l10n, content, other),
      },
      _damageScopes(l10n)
              .where((s) => s.$1 == effect['scope'])
              .firstOrNull
              ?.$2 ??
          '',
      effect['damage_type'] == null
          ? ''
          : l10n.effectDamageType(
              namesOf(content, ['${effect['damage_type']}']),
            ),
    ),
    'grant_resource' => l10n.effectResource(
      value('max'),
      _recharges(l10n, effect['recharge']),
    ),
    'grant_spell' => [
      l10n.effectSpell(namesOf(content, ['${effect['spell']}'])),
      if (effect['always_prepared'] == true) l10n.effectSpellPrepared,
      if (effect['free_casts'] case final Map<String, Object?> free)
        l10n.effectSpellFreeCasts(
          describeValue(l10n, content, free['count']),
          _recharges(l10n, free['recharge']),
        ),
    ].join(' · '),
    'grant_spell_list_access' => l10n.effectSpellListAccess(
      (effect['count'] as int?) ?? 1,
      namesOf(content, [
        for (final c in (effect['class_lists'] as List?) ?? const []) '$c',
      ]),
      _spellLevel(l10n, (effect['max_level'] as int?) ?? 0),
    ),
    'consumable_heal' => l10n.effectHeal(
      '${effect['dice'] ?? ''}',
      effect['bonus'] == null ? '' : l10n.effectHealBonus(value('bonus')),
      effect['action'] == 'bonus_action'
          ? l10n.healBonusAction
          : l10n.healAction,
    ),
    'modify_attunement_slots' => l10n.effectAttunementSlots(
      (effect['value'] as int?) ?? 3,
    ),
    'choice' => l10n.effectChoice(
      (effect['title'] as String?) ?? l10n.opChoice,
      (effect['count'] as int?) ?? 1,
      [for (final label in (effect['labels'] as List?) ?? const []) '$label']
          .join(' / '),
    ),
    final op => '$op',
  };
  return [text, ...conditions].join(' ');
}

/// Effet neuf de [op] : les champs dont l'éditeur a besoin pour démarrer.
/// [taken] : les effets voisins, pour des identifiants uniques.
EffectJson _initial(
  AppLocalizations l10n,
  String op,
  List<EffectJson> taken,
  String resourceId,
) {
  String unique(String base) {
    final used = {for (final e in taken) e['id']};
    var id = base;
    for (var n = 2; used.contains(id); n++) {
      id = '$base-$n';
    }
    return id;
  }

  return {
    'op': op,
    ...switch (op) {
      'grant_resource' => {
        'id': unique(resourceId),
        'max': 1,
        'recharge': [
          {'on': 'long_rest', 'amount': 'all'},
        ],
      },
      'choice' => {
        'id': unique('choix-${taken.where((e) => e['op'] == op).length + 1}'),
        'count': 1,
        'options': [<Object?>[], <Object?>[]],
        'labels': [
          l10n.effectChoiceOptionDefault(1),
          l10n.effectChoiceOptionDefault(2),
        ],
      },
      'ac_formula' => {
        'base': 10,
        'abilities': <Object?>['dex'],
        'allows_shield': true,
      },
      'set_attacks_per_action' => {'count': 2},
      'set_crit_range' => {'min': 19},
      'grant_mastery_slots' => {'count': 1},
      'grant_spell_list_access' => {
        'class_lists': <Object?>[],
        'count': 1,
        'max_level': 0,
      },
      'consumable_heal' => {'action': 'action'},
      'modify_attunement_slots' => {'value': 4},
      _ => const <String, Object?>{},
    },
  };
}

/// Une référence incomplète (niveau sans classe, modificateur sans
/// caractéristique) passe `validateEffect`, mais le moteur ne saurait pas
/// la calculer.
bool _incomplete(Object? json) => switch (json) {
  {'ref': 'class_level'} when (json as Map)['class'] == null => true,
  {'ref': 'ability_mod'} when (json as Map)['ability'] == null => true,
  final Map<String, Object?> map => map.values.any(_incomplete),
  final List<Object?> list => list.any(_incomplete),
  _ => false,
};

/// Effets d'une entité : chacun en une phrase, modifiable ou retiré, et
/// « Ajouter un effet ». [resourceId] : identifiant d'une ressource neuve.
class EffectList extends StatelessWidget {
  const EffectList({
    super.key,
    required this.content,
    required this.effects,
    required this.onChanged,
    required this.resourceId,
    this.title,
  });

  final ActiveContent content;
  final List<EffectJson> effects;
  final ValueChanged<List<EffectJson>> onChanged;
  final String resourceId;
  final String? title;

  Future<void> _edit(BuildContext context, int? index) async {
    final l10n = AppLocalizations.of(context);
    var op = index == null ? null : effects[index]['op'] as String?;
    if (op == null) {
      op = await showModalBottomSheet<String>(
        context: context,
        isScrollControlled: true,
        builder: (sheet) => SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(sheet).height * 0.8,
            ),
            child: ListView(
              shrinkWrap: true,
              children: [
                ListTile(title: Text(l10n.effectAddTitle)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
                  child: Text(
                    l10n.effectClosedList,
                    style: Theme.of(sheet).textTheme.bodySmall,
                  ),
                ),
                for (final op in editableOps)
                  ListTile(
                    title: Text(opLabel(l10n, op)),
                    onTap: () => Navigator.pop(sheet, op),
                  ),
              ],
            ),
          ),
        ),
      );
      if (op == null || !context.mounted) return;
    }
    final edited = await showModalBottomSheet<EffectJson>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EffectForm(
        content: content,
        resourceId: resourceId,
        initial: index == null
            ? _initial(l10n, op!, effects, resourceId)
            : {...effects[index]},
      ),
    );
    if (edited == null) return;
    onChanged([
      for (final (i, e) in effects.indexed) i == index ? edited : e,
      if (index == null) edited,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title ?? l10n.effectsTitle, style: text.titleMedium),
        for (final (i, effect) in effects.indexed)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(describeEffect(l10n, content, effect)),
            subtitle: Text(opLabel(l10n, '${effect['op']}')),
            onTap: () => _edit(context, i),
            trailing: IconButton(
              tooltip: l10n.effectRemove,
              icon: const Icon(Icons.delete_outline),
              onPressed: () => onChanged([...effects]..removeAt(i)),
            ),
          ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => _edit(context, null),
            icon: const Icon(Icons.add),
            label: Text(l10n.effectAdd),
          ),
        ),
      ],
    );
  }
}

/// Formulaire d'une opération ; « Enregistrer » rend l'effet, qui passe
/// `validateEffect`.
class _EffectForm extends StatefulWidget {
  const _EffectForm({
    required this.content,
    required this.initial,
    required this.resourceId,
  });

  final ActiveContent content;
  final EffectJson initial;
  final String resourceId;

  @override
  State<_EffectForm> createState() => _EffectFormState();
}

class _EffectFormState extends State<_EffectForm> {
  late final EffectJson _e = {...widget.initial};

  ActiveContent get _content => widget.content;
  String get _op => _e['op']! as String;

  void _set(String key, Object? value) => setState(() {
    if (value == null) {
      _e.remove(key);
    } else {
      _e[key] = value;
    }
  });

  /// Une clé de `when`, les autres gardées.
  void _setWhen(Map<String, Object?> Function(Map<String, Object?>) update) {
    final next = update({
      for (final MapEntry(:key, :value)
          in ((_e['when'] as Map<String, Object?>?) ?? const {}).entries)
        key: value,
    });
    _set('when', next.isEmpty ? null : next);
  }

  Widget _choice<T>(
    String label,
    T? value,
    List<(T, String)> options,
    ValueChanged<T?> onChanged, {
    String? none,
  }) => DropdownButtonFormField<T>(
    initialValue: options.any((o) => o.$1 == value) ? value : null,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      if (none != null) DropdownMenuItem(child: Text(none)),
      for (final (v, l) in options) DropdownMenuItem(value: v, child: Text(l)),
    ],
    onChanged: onChanged,
  );

  Widget _number(String label, String key, {bool signed = true}) =>
      _intField(label, _e[key], (v) => _set(key, v), signed: signed);

  Widget _intField(
    String label,
    Object? value,
    ValueChanged<int?> onChanged, {
    bool signed = false,
  }) => TextFormField(
    initialValue: value is int ? '$value' : '',
    keyboardType: TextInputType.numberWithOptions(signed: signed),
    inputFormatters: [
      FilteringTextInputFormatter.allow(RegExp(signed ? r'[-0-9]' : '[0-9]')),
    ],
    decoration: InputDecoration(labelText: label),
    onChanged: (v) => onChanged(int.tryParse(v)),
  );

  Widget _value(String label, String key) => _ValueField(
    key: ValueKey('value-$key'),
    label: label,
    content: _content,
    value: _e[key],
    onChanged: (v) => _set(key, v),
  );

  Widget _switch(String label, String key) => SwitchListTile(
    contentPadding: EdgeInsets.zero,
    title: Text(label),
    value: _e[key] == true,
    onChanged: (v) => _set(key, v ? true : null),
  );

  List<(String, String)> _abilities() => [
    for (final code in _abilitySlugs.keys) (code, _ability(_content, code)),
  ];

  List<(String, String)> _entities(String type) => [
    for (final e in _sorted(_content, type)) ('${e.id}', e.name),
  ];

  List<(String, String)> _replaceableOn(AppLocalizations l10n) => [
    ('level_up', l10n.replaceableLevelUp),
    ('long_rest', l10n.replaceableLongRest),
    ('short_rest', l10n.replaceableShortRest),
  ];

  /// Recharges `{on, amount}` : « Quantité » vide = toutes.
  List<Widget> _rechargeRows(
    AppLocalizations l10n,
    List<Object?> recharges,
    ValueChanged<List<Object?>> onChanged,
  ) => [
    for (final (i, r) in recharges.indexed)
      Row(
        key: ValueKey('recharge-$i-${recharges.length}'),
        children: [
          Expanded(
            child: _choice(
              l10n.rechargeOn,
              (r as Map?)?['on'] as String?,
              _rechargeOns(l10n),
              (v) => onChanged([
                for (final (j, x) in recharges.indexed)
                  j == i ? {...(x! as Map<String, Object?>), 'on': v} : x,
              ]),
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: _intField(
              l10n.rechargeAmount,
              r?['amount'],
              (v) => onChanged([
                for (final (j, x) in recharges.indexed)
                  j == i
                      ? {...(x! as Map<String, Object?>), 'amount': v ?? 'all'}
                      : x,
              ]),
            ),
          ),
          IconButton(
            tooltip: l10n.rechargeRemove,
            icon: const Icon(Icons.close),
            onPressed: () => onChanged([...recharges]..removeAt(i)),
          ),
        ],
      ),
    Align(
      alignment: Alignment.centerLeft,
      child: TextButton.icon(
        onPressed: () => onChanged([
          ...recharges,
          {'on': 'long_rest', 'amount': 'all'},
        ]),
        icon: const Icon(Icons.add),
        label: Text(l10n.rechargeAdd),
      ),
    ),
  ];

  List<Widget> _choiceFields(AppLocalizations l10n) {
    final options = [
      for (final o in (_e['options'] as List?) ?? const [])
        [for (final e in o as List) Map<String, Object?>.from(e as Map)],
    ];
    final labels = [for (final l in (_e['labels'] as List?) ?? const []) '$l'];
    void setOptions(List<List<EffectJson>> next, List<String> nextLabels) =>
        setState(() {
          _e['options'] = next;
          _e['labels'] = nextLabels;
        });
    return [
      TextFormField(
        initialValue: '${_e['title'] ?? ''}',
        decoration: InputDecoration(labelText: l10n.effectChoiceTitle),
        onChanged: (v) => _set('title', v.trim().isEmpty ? null : v.trim()),
      ),
      _number(l10n.effectChoiceCount, 'count', signed: false),
      _choice(
        l10n.effectChoiceReplaceable,
        _e['replaceable_on'] as String?,
        _replaceableOn(l10n),
        (v) => _set('replaceable_on', v),
        none: l10n.replaceableNever,
      ),
      for (final (i, option) in options.indexed)
        Card(
          key: ValueKey('option-$i-${options.length}'),
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.sm),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        initialValue: labels.elementAtOrNull(i) ?? '',
                        decoration: InputDecoration(
                          labelText: l10n.effectChoiceOptionName(i + 1),
                        ),
                        onChanged: (v) => setOptions(options, [
                          for (var j = 0; j < options.length; j++)
                            j == i ? v.trim() : labels.elementAtOrNull(j) ?? '',
                        ]),
                      ),
                    ),
                    IconButton(
                      tooltip: l10n.effectChoiceOptionRemove,
                      icon: const Icon(Icons.delete_outline),
                      onPressed: options.length <= 1
                          ? null
                          : () => setOptions(
                              [...options]..removeAt(i),
                              [...labels]..removeAt(i),
                            ),
                    ),
                  ],
                ),
                EffectList(
                  content: _content,
                  resourceId: widget.resourceId,
                  title: l10n.effectChoiceOptionEffects(i + 1),
                  effects: option,
                  onChanged: (effects) => setOptions([
                    for (final (j, o) in options.indexed) j == i ? effects : o,
                  ], labels),
                ),
              ],
            ),
          ),
        ),
      Align(
        alignment: Alignment.centerLeft,
        child: TextButton.icon(
          onPressed: () => setOptions(
            [...options, []],
            [...labels, l10n.effectChoiceOptionDefault(options.length + 1)],
          ),
          icon: const Icon(Icons.add),
          label: Text(l10n.effectChoiceOptionAdd),
        ),
      ),
    ];
  }

  List<Widget> _fields(AppLocalizations l10n) => switch (_op) {
    'ability_bonus' => [
      _choice(
        l10n.effectFieldAbility,
        _e['ability'] as String?,
        _abilities(),
        (v) => _set('ability', v),
      ),
      _value(l10n.effectFieldValue, 'value'),
      _number(l10n.effectFieldMax, 'max', signed: false),
    ],
    'grant_proficiency' => [
      _choice(
        l10n.effectFieldKind,
        _e['kind'] as String?,
        [
          ('skill', l10n.proficiencySkill),
          ('tool', l10n.proficiencyTool),
          ('weapon_category', l10n.proficiencyWeaponCategory),
          ('armor', l10n.proficiencyArmor),
          ('saving_throw', l10n.proficiencySave),
          ('language', l10n.proficiencyLanguage),
        ],
        (v) => setState(() {
          _e['kind'] = v;
          _e.remove('ref');
        }),
      ),
      if (_e['kind'] case final String kind)
        _choice(l10n.effectFieldTarget, _e['ref'] as String?, switch (kind) {
          'weapon_category' => [
            ('simple', l10n.weaponSimple),
            ('martial', l10n.weaponMartial),
          ],
          'armor' => [
            ('light', l10n.armorLight),
            ('medium', l10n.armorMedium),
            ('heavy', l10n.armorHeavy),
            ('shield', l10n.armorShield),
          ],
          'saving_throw' => [..._abilities(), ('all', l10n.effectAllSaves)],
          final type => _entities(type),
        }, (v) => _set('ref', v)),
    ],
    'grant_expertise' => [
      _choice(
        l10n.effectFieldTarget,
        _e['ref'] as String?,
        _entities('skill'),
        (v) => _set('ref', v),
      ),
    ],
    'grant_feat' => [
      _choice(
        l10n.effectFieldFeat,
        _e['feat'] as String?,
        _entities('feat'),
        (v) => setState(() {
          _e
            ..remove('category')
            ..['feat'] = v;
        }),
      ),
      _choice(
        l10n.effectFieldFeatCategory,
        _e['category'] as String?,
        [
          for (final c in ['origin', 'general', 'fighting_style', 'epic_boon'])
            (c, _featCategory(l10n, c)),
        ],
        (v) => setState(() {
          _e
            ..remove('feat')
            ..['category'] = v;
        }),
      ),
      _choice(
        l10n.effectChoiceReplaceable,
        _e['replaceable_on'] as String?,
        _replaceableOn(l10n),
        (v) => _set('replaceable_on', v),
        none: l10n.replaceableNever,
      ),
    ],
    'modify_ac' => [
      _value(l10n.effectFieldValue, 'value'),
      _choice(
        l10n.effectFieldWhen,
        switch (_e['when']) {
          {'armor': 'none'} => 'none',
          {'armor': _} => 'armor',
          {'shield': true} => 'shield',
          _ => 'always',
        },
        [
          ('always', l10n.effectWhenAlways),
          ('armor', l10n.effectWhenArmor),
          ('none', l10n.effectWhenNoArmor),
          ('shield', l10n.effectWhenShield),
        ],
        (v) => _setWhen(
          (when) => {
            'level': ?when['level'],
            ...switch (v) {
              'armor' => {'armor': 'any'},
              'none' => {'armor': 'none'},
              'shield' => {'shield': true},
              _ => const <String, Object?>{},
            },
          },
        ),
      ),
    ],
    'ac_formula' => [
      _number(l10n.effectFieldBase, 'base', signed: false),
      Text(l10n.effectFieldAbilities),
      Wrap(
        spacing: AppSpacing.xs,
        children: [
          for (final (code, name) in _abilities())
            FilterChip(
              label: Text(name),
              selected: ((_e['abilities'] as List?) ?? const []).contains(code),
              onSelected: (on) => _set('abilities', [
                for (final a in (_e['abilities'] as List?) ?? const [])
                  if (a != code) a,
                if (on) code,
              ]),
            ),
        ],
      ),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.effectFieldAllowsShield),
        value: _e['allows_shield'] == true,
        onChanged: (v) => _set('allows_shield', v),
      ),
    ],
    'modify_speed' => [
      _choice(l10n.effectFieldMode, _e['mode'] as String?, [
        ('walk', l10n.speedWalk),
        ('climb', l10n.speedClimb),
        ('swim', l10n.speedSwim),
        ('fly', l10n.speedFly),
      ], (v) => _set('mode', v)),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.effectFieldEqualWalk),
        value: _e['equal_to'] == 'walk',
        onChanged: (v) => setState(() {
          _e.remove('value');
          if (v) {
            _e['equal_to'] = 'walk';
          } else {
            _e.remove('equal_to');
          }
        }),
      ),
      if (_e['equal_to'] == null) _number(l10n.effectFieldFeet, 'value'),
    ],
    'modify_hp_max' => [
      _value(l10n.effectFieldPerLevel, 'per_level'),
      _value(l10n.effectFieldFlat, 'flat'),
    ],
    'grant_sense' => [
      _choice(l10n.effectFieldSense, _e['sense'] as String?, [
        ('darkvision', l10n.senseDarkvision),
        ('blindsight', l10n.senseBlindsight),
        ('tremorsense', l10n.senseTremorsense),
        ('truesight', l10n.senseTruesight),
      ], (v) => _set('sense', v)),
      _number(l10n.effectFieldFeet, 'range', signed: false),
    ],
    'grant_defense' => [
      _choice(l10n.effectFieldKind, _e['kind'] as String?, [
        ('resistance', l10n.effectResistance),
        ('immunity', l10n.effectImmunity),
      ], (v) => _set('kind', v)),
      _choice(
        l10n.effectFieldTarget,
        (_e['damage_type'] ?? _e['condition']) as String?,
        [..._entities('damage-type'), ..._entities('condition')],
        (v) => setState(() {
          _e
            ..remove('damage_type')
            ..remove('condition');
          if (v != null) {
            _e[v.contains(':condition:') ? 'condition' : 'damage_type'] = v;
          }
        }),
      ),
    ],
    'modify_initiative' => [
      _value(l10n.effectFieldValue, 'add'),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.effectAdvantage(l10n.effectInitiative)),
        value: _e['advantage'] == true,
        onChanged: (v) => _set('advantage', v ? true : null),
      ),
    ],
    'grant_advantage' => [
      _choice(l10n.effectFieldTarget, _e['on'] as String?, [
        ('initiative', l10n.effectInitiative),
        ('death_saves', l10n.combatDeathSaves),
        for (final code in _abilitySlugs.keys)
          (
            'saving_throw:$code',
            l10n.effectSavingThrow(_ability(_content, code)),
          ),
        for (final s in _sorted(_content, 'skill'))
          ('skill:${s.id.slug}', s.name),
      ], (v) => _set('on', v)),
    ],
    'modify_check' => [
      _choice(
        l10n.effectFieldScope,
        _e['scope'] as String?,
        _checkScopes(l10n, _content),
        (v) => _set('scope', v),
      ),
      _value(l10n.effectFieldValue, 'add'),
    ],
    'set_attacks_per_action' => [
      _number(l10n.effectFieldCount, 'count', signed: false),
    ],
    'set_crit_range' => [
      _number(l10n.effectFieldCritMin, 'min', signed: false),
    ],
    'grant_mastery_slots' => [
      _value(l10n.effectFieldCount, 'count'),
      _switch(l10n.effectFieldMeleeOnly, 'melee_only'),
    ],
    'modify_damage' => [
      TextFormField(
        initialValue: switch (_e['value']) {
          final String dice => dice,
          final int n => '$n',
          _ => '',
        },
        decoration: InputDecoration(labelText: l10n.effectFieldDamage),
        onChanged: (v) => _set(
          'value',
          v.trim().isEmpty ? null : int.tryParse(v.trim()) ?? v.trim(),
        ),
      ),
      _choice(
        l10n.effectFieldScope,
        _e['scope'] as String?,
        _damageScopes(l10n),
        (v) => _set('scope', v),
      ),
      _choice(
        l10n.effectFieldDamageType,
        _e['damage_type'] as String?,
        _entities('damage-type'),
        (v) => _set('damage_type', v),
        none: l10n.effectFieldNone,
      ),
    ],
    'grant_resource' => [
      _value(l10n.effectFieldUses, 'max'),
      ..._rechargeRows(l10n, [
        ...?(_e['recharge'] as List?),
      ], (v) => _set('recharge', v)),
      _choice(
        l10n.effectFieldDie,
        _e['die'] as String?,
        [
          for (final d in ['d4', 'd6', 'd8', 'd10', 'd12']) (d, d),
        ],
        (v) => _set('die', v),
        none: l10n.effectFieldNone,
      ),
    ],
    'grant_spell' => [
      _choice(
        l10n.effectFieldSpell,
        _e['spell'] as String?,
        _entities('spell'),
        (v) => _set('spell', v),
      ),
      _switch(l10n.effectFieldAlwaysPrepared, 'always_prepared'),
      SwitchListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(l10n.effectFieldFreeCasts),
        value: _e['free_casts'] != null,
        onChanged: (v) => _set(
          'free_casts',
          v
              ? {
                  'count': 1,
                  'recharge': [
                    {'on': 'long_rest', 'amount': 'all'},
                  ],
                }
              : null,
        ),
      ),
      if (_e['free_casts'] case final Map<String, Object?> free) ...[
        _ValueField(
          key: const ValueKey('value-free-casts'),
          label: l10n.effectFieldCasts,
          content: _content,
          value: free['count'],
          onChanged: (v) => _set('free_casts', {...free, 'count': ?v}),
        ),
        ..._rechargeRows(l10n, [
          ...?(free['recharge'] as List?),
        ], (v) => _set('free_casts', {...free, 'recharge': v})),
      ],
      _choice(
        l10n.effectFieldSpellAbility,
        _e['ability'] as String?,
        _abilities(),
        (v) => _set('ability', v),
        none: l10n.effectFieldNone,
      ),
    ],
    'grant_spell_list_access' => [
      Text(l10n.effectFieldClassLists),
      Wrap(
        spacing: AppSpacing.xs,
        children: [
          for (final c in _sorted(_content, 'class'))
            if (_content.spellList('${c.id}').isNotEmpty)
              FilterChip(
                label: Text(c.name),
                selected: ((_e['class_lists'] as List?) ?? const []).contains(
                  '${c.id}',
                ),
                onSelected: (on) => _set('class_lists', [
                  for (final x in (_e['class_lists'] as List?) ?? const [])
                    if (x != '${c.id}') x,
                  if (on) '${c.id}',
                ]),
              ),
        ],
      ),
      _number(l10n.effectFieldCount, 'count', signed: false),
      _choice(l10n.effectFieldMaxLevel, _e['max_level'] as int?, [
        for (var level = 0; level <= 9; level++)
          (level, _spellLevel(l10n, level)),
      ], (v) => _set('max_level', v)),
    ],
    'consumable_heal' => [
      TextFormField(
        initialValue: '${_e['dice'] ?? ''}',
        decoration: InputDecoration(labelText: l10n.effectFieldDice),
        onChanged: (v) => _set('dice', v.trim().isEmpty ? null : v.trim()),
      ),
      _value(l10n.effectFieldBonus, 'bonus'),
      _choice(l10n.effectFieldAction, _e['action'] as String?, [
        ('action', l10n.healAction),
        ('bonus_action', l10n.healBonusAction),
      ], (v) => _set('action', v)),
    ],
    'modify_attunement_slots' => [
      _number(l10n.effectFieldCount, 'value', signed: false),
    ],
    'choice' => _choiceFields(l10n),
    _ => const [],
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final valid = validateEffect(_e, 'effet').isEmpty && !_incomplete(_e);
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.md,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(opLabel(l10n, _op), style: text.titleLarge),
              for (final field in [
                ..._fields(l10n),
                _intField(
                  l10n.effectFieldFromLevel,
                  (_e['when'] as Map?)?['level'],
                  (v) => _setWhen(
                    (when) => {...when..remove('level'), 'level': ?v},
                  ),
                ),
              ]) ...[SizedBox(height: AppSpacing.sm), field],
              SizedBox(height: AppSpacing.md),
              Text(l10n.effectPreview, style: text.labelMedium),
              Text(
                valid ? describeEffect(l10n, _content, _e) : '—',
                style: text.bodyLarge,
              ),
              SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: valid ? () => Navigator.pop(context, _e) : null,
                  child: Text(l10n.effectSave),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Valeur du DSL (DSL_V1 §5) : un nombre, une référence (bonus de
/// maîtrise, niveau, niveau de classe, modificateur) ou une table par
/// niveau. Le libellé [label] nomme le champ du nombre.
class _ValueField extends StatefulWidget {
  const _ValueField({
    super.key,
    required this.label,
    required this.content,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final ActiveContent content;
  final Object? value;
  final ValueChanged<Object?> onChanged;

  @override
  State<_ValueField> createState() => _ValueFieldState();
}

class _ValueFieldState extends State<_ValueField> {
  late String _kind = switch (widget.value) {
    {'by_level': _} => 'by_level',
    {'ref': final String ref} => ref,
    _ => 'number',
  };

  /// Paliers en cours de saisie, gardés même incomplets.
  late List<(String, String)> _rows = [
    if (widget.value case {'by_level': final Map<String, Object?> table})
      for (final MapEntry(:key, :value) in table.entries) (key, '$value'),
  ];

  Map<String, Object?> get _ref => switch (widget.value) {
    final Map<String, Object?> map when map['ref'] == _kind => map,
    _ => {'ref': _kind},
  };

  void _emitRows(List<(String, String)> rows) {
    setState(() => _rows = rows);
    final table = {
      for (final (level, value) in rows)
        if (int.tryParse(level) != null && int.tryParse(value) != null)
          level: int.parse(value),
    };
    widget.onChanged(table.isEmpty ? null : {'by_level': table});
  }

  void _setRef(String key, Object? value) {
    final next = {..._ref};
    if (value == null) {
      next.remove(key);
    } else {
      next[key] = value;
    }
    widget.onChanged(next);
  }

  Widget _int(String label, Object? value, ValueChanged<int?> onChanged) =>
      TextFormField(
        initialValue: value is int ? '$value' : '',
        keyboardType: const TextInputType.numberWithOptions(signed: true),
        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[-0-9]'))],
        decoration: InputDecoration(labelText: label),
        onChanged: (v) => onChanged(int.tryParse(v)),
      );

  Widget _dropdown(
    String label,
    String? value,
    List<(String, String)> options,
    ValueChanged<String?> onChanged,
  ) => DropdownButtonFormField<String>(
    initialValue: options.any((o) => o.$1 == value) ? value : null,
    isExpanded: true,
    decoration: InputDecoration(labelText: label),
    items: [
      for (final (v, l) in options) DropdownMenuItem(value: v, child: Text(l)),
    ],
    onChanged: onChanged,
  );

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final content = widget.content;
    final ref = _ref;
    final times = _int(
      l10n.valueTimes,
      ref['times'],
      (v) => _setRef('times', v != null && v >= 1 ? v : null),
    );
    return Column(
      key: ValueKey(_kind),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _dropdown(
          l10n.valueKindOf(widget.label),
          _kind,
          [
            ('number', l10n.valueNumber),
            ('proficiency_bonus', l10n.valueProficiency),
            ('character_level', l10n.valueCharacterLevel),
            ('class_level', l10n.valueClassLevel),
            ('ability_mod', l10n.valueAbilityMod),
            ('by_level', l10n.valueByLevel),
          ],
          (kind) {
            if (kind == null) return;
            setState(() {
              _kind = kind;
              _rows = [];
            });
            widget.onChanged(switch (kind) {
              'number' || 'by_level' => null,
              _ => {'ref': kind},
            });
          },
        ),
        ...switch (_kind) {
          'number' => [_int(widget.label, widget.value, widget.onChanged)],
          'proficiency_bonus' || 'character_level' => [times],
          'class_level' => [
            _dropdown(l10n.valueClass, ref['class'] as String?, [
              for (final c in _sorted(content, 'class')) ('${c.id}', c.name),
            ], (v) => _setRef('class', v)),
            times,
          ],
          'ability_mod' => [
            _dropdown(l10n.effectFieldAbility, ref['ability'] as String?, [
              for (final code in _abilitySlugs.keys)
                (code, _ability(content, code)),
            ], (v) => _setRef('ability', v)),
            _int(l10n.valueMin, ref['min'], (v) => _setRef('min', v)),
            times,
          ],
          _ => [
            for (final (i, (level, value)) in _rows.indexed)
              Row(
                key: ValueKey('row-$i-${_rows.length}'),
                children: [
                  Expanded(
                    child: TextFormField(
                      initialValue: level,
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      decoration: InputDecoration(labelText: l10n.valueLevel),
                      onChanged: (v) => _emitRows([
                        for (final (j, row) in _rows.indexed)
                          j == i ? (v, row.$2) : row,
                      ]),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextFormField(
                      initialValue: value,
                      keyboardType: const TextInputType.numberWithOptions(
                        signed: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[-0-9]')),
                      ],
                      decoration: InputDecoration(labelText: widget.label),
                      onChanged: (v) => _emitRows([
                        for (final (j, row) in _rows.indexed)
                          j == i ? (row.$1, v) : row,
                      ]),
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.valueRemoveLevel,
                    icon: const Icon(Icons.close),
                    onPressed: () => _emitRows([..._rows]..removeAt(i)),
                  ),
                ],
              ),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () => setState(() => _rows = [..._rows, ('', '')]),
                icon: const Icon(Icons.add),
                label: Text(l10n.valueAddLevel),
              ),
            ),
          ],
        },
      ],
    );
  }
}
