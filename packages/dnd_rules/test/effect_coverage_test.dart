// Tâche 5.3 : chaque opération du DSL accessible à un personnage de niveau 1
// de l'échantillon M0 change la fiche ; aucune n'est ignorée en silence.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

/// Entités dont les effets s'appliquent au niveau 1 : traits d'espèce, dons
/// d'origines et de Style de combat, aptitudes de classe de niveau 1.
Iterable<ContentEntity> _levelOneEntities() => srdPack.entities.where((e) {
  final data = e.data;
  return switch (data) {
    FeatData(:final category) =>
      category == FeatCategory.origin || category == FeatCategory.fightingStyle,
    FeatureData(:final level) => (level ?? 1) == 1,
    _ => false,
  };
});

/// Personnage qui utilise l'entité testée.
final _variants = <String, void Function(Map<String, Object?> json)?>{
  'srd:feat:archery': (json) {
    (json['items']! as List<Object?>).add({
      'item_id': 'srd:weapon:shortbow',
      'quantity': 1,
    });
    _classFeat(json)['feat_id'] = 'srd:feat:archery';
  },
  'srd:feat:skilled': (json) {
    _speciesFeat(json)
      ..['feat_id'] = 'srd:feat:skilled'
      ..['choices'] = {
        'skilled': [
          'srd:skill:arcana',
          'srd:skill:history',
          'srd:skill:nature',
        ],
      };
  },
};

Map<String, Object?> _feat(Map<String, Object?> json, String sourceType) =>
    (json['feats']! as List<Object?>).cast<Map<String, Object?>>().firstWhere(
      (f) => f['source_type'] == sourceType,
    );
Map<String, Object?> _classFeat(Map<String, Object?> json) =>
    _feat(json, 'class');
Map<String, Object?> _speciesFeat(Map<String, Object?> json) =>
    _feat(json, 'species');

/// Copie de [entity] sans ses effets [op].
ContentEntity _without(ContentEntity entity, String op) {
  final json = entity.toJson();
  json['effects'] = [
    for (final e in entity.effects)
      if (e.op != op) e.toJson(),
  ];
  return parseEntity(json, 'test').entity!;
}

void main() {
  final cases = <(ContentEntity, String)>{
    for (final entity in _levelOneEntities())
      for (final effect in entity.effects) (entity, effect.op),
  };

  test("les opérations du niveau 1 de l'échantillon sont connues", () {
    expect(
      {for (final (_, op) in cases) op},
      {
        'choice',
        'grant_feat',
        'grant_mastery_slots',
        'grant_resource',
        'modify_ac',
        'modify_check',
        'modify_initiative',
      },
    );
  });

  for (final (entity, op) in cases) {
    test('${entity.id} : retirer $op change la fiche', () {
      final character = aldric(_variants['${entity.id}']);
      final normal = computeSheet(character, srdContent()).toJson();
      final stripped = computeSheet(
        character,
        srdContent([_without(entity, op)]),
      ).toJson();
      expect(stripped, isNot(equals(normal)));
    });
  }
}
