import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/srd_builder.dart';
import 'package:test/test.dart';

const _pack = {
  'id': '377190b6-2dfa-4b38-83be-1c4c6d0cf55d',
  'namespace': 'srd',
  'name': 'SRD 5.2.1 (FR)',
  'version': '1.0.0',
  'origin': 'srd',
  'author': 'Wizards of the Coast LLC',
  'licence': 'CC-BY-4.0',
  'attribution': srdAttributionFr,
  'dsl_version': 1,
  'locale': 'fr',
  'dependencies': <Object?>[],
};

Map<String, Object?> _ability(String slug) => {
  'id': 'srd:ability:$slug',
  'type': 'ability',
  'name': slug,
  'data': {'abbreviation': slug.toUpperCase()},
};

Map<String, Object?> _skill(String slug, String ability) => {
  'id': 'srd:skill:$slug',
  'type': 'skill',
  'name': slug,
  'data': {'ability': ability},
};

late Directory _tmp;

/// Écrit un dossier de sources : chemin relatif → JSON (ou texte brut).
Directory _sources(Map<String, Object?> files) {
  final dir = Directory(p.join(_tmp.path, 'sources'))..createSync();
  files.forEach((path, content) {
    File(p.join(dir.path, path))
      ..createSync(recursive: true)
      ..writeAsStringSync(content is String ? content : jsonEncode(content));
  });
  return dir;
}

({int code, String out, String err}) _build(Directory sources) {
  final out = StringBuffer();
  final err = StringBuffer();
  final code = run(
    [
      'build',
      '--sources',
      sources.path,
      '--out',
      p.join(_tmp.path, 'out', 'srd.dndpack'),
    ],
    out,
    err,
  );
  return (code: code, out: '$out', err: '$err');
}

void main() {
  setUp(() => _tmp = Directory.systemTemp.createTempSync('srd_builder_'));
  tearDown(() => _tmp.deleteSync(recursive: true));

  test('des sources valides produisent une archive relisible', () {
    final result = _build(
      _sources({
        'pack.json': _pack,
        'ability/str.json': _ability('str'),
        'skill/athletics.json': _skill('athletics', 'srd:ability:str'),
      }),
    );
    expect(result.code, 0, reason: result.err);
    final pack = readDndpack(
      File(p.join(_tmp.path, 'out', 'srd.dndpack')).readAsBytesSync(),
    );
    expect(pack.entities.map((e) => '${e.id}'), [
      'srd:ability:str',
      'srd:skill:athletics',
    ]);
    expect(result.out, contains('2 entités'));
  });

  test('une référence cassée fait échouer le build en citant le fichier', () {
    final result = _build(
      _sources({
        'pack.json': _pack,
        'skill/athletics.json': _skill('athletics', 'srd:ability:luck'),
      }),
    );
    expect(result.code, 1);
    expect(result.err, contains('skill/athletics.json'));
    expect(result.err, contains('srd:ability:luck'));
  });

  test(
    'un identifiant présent dans deux fichiers est signalé avec les deux',
    () {
      final result = _build(
        _sources({
          'pack.json': _pack,
          'ability/str.json': _ability('str'),
          'ability/force.json': _ability('str'),
        }),
      );
      expect(result.code, 1);
      expect(result.err, contains('ability/str.json'));
      expect(result.err, contains('ability/force.json'));
    },
  );

  test('le nom du fichier doit être le slug et le dossier le type', () {
    final result = _build(
      _sources({
        'pack.json': _pack,
        'ability/force.json': _ability('str'),
        'skill/str.json': _ability('dex'),
      }),
    );
    expect(result.code, 1);
    expect(result.err, contains('ability/force.json'));
    expect(result.err, contains('skill/str.json'));
  });

  test('pack.json absent fait échouer le build', () {
    final result = _build(_sources({'ability/str.json': _ability('str')}));
    expect(result.code, 1);
    expect(result.err, contains('pack.json'));
  });

  test('un JSON invalide est signalé avec son fichier', () {
    final result = _build(
      _sources({'pack.json': _pack, 'ability/str.json': '{ pas du json'}),
    );
    expect(result.code, 1);
    expect(result.err, contains('ability/str.json'));
  });

  test('tous les problèmes sont listés, pas seulement le premier', () {
    final result = _build(
      _sources({
        'pack.json': _pack,
        'skill/athletics.json': _skill('athletics', 'srd:ability:luck'),
        'skill/stealth.json': _skill('stealth', 'srd:ability:grace'),
      }),
    );
    expect(result.code, 1);
    expect(result.err, contains('srd:ability:luck'));
    expect(result.err, contains('srd:ability:grace'));
  });

  test('aucune archive n\'est écrite quand le build échoue', () {
    _build(
      _sources({
        'pack.json': _pack,
        'skill/athletics.json': _skill('athletics', 'srd:ability:luck'),
      }),
    );
    expect(File(p.join(_tmp.path, 'out', 'srd.dndpack')).existsSync(), isFalse);
  });
}
