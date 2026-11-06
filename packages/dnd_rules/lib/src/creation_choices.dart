import 'package:dnd_content/dnd_content.dart';

import 'active_content.dart';
import 'compute_sheet.dart';

/// Une option d'un choix ouvert.
final class ChoiceOption {
  const ChoiceOption({
    required this.pick,
    required this.label,
    required this.expertise,
  });

  /// Valeur à enregistrer dans `choices`.
  final String pick;
  final String label;

  /// L'option donne l'Expertise : la compétence doit être maîtrisée.
  final bool expertise;
}

/// Un effet `choice` ouvert au niveau 1.
final class OpenChoice {
  const OpenChoice({
    required this.id,
    required this.sourceId,
    required this.count,
    required this.options,
  });

  final String id;

  /// Entité qui ouvre le choix (aptitude, trait, don).
  final String sourceId;
  final int count;
  final List<ChoiceOption> options;
}

bool _atLevelOne(Effect effect) => (effect.when['level'] as int? ?? 1) <= 1;

/// Choix ouverts au niveau 1 par les entités [sourceIds].
List<OpenChoice> openChoices(
  ActiveContent content,
  Iterable<String> sourceIds,
) => [
  for (final id in sourceIds)
    for (final effect in content.entity(id)?.effects ?? const <Effect>[])
      if (effect.op == 'choice' && _atLevelOne(effect))
        OpenChoice(
          id: effect.args['id']! as String,
          sourceId: id,
          count: effect.args['count']! as int,
          options: _options(content, effect),
        ),
];

List<ChoiceOption> _options(ActiveContent content, Effect choice) {
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
      ),
    );
  }
  return options;
}

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
        {'by_level': final Map<String, Object?> steps} => steps['1']! as int,
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
