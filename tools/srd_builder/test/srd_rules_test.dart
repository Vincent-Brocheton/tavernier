// Spec content-pack : « Termes de règles ». Le texte vient du SRD français, sans
// traduction maison : son début se retrouve dans le document de référence.
import 'dart:convert';
import 'dart:io';

import 'package:test/test.dart';

void main() {
  final srd = File('../../docs/srd/FR_SRD_CC_v5.2.1.txt')
      .readAsStringSync()
      .replaceAll(RegExp(r'\s+'), ' ');
  final sources = Directory('sources/rule').listSync().whereType<File>();

  test('six termes de règles', () => expect(sources, hasLength(6)));

  for (final file in sources) {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    final text = (json['text']! as Map<String, Object?>)['fr']! as String;
    test('${json['name']} : début recopié du SRD', () {
      // Une ligne de colonne porte au moins ces 30 caractères.
      expect(srd, contains(text.substring(0, 30)));
      expect(srd, contains(json['name']));
    });
  }
}
