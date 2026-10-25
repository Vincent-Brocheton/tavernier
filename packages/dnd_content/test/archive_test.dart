import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

/// Construit une archive à la main pour simuler un fichier altéré.
List<int> _zip(Map<String, String> files) {
  final archive = Archive();
  files.forEach(
    (name, content) => archive.addFile(ArchiveFile.string(name, content)),
  );
  return ZipEncoder().encodeBytes(archive);
}

Map<String, String> _files(List<int> bytes) => {
  for (final f in ZipDecoder().decodeBytes(bytes).files)
    f.name: utf8.decode(f.content as List<int>),
};

void main() {
  test('écrire puis relire redonne le même pack', () {
    final original = validPack();
    final read = readDndpack(writeDndpack(original));
    expect(read.manifest.toJson()['entity_count'], 6);
    expect(read.manifest.toJson()['checksum'], startsWith('sha256:'));
    expect(
      read.entities.map((e) => e.toJson()),
      original.entities.map((e) => e.toJson()).toList()
        ..sort((a, b) => '${a['id']}'.compareTo('${b['id']}')),
    );
  });

  test('deux écritures des mêmes entités donnent les mêmes octets', () {
    final pack = validPack();
    final shuffled = ContentPack(
      manifest: pack.manifest,
      entities: pack.entities.reversed.toList(),
    );
    expect(writeDndpack(shuffled), writeDndpack(pack));
  });

  test('l\'archive contient le manifeste et les entités, triées par id', () {
    final files = _files(writeDndpack(validPack()));
    expect(files.keys, ['manifest.json', 'entities.json']);
    final ids = [
      for (final e in jsonDecode(files['entities.json']!) as List<Object?>)
        (e! as Map<String, Object?>)['id'],
    ];
    expect(ids, [...ids]..sort());
    final manifest =
        jsonDecode(files['manifest.json']!) as Map<String, Object?>;
    expect(manifest['format'], 'dndpack');
    expect(manifest['attribution'], srdAttributionFr);
  });

  group('archives refusées', () {
    late Map<String, String> good;
    setUp(() => good = _files(writeDndpack(validPack())));

    /// Remplace entities.json et recalcule la somme de contrôle.
    List<int> withEntities(String body) {
      final manifest =
          jsonDecode(good['manifest.json']!) as Map<String, Object?>;
      manifest['checksum'] = sha256Checksum(utf8.encode(body));
      return _zip({
        'manifest.json': jsonEncode(manifest),
        'entities.json': body,
      });
    }

    void expectRejected(List<int> bytes, String fragment) {
      expect(
        () => readDndpack(bytes),
        throwsA(
          isA<DndpackException>().having(
            (e) => e.message,
            'message',
            contains(fragment),
          ),
        ),
      );
    }

    test('somme de contrôle fausse', () {
      expectRejected(
        _zip({
          ...good,
          'entities.json': good['entities.json']!.replaceFirst(
            'Soldat',
            'Soudard',
          ),
        }),
        'somme de contrôle',
      );
    });
    test('entities.json absent', () {
      expectRejected(
        _zip({'manifest.json': good['manifest.json']!}),
        'entities.json',
      );
    });
    test('pas une archive zip', () {
      expectRejected(utf8.encode('bonjour'), 'archive');
    });
    test('version de format inconnue', () {
      final manifest =
          jsonDecode(good['manifest.json']!) as Map<String, Object?>;
      manifest['format_version'] = 2;
      expectRejected(
        _zip({...good, 'manifest.json': jsonEncode(manifest)}),
        'format_version',
      );
    });
    test('plus de 20 Mo', () {
      expect(maxPackBytes, 20 * 1024 * 1024);
      expectRejected(List<int>.filled(maxPackBytes + 1, 0), '20 Mo');
    });
    test('plus de 10 000 entités', () {
      expect(maxPackEntities, 10000);
      final many = jsonEncode([
        for (var i = 0; i <= maxPackEntities; i++) {'id': 'srd:ability:a$i'},
      ]);
      expectRejected(withEntities(many), '10000');
    });
    test('JSON plus profond que 32 niveaux', () {
      expect(maxJsonDepth, 32);
      expectRejected(withEntities('${'[' * 33}${']' * 33}'), 'profondeur');
    });
    test('JSON à 32 niveaux accepté par la mesure de profondeur', () {
      // 32 niveaux passent la mesure ; le refus vient ensuite du contenu.
      expectRejected(withEntities('${'[' * 32}${']' * 32}'), 'entité invalide');
    });
    test('entité invalide dans l\'archive', () {
      final entities = jsonDecode(good['entities.json']!) as List<Object?>;
      (entities.first! as Map<String, Object?>)['type'] = 'spellbook';
      expectRejected(withEntities(jsonEncode(entities)), 'spellbook');
    });
  });
}
