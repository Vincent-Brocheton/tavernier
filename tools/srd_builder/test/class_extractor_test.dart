// Extraction des classes (change t-04b-classes-1, décisions 3 et 5). Extraits
// réels du PDF (ordre de lecture et mise en page), abrégés.
import 'dart:convert';
import 'dart:io';

import 'package:srd_builder/src/class_extractor.dart';
import 'package:srd_builder/src/feature_extractor.dart';
import 'package:srd_builder/src/progression_table.dart';
import 'package:test/test.dart';

const _readingOrder = '''
Traits de base du Barbare
Caractéristique principale Force
Aptitudes de classe du Barbare
Niveau 1 : Rage
Vous pouvez vous animer d’une force primitive appelée Rage.
Aptitudes du Barbare
Bonus de Niveau maîtrise Aptitudes de classe
1
+2
Rage, Bottes d’arme
Rages 2 2 3 3
Résistance aux dégâts. Vous bénéficiez de la Résistance aux dégâts contondants, perforants et tranchants.
Niveau 13 : Coup brutal amélioré
Vous avez développé de nouveaux coups féroces.
Niveau 17 : Coup brutal amélioré
Les dégâts supplémentaires passent à 2d10.
Sous-classe de Barbare : Voie du Berserker
Convertissez la Rage en déchaînement de violence
Niveau 3 : Frénésie
Si vous recourez à Témérité, vous infligez des dégâts supplémentaires.
Barde
Traits de base du Barde
''';

const _layout = '''
     Aptitudes du Barde
              Bonus de                                     Dé     Sorts      Sorts
     Niveau   maîtrise     Aptitudes de classe          bardique mineurs   préparés 1 2
        1         +2       Inspiration bardique,          d6        2         4       2   —
                           Sorts
        2         +2       Expertise, Touche-à-tout          d6     2         5       3   —
        3         +2       Amélioration de                   d6     2         6       4   2
                           caractéristique
''';

void main() {
  test('aptitudes, table intercalée retirée, sous-classe, fin de section', () {
    final section = extractClassSection(
      _readingOrder,
      'Barbare',
      tableTitle: 'Aptitudes du Barbare',
    );
    expect(
      [for (final f in section.features) (f.level, f.name, f.subclass)],
      [
        (1, 'Rage', false),
        (13, 'Coup brutal amélioré', false),
        (17, 'Coup brutal amélioré', false),
        (3, 'Frénésie', true),
      ],
    );
    expect(
      section.features.first.text,
      'Vous pouvez vous animer d’une force primitive appelée Rage.\n'
      'Résistance aux dégâts. Vous bénéficiez de la Résistance aux dégâts '
      'contondants, perforants et tranchants.',
    );
    expect(section.subclassName, 'Voie du Berserker');
    expect(
      section.subclassText,
      'Convertissez la Rage en déchaînement de violence',
    );
    expect(section.features.last.text, isNot(contains('Barde')));
  });

  test('tables internes consécutives retirées du texte', () {
    const text = '''
Traits de base du Druide
Niveau 3 : Sorts du Cercle de la Terre
Choisissez un type d’environnement : aride ou polaire.
Terres arides
Niveau de Druide Sorts de cercle flou, mains brûlantes
Terres polaires
Niveau de Druide Sorts de cercle nappe de brouillard
Niveau 3 : Aval de la terre
Par une action Magie, vous dépensez une utilisation de Forme sauvage.
''';
    final section = extractClassSection(
      text,
      'Druide',
      tableTitle: 'Aptitudes du Druide',
      dropTables: ['Terres arides', 'Terres polaires'],
    );
    expect(
      section.features.first.text,
      'Choisissez un type d’environnement : aride ou polaire.',
    );
    expect(section.features.last.name, 'Aval de la terre');
    expect(
      () => extractClassSection(
        text,
        'Druide',
        tableTitle: 'Aptitudes du Druide',
        dropTables: ['Terres tropicales'],
      ),
      throwsFormatException,
    );
  });

  test('table de progression : dés, noms coupés, colonnes vides', () {
    final rows = _parse([
      'bardic_die',
      'cantrips',
      'prepared_spells',
      'slot_1',
      'slot_2',
    ]);
    expect(rows[0].features, ['Inspiration bardique', 'Sorts']);
    expect(rows[0].columns, {
      'bardic_die': 6,
      'cantrips': 2,
      'prepared_spells': 4,
      'slot_1': 2,
    });
    expect(rows[2].features, ['Amélioration de caractéristique']);
    expect(rows[2].columns['slot_2'], 2);
  });

  test('slug par niveau, sinon par nom unique', () {
    final slugs = <(String, String, int), String>{
      ('bard', 'Amélioration de caractéristique', 4): 'bard-asi',
      ('barbarian', 'Coup brutal amélioré', 13): 'b-13',
      ('barbarian', 'Coup brutal amélioré', 17): 'b-17',
    };
    expect(
      featureSlug(slugs, 'bard', 'Amélioration de caractéristique', 8),
      'bard-asi',
    );
    expect(featureSlug(slugs, 'barbarian', 'Coup brutal amélioré', 17), 'b-17');
    expect(featureSlug(slugs, 'barbarian', 'Coup brutal amélioré', 9), isNull);
  });

  test('une nouvelle extraction garde les données et effets saisis', () {
    final dir = Directory.systemTemp.createTempSync('extract_classes_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final file = File('${dir.path}/feature/barbarian-rage.json')
      ..createSync(recursive: true)
      ..writeAsStringSync(
        jsonEncode({
          'id': 'srd:feature:barbarian-rage',
          'type': 'feature',
          'name': 'Ancien nom',
          'data': {'source': 'srd:class:barbarian', 'level': 1},
          'effects': [
            {'op': 'set_attacks_per_action', 'count': 2},
          ],
          'text': {'fr': 'Ancien texte.'},
        }),
      );
    writeFeature(
      file,
      name: 'Rage',
      text: 'Nouveau texte.',
      source: 'srd:class:barbarian',
      level: 1,
    );
    final json = jsonDecode(file.readAsStringSync()) as Map<String, Object?>;
    expect(json['name'], 'Rage');
    expect(json['text'], {'fr': 'Nouveau texte.'});
    expect(json['effects'], [
      {'op': 'set_attacks_per_action', 'count': 2},
    ]);
  });
}

List<ProgressionRow> _parse(List<String> columns) {
  // La table abrégée n'a que 3 niveaux : on la complète jusqu'à 20.
  final lines = [
    _layout,
    for (var l = 4; l <= 20; l++)
      '        $l         +2       —                                 d6     2         6       4   2',
  ];
  return parseProgressionTable(lines.join('\n'), 'Aptitudes du Barde', columns);
}
