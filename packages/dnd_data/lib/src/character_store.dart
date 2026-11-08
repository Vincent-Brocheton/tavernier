import 'dart:convert';

import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart';

import 'database.dart';
import 'powersync.dart';

/// Tables qui contiennent l'entrée stockée d'un personnage ; l'état de jeu,
/// l'historique et les références de contenu n'en font pas partie.
const _inputTables = [
  'character_base_scores',
  'character_background_choice',
  'character_class_level',
  'character_feat',
  'character_weapon_mastery',
  'character_item',
  'character_spell',
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
      final columns = {
        'kind': character.kind,
        'name': character.name,
        'player': character.player,
        'species_id': character.speciesId,
        'species_choices': jsonEncode(character.speciesChoices),
        'background_id': character.backgroundId,
        'xp': character.xp,
        'score_rolls': base['rolls'] == null ? null : jsonEncode(base['rolls']),
        'coins': jsonEncode(character.coins),
        'alignment': character.alignment,
        'appearance': character.appearance,
        'personality': character.personality,
        'backstory': character.backstory,
      };
      await _upsert('character', 'id', id, columns, {'status': 'draft'});
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
      for (final (i, m) in character.weaponMasteries.indexed) {
        await insert('character_weapon_mastery', '$i', {
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
      final spells = character.spells;
      for (final (source, list) in [
        ('cantrip', spells.cantrips),
        ('class', {...spells.spellbook, ...spells.prepared}),
      ]) {
        for (final (i, spell) in list.indexed) {
          // Clé ordonnée : la relecture trie par id (une vue n'a pas de rowid).
          await insert(
            'character_spell',
            '$source:${i.toString().padLeft(4, '0')}',
            {
              'spell_id': spell,
              'source': source,
              'prepared': spells.prepared.contains(spell),
              'in_spellbook': spells.spellbook.contains(spell),
              'class_id': spells.classes[spell],
            },
          );
        }
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

  /// Personnages enregistrés, du plus ancien au plus récent.
  /// État de jeu de [id] ; vide si rien n'a encore été dépensé.
  Future<PlayState> loadState(String id) async {
    final rows = await _db
        .customSelect(
          'SELECT resources, concentration_spell_id, hp_current, exhaustion, '
          'heroic_inspiration FROM character_state '
          'WHERE character_id = ?',
          variables: [Variable.withString(id)],
        )
        .get();
    if (rows.isEmpty) return const PlayState();
    final resources = jsonDecode(
      rows.single.read<String>('resources'),
    ) as Map<String, Object?>;
    return PlayState(
      used: {
        for (final MapEntry(:key, :value) in resources.entries)
          key: value! as int,
      },
      concentrationSpellId: rows.single.readNullable<String>(
        'concentration_spell_id',
      ),
      hpCurrent: rows.single.readNullable<int>('hp_current'),
      exhaustion: rows.single.read<int>('exhaustion'),
      heroicInspiration: rows.single.read<bool>('heroic_inspiration'),
    );
  }

  /// Enregistre l'état de jeu de [id], sans toucher au reste de la fiche.
  Future<void> saveState(String id, PlayState state) =>
      _db.transaction(() async {
        final columns = {
          'resources': jsonEncode(state.used),
          'concentration_spell_id': state.concentrationSpellId,
          'hp_current': state.hpCurrent,
          'exhaustion': state.exhaustion,
          'heroic_inspiration': state.heroicInspiration,
        };
        await _upsert('character_state', 'character_id', id, columns);
      });

  /// Met à jour la ligne de [table] où [key] vaut [id], ou l'insère. Pas
  /// d'UPSERT : SQLite le refuse sur une vue, et une mise à jour de vue ne
  /// compte aucune ligne modifiée.
  Future<void> _upsert(
    String table,
    String key,
    String id,
    Map<String, Object?> columns, [
    Map<String, Object?> onInsert = const {},
  ]) async {
    List<Object?> sql(Iterable<Object?> values) => [
      for (final v in values) v is bool ? (v ? 1 : 0) : v,
    ];
    await _db.customStatement(
      'UPDATE $table SET ${columns.keys.map((c) => '$c = ?').join(', ')} '
      'WHERE $key = ?',
      sql([...columns.values, id]),
    );
    final values = {'id': id, key: id, ...onInsert, ...columns};
    await _db.customStatement(
      'INSERT INTO $table (${values.keys.join(', ')}) '
      'SELECT ${List.filled(values.length, '?').join(', ')} '
      'WHERE NOT EXISTS (SELECT 1 FROM $table WHERE $key = ?)',
      sql([...values.values, id]),
    );
  }

  /// Supprime le personnage [id] et tout son contenu. Les tables
  /// synchronisées n'ont pas de clés étrangères locales : rien ne part en
  /// cascade.
  Future<void> delete(String id) => _db.transaction(() async {
    for (final table in [
      ...syncedTables.where((t) => t.startsWith('character_')),
    ]) {
      await _db.customStatement('DELETE FROM $table WHERE character_id = ?', [
        id,
      ]);
    }
    await _db.customStatement('DELETE FROM character WHERE id = ?', [id]);
  });

  Future<List<({String id, CharacterInput character})>> list() async {
    final rows = await _db
        .customSelect('SELECT id FROM character ORDER BY id')
        .get();
    return [
      for (final row in rows)
        (
          id: row.read<String>('id'),
          character: (await load(row.read<String>('id')))!,
        ),
    ];
  }

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
    final spells = await rows('character_spell', 'id');

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
      'spells': {
        'cantrips': [
          for (final s in spells)
            if (s['source'] == 'cantrip') s['spell_id'],
        ],
        'prepared': [
          for (final s in spells)
            if (s['prepared'] == 1) s['spell_id'],
        ],
        'spellbook': [
          for (final s in spells)
            if (s['in_spellbook'] == 1) s['spell_id'],
        ],
        'classes': {
          for (final s in spells)
            if (s['class_id'] case final String classId)
              s['spell_id']! as String: classId,
        },
      },
      'coins': json(c['coins']),
      'alignment': c['alignment'],
      'appearance': c['appearance'],
      'personality': c['personality'],
      'backstory': c['backstory'],
      'xp': c['xp'],
    });
  }
}
