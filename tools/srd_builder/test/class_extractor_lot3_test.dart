// Formes de table et de section rencontrées au lot 3 de T-04 (change
// t-04c-classes-2). Extraits réels du PDF, abrégés.
import 'package:srd_builder/src/feature_extractor.dart';
import 'package:srd_builder/src/progression_table.dart';
import 'package:test/test.dart';

String _table(String title, List<String> rows) => [
  '     $title',
  ...rows,
  for (var l = rows.length + 1; l <= 20; l++)
    '        $l         +2       —                       1d6       2       +3 m',
].join('\n');

void main() {
  test('dés « 1d6 » / « 2d6 » et mètres convertis en pieds', () {
    final rows = parseProgressionTable(
      _table('Aptitudes du Moine', [
        '        1         +2       Arts martiaux             1d8       —         —',
        '        2         +2       Credo du Moine            1d8       2       +3 m',
      ]),
      'Aptitudes du Moine',
      ['martial_arts_die', 'focus_points', 'unarmored_movement_feet'],
    );
    expect(rows[0].columns, {'martial_arts_die': 8});
    expect(rows[1].columns, {
      'martial_arts_die': 8,
      'focus_points': 2,
      'unarmored_movement_feet': 10,
    });
    final sneak = parseProgressionTable(
      _table('Aptitudes du Roublard', [
        '        1         +2       Attaque sournoise                      2d6',
      ]).replaceAll('       2       +3 m', ''),
      'Aptitudes du Roublard',
      ['sneak_attack_dice'],
    );
    expect(sneak.first.columns, {'sneak_attack_dice': 2});
  });

  test('valeurs repoussées par un exposant (« 7e »)', () {
    final rows = parseProgressionTable(
      [
        '     Aptitudes de l’Occultiste',
        '         1         +2       Magie de pacte           1         2',
        '         2         +5       Arcanum mystique (sort du 7 niveau)',
        '                                                         e',
        '                                                                      8         4',
        for (var l = 3; l <= 20; l++)
          '        $l         +2       —                        1         2',
      ].join('\n'),
      'Aptitudes de l’Occultiste',
      ['invocations', 'cantrips'],
    );
    expect(rows[1].features, ['Arcanum mystique (sort du 7 niveau)']);
    expect(rows[1].columns, {'invocations': 8, 'cantrips': 4});
    expect(rows, hasLength(20));
  });

  test('fin de section au titre de la classe suivante, CRLF, saut de page', () {
    const text =
        'Traits de base du Rôdeur\r\n'
        'Niveau 15 : Défense de chasseur supérieure\r\n'
        'Vous pouvez jouer votre Réaction.\r\n'
        '\r\n\fRoublard\r\n\r\nDevenir Roublard…\r\n\r\n'
        'Traits de base du Roublard\r\n'
        'Niveau 17 : Réflexes de voleur\r\n'
        'Vous jouez deux tours.\r\n'
        '\fOrigines des\r\npersonnages\r\nHistoriques de personnage\r\n';
    final ranger = extractClassSection(text, 'Rôdeur', tableTitle: 'x');
    expect(ranger.features.single.text, 'Vous pouvez jouer votre Réaction.');
    final rogue = extractClassSection(text, 'Roublard', tableTitle: 'x');
    expect(rogue.features.single.text, 'Vous jouez deux tours.');
  });

  test('encadré qui coupe une phrase : déplacé, phrase recollée', () {
    const text = '''
Traits de base du Paladin
Niveau 3 : Conduit divin
D’autres aptitudes octroient des effets supplémentaires
Rompre votre serment
Les paladins ont beau s’efforcer de respecter une éthique.
de Conduit divin. Vous choisissez l’effet.
Niveau 3 : Sous-classe de Paladin
Vous recevez la sous-classe de Paladin de votre choix.
''';
    final section = extractClassSection(
      text,
      'Paladin',
      tableTitle: 'x',
      sidebars: {
        'Rompre votre serment': (lines: 2, to: 'Sous-classe de Paladin'),
      },
    );
    expect(
      section.features.first.text,
      'D’autres aptitudes octroient des effets supplémentaires de Conduit '
      'divin. Vous choisissez l’effet.',
    );
    expect(section.features.last.text, endsWith('respecter une éthique.'));
  });
}
