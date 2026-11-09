// Règles d'un nouveau mot de passe (cahier EF-CPT-08) : 10 caractères au
// moins, différent de l'e-mail et du pseudo, absent des listes de mots de
// passe divulgués, avec une robustesse indicative de 0 à 4.
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;

/// Longueur minimale.
const minPasswordLength = 10;

bool longEnough(String password) => password.length >= minPasswordLength;

/// Faux si [password] est l'e-mail, sa partie locale ou le pseudo, sans
/// tenir compte de la casse.
bool differsFromIdentity(
  String password, {
  required String email,
  String? pseudonym,
}) {
  final candidate = password.trim().toLowerCase();
  return !{
    email.toLowerCase(),
    email.split('@').first.toLowerCase(),
    ?pseudonym?.toLowerCase(),
  }.contains(candidate);
}

/// Robustesse indicative, de 0 à 4 segments : la longueur d'abord, puis la
/// variété des caractères. Seules les règles bloquent l'enregistrement.
int strength(String password) {
  final length = password.length;
  if (length < 6) return 0;
  if (length < minPasswordLength) return 1;
  final kinds = [
    RegExp('[a-z]'),
    RegExp('[A-Z]'),
    RegExp('[0-9]'),
    RegExp('[^a-zA-Z0-9]'),
  ].where((kind) => kind.hasMatch(password)).length;
  return 1 +
      (length >= 12 ? 1 : 0) +
      (kinds >= 3 ? 1 : 0) +
      (length >= 16 && kinds >= 2 ? 1 : 0);
}

/// Empreinte SHA-1 en hexadécimal majuscule, la forme de Have I Been Pwned.
String sha1Hex(String text) =>
    sha1.convert(utf8.encode(text)).toString().toUpperCase();

/// Mots de passe divulgués, d'après l'API « range » de Have I Been Pwned :
/// seuls les 5 premiers caractères de l'empreinte sortent (k-anonymat), et
/// la réponse est complétée de faux suffixes (`Add-Padding`).
final class BreachedPasswords {
  BreachedPasswords(this._client);

  final http.Client _client;

  /// Vrai si [password] figure dans une fuite. Lève une exception sans
  /// réponse exploitable : la règle reste alors à vérifier.
  Future<bool> isBreached(String password) async {
    final hash = sha1Hex(password);
    final response = await _client.get(
      Uri.https('api.pwnedpasswords.com', '/range/${hash.substring(0, 5)}'),
      headers: const {'Add-Padding': 'true'},
    );
    if (response.statusCode != 200) {
      throw http.ClientException('Have I Been Pwned : ${response.statusCode}');
    }
    final suffix = hash.substring(5);
    for (final line in const LineSplitter().convert(response.body)) {
      final [lineSuffix, count] = line.split(':');
      if (lineSuffix == suffix) return int.parse(count.trim()) > 0;
    }
    return false;
  }
}
