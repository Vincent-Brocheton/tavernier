import 'dart:math';

/// Dernier horodatage donné sans [uuidV7.at].
var _lastMillis = 0;

/// UUID v7 (RFC 9562) : 48 bits d'horodatage, puis de l'aléa. Les données
/// utilisateur reçoivent cet identifiant (cahier §10). Sans [at], les
/// identifiants d'un même processus croissent strictement : dans la même
/// milliseconde, l'horodatage avance d'une unité (RFC 9562, §6.2), pour que
/// l'ordre des identifiants reste celui de leur création.
String uuidV7({DateTime? at, Random? random}) {
  final source = random ?? Random.secure();
  final bytes = List<int>.generate(16, (_) => source.nextInt(256));
  var time =
      at?.millisecondsSinceEpoch ??
      (_lastMillis = max(
        DateTime.now().millisecondsSinceEpoch,
        _lastMillis + 1,
      ));
  // Divisions et non décalages : sur le Web, ceux-ci s'arrêtent à 32 bits.
  for (var i = 5; i >= 0; i--) {
    bytes[i] = time % 256;
    time ~/= 256;
  }
  bytes[6] = bytes[6] & 0x0f | 0x70;
  bytes[8] = bytes[8] & 0x3f | 0x80;
  final hex = [for (final b in bytes) b.toRadixString(16).padLeft(2, '0')];
  return [
    hex.sublist(0, 4),
    hex.sublist(4, 6),
    hex.sublist(6, 8),
    hex.sublist(8, 10),
    hex.sublist(10),
  ].map((part) => part.join()).join('-');
}
