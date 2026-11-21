import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// Vue du combat d'une rencontre, publiée pour les joueurs (US-36).
typedef PublishedCombatView = ({
  String encounterId,
  String tableId,
  Map<String, Object?> payload,
  DateTime? updatedAt,
});

/// Demande d'un joueur pour son PJ (US-36, EF-VJ-05, 06).
typedef CombatRequest = ({
  String id,
  String encounterId,
  String characterId,
  String? authorUserId,
  String type,
  Map<String, Object?> payload,
});

/// Vue du combat des joueurs (US-36, EF-VJ-03) : l'appareil du MJ la
/// publie, les membres la lisent ; le journal reste au MJ.
final class CombatViewStore {
  CombatViewStore(this._db);

  final TavernierDatabase _db;

  /// Publie [payload] pour [encounterId] ; rien n'est écrit s'il n'a pas
  /// changé. Rend vrai si la vue a été écrite. Lecture et écriture vont
  /// dans une transaction : deux publications simultanées inséreraient
  /// sinon chacune la vue (contrainte d'unicité).
  Future<bool> publish({
    required String encounterId,
    required String tableId,
    required Map<String, Object?> payload,
  }) => _db.transaction(() async {
    final json = jsonEncode(payload);
    final row = await _db
        .customSelect(
          'SELECT payload FROM combat_view WHERE id = ?',
          variables: [Variable.withString(encounterId)],
        )
        .getSingleOrNull();
    if (row?.read<String>('payload') == json) return false;
    final now = DateTime.now().toUtc().toIso8601String();
    if (row == null) {
      await _db.customStatement(
        'INSERT INTO combat_view (id, table_id, payload, updated_at) '
        'VALUES (?, ?, ?, ?)',
        [encounterId, tableId, json, now],
      );
    } else {
      await _db.customStatement(
        'UPDATE combat_view SET payload = ?, updated_at = ? WHERE id = ?',
        [json, now, encounterId],
      );
    }
    _db.markTablesUpdated({_db.combatViews});
    return true;
  });

  /// Retire la vue de [encounterId] : la rencontre est terminée.
  Future<void> remove(String encounterId) async {
    await _db.customStatement('DELETE FROM combat_view WHERE id = ?', [
      encounterId,
    ]);
    _db.markTablesUpdated({_db.combatViews});
  }

  /// Vues des rencontres de [tableId], la plus récente d'abord.
  Stream<List<PublishedCombatView>> watchTable(String tableId) => _db
      .customSelect(
        'SELECT * FROM combat_view WHERE table_id = ? ORDER BY updated_at DESC',
        variables: [Variable.withString(tableId)],
        readsFrom: {_db.combatViews},
      )
      .watch()
      .map((rows) => [for (final row in rows) _view(row)]);

  /// Vue de [encounterId] ; `null` sans vue publiée.
  Stream<PublishedCombatView?> watch(String encounterId) => _db
      .customSelect(
        'SELECT * FROM combat_view WHERE id = ?',
        variables: [Variable.withString(encounterId)],
        readsFrom: {_db.combatViews},
      )
      .watch()
      .map((rows) => rows.isEmpty ? null : _view(rows.single));

  /// Vue la plus récente où figure le PJ [characterId] ; `null` s'il
  /// n'est dans aucun combat en cours (EF-VJ-01).
  Stream<PublishedCombatView?> watchCharacter(String characterId) => _db
      .customSelect(
        'SELECT * FROM combat_view '
        r"WHERE json_extract(payload, '$.pcs.' || json_quote(?)) IS NOT NULL "
        'ORDER BY updated_at DESC LIMIT 1',
        variables: [Variable.withString(characterId)],
        readsFrom: {_db.combatViews},
      )
      .watch()
      .map((rows) => rows.isEmpty ? null : _view(rows.single));

  static PublishedCombatView _view(QueryRow row) => (
    encounterId: row.read<String>('id'),
    tableId: row.read<String>('table_id'),
    payload: jsonDecode(row.read<String>('payload')) as Map<String, Object?>,
    updatedAt: DateTime.tryParse(row.readNullable<String>('updated_at') ?? ''),
  );
}

/// Demandes des joueurs (US-36) : le joueur les envoie, l'appareil du MJ
/// les applique au journal puis les retire.
final class CombatRequestStore {
  CombatRequestStore(this._db);

  final TavernierDatabase _db;

  /// Envoie une demande pour le PJ [characterId] ; rend son identifiant.
  /// Hors-ligne, elle part à la reconnexion (EF-VJ-06).
  Future<String> send({
    required String encounterId,
    required String tableId,
    required String characterId,
    required String? authorUserId,
    required String type,
    Map<String, Object?> payload = const {},
  }) async {
    final id = uuidV7();
    await _db.customStatement(
      'INSERT INTO combat_request (id, encounter_id, table_id, character_id, '
      'author_user_id, type, payload, created_at) '
      'VALUES (?, ?, ?, ?, ?, ?, ?, ?)',
      [
        id,
        encounterId,
        tableId,
        characterId,
        authorUserId,
        type,
        jsonEncode(payload),
        DateTime.now().toUtc().toIso8601String(),
      ],
    );
    _db.markTablesUpdated({_db.combatRequests});
    return id;
  }

  /// Demandes de [encounterId], dans l'ordre d'envoi.
  Stream<List<CombatRequest>> watch(String encounterId) => _db
      .customSelect(
        'SELECT * FROM combat_request WHERE encounter_id = ? ORDER BY id',
        variables: [Variable.withString(encounterId)],
        readsFrom: {_db.combatRequests},
      )
      .watch()
      .map(
        (rows) => [
          for (final row in rows)
            (
              id: row.read<String>('id'),
              encounterId: row.read<String>('encounter_id'),
              characterId: row.read<String>('character_id'),
              authorUserId: row.readNullable<String>('author_user_id'),
              type: row.read<String>('type'),
              payload: jsonDecode(
                row.read<String>('payload'),
              ) as Map<String, Object?>,
            ),
        ],
      );

  /// Retire la demande [id], appliquée par le MJ.
  Future<void> remove(String id) async {
    await _db.customStatement('DELETE FROM combat_request WHERE id = ?', [id]);
    _db.markTablesUpdated({_db.combatRequests});
  }
}
