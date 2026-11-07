// Spec character-sheet : « Maîtrises de jets de sauvegarde accordées ».
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final content = srdContent();

  /// FOR 17, DEX 13, CON 15, INT 8, SAG 12, CHA 10.
  final aldric = CharacterInput.fromJson(fixtureInput('aldric_n1'))
      .copyWith(items: const [], feats: const [], weaponMasteries: const []);

  Map<String, int> saves(List<ClassLevelInput> levels) =>
      computeSheet(aldric.copyWith(classLevels: levels), content).savingThrows;

  test('Roublard 14 : Sagesse et Charisme non maîtrisés', () {
    final s = saves(const [
      ClassLevelInput(classId: 'srd:class:rogue', level: 14),
    ]);
    expect(s['wis'], 1);
    expect(s['cha'], 0);
  });

  test('Roublard 15 : Esprit fuyant, +5 de maîtrise', () {
    final s = saves(const [
      ClassLevelInput(classId: 'srd:class:rogue', level: 15),
    ]);
    expect(s['wis'], 6);
    expect(s['cha'], 5);
    // INT reste maîtrisée par la classe, sans doubler le bonus.
    expect(s['int'], 4);
  });

  test('Moine 14 : les six jets maîtrisés une seule fois', () {
    final s = saves(const [
      ClassLevelInput(classId: 'srd:class:monk', level: 14),
    ]);
    expect(s, {'str': 8, 'dex': 6, 'con': 7, 'int': 4, 'wis': 6, 'cha': 5});
  });

  test('multiclassage : pas de maîtrise de jets de la seconde classe', () {
    final s = saves(const [
      ClassLevelInput(classId: 'srd:class:fighter', level: 1),
      ClassLevelInput(classId: 'srd:class:rogue', level: 1),
    ]);
    expect(s['dex'], 1);
  });
}
