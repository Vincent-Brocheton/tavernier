import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:crypto/crypto.dart';
import 'package:cryptography/cryptography.dart';

import '../entities/content_entity.dart';
import 'content_pack.dart';
import 'manifest.dart';

/// Plafonds à la lecture d'un pack (ENF-09).
const maxPackBytes = 20 * 1024 * 1024;
const maxPackEntities = 10000;
const maxJsonDepth = 32;

const _manifestFile = 'manifest.json';
const _entitiesFile = 'entities.json';

/// Horodatage fixe des fichiers : l'archive est déterministe.
final _epoch = DateTime.utc(2000);

/// Pack refusé à la lecture.
final class DndpackException implements Exception {
  const DndpackException(this.message);

  final String message;

  @override
  String toString() => 'DndpackException : $message';
}

String sha256Checksum(List<int> bytes) => 'sha256:${sha256.convert(bytes)}';

/// Entités triées par id et `entities.json` qui les porte.
(List<ContentEntity>, List<int>) _body(ContentPack pack) {
  final entities = [...pack.entities]
    ..sort((a, b) => '${a.id}'.compareTo('${b.id}'));
  return (
    entities,
    utf8.encode(
      const JsonEncoder.withIndent('  ')
          .convert([for (final e in entities) e.toJson()]),
    ),
  );
}

List<int> _json(Object? value) =>
    utf8.encode(const JsonEncoder.withIndent('  ').convert(value));

/// Écrit l'archive `.dndpack` : manifeste complété, entités triées par id.
/// Une signature déjà portée par le manifeste est gardée.
List<int> writeDndpack(ContentPack pack) {
  final (entities, body) = _body(pack);
  final manifest = pack.manifest.withContent(
    entityCount: entities.length,
    checksum: sha256Checksum(body),
  );
  final archive = Archive();
  for (final (name, bytes) in [
    (_manifestFile, _json(manifest.toJson())),
    (_entitiesFile, body),
  ]) {
    archive.addFile(
      ArchiveFile.bytes(name, bytes)
        ..lastModTime = _epoch.millisecondsSinceEpoch ~/ 1000,
    );
  }
  return ZipEncoder().encodeBytes(archive, modified: _epoch);
}

/// Lit une archive `.dndpack` ; lève [DndpackException] si elle est refusée.
ContentPack readDndpack(List<int> bytes) {
  if (bytes.length > maxPackBytes) {
    throw const DndpackException('archive de plus de 20 Mo');
  }
  final Archive archive;
  try {
    archive = ZipDecoder().decodeBytes(bytes);
  } on Object {
    throw const DndpackException('archive zip illisible');
  }
  List<int> file(String name) {
    final entry =
        archive.findFile(name) ??
        (throw DndpackException('fichier $name absent de l\'archive'));
    // Taille annoncée par le zip, vérifiée avant toute décompression.
    if (entry.size > maxPackBytes) {
      throw DndpackException('$name décompressé dépasse 20 Mo');
    }
    return entry.content as List<int>;
  }

  final manifestResult = PackManifest.parse(
    _decode(file(_manifestFile), _manifestFile),
  );
  final manifest =
      manifestResult.manifest ??
      (throw DndpackException(
        'manifeste invalide : ${manifestResult.issues.join(' ; ')}',
      ));

  final body = file(_entitiesFile);
  if (sha256Checksum(body) != manifest.checksum) {
    throw const DndpackException(
      'somme de contrôle de entities.json incorrecte',
    );
  }
  final raw = _decode(body, _entitiesFile);
  if (raw is! List<Object?>) {
    throw const DndpackException('entities.json doit être une liste');
  }
  if (raw.length > maxPackEntities) {
    throw const DndpackException('plus de $maxPackEntities entités');
  }
  if (raw.length != manifest.entityCount) {
    throw DndpackException(
      'entity_count du manifeste (${manifest.entityCount}) différent du '
      'nombre d\'entités (${raw.length})',
    );
  }
  final entities = <ContentEntity>[];
  final ids = <String>{};
  for (var i = 0; i < raw.length; i++) {
    final result = parseEntity(raw[i], '$_entitiesFile[$i]');
    final entity =
        result.entity ??
        (throw DndpackException(
          'entité invalide : ${result.issues.join(' ; ')}',
        ));
    if (!ids.add('${entity.id}')) {
      throw DndpackException('identifiant en double : ${entity.id}');
    }
    entities.add(entity);
  }
  // Les références se vérifient à l'import, avec les dépendances :
  // validatePack(pack, dependencies: …).
  return ContentPack(manifest: manifest, entities: entities);
}

