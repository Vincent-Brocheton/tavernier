import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// État d'une séance : « Préparée », « En cours », « Close ».
enum SessionStatus {
  planned('planned'),
  inProgress('in_progress'),
  closed('closed');

  const SessionStatus(this.code);

  final String code;

  static SessionStatus parse(String code) =>
      values.firstWhere((s) => s.code == code, orElse: () => planned);
}

/// Séance d'une table, avec son numéro « Séance n ».
final class GameSession {
  const GameSession({
    required this.id,
    required this.tableId,
    required this.number,
    required this.title,
    required this.date,
    required this.status,
  });

  final String id;
  final String tableId;
  final int number;
  final String title;
  final DateTime date;
  final SessionStatus status;
}

/// Séances d'une table et présences prévues (US-35, EF-SEA-01, EF-SEA-02).
final class SessionStore {
  SessionStore(this._db);

  final TavernierDatabase _db;

  static String _day(DateTime d) =>
      '${d.year.toString().padLeft(4, '0')}-'
      '${d.month.toString().padLeft(2, '0')}-'
      '${d.day.toString().padLeft(2, '0')}';

  Future<void> _write(
    String sql,
    List<Object?> args,
    TableInfo<Table, Object?> table,
  ) => _db.customUpdate(
    sql,
    variables: [for (final arg in args) Variable<Object>(arg)],
    updates: {table},
  );

  /// Crée une séance ; rend son identifiant.
  Future<String> create({
    required String tableId,
    required String title,
    required DateTime date,
    SessionStatus status = SessionStatus.planned,
  }) async {
    final id = uuidV7();
    await _write(
      'INSERT INTO session (id, table_id, title, date, status, created_at) '
      'VALUES (?, ?, ?, ?, ?, ?)',
      [
        id,
        tableId,
        title,
        _day(date),
        status.code,
        DateTime.now().toUtc().toIso8601String(),
      ],
      _db.sessions,
    );
    return id;
  }

  Future<void> update(
    String id, {
    String? title,
    DateTime? date,
    SessionStatus? status,
  }) async {
    final columns = {
      'title': ?title,
      if (date != null) 'date': _day(date),
      'status': ?status?.code,
    };
    if (columns.isEmpty) return;
    await _write(
      'UPDATE session SET ${columns.keys.map((c) => '$c = ?').join(', ')} '
      'WHERE id = ?',
      [...columns.values, id],
      _db.sessions,
    );
  }

  /// Supprime la séance et ses présences : les vues PowerSync n'ont pas de
  /// clés étrangères, rien ne part en cascade.
  Future<void> delete(String id) => _db.transaction(() async {
    await _write('DELETE FROM session_attendance WHERE session_id = ?', [
      id,
    ], _db.sessionAttendances);
    await _write('DELETE FROM session WHERE id = ?', [id], _db.sessions);
  });

  /// Séances de [tableId], la plus récente d'abord. Le numéro suit l'ordre
  /// des dates, puis de création.
  Stream<List<GameSession>> watchList(String tableId) => _db
      .customSelect(
        'SELECT id, table_id, title, date, status, row_number() OVER '
        '(ORDER BY date, created_at, id) AS number '
        'FROM session WHERE table_id = ? ORDER BY number DESC',
        variables: [Variable.withString(tableId)],
        readsFrom: {_db.sessions},
      )
      .watch()
      .map(
        (rows) => [
          for (final row in rows)
            GameSession(
              id: row.read<String>('id'),
              tableId: row.read<String>('table_id'),
              number: row.read<int>('number'),
              title: row.read<String>('title'),
              date: DateTime.parse(row.read<String>('date')),
              status: SessionStatus.parse(row.read<String>('status')),
            ),
        ],
      );

  /// Personnages prévus à la séance [sessionId].
  Stream<Set<String>> watchAttendance(String sessionId) => _db
      .customSelect(
        'SELECT character_id FROM session_attendance WHERE session_id = ?',
        variables: [Variable.withString(sessionId)],
        readsFrom: {_db.sessionAttendances},
      )
      .watch()
      .map((rows) => {for (final r in rows) r.read<String>('character_id')});

  /// Coche ou décoche [characterId] à la séance [sessionId].
  Future<void> setPresent(
    String sessionId,
    String characterId, {
    required bool present,
  }) {
    final id = '$sessionId:$characterId';
    return present
        ? _write(
            'INSERT INTO session_attendance '
            '(id, session_id, character_id, table_id) '
            'SELECT ?, id, ?, table_id FROM session WHERE id = ? '
            'AND NOT EXISTS (SELECT 1 FROM session_attendance WHERE id = ?)',
            [id, characterId, sessionId, id],
            _db.sessionAttendances,
          )
        : _write('DELETE FROM session_attendance WHERE id = ?', [
            id,
          ], _db.sessionAttendances);
  }
}
