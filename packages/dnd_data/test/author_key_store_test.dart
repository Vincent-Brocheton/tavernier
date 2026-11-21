// Spec local-database : « Clé de l'auteur » (US-29, EF-HB-05).
import 'dart:convert';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  late TavernierDatabase db;
  setUp(() => db = memoryDatabase());
  tearDown(() => db.close());

  test('une seule clé par appareil, toujours la même', () async {
    final store = AuthorKeyStore(db);
    final first = await store.seed();
    final second = await store.seed();
    expect(first, hasLength(32));
    expect(second, first);
    final rows = await db
        .customSelect('SELECT public_key FROM author_key')
        .get();
    expect(rows, hasLength(1));
    final keys = await authorKeyPair(first);
    expect(
      rows.single.read<String>('public_key'),
      base64.encode((await keys.extractPublicKey()).bytes),
    );
  });
}
