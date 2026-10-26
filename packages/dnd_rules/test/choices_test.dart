// Spec character-sheet : « Choix conformes ».
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

ComputedSheet _sheet(void Function(Map<String, Object?> json) change) =>
    computeSheet(aldric(change), srdContent());

Iterable<IntegrityError> _choiceErrors(ComputedSheet sheet) =>
    sheet.integrityErrors.where((e) => e.rule == IntegrityRule.choice);

List<Map<String, Object?>> _feats(Map<String, Object?> json) =>
    (json['feats']! as List<Object?>).cast<Map<String, Object?>>();

void main() {
  test('deux sélections pour Compétent : erreur, aucune maîtrise', () {
    final sheet = _sheet(
      (json) => json['choices'] = {
        'skillful': ['srd:skill:insight', 'srd:skill:stealth'],
      },
    );
    expect(_choiceErrors(sheet).single.path, 'choices.skillful');
    expect(sheet.skillProficiencies, isNot(contains('insight')));
    expect(sheet.skillProficiencies, isNot(contains('stealth')));
  });

  test('aucune sélection pour Compétent : erreur', () {
    final sheet = _sheet((json) => json['choices'] = <String, Object?>{});
    expect(_choiceErrors(sheet).single.path, 'choices.skillful');
  });

  test('une sélection hors des options : erreur', () {
    final sheet = _sheet(
      (json) => json['choices'] = {
        'skillful': ['srd:weapon:longsword'],
      },
    );
    expect(_choiceErrors(sheet), hasLength(1));
  });

  test('Doué pris deux fois garde deux sélections distinctes', () {
    final sheet = _sheet((json) {
      _feats(json).firstWhere((f) => f['source_type'] == 'species')
        ..['feat_id'] = 'srd:feat:skilled'
        ..['choices'] = {
          'skilled': [
            'srd:skill:arcana',
            'srd:skill:history',
            'srd:skill:nature',
          ],
        };
      _feats(json).add({
        'feat_id': 'srd:feat:skilled',
        'source_type': 'class_level',
        'source_ref': 'srd:class:fighter:4',
        'choices': {
          'skilled': [
            'srd:skill:medicine',
            'srd:skill:religion',
            'srd:skill:stealth',
          ],
        },
      });
    });
    expect(_choiceErrors(sheet), isEmpty);
    expect(
      sheet.skillProficiencies,
      containsAll([
        'arcana',
        'history',
        'nature',
        'medicine',
        'religion',
        'stealth',
      ]),
    );
  });
}
