// Spec character-sheet : « Emplacements de bottes », « Bottes choisies
// conformes », « Attaques ». Valeurs : [D1] et SRD p. 56, 93, 97, 189.
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

ComputedSheet _sheet(
  void Function(Map<String, Object?> json)? change, [
  List<ContentEntity> extra = const [],
]) => computeSheet(aldric(change), srdContent(extra));

Attack _attack(ComputedSheet sheet, String weaponId) =>
    sheet.attacks.firstWhere((a) => a.weaponId == weaponId);

List<Map<String, Object?>> _items(Map<String, Object?> json) =>
    (json['items']! as List<Object?>).cast<Map<String, Object?>>();

/// Classe de test qui ne maîtrise que les armes courantes, avec les Bottes
/// d'arme du Guerrier.
ContentEntity _simpleOnlyClass() {
  final fighter = srdPack.entities.firstWhere(
    (e) => '${e.id}' == 'srd:class:fighter',
  );
  final json = fighter.toJson()
    ..['id'] = 'test:class:militia'
    ..['name'] = 'Milice';
  (json['data']! as Map<String, Object?>)['weapon_proficiencies'] = ['simple'];
  return parseEntity(json, 'test').entity!;
}

void main() {
  test('Guerrier 1 : 3 emplacements de bottes', () {
    expect(_sheet(null).weaponMasterySlots, 3);
  });

  group('bottes choisies (§11.3)', () {
    Iterable<IntegrityRule> rules(ComputedSheet s) =>
        s.integrityErrors.map((e) => e.rule);

    test("les bottes d'Aldric sont conformes", () {
      expect(rules(_sheet(null)), isNot(contains(IntegrityRule.weaponMastery)));
    });

    test('4 bottes pour 3 emplacements est une erreur', () {
      final sheet = _sheet(
        (json) => (json['weapon_masteries']! as List<Object?>).add({
          'weapon_id': 'srd:weapon:greatsword',
          'slot_index': 3,
        }),
      );
      expect(rules(sheet), contains(IntegrityRule.weaponMastery));
    });

    test('la botte d\'une arme non maîtrisée est une erreur', () {
      final sheet = _sheet((json) {
        ((json['class_levels']! as List<Object?>).first!
                as Map<String, Object?>)['class_id'] =
            'test:class:militia';
      }, [_simpleOnlyClass()]);
      final masteryErrors = sheet.integrityErrors.where(
        (e) => e.rule == IntegrityRule.weaponMastery,
      );
      expect(masteryErrors.map((e) => e.path), [
        'weapon_masteries[0]',
        'weapon_masteries[2]',
      ]);
    });
  });

  group('attaques', () {
    test('épée longue : +5, 1d8+3 tranchants, Sape', () {
      final sword = _attack(_sheet(null), 'srd:weapon:longsword');
      expect(sword.attackBonus, 5);
      expect(sword.damage, '1d8+3');
      expect(sword.damageType, 'slashing');
      expect(sword.mastery, 'srd:mastery:sap');
    });

    test('javeline : +5, 1d6+3 perforants, 30/120 pieds, Ralentissement', () {
      final javelin = _attack(_sheet(null), 'srd:weapon:javelin');
      expect(javelin.attackBonus, 5);
      expect(javelin.damage, '1d6+3');
      expect(javelin.damageType, 'piercing');
      expect(javelin.rangeFeet, [30, 120]);
      expect(javelin.mastery, 'srd:mastery:slow');
    });

    test('mains nues : +5, 4 contondants', () {
      final unarmed = _attack(_sheet(null), 'unarmed');
      expect(unarmed.attackBonus, 5);
      expect(unarmed.damage, '4');
      expect(unarmed.damageType, 'bludgeoning');
      expect(unarmed.mastery, isNull);
    });

    test('Finesse : la meilleure de Force et Dextérité', () {
      final sheet = _sheet((json) {
        (json['base_scores']! as Map<String, Object?>)
          ..['str'] = 8
          ..['dex'] = 15;
        _items(json).add({'item_id': 'srd:weapon:dagger', 'quantity': 1});
      });
      final dagger = _attack(sheet, 'srd:weapon:dagger');
      expect(dagger.attackBonus, 4);
      expect(dagger.damage, '1d4+2');
    });

    test('arme à distance : Dextérité, et +2 avec Archerie', () {
      final bow = _sheet((json) {
        _items(json).add({'item_id': 'srd:weapon:shortbow', 'quantity': 1});
        (json['feats']! as List<Object?>)
                .cast<Map<String, Object?>>()
                .firstWhere((f) => f['source_type'] == 'class')['feat_id'] =
            'srd:feat:archery';
      });
      final shortbow = _attack(bow, 'srd:weapon:shortbow');
      expect(shortbow.attackBonus, 1 + 2 + 2);
      expect(shortbow.damage, '1d6+1');
      expect(shortbow.rangeFeet, [80, 320]);
    });
  });
}
