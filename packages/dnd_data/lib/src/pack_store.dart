import 'dart:convert';

import 'package:dnd_content/dnd_content.dart';
import 'package:drift/drift.dart';

import 'database.dart';

/// Résultat de recherche dans le compendium.
typedef SearchHit = ({String id, String type, String name});

/// Table de chaque type d'entité (cahier §11.1).
const _tableOf = {
  'ability': 'ability',
  'skill': 'skill',
  'language': 'language',
  'condition': 'condition',
  'damage-type': 'damage_type',
  'mastery': 'mastery_property',
  'weapon': 'weapon',
  'armor': 'armor',
  'tool': 'tool',
  'item': 'item',
  'background': 'background',
  'species': 'species',
  'feat': 'feat',
  'class': 'class',
  'subclass': 'subclass',
  'feature': 'feature',
};

/// Écrit et relit les packs dans les tables normalisées, et cherche dans le
/// compendium (FTS5).
final class PackStore {
  PackStore(this._db);

  final TavernierDatabase _db;

  /// Remplace le pack et toutes ses entités, dans une transaction.
  Future<void> importPack(ContentPack pack) => _db.transaction(() async {
    final m = pack.manifest;
    await _db.customStatement('DELETE FROM content_search WHERE pack_id = ?', [
      m.id,
    ]);
    await _db.customStatement('DELETE FROM content_pack WHERE id = ?', [m.id]);
    await _insert('content_pack', {
      'id': m.id,
      'namespace': m.namespace,
      'name': m.name,
      'version': m.version,
      'origin': m.origin.name,
      'author': m.author,
      'licence': m.licence,
      'attribution': m.attribution,
      'dsl_version': m.dslVersion,
      'locale': m.locale,
      'checksum': m.checksum,
    });
    for (final d in m.dependencies) {
      await _insert('pack_dependency', {
        'pack_id': m.id,
        'depends_on_pack_id': d.id,
        'version_range': d.versionRange,
      });
    }
    for (final entity in pack.entities) {
      await _importEntity(m.id, entity);
    }
  });

