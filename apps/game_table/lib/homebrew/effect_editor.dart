// Éditeur d'effets (US-27, EF-HB-01, [H03]) : liste fermée des opérations
// du DSL v1, chacune par un formulaire guidé ; pas de formule libre, pas de
// code. Lot a : les opérations à champs simples.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:dnd_ui_kit/dnd_ui_kit.dart';
import 'package:flutter/services.dart' show FilteringTextInputFormatter;
import 'package:material_ui/material_ui.dart';

import '../creation/step_layout.dart';
import '../l10n/app_localizations.dart';

/// Effet en JSON : `{op, …champs, when?}`.
typedef EffectJson = Map<String, Object?>;

/// Opérations proposées par l'éditeur (lot a).
const editableOps = [
  'ability_bonus',
  'grant_proficiency',
  'grant_expertise',
  'modify_ac',
  'modify_speed',
  'modify_hp_max',
  'grant_sense',
  'grant_defense',
  'modify_initiative',
  'grant_advantage',
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
  'modify_ac' => l10n.opModifyAc,
  'modify_speed' => l10n.opModifySpeed,
  'modify_hp_max' => l10n.opModifyHpMax,
  'grant_sense' => l10n.opGrantSense,
  'grant_defense' => l10n.opGrantDefense,
  'modify_initiative' => l10n.opModifyInitiative,
  'grant_advantage' => l10n.opGrantAdvantage,
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

/// Phrase que le joueur lira pour [effect] ([H03]).
String describeEffect(
  AppLocalizations l10n,
  ActiveContent content,
  EffectJson effect,
) {
  final when = switch (effect['when']) {
    {'armor': 'none'} => l10n.effectWhenNoArmor,
    {'armor': _} => l10n.effectWhenArmor,
    {'shield': true} => l10n.effectWhenShield,
    _ => null,
  };
  final text = switch (effect['op']) {
    'ability_bonus' => l10n.effectAbilityBonus(
      '${effect['value'] ?? 0}',
      _ability(content, '${effect['ability']}'),
      (effect['max'] as int?) ?? 20,
    ),
    'grant_proficiency' => l10n.effectProficiency(
      _proficiencyTarget(l10n, content, effect['kind'], effect['ref']),
    ),
    'grant_expertise' => l10n.effectExpertise(
      namesOf(content, ['${effect['ref']}']),
    ),
    'modify_ac' => l10n.effectAc('${effect['value'] ?? 0}'),
    'modify_speed' => l10n.effectSpeed(
      formatFeet((effect['value'] as int?) ?? 0),
      _speedMode(l10n, effect['mode']),
    ),
    'modify_hp_max' when effect['per_level'] != null => l10n.effectHpPerLevel(
      '${effect['per_level']}',
    ),
    'modify_hp_max' => l10n.effectHpFlat('${effect['flat'] ?? 0}'),
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
    'modify_initiative' => l10n.effectInitiativeBonus('${effect['add'] ?? 0}'),
    'grant_advantage' => l10n.effectAdvantage(
      _advantageTarget(l10n, content, effect['on']),
    ),
    final op => '$op',
  };
  return when == null ? text : '$text $when';
}

/// Effets d'une entité : chacun en une phrase, modifiable ou retiré, et
/// « Ajouter un effet ».
class EffectList extends StatelessWidget {
  const EffectList({
    super.key,
    required this.content,
    required this.effects,
    required this.onChanged,
  });

  final ActiveContent content;
  final List<EffectJson> effects;
  final ValueChanged<List<EffectJson>> onChanged;

  Future<void> _edit(BuildContext context, int? index) async {
    final l10n = AppLocalizations.of(context);
    var op = index == null ? null : effects[index]['op'] as String?;
    if (op == null) {
      op = await showModalBottomSheet<String>(
        context: context,
        builder: (sheet) => SafeArea(
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
      );
      if (op == null || !context.mounted) return;
    }
    final edited = await showModalBottomSheet<EffectJson>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EffectForm(
        content: content,
        initial: index == null ? {'op': op} : {...effects[index]},
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
        Text(l10n.effectsTitle, style: text.titleMedium),
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
  const _EffectForm({required this.content, required this.initial});

  final ActiveContent content;
  final EffectJson initial;

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

  List<ContentEntity> _ofType(String type) => [
    for (final e in _content.entities)
      if (e.id.type == type) e,
  ]..sort((a, b) => foldAccents(a.name).compareTo(foldAccents(b.name)));

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

  Widget _number(String label, String key, {bool signed = true}) =>
      TextFormField(
        initialValue: '${_e[key] ?? ''}',
        keyboardType: TextInputType.numberWithOptions(signed: signed),
        inputFormatters: [
          FilteringTextInputFormatter.allow(
            RegExp(signed ? r'[-0-9]' : '[0-9]'),
          ),
        ],
        decoration: InputDecoration(labelText: label),
        onChanged: (v) => _set(key, int.tryParse(v)),
      );

  List<(String, String)> _abilities() => [
    for (final code in _abilitySlugs.keys) (code, _ability(_content, code)),
  ];

  List<(String, String)> _entities(String type) => [
    for (final e in _ofType(type)) ('${e.id}', e.name),
  ];

  List<Widget> _fields(AppLocalizations l10n) => switch (_op) {
    'ability_bonus' => [
      _choice(
        l10n.effectFieldAbility,
        _e['ability'] as String?,
        _abilities(),
        (v) => _set('ability', v),
      ),
      _number(l10n.effectFieldValue, 'value'),
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
    'modify_ac' => [
      _number(l10n.effectFieldValue, 'value'),
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
        (v) => _set('when', switch (v) {
          'armor' => {'armor': 'any'},
          'none' => {'armor': 'none'},
          'shield' => {'shield': true},
          _ => null,
        }),
      ),
    ],
    'modify_speed' => [
      _choice(l10n.effectFieldMode, _e['mode'] as String?, [
        ('walk', l10n.speedWalk),
        ('climb', l10n.speedClimb),
        ('swim', l10n.speedSwim),
        ('fly', l10n.speedFly),
      ], (v) => _set('mode', v)),
      _number(l10n.effectFieldFeet, 'value'),
    ],
    'modify_hp_max' => [
      _number(l10n.effectFieldPerLevel, 'per_level'),
      _number(l10n.effectFieldFlat, 'flat'),
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
      _number(l10n.effectFieldValue, 'add'),
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
        for (final s in _ofType('skill')) ('skill:${s.id.slug}', s.name),
      ], (v) => _set('on', v)),
    ],
    _ => const [],
  };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final text = Theme.of(context).textTheme;
    final issues = validateEffect(_e, 'effet');
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
              for (final field in _fields(l10n)) ...[
                SizedBox(height: AppSpacing.sm),
                field,
              ],
              SizedBox(height: AppSpacing.md),
              Text(l10n.effectPreview, style: text.labelMedium),
              Text(
                issues.isEmpty ? describeEffect(l10n, _content, _e) : '—',
                style: text.bodyLarge,
              ),
              SizedBox(height: AppSpacing.md),
              Align(
                alignment: Alignment.centerRight,
                child: FilledButton(
                  onPressed: issues.isEmpty
                      ? () => Navigator.pop(context, _e)
                      : null,
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
