// Table des opérations du DSL v1 (docs/dsl/DSL_V1.md, validé le 25 oct. 2026).
// Une opération ou un champ absent de cette table rend l'effet invalide.
import '../content_id.dart';
import '../content_issue.dart';

const abilities = ['str', 'dex', 'con', 'int', 'wis', 'cha'];

/// Spécification d'un champ d'effet : renvoie les problèmes de la valeur.
typedef FieldCheck = List<ContentIssue> Function(Object? value, String path);

final class FieldSpec {
  const FieldSpec(this.check, {this.required = false});

  final FieldCheck check;
  final bool required;
}

List<ContentIssue> _one(String path, String message) => [
  ContentIssue(path, message),
];

FieldCheck intField({int min = 0}) =>
    (value, path) => value is int && value >= min
    ? const []
    : _one(path, 'entier ≥ $min attendu');

FieldCheck boolField() =>
    (value, path) => value is bool ? const [] : _one(path, 'booléen attendu');

FieldCheck stringField() =>
    (value, path) => value is String && value.isNotEmpty
    ? const []
    : _one(path, 'chaîne non vide attendue');

FieldCheck enumField(Iterable<String> values) =>
    (value, path) => values.contains(value)
    ? const []
    : _one(path, 'valeur attendue parmi ${values.join(', ')}');

/// Valeur qui suit un motif, ex. `skill:<slug>`.
FieldCheck patternField(RegExp pattern, String description) =>
    (value, path) => value is String && pattern.hasMatch(value)
    ? const []
    : _one(path, '$description attendu');

/// Référence vers une entité d'un type donné (ou n'importe quel type).
FieldCheck contentIdField([String? type]) => (value, path) {
  final id = value is String ? ContentId.tryParse(value) : null;
  if (id == null) return _one(path, 'identifiant de contenu attendu');
  if (type != null && id.type != type) {
    return _one(
      path,
      'identifiant de type « $type » attendu, reçu « ${id.type} »',
    );
  }
  return const [];
};

FieldCheck listField(FieldCheck item) => (value, path) {
  if (value is! List) return _one(path, 'liste attendue');
  return [
    for (var i = 0; i < value.length; i++) ...item(value[i], '$path[$i]'),
  ];
};

/// Objet fermé : champs connus, requis présents, aucun champ en trop.
FieldCheck objectField(Map<String, FieldSpec> fields) => (value, path) {
  if (value is! Map<String, Object?>) return _one(path, 'objet attendu');
  return checkObject(value, fields, path);
};

List<ContentIssue> checkObject(
  Map<String, Object?> json,
  Map<String, FieldSpec> fields,
  String path, {
  Set<String> ignored = const {},
}) => [
  for (final key in json.keys)
    if (!fields.containsKey(key) && !ignored.contains(key))
      ContentIssue('$path.$key', 'champ inconnu'),
  for (final MapEntry(:key, value: spec) in fields.entries)
    if (json.containsKey(key))
      ...spec.check(json[key], '$path.$key')
    else if (spec.required)
      ContentIssue('$path.$key', 'champ requis absent'),
];

/// Expression de valeur fermée (DSL_V1.md, Principes §5).
List<ContentIssue> checkValue(Object? value, String path) {
  if (value is int) return const [];
  if (value is! Map<String, Object?>) {
    return _one(path, 'entier, référence ou table par niveau attendu');
  }
  if (value.containsKey('by_level')) {
    final table = value['by_level'];
    if (value.length != 1 || table is! Map<String, Object?> || table.isEmpty) {
      return _one(
        path,
        'by_level : table non vide { niveau: valeur } attendue',
      );
    }
    return [
      for (final MapEntry(:key, value: entry) in table.entries)
        if (int.tryParse(key) case final level? when level >= 1 && level <= 20)
          if (entry is! int && !(entry is String && _dice.hasMatch(entry)))
            ContentIssue('$path.by_level.$key', 'entier ou dé (ex. d8) attendu')
          else
            ...const <ContentIssue>[]
        else
          ContentIssue('$path.by_level.$key', 'niveau de 1 à 20 attendu'),
    ];
  }
  return checkObject(value, _refFields, path);
}

