// Diffusion des packs activés sur une table (US-30 lot b, EF-HB-09) : le
// fichier de la version figée va dans le bucket privé `packs` sous son
// empreinte ; chaque membre télécharge, vérifie et installe ceux qui lui
// manquent.
import 'dart:async';
import 'dart:typed_data';

import 'package:crypto/crypto.dart';
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../account/account_providers.dart';
import '../creation/creation_providers.dart';

/// Stockage des fichiers de packs, sous `{sha256}.dndpack`.
abstract interface class PackStorage {
  Future<void> upload(String sha256, Uint8List bytes);
  Future<Uint8List> download(String sha256);
}

/// Le bucket `packs` de Supabase.
final class SupabasePackStorage implements PackStorage {
  SupabasePackStorage(this._client);

  final SupabaseClient _client;

  StorageFileApi get _bucket => _client.storage.from('packs');

  @override
  Future<void> upload(String sha256, Uint8List bytes) async {
    try {
      await _bucket.uploadBinary(
        '$sha256.dndpack',
        bytes,
        fileOptions: const FileOptions(contentType: 'application/zip'),
      );
    } on StorageException catch (e) {
      // Déjà déposé : le fichier est le même, il est nommé par son contenu.
      if (e.statusCode != '409') rethrow;
    }
  }

  @override
  Future<Uint8List> download(String sha256) =>
      _bucket.download('$sha256.dndpack');
}

/// Stockage des packs ; `null` sans comptes (mode local, rien à diffuser).
final packStorageProvider = Provider<PackStorage?>(
  (ref) =>
      accountsConfigured ? SupabasePackStorage(Supabase.instance.client) : null,
);

/// Empreinte sha256 d'un fichier, en hexadécimal.
String fileSha256(List<int> bytes) => '${sha256.convert(bytes)}';

/// Télécharge le fichier [sha], vérifie son empreinte et sa signature, puis
/// l'installe. Faux si le fichier est refusé.
Future<bool> fetchPack(
  TavernierDatabase db,
  PackStorage storage,
  String sha,
) async {
  final bytes = await storage.download(sha);
  if (fileSha256(bytes) != sha) return false;
  final ContentPack pack;
  try {
    pack = readDndpack(bytes);
  } on DndpackException {
    return false;
  }
  if (!await verifyPackSignature(pack.manifest)) return false;
  await PackLibrary(db).install(bytes);
  return true;
}

final _fetching = <String>{};

/// Installe chez ce membre les packs actifs de ses tables qui lui manquent.
/// À écouter depuis la racine de l'app ; un échec se retente au prochain
/// changement.
final packDownloaderProvider = Provider<void>((ref) {
  // Sans stockage (mode local), rien à recevoir : pas de flux ouvert.
  final storage = ref.watch(packStorageProvider);
  if (storage == null) return;
  final active = ref.watch(activePacksProvider).value;
  final have = ref.watch(libraryVersionsProvider).value;
  if (active == null || have == null) return;
  final db = ref.watch(databaseProvider);
  for (final p in active) {
    final sha = p.fileSha256;
    if (sha == null || have.contains('${p.packId}@${p.version}')) continue;
    if (!_fetching.add(sha)) continue;
    unawaited(
      fetchPack(db, storage, sha)
          .catchError((Object _) => false)
          .whenComplete(() => _fetching.remove(sha)),
    );
  }
});
