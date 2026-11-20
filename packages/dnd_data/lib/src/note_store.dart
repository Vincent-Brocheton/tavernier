import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// Note (US-26) : son auteur, sa table, son rattachement (`table`,
/// `session`, `npc`, `encounter` et l'identifiant visé), son titre, son
/// texte en Markdown réduit, sa confidentialité et l'autre version d'un
/// conflit (EF-NOT-06).
typedef Note = ({
  String id,
  String ownerUserId,
  String? tableId,
  String scope,
  String? refId,
  String title,
  String content,
  bool private,
  DateTime? updatedAt,
  String? conflict,
});

/// Notes (US-26, EF-NOT-01 à 06) : privées par défaut, partageables avec la
/// table en lecture seule, modifiables par leur seul auteur.
final class NoteStore {
  NoteStore(this._db);

  final TavernierDatabase _db;

  static String _now() => DateTime.now().toUtc().toIso8601String();

  /// Écrit une note privée ; rend son identifiant.
  Future<String> create({
    required String ownerUserId,
    required String? tableId,
    required String scope,
    String? refId,
    String title = '',
    required String content,
  }) async {
    final id = uuidV7();
    await _db.customStatement(
      'INSERT INTO note (id, owner_user_id, table_id, scope, ref_id, title, '
      'content, private, updated_at) VALUES (?, ?, ?, ?, ?, ?, ?, 1, ?)',
      [id, ownerUserId, tableId, scope, refId, title, content, _now()],
    );
    _db.markTablesUpdated({_db.notes});
    return id;
  }

  /// Modifie la note [id] : seuls les champs donnés changent.
  Future<void> update(
    String id, {
    String? title,
    String? content,
    String? scope,
    String? refId,
    bool? private,
  }) async {
    final sets = {
      'title': ?title,
      'content': ?content,
      'scope': ?scope,
      'ref_id': ?refId,
      if (private != null) 'private': private ? 1 : 0,
      'updated_at': _now(),
    };
    await _db.customStatement(
      'UPDATE note SET ${[for (final k in sets.keys) '$k = ?'].join(', ')} '
      'WHERE id = ?',
      [...sets.values, id],
    );
    _db.markTablesUpdated({_db.notes});
  }

  /// Fusion d'un conflit : [content] remplace le texte, l'autre version
  /// disparaît (EF-NOT-06).
  Future<void> resolve(String id, String content) async {
    await _db.customStatement(
      'UPDATE note SET content = ?, conflict = NULL, updated_at = ? '
      'WHERE id = ?',
      [content, _now(), id],
    );
    _db.markTablesUpdated({_db.notes});
  }

  Future<void> delete(String id) async {
    await _db.customStatement('DELETE FROM note WHERE id = ?', [id]);
    _db.markTablesUpdated({_db.notes});
  }

  /// Notes que [userId] voit : les siennes et celles partagées, de la table
  /// [tableId] s'il est donné ; la plus récente d'abord.
  Stream<List<Note>> watchVisible(String userId, {String? tableId}) => _db
      .customSelect(
        'SELECT * FROM note WHERE (owner_user_id = ?1 OR private = 0) '
        'AND (?2 IS NULL OR table_id = ?2) '
        'ORDER BY updated_at DESC, id DESC',
        variables: [Variable.withString(userId), Variable(tableId)],
        readsFrom: {_db.notes},
      )
      .watch()
      .map(
        (rows) => [
          for (final row in rows)
            (
              id: row.read<String>('id'),
              ownerUserId: row.read<String>('owner_user_id'),
              tableId: row.readNullable<String>('table_id'),
              scope: row.read<String>('scope'),
              refId: row.readNullable<String>('ref_id'),
              title: row.read<String>('title'),
              content: row.read<String>('content'),
              private: row.read<int>('private') != 0,
              updatedAt: DateTime.tryParse(
                row.readNullable<String>('updated_at') ?? '',
              ),
              conflict: row.readNullable<String>('conflict'),
            ),
        ],
      );
}
