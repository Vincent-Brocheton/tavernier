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

  test('huit termes de règles', () => expect(sources, hasLength(8)));

  for (final file in sources) {
    final json = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    final text = (json['text']! as Map<String, Object?>)['fr']! as String;
    test('${json['name']} : début recopié du SRD', () {
      // Une ligne de colonne porte au moins ces 30 caractères.
      expect(srd, contains(text.substring(0, 30)));
      expect(srd, contains(json['name']));
    });
  }

  // Spec content-pack : « Tables de règles d'une entité rule » (EF-ACT-05).
  Map<String, Object?> data(String slug) =>
      (jsonDecode(File('sources/rule/$slug.json').readAsStringSync())
              as Map<String, Object?>)['data']!
          as Map<String, Object?>;

  test('Domaines de savoir : une compétence par type de créature', () {
    final skills = data('study')['study_skills']! as Map<String, Object?>;
    expect(skills, hasLength(14));
    expect(skills['humanoid'], 'srd:skill:history');
    expect(skills['aberration'], 'srd:skill:arcana');
    expect(skills['dragon'], 'srd:skill:nature');
    expect(skills['undead'], 'srd:skill:religion');
  });

  test("Tests d'Influence : cinq façons d'interagir", () {
    final checks = [
      for (final c in data('influence')['influence_checks']! as List<Object?>)
        c! as Map<String, Object?>,
    ];
    expect(
      [for (final c in checks) c['skill']],
      [
        'srd:skill:intimidation',
        'srd:skill:persuasion',
        'srd:skill:performance',
        'srd:skill:deception',
        'srd:skill:animal-handling',
      ],
    );
    expect(checks.last['ability'], 'srd:ability:wisdom');
    expect(checks.last['creature_types'], ['beast', 'monstrosity']);
  });
}
