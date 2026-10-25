// Petits packs de test partagés par pack_test.dart et archive_test.dart.
import 'package:dnd_content/dnd_content.dart';

ContentEntity entity(Map<String, Object?> json) {
  final result = parseEntity(json, json['id'].toString());
  if (result.entity == null) throw StateError('${result.issues}');
  return result.entity!;
}

ContentEntity ability(String slug) => entity({
  'id': 'srd:ability:$slug',
  'type': 'ability',
  'name': slug.toUpperCase(),
  'data': {'abbreviation': slug.toUpperCase()},
});

ContentEntity skill(String slug, String abilityId) => entity({
  'id': 'srd:skill:$slug',
  'type': 'skill',
  'name': slug,
  'data': {'ability': abilityId},
});

ContentEntity feat(String slug, String category) => entity({
  'id': 'srd:feat:$slug',
  'type': 'feat',
  'name': slug,
  'data': {'category': category},
  'text': {'fr': 'Texte.'},
});

ContentEntity background(List<String> abilities, String originFeat) => entity({
  'id': 'srd:background:soldier',
  'type': 'background',
  'name': 'Soldat',
  'data': {
    'abilities': abilities,
    'origin_feat': originFeat,
    'skill_proficiencies': ['srd:skill:athletics'],
    'equipment_a': <Object?>[],
    'gold_a': 14,
    'gold_b': 50,
  },
  'text': {'fr': 'Texte du Soldat.'},
});

PackManifest srdManifest({String attribution = srdAttributionFr}) =>
    PackManifest(
      id: '377190b6-2dfa-4b38-83be-1c4c6d0cf55d',
      namespace: 'srd',
      name: 'SRD 5.2.1 (FR)',
      version: '1.0.0',
      origin: PackOrigin.srd,
      author: 'Wizards of the Coast LLC',
      licence: 'CC-BY-4.0',
      attribution: attribution,
      locale: 'fr',
    );

/// Pack valide : trois caractéristiques, une compétence, un Soldat.
ContentPack validPack() => ContentPack(
  manifest: srdManifest(),
  entities: [
    ability('str'),
    ability('dex'),
    ability('con'),
    skill('athletics', 'srd:ability:str'),
    feat('savage-attacker', 'origin'),
    background([
      'srd:ability:str',
      'srd:ability:dex',
      'srd:ability:con',
    ], 'srd:feat:savage-attacker'),
  ],
);
