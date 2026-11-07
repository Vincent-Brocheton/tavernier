import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';

/// Ressource accordée par une aptitude : son maximum et sa recharge.
typedef FeatureResource = ({int max, String? recharge});

/// Une aptitude, un trait ou un don du personnage.
typedef SheetFeature = ({ContentEntity entity, FeatureResource? resource});

/// Aptitudes d'une même origine. [level] n'est renseigné que pour une classe.
typedef FeatureGroup = ({
  String sourceId,
  int? level,
  bool feats,
  List<SheetFeature> features,
});

FeatureResource? _resource(ContentEntity entity, ComputedSheet sheet) {
  for (final effect in entity.effects) {
    if (effect.op != 'grant_resource') continue;
    final max = sheet.resources[effect.args['id']];
    if (max == null) continue;
    final recharge = effect.args['recharge'] as List<Object?>?;
    final first = recharge?.firstOrNull as Map<String, Object?>?;
    return (max: max, recharge: first?['on'] as String?);
  }
  return null;
}

/// Aptitudes atteintes par [character], groupées par origine : classes,
/// sous-classes, espèce, puis dons.
List<FeatureGroup> featureGroups(
  CharacterInput character,
  ComputedSheet sheet,
  ActiveContent content,
) {
  List<SheetFeature> resolved(Iterable<Object> ids) => [
    for (final id in ids)
      if (content.entity('$id') case final entity?)
        (entity: entity, resource: _resource(entity, sheet)),
  ];

  final species = content.entity(character.speciesId)?.data;
  return [
    for (final level in character.classLevels)
      if (content.entity(level.classId)?.data case final ClassData data)
        (
          sourceId: level.classId,
          level: level.level,
          feats: false,
          features: resolved([
            for (final row in data.levels)
              if (row.level <= level.level) ...row.features,
          ]),
        ),
    if (species is SpeciesData)
      (
        sourceId: character.speciesId,
        level: null,
        feats: false,
        features: resolved(species.traits),
      ),
    if (character.feats.isNotEmpty)
      (
        sourceId: '',
        level: null,
        feats: true,
        features: resolved([for (final feat in character.feats) feat.featId]),
      ),
  ];
}