final _dice = RegExp(r'^(\d+)?d(4|6|8|10|12|20)$');

final _refFields = {
  'ref': FieldSpec(
    enumField([
      'proficiency_bonus',
      'class_level',
      'character_level',
      'ability_mod',
    ]),
    required: true,
  ),
  'ability': FieldSpec(enumField(abilities)),
  'class': FieldSpec(contentIdField('class')),
  'min': FieldSpec(intField(min: -10)),
  'times': FieldSpec(intField(min: 1)),
};

/// Dégâts : dés (« 1d8 ») ou expression de valeur.
List<ContentIssue> checkDamage(Object? value, String path) =>
    value is String && RegExp(r'^\d+d(4|6|8|10|12|20)$').hasMatch(value)
    ? const []
    : checkValue(value, path);

final rechargeEntry = objectField({
  'on': FieldSpec(
    enumField(['short_rest', 'long_rest', 'initiative', 'dawn']),
    required: true,
  ),
  'amount': FieldSpec(
    (v, p) => v == 'all' ? const [] : intField(min: 1)(v, p),
    required: true,
  ),
  'up_to': FieldSpec(intField(min: 1)),
});

const _replaceableOn = ['level_up', 'long_rest', 'short_rest'];

final whenFields = {
  'level': FieldSpec(intField(min: 1)),
  'armor': FieldSpec(enumField(['any', 'none', 'heavy', 'not_heavy'])),
  'shield': FieldSpec(boolField()),
};

