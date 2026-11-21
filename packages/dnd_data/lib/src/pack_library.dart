import 'dart:convert';
import 'dart:typed_data';

import 'package:dnd_content/dnd_content.dart';
import 'package:drift/drift.dart' show Variable;

import 'database.dart';
import 'ids.dart';
import 'pack_store.dart';

/// Bibliothèque des packs importés (US-30, EF-HB-06 à 09) : chaque version
/// gardée telle que reçue dans `pack_file`, et la plus récente de chaque
/// pack dans les tables de contenu.
final class PackLibrary {
  PackLibrary(this._db);

  final TavernierDatabase _db;

  /// Le pack d'une ligne : relu depuis son fichier, renommé si c'est un
  /// pack distinct, avec les noms donnés dans la bibliothèque.
  static ContentPack _packOf(Map<String, Object?> row) {
    var pack = readDndpack(row['bytes']! as Uint8List);
    final packId = row['pack_id']! as String;
    if (packId != pack.manifest.id) {
      pack = rebrandPack(
        pack,
        id: packId,
        namespace: row['namespace']! as String,
        name: row['name']! as String,
      );
    }
    final renames = (jsonDecode(row['renames']! as String) as Map)
        .cast<String, String>();
    return ContentPack(
      manifest: pack.manifest.copyWith(origin: PackOrigin.imported),
      entities: [
        for (final e in pack.entities)
          if (renames['${e.id}'] case final name?)
            parseEntity({...e.toJson(), 'name': name}, 'renames').entity!
          else
            e,
      ],
    );
  }

  Future<List<Map<String, Object?>>> _rows([String? packId]) async => [
    for (final r
        in await _db
            .customSelect(
              'SELECT * FROM pack_file'
              '${packId == null ? '' : ' WHERE pack_id = ?'} ORDER BY imported_at',
              variables: [if (packId != null) Variable.withString(packId)],
            )
            .get())
      r.data,
  ];

  /// Chaque version gardée par l'appareil.
  Future<List<InstalledVersion>> installed() async => [
    for (final row in await _rows())
      (
        packId: row['pack_id']! as String,
        sourceId: row['source_id']! as String,
        authorKey: row['author_public_key'] as String?,
        version: row['version']! as String,
        pack: _packOf(row),
      ),
  ];

  /// Une version donnée d'un pack, ou `null`.
  Future<ContentPack?> version(String packId, String version) async {
    for (final row in await _rows(packId)) {
      if (row['version'] == version) return _packOf(row);
    }
    return null;
  }

  /// Garde la version de [bytes] ; [packId], [namespace] et [name] en font
  /// un pack distinct. Si c'est la plus récente de ce pack, elle remplace
  /// le pack dans les tables de contenu. Rend l'identifiant local.
  Future<String> install(
    List<int> bytes, {
    String? packId,
    String? namespace,
    String? name,
    Map<String, String> renames = const {},
  }) async {
    final pack = readDndpack(bytes);
    final m = pack.manifest;
    final id = packId ?? m.id;
    final row = {
      'id': uuidV7(),
      'pack_id': id,
      'source_id': m.id,
      'version': m.version,
      'namespace': namespace ?? m.namespace,
      'name': name ?? m.name,
      'author_public_key': m.authorPublicKey,
      'checksum': m.checksum ?? sha256Checksum(bytes),
      'bytes': Uint8List.fromList(bytes),
      'renames': jsonEncode(renames),
      'imported_at': DateTime.now().toUtc().toIso8601String(),
    };
    final older = [
      for (final r in await _rows(id))
        if (compareVersions('${r['version']}', m.version) > 0) r,
    ];
    await _db.customStatement(
      'INSERT INTO pack_file (${row.keys.join(', ')}) '
      'VALUES (${[for (final _ in row.keys) '?'].join(', ')})',
      row.values.toList(),
    );
    if (older.isEmpty) await PackStore(_db).importPack(_packOf(row));
    return id;
  }
}
