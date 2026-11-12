// Spec local-database : « Identifiants des données utilisateur ».
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

void main() {
  test('format : version 7, variante RFC 9562', () {
    expect(
      uuidV7(),
      matches(
        RegExp(
          r'^[0-9a-f]{8}-[0-9a-f]{4}-7[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
        ),
      ),
    );
  });

  test('horodatage sur 48 bits', () {
    final id = uuidV7(at: DateTime.utc(2026, 11, 6));
    final ms = int.parse(id.replaceAll('-', '').substring(0, 12), radix: 16);
    expect(ms, DateTime.utc(2026, 11, 6).millisecondsSinceEpoch);
  });

  test('unique', () {
    expect({for (var i = 0; i < 1000; i++) uuidV7()}, hasLength(1000));
  });

  test('le plus récent se trie après', () {
    final first = uuidV7(at: DateTime.utc(2026, 11, 6));
    final second = uuidV7(at: DateTime.utc(2026, 11, 6, 0, 0, 1));
    expect(first.compareTo(second), isNegative);
  });

  test('identifiants successifs : strictement croissants', () {
    final ids = [for (var i = 0; i < 1000; i++) uuidV7()];
    expect(ids, [...ids]..sort());
    expect(ids.toSet(), hasLength(1000));
  });
}