/// Champs de chaque opération, hors `op` et `when`.
Map<String, Map<String, FieldSpec>> opSchemas(FieldCheck effects) => {
  'ability_bonus': {
    'ability': FieldSpec(enumField(abilities), required: true),
    'value': const FieldSpec(checkValue, required: true),
    'max': FieldSpec(intField(min: 1)),
  },
  'grant_proficiency': {
    'kind': FieldSpec(
      enumField([
        'skill',
        'tool',
        'weapon',
        'weapon_category',
        'armor',
        'saving_throw',
        'language',
      ]),
      required: true,
    ),
    // Vérifiée selon `kind` par validateEffect.
    'ref': FieldSpec(stringField(), required: true),
  },
  'grant_expertise': {
    'ref': FieldSpec(contentIdField('skill'), required: true),
  },
  'grant_feat': {
    'feat': FieldSpec(contentIdField('feat')),
    'category': FieldSpec(
      enumField(['origin', 'general', 'fighting_style', 'epic_boon']),
    ),
    'replaceable_on': FieldSpec(enumField(_replaceableOn)),
  },
  'modify_ac': {'value': const FieldSpec(checkValue, required: true)},
  'ac_formula': {
    'base': FieldSpec(intField(), required: true),
    'abilities': FieldSpec(listField(enumField(abilities)), required: true),
    'allows_shield': FieldSpec(boolField(), required: true),
  },
  'modify_speed': {
    'mode': FieldSpec(
      enumField(['walk', 'climb', 'swim', 'fly']),
      required: true,
    ),
    'value': const FieldSpec(checkValue),
    'equal_to': FieldSpec(enumField(['walk'])),
  },
  'modify_hp_max': {
    'per_level': const FieldSpec(checkValue),
    'flat': const FieldSpec(checkValue),
  },
  'grant_sense': {
    'sense': FieldSpec(
      enumField(['darkvision', 'blindsight', 'tremorsense', 'truesight']),
      required: true,
    ),
    'range': FieldSpec(intField(min: 5), required: true),
  },
  'grant_defense': {
    'kind': FieldSpec(enumField(['resistance', 'immunity']), required: true),
    'damage_type': FieldSpec(contentIdField('damage-type')),
    'condition': FieldSpec(contentIdField('condition')),
  },
  'modify_initiative': {
    'add': const FieldSpec(checkValue),
    'advantage': FieldSpec(boolField()),
  },
  'grant_advantage': {
    'on': FieldSpec(
      patternField(
        RegExp(
          r'^(initiative|death_saves|saving_throw:(str|dex|con|int|wis|cha)|skill:[a-z-]+|saving_throw_vs:[a-z-]+)$',
        ),
        'cible d\'Avantage',
      ),
      required: true,
    ),
    'except_condition': FieldSpec(contentIdField('condition')),
  },
  'modify_check': {
    'scope': FieldSpec(
      patternField(
        RegExp(
          r'^(unproficient_ability_checks|saving_throws|melee_weapon_attack|ranged_weapon_attack|spell_attack|skill:[a-z-]+|saving_throw:(str|dex|con|int|wis|cha))$',
        ),
        'portée de modify_check',
      ),
      required: true,
    ),
    'add': const FieldSpec(checkValue, required: true),
  },
  'set_attacks_per_action': {
    'count': FieldSpec(intField(min: 1), required: true),
  },
  'set_crit_range': {'min': FieldSpec(intField(min: 2), required: true)},
  'grant_mastery_slots': {'count': const FieldSpec(checkValue, required: true)},
  'modify_damage': {
    'value': const FieldSpec(checkDamage, required: true),
    'scope': FieldSpec(
      patternField(
        RegExp(
          r'^(melee_weapon|ranged_weapon|unarmed|cantrip:[a-z-]+|spell_school:[a-z-]+)$',
        ),
        'portée de modify_damage',
      ),
      required: true,
    ),
    'damage_type': FieldSpec(contentIdField('damage-type')),
  },
  'grant_resource': {
    'id': FieldSpec(contentIdField('resource'), required: true),
    'max': const FieldSpec(checkValue, required: true),
    'recharge': FieldSpec(listField(rechargeEntry), required: true),
    'die': FieldSpec(
      (v, p) => v is String
          ? enumField(['d4', 'd6', 'd8', 'd10', 'd12'])(v, p)
          : checkValue(v, p),
    ),
  },
  'grant_spell': {
    'spell': FieldSpec(contentIdField('spell'), required: true),
    'always_prepared': FieldSpec(boolField()),
    'free_casts': FieldSpec(
      objectField({
        'count': const FieldSpec(checkValue, required: true),
        'recharge': FieldSpec(listField(rechargeEntry), required: true),
      }),
    ),
    'ability': FieldSpec(enumField(abilities)),
  },
  'grant_spell_list_access': {
    'class_lists': FieldSpec(
      listField(contentIdField('class')),
      required: true,
    ),
    'count': FieldSpec(intField(min: 1), required: true),
    'max_level': FieldSpec(intField(), required: true),
  },
  'modify_attunement_slots': {
    'value': FieldSpec(intField(min: 1), required: true),
  },
  'choice': {
    'id': FieldSpec(stringField(), required: true),
    'count': FieldSpec(intField(min: 1), required: true),
    'options': FieldSpec(listField(effects), required: true),
    'replaceable_on': FieldSpec(enumField(_replaceableOn)),
  },
};

/// Cible de `grant_proficiency` selon son `kind`.
final Map<String, FieldCheck> proficiencyRefChecks = {
  'skill': contentIdField('skill'),
  'tool': contentIdField('tool'),
  'weapon': contentIdField('weapon'),
  'language': contentIdField('language'),
  'weapon_category': enumField(['simple', 'martial']),
  'armor': enumField(['light', 'medium', 'heavy', 'shield']),
  'saving_throw': enumField([...abilities, 'all']),
};

/// Contraintes « au moins un » / « exactement un » entre champs.
final Map<String, ({List<String> fields, bool exactlyOne})> fieldGroups = {
  'grant_feat': (fields: ['feat', 'category'], exactlyOne: true),
  'modify_speed': (fields: ['value', 'equal_to'], exactlyOne: true),
  'modify_hp_max': (fields: ['per_level', 'flat'], exactlyOne: false),
  'grant_defense': (fields: ['damage_type', 'condition'], exactlyOne: true),
  'modify_initiative': (fields: ['add', 'advantage'], exactlyOne: false),
};
