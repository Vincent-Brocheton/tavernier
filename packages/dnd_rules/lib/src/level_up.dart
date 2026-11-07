import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'character_input.dart';
import 'compute_sheet.dart';
import 'computed_sheet.dart';
import 'creation_choices.dart';

/// Niveau de personnage maximal (SRD p. 24).
const maxCharacterLevel = 20;

/// Identifiant du don Amélioration de caractéristique.
const abilityScoreImprovementFeat = 'srd:feat:ability-score-improvement';

/// Ce qu'apporte le niveau suivant d'une classe.
final class LevelGain {
  const LevelGain({
    required this.classLevel,
    required this.features,
    required this.subclasses,
    required this.featCategories,
    required this.choices,
  });

  /// Nouveau niveau dans la classe.
  final int classLevel;
  final List<ContentEntity> features;

  /// Sous-classes à choisir, vide si le niveau n'en demande pas.
  final List<ContentEntity> subclasses;

  /// Une catégorie par don accordé.
  final List<String> featCategories;
  final List<OpenChoice> choices;
}

/// Raison pour laquelle un don n'est pas disponible.
enum FeatBlock { level, ability, feature, notRepeatable }

/// Choix faits pendant une montée de niveau.
final class LevelChoices {
  const LevelChoices({
    this.subclassId,
    this.feat,
    this.featChoices,
    this.choices = const {},
    this.masteries = const [],
  });

  final String? subclassId;
  final String? feat;
  final Map<String, Object?>? featChoices;

  /// Sélections des effets `choice` ouverts à ce niveau.
  final Map<String, List<String>> choices;

  /// Armes des bottes gagnées.
  final List<String> masteries;
}

ClassLevelInput _classLevel(CharacterInput character, String classId) =>
    character.classLevels.firstWhere((c) => c.classId == classId);

/// [character] avec un niveau de plus dans [classId], sans aucun choix.
CharacterInput raisedOneLevel(CharacterInput character, String classId) =>
    character.copyWith(
      classLevels: [
        for (final level in character.classLevels)
          level.classId == classId
              ? level.copyWith(level: level.level + 1)
              : level,
      ],
    );

List<ContentEntity> _subclassesOf(ActiveContent content, String classId) => [
  for (final entity in content.entities)
    if (entity.data case final SubclassData data)
      if ('${data.parentClass}' == classId) entity,
];

/// Gains du niveau suivant de [classId]. [subclassId] est la sous-classe
/// retenue, connue ou en cours de choix ; [picks] sont les sélections déjà
/// faites, dont une option peut accorder un don.
LevelGain levelGain(
  CharacterInput character,
  ActiveContent content,
  String classId, {
  String? subclassId,
  Map<String, List<String>> picks = const {},
}) {
  final current = _classLevel(character, classId);
  final data = content.entity(classId)!.data as ClassData;
  final next = current.level + 1;
  final subclass = subclassId ?? current.subclassId;
  final row = data.levels.where((l) => l.level == next).firstOrNull;
  final ofSubclass = content.entity(subclass ?? '')?.data;
  final features = [
    for (final id in row?.features ?? const <ContentId>[])
      ?content.entity('$id'),
    if (ofSubclass is SubclassData)
      for (final id in ofSubclass.features)
        if (content.entity('$id') case final feature?)
          if ((feature.data as FeatureData).level == next) feature,
  ];

  // Choix ouverts par une aptitude de ce niveau, ou par un palier `when.level`
  // d'une aptitude plus ancienne (seconde Expertise du Roublard).
  final known = [
    for (final level in data.levels)
      if (level.level <= next) ...level.features.map((id) => '$id'),
  ];
  final gained = {for (final feature in features) '${feature.id}'};
  bool opens(String source, Effect effect) {
    final threshold = effect.when['level'] as int?;
    return threshold == next || (threshold == null && gained.contains(source));
  }

  final choices = [
    for (final source in {...known, ...gained})
      for (final effect in content.entity(source)?.effects ?? const <Effect>[])
        if (effect.op == 'choice' && opens(source, effect))
          ...openChoices(content, [
            source,
          ], level: next).where((choice) => choice.id == effect.args['id']),
  ];

  return LevelGain(
    classLevel: next,
    features: features,
    subclasses: data.subclassLevel == next && current.subclassId == null
        ? _subclassesOf(content, classId)
        : const [],
    featCategories: [
      for (final feature in features)
        for (final effect in feature.effects)
          if (effect.op == 'grant_feat')
            if (effect.args['category'] case final String category) category,
      for (final choice in choices)
        for (final option in choice.options)
          if (picks[choice.id]?.contains(option.pick) ?? false)
            ?option.featCategory,
    ],
    choices: choices,
  );
}

/// Dons proposés pour une catégorie accordée. Un don général ouvre aussi les
/// dons d'origines (SRD, Amélioration de caractéristique, [P10]) ; l'Initié à
/// la magie attend le change suivant.
List<ContentEntity> featsForCategory(ActiveContent content, String category) {
  bool offered(FeatCategory value) => category == 'general'
      ? value == FeatCategory.general || value == FeatCategory.origin
      : featCategoryName(value) == category;
  return [
    for (final entity in content.entities)
      if (entity.data case final FeatData data)
        if (offered(data.category) && '${entity.id}' != magicInitiateFeat)
          entity,
  ];
}

/// Raison pour laquelle [character] ne peut pas prendre le don [feat] au
/// niveau de personnage [level], ou `null`.
FeatBlock? featBlock(
  ContentEntity feat,
  CharacterInput character,
  ComputedSheet sheet,
  int level,
  ActiveContent content,
) {
  final data = feat.data as FeatData;
  final taken = character.feats.any((f) => f.featId == '${feat.id}');
  if (taken && !data.repeatable) return FeatBlock.notRepeatable;
  final needs = data.prerequisites;
  if (needs == null) return null;
  if (level < (needs.minLevel ?? 0)) return FeatBlock.level;
  if (needs.abilityMinAny case final minima?) {
    final met = minima.entries.any(
      (e) => (sheet.abilities[e.key]?.value ?? 0) >= e.value,
    );
    if (!met) return FeatBlock.ability;
  }
  // « Style de combat » est rempli par l'aptitude qui accorde ces dons.
  if (needs.feature == 'spellcasting') {
    final caster = character.classLevels.any((c) {
      final data = content.entity(c.classId)?.data;
      return data is ClassData && data.spellcastingAbility != null;
    });
    if (!caster) return FeatBlock.feature;
  }
  return null;
}

/// [character] monté d'un niveau dans [classId], avec ses choix.
CharacterInput applyLevelUp(
  CharacterInput character,
  String classId,
  LevelChoices picks,
) {
  final raised = raisedOneLevel(character, classId);
  final level = _classLevel(raised, classId).level;
  return raised.copyWith(
    classLevels: [
      for (final entry in raised.classLevels)
        entry.classId == classId && picks.subclassId != null
            ? entry.copyWith(subclassId: picks.subclassId)
            : entry,
    ],
    feats: [
      ...raised.feats,
      if (picks.feat case final feat?)
        FeatInput(
          featId: feat,
          sourceType: 'class_level',
          sourceRef: '$classId:$level',
          choices: picks.featChoices,
        ),
    ],
    choices: {...raised.choices, ...picks.choices},
    weaponMasteries: [
      ...raised.weaponMasteries,
      for (final (i, weapon) in picks.masteries.indexed)
        WeaponMasteryInput(
          weaponId: weapon,
          slotIndex: raised.weaponMasteries.length + i,
        ),
    ],
  );
}
