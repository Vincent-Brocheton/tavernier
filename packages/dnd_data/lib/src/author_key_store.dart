import 'dart:convert';

import 'package:dnd_content/dnd_content.dart';

import 'database.dart';
import 'ids.dart';

/// Clé Ed25519 de l'auteur sur cet appareil (US-29, EF-HB-05) : créée à la
/// première demande, puis toujours la même. Une seule par appareil.
final class AuthorKeyStore {
  AuthorKeyStore(this._db);

  final TavernierDatabase _db;

  /// Graine privée de 32 octets ; la paire s'en tire par `authorKeyPair`.
  Future<List<int>> seed() => _db.transaction(() async {
    final row = await _db
        .customSelect('SELECT seed FROM author_key LIMIT 1')
        .getSingleOrNull();
    if (row != null) return base64.decode(row.read<String>('seed'));
    final seed = await newAuthorSeed();
    final keys = await authorKeyPair(seed);
    final publicKey = await keys.extractPublicKey();
    await _db.customStatement(
      'INSERT INTO author_key (id, seed, public_key) VALUES (?, ?, ?)',
      [uuidV7(), base64.encode(seed), base64.encode(publicKey.bytes)],
    );
    return seed;
  });
}
