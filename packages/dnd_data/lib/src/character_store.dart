import 'dart:convert';

import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';
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

/// État de santé qualitatif d'un PJ, vu par les autres joueurs (EF-TAB-09).
enum Health { unhurt, wounded, badly }

/// Indemne au maximum de PV, blessé au-dessus de la moitié, gravement blessé
/// à la moitié ou moins (EF-TAB-09).
Health healthOf(int current, int max) => current >= max
    ? Health.unhurt
    : current * 2 > max
    ? Health.wounded
    : Health.badly;

/// Résumé d'une fiche de table (US-15) : ce que les autres joueurs en voient.
final class CharacterSummary {
  const CharacterSummary({
    required this.id,
    required this.tableId,
    required this.ownerUserId,
    required this.name,
    required this.speciesId,
    required this.classes,
    required this.health,
  });

  final String id;
  final String tableId;
  final String? ownerUserId;
  final String name;
  final String speciesId;
  final List<({String classId, int level})> classes;
  final Health health;

  String get _classesJson => jsonEncode([
    for (final c in classes) {'class_id': c.classId, 'level': c.level},
  ]);

  static CharacterSummary fromRow(QueryRow row) => CharacterSummary(
    id: row.read<String>('id'),
    tableId: row.read<String>('table_id'),
    ownerUserId: row.readNullable<String>('owner_user_id'),
    name: row.read<String>('name'),
    speciesId: row.read<String>('species_id'),
    classes: [
      for (final c in jsonDecode(
        row.readNullable<String>('classes') ?? '[]',
      ) as List<Object?>)
        if (c case {'class_id': final String id, 'level': final int level})
          (classId: id, level: level),
    ],
    health:
        Health.values.asNameMap()[row.read<String>('health')] ?? Health.unhurt,
  );

  @override
  bool operator ==(Object other) =>
      other is CharacterSummary &&
      other.id == id &&
      other.tableId == tableId &&
      other.ownerUserId == ownerUserId &&
      other.name == name &&
      other.speciesId == speciesId &&
      other._classesJson == _classesJson &&
      other.health == health;

  @override
  int get hashCode =>
      Object.hash(id, tableId, ownerUserId, name, speciesId, _classesJson);
}

/// Entrée de l'historique d'une fiche (`character_change_log`).
final class CharacterHistoryEntry {
  const CharacterHistoryEntry({
    required this.at,
    required this.authorUserId,
    required this.detail,
  });

  final DateTime at;
  final String? authorUserId;
  final Map<String, Object?> detail;
}

/// Écrit et relit un personnage stocké (`CharacterInput`) dans les tables
/// `character_*` (cahier §11.2). Aucun calcul de règles ici.
final class CharacterStore {
  CharacterStore(this._db);

  final TavernierDatabase _db;

