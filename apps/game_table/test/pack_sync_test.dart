// Spec homebrew : « Diffusion aux membres » (US-30 lot b, EF-HB-09).
import 'dart:io';
import 'dart:typed_data';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/homebrew/pack_storage.dart';

import 'fake_pack_storage.dart';

final _srd = readDndpack(
  File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync(),
);
const _gardiens = '0193a000-0000-7000-8000-000000000030';

void main() {
  late TavernierDatabase db;
  late FakePackStorage storage;
  late ProviderContainer container;
  late String table;

  setUp(() async {
    db = TavernierDatabase(NativeDatabase.memory());
    storage = FakePackStorage();
    container = ProviderContainer(
      overrides: [
        databaseProvider.overrideWithValue(db),
        srdPackProvider.overrideWith((ref) => _srd),
        packStorageProvider.overrideWithValue(storage),
      ],
    );
    table = await TableStore(db).create(
      gmUserId: '00000000-0000-0000-0000-00000000000a',
      settings: const TableSettings(name: 'Brumeval'),
      packs: [(packId: _srd.manifest.id, version: _srd.manifest.version)],
    );
  });
  tearDown(() async {
    container.dispose();
    await db.close();
  });

  /// Attend que [test] soit vrai, en laissant tourner les flux de la base.
  Future<void> until(Future<bool> Function() test) async {
    for (var i = 0; i < 100 && !await test(); i++) {
      await Future<void>.delayed(const Duration(milliseconds: 20));
    }
  }

  test('pack actif reçu, vérifié, installé : la sous-classe est là', () async {
    final bytes = Uint8List.fromList(
      await gardiensFile(_srd.manifest, '0.1.0'),
    );
    final sha = fileSha256(bytes);
    storage.files[sha] = bytes;
    container.listen(packDownloaderProvider, (_, _) {});
    // Le MJ active le pack : la ligne arrive par la synchronisation.
    await TableStore(db)
        .setPack(table, packId: _gardiens, version: '0.1.0', fileSha256: sha);
    await until(
      () async => await PackLibrary(db).version(_gardiens, '0.1.0') != null,
    );
    await until(
      () async =>
          (await container.read(contentProvider.future))
              .entity('gardiens:subclass:rempart') !=
          null,
    );
    final content = await container.read(contentProvider.future);
    expect(
      content.entity('gardiens:subclass:rempart')!.name,
      'Gardien du rempart',
    );
    expect(content.entity('srd:class:fighter'), isNotNull);
  });

  test('fichier altéré : rien n’est installé', () async {
    final bytes = Uint8List.fromList(
      await gardiensFile(_srd.manifest, '0.1.0'),
    );
    final sha = fileSha256(bytes);
    storage.files[sha] = Uint8List.fromList([...bytes]..[100] ^= 0xff);
    expect(await fetchPack(db, storage, sha), isFalse);
    expect(await PackLibrary(db).installed(), isEmpty);
  });

  test('deux tables, deux versions : la plus récente', () async {
    final other = await TableStore(db).create(
      gmUserId: '00000000-0000-0000-0000-00000000000a',
      settings: const TableSettings(name: 'Ailleurs'),
      packs: const [],
    );
    for (final v in ['0.1.0', '0.2.0']) {
      await PackLibrary(db).install(await gardiensFile(_srd.manifest, v));
    }
    await TableStore(db).setPack(table, packId: _gardiens, version: '0.1.0');
    await TableStore(db).setPack(other, packId: _gardiens, version: '0.2.0');
    await until(
      () async =>
          (await container.read(contentProvider.future)).packs.length == 2,
    );
    final packs = (await container.read(contentProvider.future)).packs;
    expect(packs.last.manifest.version, '0.2.0');
  });
}
