// Spec character-sheet : « Jets de sauvegarde », « Compétences et
// Perception passive », « Dons accordés conformes », « Initiative »,
// « Classe d'armure », « Vitesse, points de vie et dés de vie »,
// « Ressources ». Valeurs : [D1] et SRD p. 23-24, 56, 90, 92-93, 98.
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

ComputedSheet _sheet([void Function(Map<String, Object?> json)? change]) =>
    computeSheet(aldric(change), srdContent());

List<Object?> _list(Map<String, Object?> json, String key) =>
    json[key]! as List<Object?>;

Map<String, Object?> _feat(Map<String, Object?> json, String sourceType) =>
    _list(json, 'feats').cast<Map<String, Object?>>().firstWhere(
      (f) => f['source_type'] == sourceType,
    );

void main() {
  test('jets de sauvegarde du Guerrier : FOR +5, CON +4, DEX +1', () {
    final saves = _sheet().savingThrows;
    expect(saves['str'], 5);
    expect(saves['con'], 4);
    expect(saves['dex'], 1);
    expect(saves['int'], -1);
  });

  group('compétences', () {
    test("maîtrises d'Aldric (Soldat, Guerrier, Compétent)", () {
      final skills = _sheet().skills;
      expect(skills['athletics'], 5);
      expect(skills['intimidation'], 2);
      expect(skills['perception'], 3);
      expect(skills['insight'], 3);
      expect(skills['arcana'], -1);
      expect(skills, hasLength(18));
    });

    test('Perception passive 13', () {
      expect(_sheet().passivePerception, 13);
    });

    test('le choix Compétent donne la compétence choisie', () {
      final sheet = _sheet(
        (json) => json['choices'] = {
          'skillful': ['srd:skill:stealth'],
        },
      );
      expect(sheet.skills['stealth'], 3);
      expect(sheet.skills['insight'], 1);
    });
  });

  group('dons accordés (§11.3)', () {
    Iterable<IntegrityRule> rules(ComputedSheet s) =>
        s.integrityErrors.map((e) => e.rule);

    test("les dons d'Aldric sont conformes", () {
      expect(rules(_sheet()), isNot(contains(IntegrityRule.featGrant)));
    });

    test(
      "Polyvalent avec Défense, qui n'est pas d'origines, est une erreur",
      () {
        final sheet = _sheet(
          (json) => _feat(json, 'species')['feat_id'] = 'srd:feat:defense',
        );
        expect(rules(sheet), contains(IntegrityRule.featGrant));
      },
    );

    test("un don d'Historique remplacé est une erreur", () {
      final sheet = _sheet(
        (json) => _feat(json, 'background')['feat_id'] = 'srd:feat:alert',
      );
      expect(rules(sheet), contains(IntegrityRule.featGrant));
    });

    test('un don accordé non choisi est une erreur', () {
      final sheet = _sheet(
        (json) => _list(json, 'feats').removeWhere(
          (f) => (f! as Map<String, Object?>)['source_type'] == 'class',
        ),
      );
      expect(rules(sheet), contains(IntegrityRule.featGrant));
    });
  });

  group('Initiative', () {
    test('Vigilant : DEX +1 et maîtrise +2, sans Avantage', () {
      final initiative = _sheet().initiative;
      expect(initiative.value, 3);
      expect(initiative.advantage, isFalse);
      expect(initiative.sources, [
        const Contribution('dex', 1),
        const Contribution('srd:feat:alert', 2),
      ]);
    });
  });

  group("classe d'armure", () {
    test('cotte de mailles, bouclier et Défense : 19', () {
      final ac = _sheet().armorClass;
      expect(ac.value, 19);
      expect(ac.sources, [
        const Contribution('srd:armor:chain-mail', 16),
        const Contribution('srd:armor:shield', 2),
        const Contribution('srd:feat:defense', 1),
      ]);
    });

    test('sans armure ni bouclier : 10 + DEX, sans Défense', () {
      final ac = _sheet((json) {
        for (final item in _list(json, 'items').cast<Map<String, Object?>>()) {
          item['equipped'] = false;
        }
      }).armorClass;
      expect(ac.value, 11);
      expect(ac.sources, [
        const Contribution('base', 10),
        const Contribution('dex', 1),
      ]);
    });

    test('armure de cuir : 11 + DEX sans plafond', () {
      final ac = _sheet((json) {
        final items = _list(json, 'items').cast<Map<String, Object?>>();
        items.firstWhere((i) => i['item_id'] == 'srd:armor:chain-mail')
          ..['item_id'] = 'srd:armor:leather';
      }).armorClass;
      expect(ac.value, 11 + 1 + 2 + 1);
    });
  });

  test('vitesse 30 pieds, PV 12, 1 dé de vie d10', () {
    final sheet = _sheet();
    expect(sheet.speedFeet, 30);
    expect(sheet.hitPointsMax.value, 12);
    expect(sheet.hitPointsMax.sources, [
      const Contribution('srd:class:fighter', 10),
      const Contribution('con', 2),
    ]);
    expect(sheet.hitDice, (die: 'd10', total: 1));
  });

  test('ressources : Second souffle 2 et Inspiration héroïque', () {
    expect(_sheet().resources, {
      'srd:resource:second-wind': 2,
      'srd:resource:heroic-inspiration': 1,
    });
  });
}
