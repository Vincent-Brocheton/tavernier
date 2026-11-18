import 'dart:convert';

import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// Événement à écrire : son type et ses données.
typedef NewCombatEvent = (CombatEventType type, Map<String, Object?> payload);

/// Journal du combat (US-20, cahier §10) : ajout seul ; l'état d'une
/// rencontre est la projection de ses événements.
final class CombatStore {
  CombatStore(this._db);

  final TavernierDatabase _db;

  /// Ajoute [events] au journal de [encounterId], en une transaction ;
  /// leurs identifiants UUID v7 donnent l'ordre du journal.
  Future<void> append(
    String encounterId,
    List<NewCombatEvent> events, {
    required String? authorUserId,
  }) => _db.transaction(() async {
    // Sans rencontre locale, rien ne s'écrirait : le dire plutôt que perdre
    // l'événement. (Les vues PowerSync ne comptent pas les lignes écrites.)
    final known = await _db
        .customSelect(
          'SELECT 1 FROM encounter WHERE id = ?',
          variables: [Variable.withString(encounterId)],
        )
        .getSingleOrNull();
    if (known == null) {
      throw StateError('rencontre introuvable : $encounterId');
    }
    final now = DateTime.now().toUtc().toIso8601String();
    for (final (type, payload) in events) {
      await _db.customUpdate(
        'INSERT INTO encounter_event (id, encounter_id, table_id, '
        'author_user_id, type, payload, created_at) '
        'SELECT ?, id, table_id, ?, ?, ?, ? FROM encounter WHERE id = ?',
        variables: [
          Variable.withString(uuidV7()),
          Variable(authorUserId),
          Variable.withString(type.code),
          Variable.withString(jsonEncode(payload)),
          Variable.withString(now),
          Variable.withString(encounterId),
        ],
        updates: {_db.encounterEvents},
      );
    }
  });

  /// Lance la rencontre : « En cours », et ses premiers [events].
  Future<void> launch(
    String encounterId,
    List<NewCombatEvent> events, {
    required String? authorUserId,
  }) => _db.transaction(() async {
    await _setStatus(encounterId, 'running');
    await append(encounterId, events, authorUserId: authorUserId);
  });

  /// Termine la rencontre.
  Future<void> finish(String encounterId) =>
      _setStatus(encounterId, 'finished');

  Future<void> _setStatus(String encounterId, String status) =>
      _db.customUpdate(
        'UPDATE encounter SET status = ? WHERE id = ?',
        variables: [
          Variable.withString(status),
          Variable.withString(encounterId),
        ],
        updates: {_db.encounters},
      );

  /// Journal de [encounterId], dans l'ordre de ses identifiants.
  Stream<List<CombatEvent>> watchEvents(String encounterId) => _db
      .customSelect(
        'SELECT id, type, payload FROM encounter_event '
        'WHERE encounter_id = ? ORDER BY id',
        variables: [Variable.withString(encounterId)],
        readsFrom: {_db.encounterEvents},
      )
      .watch()
      .map(
        (rows) => [
          for (final row in rows)
            CombatEvent.fromJson({
              'id': row.read<String>('id'),
              'type': row.read<String>('type'),
              'payload': jsonDecode(row.read<String>('payload')),
            }),
        ],
      );

  /// État de la rencontre : la projection de son journal.
  Stream<CombatState> watchState(String encounterId) =>
      watchEvents(encounterId).map(projectCombat);
}