  Future<void> _importEntity(String packId, ContentEntity entity) async {
    final id = '${entity.id}';
    Future<void> child(String table, Map<String, Object?> row) =>
        _insert(table, {'pack_id': packId, ...row});

    final row = <String, Object?>{
      'id': id,
      'pack_id': packId,
      'name': entity.name,
      'extends_id': entity.extendsId?.toString(),
    };
    switch (entity.data) {
      case AbilityData(:final abbreviation):
        row['abbreviation'] = abbreviation;
      case SkillData(:final ability):
        row['ability_id'] = '$ability';
      case LanguageData(:final category):
        row['category'] = category.name;
      case EmptyData():
        break;
      case final WeaponData w:
        final json = w.toJson();
        row.addAll({
          'category': json['category'],
          'kind': json['kind'],
          'damage': w.damage,
          'damage_type_id': '${w.damageType}',
          'properties': jsonEncode(w.properties),
          'versatile_damage': w.versatileDamage,
          'range_normal_feet': w.rangeFeet?.first,
          'range_long_feet': w.rangeFeet?.last,
          'mastery_property_id': '${w.mastery}',
          'weight_kg': w.weightKg,
          'cost_cp': w.costCp,
        });
      case final ArmorData a:
        row.addAll({
          'category': a.toJson()['category'],
          'base_ac': a.baseAc,
          'dex_cap': a.dexCap,
          'str_requirement': a.strRequirement,
          'stealth_disadvantage': a.stealthDisadvantage,
          'weight_kg': a.weightKg,
          'cost_cp': a.costCp,
        });
      case final ToolData t:
        row.addAll({
          'category': t.toJson()['category'],
          'ability_id': t.ability?.toString(),
          'weight_kg': t.weightKg,
          'cost_cp': t.costCp,
        });
      case final ItemData i:
        row.addAll({'weight_kg': i.weightKg, 'cost_cp': i.costCp});
      case final BackgroundData b:
        row.addAll({
          'origin_feat_id': '${b.originFeat}',
          'origin_feat_choices': b.originFeatChoices == null
              ? null
              : jsonEncode(b.originFeatChoices),
          'tool_choice_category': b.toJson()['tool_choice_category'],
          'gold_a': b.goldA,
          'equipment_gold_alt': b.goldB,
        });
      case final SpeciesData s:
        row.addAll({
          'creature_type': s.creatureType,
          'sizes': jsonEncode(s.sizes),
          'speed_feet': s.speedFeet,
        });
      case final FeatData f:
        final json = f.toJson();
        row.addAll({
          'category': json['category'],
          'prerequisites': json['prerequisites'] == null
              ? null
              : jsonEncode(json['prerequisites']),
          'repeatable': f.repeatable,
        });
      case final ClassData c:
        final json = c.toJson();
        row.addAll({
          for (final key in [
            'primary_abilities',
            'saving_throws',
            'skill_choices',
            'weapon_proficiencies',
            'armor_training',
          ])
            key: jsonEncode(json[key]),
          'hit_die': c.hitDie,
          'skill_choice_count': c.skillChoiceCount,
          'subclass_level': c.subclassLevel,
        });
      case SubclassData(:final parentClass):
        row['parent_class_id'] = '$parentClass';
      case FeatureData(:final source, :final level):
        row.addAll({'source_id': '$source', 'level': level});
    }
    await _insert(_tableOf[entity.type]!, row);

    // Lignes rattachées : listes ordonnées des Historiques, espèces, classes.
    switch (entity.data) {
      case final BackgroundData b:
        for (final (i, ability) in b.abilities.indexed) {
          await child('background_ability', {
            'background_id': id,
            'position': i,
            'ability_id': '$ability',
          });
        }
        final proficiencies = [
          for (final s in b.skillProficiencies) ('skill', '$s'),
          if (b.toolProficiency case final tool?) ('tool', '$tool'),
        ];
        for (final (i, (type, ref)) in proficiencies.indexed) {
          await child('background_proficiency', {
            'background_id': id,
            'position': i,
            'type': type,
            'ref_id': ref,
          });
        }
        await child('background_equipment_option', {
          'background_id': id,
          'option': 'A',
          'items': jsonEncode([for (final q in b.equipmentA) q.toJson()]),
        });
      case final SpeciesData s:
        for (final (i, trait) in s.traits.indexed) {
          await child('species_trait', {
            'species_id': id,
            'position': i,
            'feature_id': '$trait',
          });
        }
      case final ClassData c:
        for (final l in c.levels) {
          await child('class_level', {
            'class_id': id,
            'level': l.level,
            'prof_bonus': l.proficiencyBonus,
            'features': jsonEncode([for (final f in l.features) '$f']),
            'columns': jsonEncode(l.columns),
          });
        }
      case final SubclassData s:
        for (final (i, feature) in s.features.indexed) {
          await child('subclass_feature', {
            'subclass_id': id,
            'position': i,
            'feature_id': '$feature',
          });
        }
      default:
        break;
    }
    for (final (i, effect) in entity.effects.indexed) {
      await child('effect', {
        'owner_id': id,
        'owner_type': entity.type,
        'position': i,
        'payload': jsonEncode(effect.toJson()),
      });
    }
    if (entity.textFr case final text?) {
      await child('entity_text', {
        'entity_id': id,
        'locale': 'fr',
        'description': text,
      });
    }
    await _insert('content_search', {
      'entity_id': id,
      'type': entity.type,
      'pack_id': packId,
      'name': entity.name,
      'description': entity.textFr ?? '',
    });
  }

