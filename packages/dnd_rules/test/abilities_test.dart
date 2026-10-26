// Spec character-sheet : « Valeurs de caractéristique », « Bonus de
// maîtrise », « Décomposition de chaque valeur », « Génération des valeurs »,
// « Bonus d'Historique conformes ». Valeurs : [D1] et SRD p. 22, p. 24, p. 87.
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

ComputedSheet _sheet([void Function(Map<String, Object?> json)? change]) =>
    computeSheet(aldric(change), srdContent());

Iterable<IntegrityRule> _rules(ComputedSheet sheet) =>
    sheet.integrityErrors.map((e) => e.rule);

void _setBase(Map<String, Object?> json, Map<String, Object?> scores) =>
    (json['base_scores']! as Map<String, Object?>).addAll(scores);

void main() {
  group('valeurs de caractéristique', () {
    test('Force 15 + 2 du Soldat = 17, modificateur +3', () {
      final str = _sheet().abilities['str']!;
      expect(str.value, 17);
      expect(str.modifier, 3);
    });

    test('Intelligence 8 sans bonus = 8, modificateur −1', () {
      final int = _sheet().abilities['int']!;
      expect(int.value, 8);
      expect(int.modifier, -1);
    });

    test('la Force est décomposée en base et bonus du Soldat', () {
      expect(_sheet().abilities['str']!.sources, [
        const Contribution('base', 15),
        const Contribution('srd:background:soldier', 2),
      ]);
    });
  });

  test('bonus de maîtrise +2 au niveau 1', () {
    expect(_sheet().proficiencyBonus, 2);
  });

  test('même entrée, même fiche', () {
    expect(_sheet().toJson(), _sheet().toJson());
  });

  group('génération des valeurs', () {
    test("l'acquisition par points d'Aldric coûte 27", () {
      final sheet = _sheet();
      expect(sheet.pointBuyCost, 27);
      expect(_rules(sheet), isNot(contains(IntegrityRule.abilityGeneration)));
    });

    test('29 points dépensés sont une erreur', () {
      final sheet = _sheet((json) => _setBase(json, {'cha': 12}));
      expect(sheet.pointBuyCost, 29);
      expect(_rules(sheet), contains(IntegrityRule.abilityGeneration));
    });

    test('une valeur hors de 8 à 15 est une erreur', () {
      final sheet = _sheet(
        (json) => _setBase(json, {'str': 16, 'dex': 12, 'cha': 8}),
      );
      expect(_rules(sheet), contains(IntegrityRule.abilityGeneration));
    });

    test('les valeurs standard dans un ordre quelconque sont valides', () {
      final sheet = _sheet((json) {
        _setBase(json, {
          'method': 'standard_array',
          'str': 15,
          'dex': 13,
          'con': 14,
          'int': 8,
          'wis': 12,
          'cha': 10,
        });
      });
      expect(_rules(sheet), isNot(contains(IntegrityRule.abilityGeneration)));
    });

    test('des valeurs standard modifiées sont une erreur', () {
      final sheet = _sheet((json) {
        _setBase(json, {'method': 'standard_array', 'cha': 11});
      });
      expect(_rules(sheet), contains(IntegrityRule.abilityGeneration));
    });

    test('la génération aléatoire doit répartir exactement les jets', () {
      final ok = _sheet((json) {
        (json['base_scores']! as Map<String, Object?>)
          ..['method'] = 'random'
          ..['rolls'] = [15, 13, 14, 8, 12, 10];
      });
      expect(_rules(ok), isNot(contains(IntegrityRule.abilityGeneration)));
      final wrong = _sheet((json) {
        (json['base_scores']! as Map<String, Object?>)
          ..['method'] = 'random'
          ..['rolls'] = [18, 13, 14, 8, 12, 10];
      });
      expect(_rules(wrong), contains(IntegrityRule.abilityGeneration));
    });
  });

  group("bonus d'Historique (§11.3)", () {
    Map<String, Object?> choice(Map<String, Object?> json) =>
        json['background_choice']! as Map<String, Object?>;

    test('une caractéristique non éligible est une erreur', () {
      final sheet = _sheet(
        (json) => choice(json)['bonuses'] = {'str': 2, 'int': 1},
      );
      expect(_rules(sheet), contains(IntegrityRule.backgroundBonus));
    });

    test('la répartition 1-1-1 sur For, Dex, Con est valide', () {
      final sheet = _sheet((json) {
        choice(json)
          ..['distribution'] = '1-1-1'
          ..['bonuses'] = {'str': 1, 'dex': 1, 'con': 1};
      });
      expect(_rules(sheet), isNot(contains(IntegrityRule.backgroundBonus)));
      expect(sheet.abilities['dex']!.value, 14);
    });

    test('une répartition qui ne suit pas la distribution est une erreur', () {
      final sheet = _sheet(
        (json) => choice(json)['bonuses'] = {'str': 1, 'con': 1},
      );
      expect(_rules(sheet), contains(IntegrityRule.backgroundBonus));
    });

    test('une valeur portée au-delà de 20 est une erreur', () {
      final sheet = _sheet((json) {
        (json['base_scores']! as Map<String, Object?>)
          ..['method'] = 'random'
          ..['rolls'] = [19, 13, 14, 8, 12, 10]
          ..['str'] = 19;
      });
      expect(_rules(sheet), contains(IntegrityRule.backgroundBonus));
    });
  });
}
