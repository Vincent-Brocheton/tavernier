import 'dart:convert';

import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart';

import 'database.dart';

/// Tables qui contiennent l'entrée stockée d'un personnage ; l'état de jeu,
/// l'historique et les références de contenu n'en font pas partie.
const _inputTables = [
  'character_base_scores',
  'character_background_choice',
  'character_class_level',
  'character_feat',
  'character_weapon_mastery',
  'character_item',
  'character_language',
  'character_choice',
];

/// Écrit et relit un personnage stocké (`CharacterInput`) dans les tables
/// `character_*` (cahier §11.2). Aucun calcul de règles ici.
final class CharacterStore {
  CharacterStore(this._db);

  final TavernierDatabase _db;

  /// Enregistre [character] sous [id] ; un enregistrement existant est mis
  /// à jour sans toucher à son état de jeu ni à son historique.
  Future<void> save(String id, CharacterInput character) => _db.transaction(
    () async {
      final c = character.toJson();
      final base = c['base_scores']! as Map<String, Object?>;
      await _db.customStatement(
        'INSERT INTO character (id, kind, name, player, species_id, '
        'species_choices, background_id, status, xp, score_rolls) '
        "VALUES (?, ?, ?, ?, ?, ?, ?, 'draft', ?, ?) "
        'ON CONFLICT(id) DO UPDATE SET kind = excluded.kind, '
        'name = excluded.name, player = excluded.player, '
        'species_id = excluded.species_id, '
        'species_choices = excluded.species_choices, '
        'background_id = excluded.background_id, xp = excluded.xp, '
        'score_rolls = excluded.score_rolls',
        [
          id,
          character.kind,
          character.name,
          character.player,
          character.speciesId,
          jsonEncode(character.speciesChoices),
          character.backgroundId,
          character.xp,
          base['rolls'] == null ? null : jsonEncode(base['rolls']),
        ],
      );
      for (final table in _inputTables) {
        await _db.customStatement('DELETE FROM $table WHERE character_id = ?', [
          id,
        ]);
      }

      Future<void> insert(String table, String key, Map<String, Object?> row) {
        final values = {'id': '$id:$table:$key', 'character_id': id, ...row};
        return _db.customStatement(
          'INSERT INTO $table (${values.keys.join(', ')}) '
          'VALUES (${List.filled(values.length, '?').join(', ')})',
          [for (final v in values.values) v is bool ? (v ? 1 : 0) : v],
        );
      }

      for (final code in abilityCodes) {
        await insert('character_base_scores', code, {
          'ability_id': code,
          'base': character.baseScores.of(code),
          'method': base['method'],
        });
      }
      final bg = character.backgroundChoice;
      await insert('character_background_choice', 'bg', {
        'distribution': bg.distribution,
        'bonuses': jsonEncode(bg.bonuses),
        'tool_choice': bg.toolChoice,
      });
      for (final (i, cl) in character.classLevels.indexed) {
        await insert('character_class_level', '$i', {
          'class_id': cl.classId,
          'level': cl.level,
          'subclass_id': cl.subclassId,
          'hp_roll': cl.hpRoll == null ? null : jsonEncode(cl.hpRoll),
          'skill_choices': jsonEncode(cl.skillChoices),
          'expertise': jsonEncode(cl.expertise),
          'position': i,
        });
      }
      for (final (i, f) in character.feats.indexed) {
        await insert('character_feat', '$i', {
          'feat_id': f.featId,
          'source_type': f.sourceType,
          'source_ref': f.sourceRef,
          'choices': f.choices == null ? null : jsonEncode(f.choices),
          'position': i,
        });
      }
      for (final m in character.weaponMasteries) {
        await insert('character_weapon_mastery', '${m.slotIndex}', {
          'weapon_id': m.weaponId,
          'slot_index': m.slotIndex,
        });
      }
      for (final (i, item) in character.items.indexed) {
        await insert('character_item', '$i', {
          'item_id': item.itemId,
          'quantity': item.quantity,
          'equipped': item.equipped,
          'attuned': item.attuned,
          'position': i,
        });
      }
      for (final (i, language) in character.languages.indexed) {
        await insert('character_language', '$i', {
          'language_id': language,
          'position': i,
        });
      }
      for (final MapEntry(:key, :value) in character.choices.entries) {
        await insert('character_choice', key, {
          'choice_key': key,
          'selections': jsonEncode(value),
        });
      }
    },
  );

  /// Relit le personnage [id], ou `null` s'il n'existe pas.
  Future<CharacterInput?> load(String id) async {
    Future<List<Map<String, Object?>>> rows(
      String table, [
      String? order,
    ]) async => [
      for (final row
          in await _db
              .customSelect(
                'SELECT * FROM $table WHERE '
                '${table == 'character' ? 'id' : 'character_id'} = ?'
                '${order == null ? '' : ' ORDER BY $order'}',
                variables: [Variable<String>(id)],
              )
              .get())
        row.data,
    ];

    final character = await rows('character');
    if (character.isEmpty) return null;
    final c = character.single;
    final scores = await rows('character_base_scores');
    final bg = (await rows('character_background_choice')).single;
    Object? json(Object? text) => text == null ? null : jsonDecode('$text');

    return CharacterInput.fromJson({
      'name': c['name'],
      'player': c['player'],
      'kind': c['kind'],
      'species_id': c['species_id'],
      'species_choices': json(c['species_choices']),
      'background_id': c['background_id'],
      'base_scores': {
        'method': scores.first['method'],
        if (c['score_rolls'] != null) 'rolls': json(c['score_rolls']),
        for (final s in scores) s['ability_id']! as String: s['base'],
      },
      'background_choice': {
        'distribution': bg['distribution'],
        'bonuses': json(bg['bonuses']),
        if (bg['tool_choice'] != null) 'tool_choice': bg['tool_choice'],
      },
      'class_levels': [
        for (final cl in await rows('character_class_level', 'position'))
          {
            'class_id': cl['class_id'],
            'level': cl['level'],
            'subclass_id': cl['subclass_id'],
            'hp_roll': json(cl['hp_roll']),
            'skill_choices': json(cl['skill_choices']),
            'expertise': json(cl['expertise']),
          },
      ],
      'feats': [
        for (final f in await rows('character_feat', 'position'))
          {
            'feat_id': f['feat_id'],
            'source_type': f['source_type'],
            'source_ref': f['source_ref'],
            if (f['choices'] != null) 'choices': json(f['choices']),
          },
      ],
      'choices': {
        for (final ch in await rows('character_choice', 'choice_key'))
          ch['choice_key']! as String: json(ch['selections']),
      },
      'languages': [
        for (final l in await rows('character_language', 'position'))
          l['language_id'],
      ],
      'weapon_masteries': [
        for (final m in await rows('character_weapon_mastery', 'slot_index'))
          {'weapon_id': m['weapon_id'], 'slot_index': m['slot_index']},
      ],
      'items': [
        for (final item in await rows('character_item', 'position'))
          {
            'item_id': item['item_id'],
            'quantity': item['quantity'],
            'equipped': item['equipped'] == 1,
            'attuned': item['attuned'] == 1,
          },
      ],
      'xp': c['xp'],
    });
  }
}
