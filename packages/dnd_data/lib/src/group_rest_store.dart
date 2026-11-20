import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// Repos de groupe ouvert (US-38) : sa séance, `short` ou `long`, et les
/// fiches des PJ visés.
typedef GroupRest = ({
  String id,
  String tableId,
  String? sessionId,
  String kind,
  List<String> characters,
});

/// Repos de groupe (US-38, EF-PJ-19) : le MJ le déclenche et le clôt ;
/// chaque PJ visé le fait sur sa fiche, puis le signale terminé.
final class GroupRestStore {
  GroupRestStore(this._db);

  final TavernierDatabase _db;

  static String _now() => DateTime.now().toUtc().toIso8601String();

  /// Déclenche un repos [kind] pour [characters] ; rend son identifiant.
  Future<String> start({
    required String tableId,
    required String? sessionId,
    required String kind,
    required List<String> characters,
  }) async {
    final id = uuidV7();
    await _db.customStatement(
      'INSERT INTO group_rest (id, table_id, session_id, kind, characters, '
      'created_at) VALUES (?, ?, ?, ?, ?, ?)',
      [id, tableId, sessionId, kind, jsonEncode(characters), _now()],
    );
    _db.markTablesUpdated({_db.groupRests});
    return id;
  }

  /// Clôt le repos [id] : il n'est plus proposé aux joueurs.
  Future<void> close(String id) async {
    await _db.customStatement(
      'UPDATE group_rest SET closed_at = ? WHERE id = ?',
      [_now(), id],
    );
    _db.markTablesUpdated({_db.groupRests});
  }

  /// Signale le repos [restId] terminé pour [characterId], avec son
  /// récapitulatif (« 2 dés de vie dépensés »).
  Future<void> markDone({
    required String restId,
    required String tableId,
    required String characterId,
    required String? authorUserId,
    Map<String, Object?> summary = const {},
  }) async {
    await _db.customStatement(
      'INSERT INTO group_rest_done (id, rest_id, table_id, character_id, '
      'author_user_id, summary, created_at) VALUES (?, ?, ?, ?, ?, ?, ?)',
      [
        uuidV7(),
        restId,
        tableId,
        characterId,
        authorUserId,
        jsonEncode(summary),
        _now(),
      ],
    );
    _db.markTablesUpdated({_db.groupRestDones});
  }

  /// Repos ouverts de [tableId], le plus récent d'abord.
  Stream<List<GroupRest>> watchOpen(String tableId) => _db
      .customSelect(
        'SELECT * FROM group_rest WHERE table_id = ? AND closed_at IS NULL '
        'ORDER BY id DESC',
        variables: [Variable.withString(tableId)],
        readsFrom: {_db.groupRests},
      )
      .watch()
      .map((rows) => [for (final row in rows) _rest(row)]);

  /// Repos ouvert qui attend encore le PJ [characterId] ; `null` sinon.
  Stream<GroupRest?> watchForCharacter(String characterId) => _db
      .customSelect(
        'SELECT r.* FROM group_rest r, json_each(r.characters) c '
        'WHERE r.closed_at IS NULL AND c.value = ?1 AND NOT EXISTS ('
        'SELECT 1 FROM group_rest_done d '
        'WHERE d.rest_id = r.id AND d.character_id = ?1) '
        'ORDER BY r.id DESC LIMIT 1',
        variables: [Variable.withString(characterId)],
        readsFrom: {_db.groupRests, _db.groupRestDones},
      )
      .watch()
      .map((rows) => rows.isEmpty ? null : _rest(rows.single));

  /// Récapitulatifs du repos [restId], par fiche de PJ.
  Stream<Map<String, Map<String, Object?>>> watchDone(String restId) => _db
      .customSelect(
        'SELECT character_id, summary FROM group_rest_done WHERE rest_id = ?',
        variables: [Variable.withString(restId)],
        readsFrom: {_db.groupRestDones},
      )
      .watch()
      .map(
        (rows) => {
          for (final row in rows)
            row.read<String>('character_id'):
                jsonDecode(row.read<String>('summary')) as Map<String, Object?>,
        },
      );

  static GroupRest _rest(QueryRow row) => (
    id: row.read<String>('id'),
    tableId: row.read<String>('table_id'),
    sessionId: row.readNullable<String>('session_id'),
    kind: row.read<String>('kind'),
    characters: [
      for (final c in jsonDecode(row.read<String>('characters')) as List)
        c as String,
    ],
  );
}