  /// Enregistre [character] sous [id] ; un enregistrement existant est mis
  /// à jour sans toucher à son état de jeu ni à son historique. [tableId]
  /// rattache une fiche neuve à une table ; il n'est jamais effacé ensuite.
  Future<void> save(
    String id,
    CharacterInput character, {
    String? tableId,
  }) => _db.transaction(() async {
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
    await _upsert('character', 'id', id, columns, {
      'status': 'draft',
      'table_id': ?tableId,
    });
    // Lignes voulues, par table : seules les différences s'écrivent, pour
    // ne pas écraser ce qu'un autre appareil a modifié (ENF-03).
    final wanted = {
      for (final t in _inputTables) t: <String, Map<String, Object?>>{},
    };
    void insert(String table, String key, Map<String, Object?> row) =>
        wanted[table]!['$id:$table:$key'] = {'character_id': id, ...row};

    for (final code in abilityCodes) {
      insert('character_base_scores', code, {
        'ability_id': code,
        'base': character.baseScores.of(code),
        'method': base['method'],
      });
    }
    final bg = character.backgroundChoice;
    insert('character_background_choice', 'bg', {
      'distribution': bg.distribution,
      'bonuses': jsonEncode(bg.bonuses),
      'tool_choice': bg.toolChoice,
    });
    for (final (i, cl) in character.classLevels.indexed) {
      insert('character_class_level', '$i', {
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
      insert('character_feat', '$i', {
        'feat_id': f.featId,
        'source_type': f.sourceType,
        'source_ref': f.sourceRef,
        'choices': f.choices == null ? null : jsonEncode(f.choices),
        'position': i,
      });
    }
    for (final (i, m) in character.weaponMasteries.indexed) {
      insert('character_weapon_mastery', '$i', {
        'weapon_id': m.weaponId,
        'slot_index': m.slotIndex,
      });
    }
    for (final (i, item) in character.items.indexed) {
      insert('character_item', '$i', {
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
        insert('character_spell', '$source:${i.toString().padLeft(4, '0')}', {
          'spell_id': spell,
          'source': source,
          'prepared': spells.prepared.contains(spell),
          'in_spellbook': spells.spellbook.contains(spell),
          'class_id': spells.classes[spell],
        });
      }
    }
    for (final (i, language) in character.languages.indexed) {
      insert('character_language', '$i', {
        'language_id': language,
        'position': i,
      });
    }
    for (final MapEntry(:key, :value) in character.choices.entries) {
      insert('character_choice', key, {
        'choice_key': key,
        'selections': jsonEncode(value),
      });
    }
    for (final MapEntry(key: table, value: rows) in wanted.entries) {
      await _writeDifference(table, id, rows);
    }
    // Les requêtes observées (emplacements d'une table) voient la fiche.
    _db.markTablesUpdated({_db.characters, _db.characterClassLevels});
  });

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
        // Le résumé du groupe suit les PV (US-15).
        _db.markTablesUpdated({_db.characterStates});
      });

  /// Amène les lignes de [table] de la fiche [id] à [wanted] (par
  /// identifiant) : supprime, insère, ou met à jour. PowerSync n'envoie que
  /// les colonnes changées, et rien pour une ligne identique.
  Future<void> _writeDifference(
    String table,
    String id,
    Map<String, Map<String, Object?>> wanted,
  ) async {
    final existing = {
      for (final row
          in await _db
              .customSelect(
                'SELECT id FROM $table WHERE character_id = ?',
                variables: [Variable.withString(id)],
              )
              .get())
        row.read<String>('id'),
    };
    for (final gone in existing.difference(wanted.keys.toSet())) {
      await _db.customStatement('DELETE FROM $table WHERE id = ?', [gone]);
    }
    for (final MapEntry(key: rowId, value: row) in wanted.entries) {
      await _upsert(table, 'id', rowId, row);
    }
  }

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
      ...syncedTables.where(
        (t) => t.startsWith('character_') && t != 'character_summary',
      ),
    ]) {
      await _db.customStatement('DELETE FROM $table WHERE character_id = ?', [
        id,
      ]);
    }
    // Le résumé a pour identifiant celui de la fiche.
    await _db.customStatement('DELETE FROM character_summary WHERE id = ?', [
      id,
    ]);
    await _db.customStatement('DELETE FROM character WHERE id = ?', [id]);
  });

  /// Statut de la fiche : `draft`, `submitted`, `validated`,
  /// `changes_requested` ou `archived`.
  Future<String?> status(String id) async =>
      (await _db
              .customSelect(
                'SELECT status FROM character WHERE id = ?',
                variables: [Variable.withString(id)],
              )
              .getSingleOrNull())
          ?.read<String>('status');

  /// Change le statut ; le serveur n'accepte que les passages permis.
  Future<void> setStatus(String id, String status) async {
    await _db.customStatement('UPDATE character SET status = ? WHERE id = ?', [
      status,
      id,
    ]);
    _db.markTablesUpdated({_db.characters});
  }

  /// Personnages libres de [ownerUserId] : sans table, non archivés, à lui ou
  /// pas encore envoyés (cahier §4.3).
  Future<List<({String id, String name})>> freeCharacters(
    String ownerUserId,
  ) async => [
    for (final row
        in await _db
            .customSelect(
              'SELECT id, name FROM character WHERE table_id IS NULL '
              "AND status <> 'archived' "
              'AND (owner_user_id IS NULL OR owner_user_id = ?) ORDER BY id',
              variables: [Variable.withString(ownerUserId)],
            )
            .get())
      (id: row.read<String>('id'), name: row.read<String>('name')),
  ];

  /// Inscrit des dérogations du MJ dans l'historique de la fiche, sans
  /// notification (cahier §4.3). Chaque entrée : `check`, `table`, `sheet`,
  /// `message` facultatif.
  Future<void> addDerogations(
    String id,
    String authorUserId,
    List<Map<String, Object?>> derogations,
  ) async {
    await _db.transaction(() async {
      for (final derogation in derogations) {
        await _db.customStatement(
          'INSERT INTO character_change_log (id, character_id, '
          'author_user_id, timestamp, diff) VALUES (?, ?, ?, ?, ?)',
          [
            uuidV7(),
            id,
            authorUserId,
            DateTime.now().toUtc().toIso8601String(),
            jsonEncode({'kind': 'derogation', ...derogation}),
          ],
        );
      }
    });
    _db.markTablesUpdated({_db.characterChangeLogs});
  }

  /// Historique de la fiche, le plus récent d'abord.
  Future<List<CharacterHistoryEntry>> history(String id) async => [
    for (final row
        in await _db
            .customSelect(
              'SELECT * FROM character_change_log WHERE character_id = ? '
              'ORDER BY timestamp DESC, id DESC',
              variables: [Variable.withString(id)],
            )
            .get())
      CharacterHistoryEntry(
        at: DateTime.parse(row.read<String>('timestamp')),
        authorUserId: row.readNullable<String>('author_user_id'),
        detail: jsonDecode(row.read<String>('diff')) as Map<String, Object?>,
      ),
  ];

  /// Publie le résumé d'une fiche de table, seulement s'il a changé : rien
  /// ne part au serveur pour rien. Rend `true` s'il a été écrit.
  Future<bool> publishSummary(CharacterSummary summary) async {
    final row = await _db
        .customSelect(
          'SELECT * FROM character_summary WHERE id = ?',
          variables: [Variable.withString(summary.id)],
        )
        .getSingleOrNull();
    if (row != null && CharacterSummary.fromRow(row) == summary) return false;
    await _upsert('character_summary', 'id', summary.id, {
      'table_id': summary.tableId,
      'owner_user_id': summary.ownerUserId,
      'name': summary.name,
      'species_id': summary.speciesId,
      'classes': summary._classesJson,
      'health': summary.health.name,
      'updated_at': DateTime.now().toUtc().toIso8601String(),
    });
    _db.markTablesUpdated({_db.characterSummaries});
    return true;
  }

  /// Envoie la fiche au MJ, avec un message facultatif (US-15).
  Future<void> submit(String id, String? message) =>
      _update(id, {'status': 'submitted', 'submit_message': message});

  /// Reprend une fiche envoyée.
  Future<void> withdraw(String id) => setStatus(id, 'draft');

  /// Revue du MJ : fiche validée, ou corrections demandées avec [comment].
  Future<void> review(
    String id, {
    required bool validated,
    required String? comment,
  }) => _update(id, {
    'status': validated ? 'validated' : 'changes_requested',
    'review_comment': comment,
  });

  Future<void> _update(String id, Map<String, Object?> columns) async {
    await _db.customStatement(
      'UPDATE character SET ${columns.keys.map((c) => '$c = ?').join(', ')} '
      'WHERE id = ?',
      [...columns.values, id],
    );
    _db.markTablesUpdated({_db.characters});
  }

  /// Personnages de l'appareil. Avec [ownerUserId], seulement ceux de cet
  /// utilisateur et ceux pas encore envoyés : un MJ reçoit aussi les fiches
  /// de ses joueurs.
  Future<List<({String id, CharacterInput character})>> list({
    String? ownerUserId,
  }) async {
    final rows = await _db
        .customSelect(
          'SELECT id FROM character '
          '${ownerUserId == null ? '' : 'WHERE owner_user_id IS NULL OR owner_user_id = ? '}'
          'ORDER BY id',
          variables: [
            if (ownerUserId != null) Variable.withString(ownerUserId),
          ],
        )
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
