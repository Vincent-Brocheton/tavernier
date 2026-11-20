import 'dart:convert';

import 'package:drift/drift.dart';

import 'database.dart';
import 'ids.dart';

/// Brouillon d'un pack homebrew (US-27) : son manifeste et ses entités en
/// JSON brut, tels qu'ils iront dans un `.dndpack`, même incomplets.
typedef HomebrewDraft = ({
  String id,
  Map<String, Object?> manifest,
  List<Map<String, Object?>> entities,
  DateTime? updatedAt,
});

/// Brouillons homebrew de l'appareil (US-27, EF-HB-01) : locaux, jamais
/// synchronisés ; ils entrent dans le contenu au test ou à la publication.
final class HomebrewStore {
  HomebrewStore(this._db);

  final TavernierDatabase _db;

  static String _now() => DateTime.now().toUtc().toIso8601String();

  static String _json(
    Map<String, Object?> manifest,
    List<Map<String, Object?>> entities,
  ) => jsonEncode({'manifest': manifest, 'entities': entities});

  /// Crée un brouillon vide de [manifest] ; rend son identifiant.
  Future<String> create(Map<String, Object?> manifest) async {
    final id = uuidV7();
    await _db.customStatement(
      'INSERT INTO homebrew_draft (id, pack, updated_at) VALUES (?, ?, ?)',
      [id, _json(manifest, const []), _now()],
    );
    _db.markTablesUpdated({_db.homebrewDrafts});
    return id;
  }

  /// Enregistre le brouillon [id] en entier.
  Future<void> save(
    String id, {
    required Map<String, Object?> manifest,
    required List<Map<String, Object?>> entities,
  }) async {
    await _db.customStatement(
      'UPDATE homebrew_draft SET pack = ?, updated_at = ? WHERE id = ?',
      [_json(manifest, entities), _now(), id],
    );
    _db.markTablesUpdated({_db.homebrewDrafts});
  }

  Future<void> delete(String id) async {
    await _db.customStatement('DELETE FROM homebrew_draft WHERE id = ?', [id]);
    _db.markTablesUpdated({_db.homebrewDrafts});
  }

  /// Brouillons, le plus récemment modifié d'abord.
  Stream<List<HomebrewDraft>> watchAll() => _db
      .customSelect(
        'SELECT * FROM homebrew_draft ORDER BY updated_at DESC, id DESC',
        readsFrom: {_db.homebrewDrafts},
      )
      .watch()
      .map((rows) => [for (final row in rows) _draft(row)]);

  /// Le brouillon [id] ; `null` s'il n'existe plus.
  Stream<HomebrewDraft?> watch(String id) => _db
      .customSelect(
        'SELECT * FROM homebrew_draft WHERE id = ?',
        variables: [Variable.withString(id)],
        readsFrom: {_db.homebrewDrafts},
      )
      .watch()
      .map((rows) => rows.isEmpty ? null : _draft(rows.single));

  static HomebrewDraft _draft(QueryRow row) {
    final pack = jsonDecode(row.read<String>('pack')) as Map<String, Object?>;
    return (
      id: row.read<String>('id'),
      manifest: pack['manifest']! as Map<String, Object?>,
      entities: [
        for (final e in pack['entities']! as List) e as Map<String, Object?>,
      ],
      updatedAt: DateTime.tryParse(
        row.readNullable<String>('updated_at') ?? '',
      ),
    );
  }
}