  /// Reconstruit le pack [packId], ou `null` s'il n'est pas dans la base.
  Future<ContentPack?> exportPack(String packId) async {
    final pack = await _select('SELECT * FROM content_pack WHERE id = ?', [
      packId,
    ]);
    if (pack.isEmpty) return null;
    final p = pack.single;
    final deps = await _select(
      'SELECT * FROM pack_dependency WHERE pack_id = ?',
      [packId],
    );
    final manifest = PackManifest(
      id: p['id']! as String,
      namespace: p['namespace']! as String,
      name: p['name']! as String,
      version: p['version']! as String,
      origin: PackOrigin.values.byName(p['origin']! as String),
      author: p['author']! as String,
      licence: p['licence']! as String,
      attribution: p['attribution'] as String?,
      dslVersion: p['dsl_version']! as int,
      locale: p['locale']! as String,
      checksum: p['checksum'] as String?,
      dependencies: [
        for (final d in deps)
          (
            id: d['depends_on_pack_id']! as String,
            versionRange: d['version_range']! as String,
          ),
      ],
    );

    Future<Map<String, List<Map<String, Object?>>>> grouped(
      String table,
      String key,
      String order,
    ) async {
      final result = <String, List<Map<String, Object?>>>{};
      for (final row in await _select(
        'SELECT * FROM $table WHERE pack_id = ? ORDER BY $key, $order',
        [packId],
      )) {
        result.putIfAbsent(row[key]! as String, () => []).add(row);
      }
      return result;
    }

    final effects = await grouped('effect', 'owner_id', 'position');
    final texts = await grouped('entity_text', 'entity_id', 'locale');
    final bgAbilities = await grouped(
      'background_ability',
      'background_id',
      'position',
    );
    final bgProficiencies = await grouped(
      'background_proficiency',
      'background_id',
      'position',
    );
    final bgEquipment = await grouped(
      'background_equipment_option',
      'background_id',
      'option',
    );
    final traits = await grouped('species_trait', 'species_id', 'position');
    final levels = await grouped('class_level', 'class_id', 'level');
    final subFeatures = await grouped(
      'subclass_feature',
      'subclass_id',
      'position',
    );

    final entities = <ContentEntity>[];
    for (final MapEntry(key: type, value: table) in _tableOf.entries) {
      for (final row in await _select(
        'SELECT * FROM $table WHERE pack_id = ? ORDER BY id',
        [packId],
      )) {
        final id = row['id']! as String;
        List<Map<String, Object?>> of(
          Map<String, List<Map<String, Object?>>> g,
        ) => g[id] ?? const [];
        final data = <String, Object?>{
          ...switch (type) {
            'ability' => {'abbreviation': row['abbreviation']},
            'skill' => {'ability': row['ability_id']},
            'language' => {'category': row['category']},
            'weapon' => {
              'category': row['category'],
              'kind': row['kind'],
              'damage': row['damage'],
              'damage_type': row['damage_type_id'],
              'properties': jsonDecode(row['properties']! as String),
              'versatile_damage': row['versatile_damage'],
              if (row['range_normal_feet'] != null)
                'range_feet': [
                  row['range_normal_feet'],
                  row['range_long_feet'],
                ],
              'mastery': row['mastery_property_id'],
              'weight_kg': row['weight_kg'],
              'cost_cp': row['cost_cp'],
            },
            'armor' => {
              'category': row['category'],
              'base_ac': row['base_ac'],
              'dex_cap': row['dex_cap'],
              'str_requirement': row['str_requirement'],
              'stealth_disadvantage': row['stealth_disadvantage'] == 1,
              'weight_kg': row['weight_kg'],
              'cost_cp': row['cost_cp'],
            },
            'tool' => {
              'category': row['category'],
              'ability': row['ability_id'],
              'weight_kg': row['weight_kg'],
              'cost_cp': row['cost_cp'],
            },
            'item' => {
              'weight_kg': row['weight_kg'],
              'cost_cp': row['cost_cp'],
            },
            'background' => {
              'abilities': [for (final r in of(bgAbilities)) r['ability_id']],
              'origin_feat': row['origin_feat_id'],
              if (row['origin_feat_choices'] case final String choices)
                'origin_feat_choices': jsonDecode(choices),
              'skill_proficiencies': [
                for (final r in of(bgProficiencies))
                  if (r['type'] == 'skill') r['ref_id'],
              ],
              'tool_proficiency': of(bgProficiencies)
                  .where((r) => r['type'] == 'tool')
                  .firstOrNull?['ref_id'],
              'tool_choice_category': row['tool_choice_category'],
              'equipment_a': jsonDecode(
                of(bgEquipment).single['items']! as String,
              ),
              'gold_a': row['gold_a'],
              'gold_b': row['equipment_gold_alt'],
            },
            'species' => {
              'creature_type': row['creature_type'],
              'sizes': jsonDecode(row['sizes']! as String),
              'speed_feet': row['speed_feet'],
              'traits': [for (final r in of(traits)) r['feature_id']],
            },
            'feat' => {
              'category': row['category'],
              if (row['prerequisites'] case final String prerequisites)
                'prerequisites': jsonDecode(prerequisites),
              'repeatable': row['repeatable'] == 1,
            },
            'class' => {
              for (final key in [
                'primary_abilities',
                'saving_throws',
                'skill_choices',
                'weapon_proficiencies',
                'armor_training',
              ])
                key: jsonDecode(row[key]! as String),
              'hit_die': row['hit_die'],
              'skill_choice_count': row['skill_choice_count'],
              'subclass_level': row['subclass_level'],
              'levels': [
                for (final l in of(levels))
                  {
                    'level': l['level'],
                    'proficiency_bonus': l['prof_bonus'],
                    'features': jsonDecode(l['features']! as String),
                    'columns': jsonDecode(l['columns']! as String),
                  },
              ],
            },
            'subclass' => {
              'parent_class': row['parent_class_id'],
              'features': [for (final r in of(subFeatures)) r['feature_id']],
            },
            'feature' => {'source': row['source_id'], 'level': row['level']},
            _ => const <String, Object?>{},
          },
        }..removeWhere((_, value) => value == null);
        final text = of(texts).where((t) => t['locale'] == 'fr').firstOrNull;
        final parsed = parseEntity({
          'id': id,
          'type': type,
          'name': row['name'],
          if (row['extends_id'] != null) 'extends_id': row['extends_id'],
          'data': data,
          'effects': [
            for (final e in of(effects)) jsonDecode(e['payload']! as String),
          ],
          if (text != null) 'text': {'fr': text['description']},
        }, '$table/$id');
        entities.add(
          parsed.entity ??
              (throw StateError('entité illisible : ${parsed.issues}')),
        );
      }
    }
    return ContentPack(manifest: manifest, entities: entities);
  }

