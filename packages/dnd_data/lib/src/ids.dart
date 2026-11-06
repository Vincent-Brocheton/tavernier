import 'dart:math';

/// UUID v7 (RFC 9562) : 48 bits d'horodatage, puis de l'aléa. Les données
/// utilisateur reçoivent cet identifiant (cahier §10).
String uuidV7({DateTime? at, Random? random}) {
  final source = random ?? Random.secure();
  final bytes = List<int>.generate(16, (_) => source.nextInt(256));
  // Divisions et non décalages : sur le Web, ceux-ci s'arrêtent à 32 bits.
  var time = (at ?? DateTime.now()).millisecondsSinceEpoch;
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
