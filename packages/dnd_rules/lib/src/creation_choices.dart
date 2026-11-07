import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'compute_sheet.dart';

/// Une option d'un choix ouvert.
final class ChoiceOption {
  const ChoiceOption({
    required this.pick,
    required this.label,
    required this.expertise,
    required this.bonusCantrips,
    required this.spells,
    this.featCategory,
    this.cantripListId,
  });

  /// Valeur à enregistrer dans `choices`.
  final String pick;
  final String label;

  /// L'option donne l'Expertise : la compétence doit être maîtrisée.
  final bool expertise;

  /// Sorts mineurs de classe supplémentaires (Thaumaturge).
  final int bonusCantrips;

  /// Sorts que l'option accorde au niveau 1.
  final List<String> spells;

  /// Catégorie du don que l'option accorde (Style de combat du Paladin).
  final String? featCategory;

  /// Liste de classe des sorts mineurs à choisir (Combattant béni).
  final String? cantripListId;
}

/// Un effet `choice` ouvert au niveau 1.
final class OpenChoice {
  const OpenChoice({
    required this.id,
    required this.sourceId,
    required this.count,
    required this.options,
    this.title,
  });

  final String id;

  /// Entité qui ouvre le choix (aptitude, trait, don).
  final String sourceId;
  final int count;
  final List<ChoiceOption> options;

  /// Distingue ce choix d'un autre de la même entité.
  final String? title;
}

bool _atLevelOne(Effect effect) => (effect.when['level'] as int? ?? 1) <= 1;

bool _reached(Effect effect, int level) =>
    (effect.when['level'] as int? ?? 1) <= level;

/// Choix ouverts au niveau [level] par les entités [sourceIds].
List<OpenChoice> openChoices(
  ActiveContent content,
  Iterable<String> sourceIds, {
  int level = 1,
}) => [
  for (final id in sourceIds)
    for (final effect in content.entity(id)?.effects ?? const <Effect>[])
      if (effect.op == 'choice' && _reached(effect, level))
        OpenChoice(
          id: effect.args['id']! as String,
          sourceId: id,
          count: effect.args['count']! as int,
          options: _options(content, effect, level),
          title: effect.args['title'] as String?,
        ),
];

List<ChoiceOption> _options(ActiveContent content, Effect choice, int level) {
  final labels = [
    for (final label in (choice.args['labels'] as List<Object?>?) ?? [])
      '$label',
  ];
  final options = <ChoiceOption>[];
  for (final (i, option)
      in (choice.args['options']! as List<Object?>).indexed) {
    final effects = [
      for (final json in option! as List<Object?>)
        Effect.fromJson(json! as Map<String, Object?>),
    ];
    final reference = effects.expand(effectReferences).firstOrNull;
    final label = i < labels.length
        ? labels[i]
        : content.entity(reference ?? '')?.name;
    final pick = i < labels.length ? labels[i] : reference;
    if (label == null || pick == null) continue;
    options.add(
      ChoiceOption(
        pick: pick,
        label: label,
        expertise: effects.any((e) => e.op == 'grant_expertise'),
        bonusCantrips: effects
            .where(
              (e) =>
                  e.op == 'grant_spell_list_access' && e.args['max_level'] == 0,
            )
            .fold(0, (sum, e) => sum + (e.args['count']! as int)),
        spells: _grantedBy(effects, level).toList(),
        cantripListId: effects
            .where(
              (e) =>
                  e.op == 'grant_spell_list_access' && e.args['max_level'] == 0,
            )
            .map((e) => '${(e.args['class_lists']! as List<Object?>).first}')
            .firstOrNull,
        featCategory: effects
            .where((e) => e.op == 'grant_feat')
            .map((e) => e.args['category'] as String?)
            .nonNulls
            .firstOrNull,
      ),
    );
  }
  return options;
}

Iterable<String> _grantedBy(Iterable<Effect> effects, int level) => [
  for (final effect in effects)
    if (effect.op == 'grant_spell' && _reached(effect, level))
      effect.args['spell']! as String,
];

/// Sorts accordés au niveau [level] par [sourceIds], avec les options retenues
/// de [choices].
Set<String> grantedSpells(
  ActiveContent content,
  Iterable<String> sourceIds,
  Map<String, List<String>> choices, {
  int level = 1,
}) => {
  for (final id in sourceIds)
    ..._grantedBy(content.entity(id)?.effects ?? const [], level),
  for (final choice in openChoices(content, sourceIds, level: level))
    for (final option in choice.options)
      if (choices[choice.id]?.contains(option.pick) ?? false) ...option.spells,
};

/// Sorts mineurs de [data] au niveau 1.
int cantripsAtFirstLevel(ClassData data) =>
    data.levels.firstOrNull?.columns['cantrips'] ?? 0;

/// Sorts préparés de [data] au niveau 1.
int preparedAtFirstLevel(ClassData data) =>
    data.levels.firstOrNull?.columns['prepared_spells'] ?? 0;

/// Sorts du grimoire de départ (SRD, Magicien, « Grimoire »).
int spellbookSize(String classId) => classId == 'srd:class:wizard' ? 6 : 0;

/// Initié à la magie (SRD, « Dons »). Ses choix dépendent les uns des autres :
/// le DSL ne les exprime pas.
const magicInitiateFeat = 'srd:feat:magic-initiate';
const magicInitiateCantrips = 2;
const magicInitiateSpells = 1;
const magicInitiateLists = [
  'srd:class:cleric',
  'srd:class:druid',
  'srd:class:wizard',
];
const magicInitiateAbilities = [
  'srd:ability:intelligence',
  'srd:ability:wisdom',
  'srd:ability:charisma',
];

/// Identifiants des aptitudes de niveau 1 de [data].
List<String> levelOneFeatures(ClassData data) => [
  for (final id in data.levels.firstOrNull?.features ?? const <ContentId>[])
    '$id',
];

/// Catégories de don accordées au niveau 1 par [sourceIds] : `fighting_style`
/// pour le Guerrier, `origin` pour l'Humain.
List<String> grantedFeatCategories(
  ActiveContent content,
  Iterable<String> sourceIds,
) => [
  for (final id in sourceIds)
    for (final effect in content.entity(id)?.effects ?? const <Effect>[])
      if (effect.op == 'grant_feat' && _atLevelOne(effect))
        if (effect.args['category'] case final String category) category,
];

/// Bottes d'une classe au niveau 1 et armes qu'elles acceptent (triées par
/// l'appelant).
({int slots, List<ContentEntity> weapons}) masteryOptions(
  ActiveContent content,
  ClassData data,
) {
  var slots = 0;
  var meleeOnly = false;
  for (final id in levelOneFeatures(data)) {
    for (final effect in content.entity(id)?.effects ?? const <Effect>[]) {
      if (effect.op != 'grant_mastery_slots') continue;
      slots += switch (effect.args['count']) {
        final int count => count,
        {'by_level': final Map<String, Object?> steps} =>
          steps['1'] as int? ?? 0,
        _ => 0,
      };
      meleeOnly = effect.args['melee_only'] == true;
    }
  }
  final categories = data.weaponProficiencies.toSet();
  return (
    slots: slots,
    weapons: slots == 0
        ? const []
        : [
            for (final entity in content.entities)
              if (entity.data case final WeaponData weapon)
                if (coversWeapon(categories, weapon) &&
                    (!meleeOnly || weapon.kind == WeaponKind.melee))
                  entity,
          ],
  );
}