  /// Entités dont le nom ou le texte contient les mots de [query] (début de
  /// mot, sans accent ni casse), les plus pertinentes d'abord.
  Future<List<SearchHit>> search(String query, {int limit = 50}) async {
    final words = RegExp(
      r'[\p{L}\p{N}]+',
      unicode: true,
    ).allMatches(query).map((m) => '"${m[0]}"*');
    if (words.isEmpty) return const [];
    return [
      for (final row in await _select(
        'SELECT entity_id, type, name FROM content_search '
        'WHERE content_search MATCH ? '
        // Un nom correspondant pèse dix fois plus que le texte de règles.
        'ORDER BY bm25(content_search, 0, 0, 0, 10.0, 1.0) LIMIT ?',
        [words.join(' '), limit],
      ))
        (
          id: row['entity_id']! as String,
          type: row['type']! as String,
          name: row['name']! as String,
        ),
    ];
  }

  Future<void> _insert(
    String table,
    Map<String, Object?> row,
  ) => _db.customStatement(
    'INSERT INTO $table (${row.keys.join(', ')}) '
    'VALUES (${List.filled(row.length, '?').join(', ')})',
    [for (final value in row.values) value is bool ? (value ? 1 : 0) : value],
  );

  Future<List<Map<String, Object?>>> _select(
    String sql,
    List<Object?> args,
  ) async => [
    for (final row
        in await _db
            .customSelect(sql, variables: [for (final a in args) _variable(a)])
            .get())
      row.data,
  ];
}

Variable<Object> _variable(Object? value) => switch (value) {
  final int v => Variable<int>(v),
  final String v => Variable<String>(v),
  _ => throw ArgumentError.value(value),
};