Object? _decode(List<int> bytes, String name) {
  final String text;
  try {
    text = utf8.decode(bytes);
  } on FormatException {
    throw DndpackException('$name n\'est pas en UTF-8');
  }
  if (_depth(text) > maxJsonDepth) {
    throw DndpackException('$name dépasse la profondeur JSON de $maxJsonDepth');
  }
  try {
    return jsonDecode(text);
  } on FormatException catch (e) {
    throw DndpackException('$name : JSON invalide (${e.message})');
  }
}

/// Profondeur d'imbrication maximale, mesurée avant tout décodage.
int _depth(String json) {
  var depth = 0;
  var max = 0;
  var inString = false;
  for (var i = 0; i < json.length; i++) {
    final c = json[i];
    if (inString) {
      if (c == r'\') {
        i++;
      } else if (c == '"') {
        inString = false;
      }
    } else if (c == '"') {
      inString = true;
    } else if (c == '[' || c == '{') {
      if (++depth > max) max = depth;
    } else if (c == ']' || c == '}') {
      depth--;
    }
  }
  return max;
}

final _ed25519 = Ed25519();

/// Message signé : le JSON du manifeste sans `signature`, encodé comme dans
/// l'archive.
List<int> signedMessage(PackManifest manifest) =>
    _json(manifest.copyWith(clearSignature: true).toJson());

/// Signe [pack] avec la paire Ed25519 [keys] (EF-HB-05) : le manifeste reçoit
/// `entity_count`, `checksum`, `author_public_key` et `signature`.
Future<ContentPack> signPack(ContentPack pack, SimpleKeyPair keys) async {
  final (entities, body) = _body(pack);
  final publicKey = await keys.extractPublicKey();
  final unsigned = pack.manifest
      .withContent(entityCount: entities.length, checksum: sha256Checksum(body))
      .copyWith(
        authorPublicKey: base64.encode(publicKey.bytes),
        clearSignature: true,
      );
  final signature = await _ed25519.sign(signedMessage(unsigned), keyPair: keys);
  return ContentPack(
    manifest: unsigned.copyWith(signature: base64.encode(signature.bytes)),
    entities: entities,
  );
}

/// Vrai si [manifest] porte une signature valide de sa propre clé publique.
/// Le `checksum` signé couvre les entités, vérifié à la lecture.
Future<bool> verifyPackSignature(PackManifest manifest) async {
  final key = manifest.authorPublicKey;
  final signature = manifest.signature;
  if (key == null || signature == null) return false;
  try {
    return await _ed25519.verify(
      signedMessage(manifest),
      signature: Signature(
        base64.decode(signature),
        publicKey: SimplePublicKey(
          base64.decode(key),
          type: KeyPairType.ed25519,
        ),
      ),
    );
  } on Object {
    return false;
  }
}

/// Paire Ed25519 tirée d'une graine de 32 octets, gardée par l'appareil.
Future<SimpleKeyPair> authorKeyPair(List<int> seed) =>
    _ed25519.newKeyPairFromSeed(seed);

/// Nouvelle graine aléatoire de 32 octets.
Future<List<int>> newAuthorSeed() async =>
    (await _ed25519.newKeyPair()).extractPrivateKeyBytes();
