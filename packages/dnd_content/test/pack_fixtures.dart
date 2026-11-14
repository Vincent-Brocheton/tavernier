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

/// Loup, SRD 5.2.1 p. 370.
Map<String, Object?> wolf({
  Map<String, Object?> data = const {},
  List<Map<String, Object?>>? actions,
}) => {
  'id': 'srd:monster:wolf',
  'type': 'monster',
  'name': 'Loup',
  'data': {
    'sizes': ['medium'],
    'creature_type': 'beast',
    'type_tags': <String>[],
    'alignment': 'non alignée',
    'ac': 12,
    'initiative': 2,
    'hp': 11,
    'hit_dice': '2d8 + 2',
    'speed': {'walk': 40},
    'hover': false,
    'abilities': {
      'str': 14,
      'dex': 15,
      'con': 12,
      'int': 3,
      'wis': 12,
      'cha': 6,
    },
    'saving_throws': {
      'str': 2,
      'dex': 2,
      'con': 1,
      'int': -4,
      'wis': 1,
      'cha': -2,
    },
    'skills': {'srd:skill:stealth': 4, 'srd:skill:perception': 5},
    'vulnerabilities': <String>[],
    'resistances': <String>[],
    'immunities': <String>[],
    'condition_immunities': <String>[],
    'gear': <String>[],
    'senses': {'darkvision': 60},
    'passive_perception': 15,
    'languages': 'aucune',
    'cr': '1/4',
    'xp': 50,
    'proficiency_bonus': 2,
    'actions':
        actions ??
        [
          {
            'kind': 'trait',
            'name': 'Tactique de meute',
            'text': 'Quand au moins un de ses alliés…',
          },
          {
            'kind': 'action',
            'name': 'Morsure',
            'attack': {
              'kind': 'melee',
              'bonus': 4,
              'reach': 5,
              'damage': [
                {
                  'average': 5,
                  'dice': '1d6 + 2',
                  'type': 'srd:damage-type:piercing',
                },
              ],
            },
            'text': 'Corps à corps : +4, allonge 1,50 m. Touché : 5 (1d6 + 2)…',
          },
        ],
    ...data,
  },
};
