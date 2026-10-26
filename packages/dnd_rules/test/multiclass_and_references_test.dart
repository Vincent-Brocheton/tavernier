// Spec character-sheet : « Prérequis de multiclassage » (SRD p. 26) et
// « Erreurs signalées sans interrompre le calcul ».
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

/// Seconde classe de test, de caractéristique principale [ability].
ContentEntity _secondClass(String ability) {
  final fighter = srdPack.entities.firstWhere(
    (e) => '${e.id}' == 'srd:class:fighter',
  );
  final json = fighter.toJson()
    ..['id'] = 'test:class:second'
    ..['name'] = 'Seconde classe';
  (json['data']! as Map<String, Object?>)
    ..['primary_abilities'] = ['srd:ability:$ability']
    ..['levels'] = [
      {'level': 1, 'proficiency_bonus': 2},
    ];
  return parseEntity(json, 'test').entity!;
}

void _addSecondClass(Map<String, Object?> json) =>
    (json['class_levels']! as List<Object?>).add({
      'class_id': 'test:class:second',
      'level': 1,
    });

Iterable<IntegrityRule> _rules(ComputedSheet sheet) =>
    sheet.integrityErrors.map((e) => e.rule);

void main() {
  group('prérequis de multiclassage (§11.3)', () {
    test('Guerrier à FOR 12 et DEX 12 : prérequis non remplis', () {
      final sheet = computeSheet(
        aldric((json) {
          (json['base_scores']! as Map<String, Object?>)
            ..['str'] = 10
            ..['dex'] = 11;
          (json['background_choice']! as Map<String, Object?>)['bonuses'] = {
            'str': 2,
            'dex': 1,
          };
          _addSecondClass(json);
        }),
        srdContent([_secondClass('constitution')]),
      );
      expect(sheet.abilities['str']!.value, 12);
      expect(sheet.abilities['dex']!.value, 12);
      expect(_rules(sheet), contains(IntegrityRule.multiclass));
    });

    test('caractéristique principale de la nouvelle classe sous 13', () {
      final sheet = computeSheet(
        aldric(_addSecondClass),
        srdContent([_secondClass('intelligence')]),
      );
      expect(_rules(sheet), contains(IntegrityRule.multiclass));
    });

    test('prérequis remplis : FOR 17 et CON 15', () {
      final sheet = computeSheet(
        aldric(_addSecondClass),
        srdContent([_secondClass('constitution')]),
      );
      expect(sheet.level, 2);
      expect(_rules(sheet), isNot(contains(IntegrityRule.multiclass)));
    });
  });

  group('erreurs sans interruption', () {
    test('un personnage invalide a une fiche et la règle concernée', () {
      final sheet = computeSheet(
        aldric(
          (json) =>
              (json['background_choice']! as Map<String, Object?>)['bonuses'] =
                  {'str': 2, 'int': 1},
        ),
        srdContent(),
      );
      expect(sheet.armorClass.value, 19);
      expect(sheet.integrityErrors.single.rule, IntegrityRule.backgroundBonus);
    });

    test('une espèce absente du contenu est une erreur de référence', () {
      final sheet = computeSheet(
        aldric((json) => json['species_id'] = 'srd:species:elf'),
        srdContent(),
      );
      expect(
        sheet.integrityErrors.where((e) => e.rule == IntegrityRule.reference),
        [
          isA<IntegrityError>()
              .having((e) => e.path, 'path', 'species_id')
              .having((e) => e.message, 'message', contains('srd:species:elf')),
        ],
      );
      expect(sheet.abilities['str']!.value, 17);
    });

    test('un don ou un objet absents sont des erreurs de référence', () {
      final sheet = computeSheet(
        aldric((json) {
          (json['feats']! as List<Object?>).add({
            'feat_id': 'srd:feat:lucky',
            'source_type': 'class_level',
            'source_ref': 'srd:class:fighter:4',
          });
          (json['items']! as List<Object?>).add({
            'item_id': 'srd:item:bag-of-holding',
            'quantity': 1,
          });
        }),
        srdContent(),
      );
      final paths = sheet.integrityErrors
          .where((e) => e.rule == IntegrityRule.reference)
          .map((e) => e.path);
      expect(paths, containsAll(['feats[3].feat_id', 'items[6].item_id']));
    });
  });
}
