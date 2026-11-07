// Spec character-sheet : « Inventaire », « Équipement », « Harmonisation »,
// « Monnaie ». Valeurs de [D1] et [P15].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final content = srdContent();
  final aldric = CharacterInput.fromJson(fixtureInput('aldric_n5'));

  int indexOf(CharacterInput character, String id) =>
      character.items.indexWhere((i) => i.itemId == id);

  ItemInput item(CharacterInput character, String id) =>
      character.items.singleWhere((i) => i.itemId == id);

  group('objets', () {
    test('ajouter : nouvel objet, au sac', () {
      final after = addItem(aldric, 'srd:weapon:dagger');
      expect(item(after, 'srd:weapon:dagger').quantity, 1);
      expect(item(after, 'srd:weapon:dagger').equipped, isFalse);
    });

    test('ajouter : un objet possédé s\'empile', () {
      final after = addItem(aldric, 'srd:weapon:javelin');
      expect(item(after, 'srd:weapon:javelin').quantity, 5);
      expect(after.items, hasLength(aldric.items.length));
    });

    test('quantité changée', () {
      final after = setItemQuantity(
        aldric,
        indexOf(aldric, 'srd:weapon:javelin'),
        2,
      );
      expect(item(after, 'srd:weapon:javelin').quantity, 2);
    });

    test('quantité nulle : objet retiré', () {
      final after = setItemQuantity(
        aldric,
        indexOf(aldric, 'srd:weapon:javelin'),
        0,
      );
      expect(indexOf(after, 'srd:weapon:javelin'), -1);
    });
  });

  group('équipement', () {
    test('retirer la cotte de mailles recalcule la CA', () {
      final after = toggleEquipped(
        aldric,
        content,
        indexOf(aldric, 'srd:armor:chain-mail'),
      );
      // 10 + DEX +1 + bouclier +2.
      expect(computeSheet(after, content).armorClass.value, 13);
    });

    test('une seconde armure remplace la première', () {
      final added = addItem(aldric, 'srd:armor:leather');
      final after = toggleEquipped(
        added,
        content,
        indexOf(added, 'srd:armor:leather'),
      );
      expect(item(after, 'srd:armor:leather').equipped, isTrue);
      expect(item(after, 'srd:armor:chain-mail').equipped, isFalse);
      expect(item(after, 'srd:armor:shield').equipped, isTrue);
    });

    test('un second bouclier remplace le premier, pas l\'armure', () {
      final other = aldric.copyWith(
        items: [
          ...aldric.items,
          const ItemInput(itemId: 'srd:armor:shield', quantity: 1),
        ],
      );
      final after = toggleEquipped(other, content, other.items.length - 1);
      expect(after.items.last.equipped, isTrue);
      expect(item(after, 'srd:armor:chain-mail').equipped, isTrue);
      expect(
        after.items.where((i) => i.itemId == 'srd:armor:shield' && i.equipped),
        hasLength(1),
      );
    });

    test('les armes s\'équipent librement', () {
      final after = toggleEquipped(
        aldric,
        content,
        indexOf(aldric, 'srd:weapon:battleaxe'),
      );
      expect(item(after, 'srd:weapon:battleaxe').equipped, isTrue);
      expect(item(after, 'srd:weapon:longsword').equipped, isTrue);
    });

    test('ranger un objet ne touche pas aux autres', () {
      final after = toggleEquipped(
        aldric,
        content,
        indexOf(aldric, 'srd:armor:shield'),
      );
      expect(item(after, 'srd:armor:chain-mail').equipped, isTrue);
    });
  });

  group('harmonisation [P15]', () {
    const cloak = 'srd:magic-item:cloak-of-protection';

    test('Cape portée sans harmonisation : CA 19', () {
      expect(computeSheet(aldric, content).armorClass.value, 19);
      expect(computeSheet(aldric, content).attunedCount, 0);
    });

    test('Cape harmonisée : CA 20 et JS +1', () {
      final before = computeSheet(aldric, content);
      final after = computeSheet(
        toggleAttuned(aldric, indexOf(aldric, cloak)),
        content,
      );
      expect(after.armorClass.value, 20);
      expect(after.savingThrows['str'], before.savingThrows['str']! + 1);
      expect(after.attunedCount, 1);
    });

    test('Cape harmonisée mais rangée : sans effet', () {
      final attuned = toggleAttuned(aldric, indexOf(aldric, cloak));
      final after = toggleEquipped(attuned, content, indexOf(attuned, cloak));
      expect(item(after, cloak).attuned, isTrue);
      expect(computeSheet(after, content).armorClass.value, 19);
    });

    test('3 emplacements', () {
      expect(computeSheet(aldric, content).attunementSlots, 3);
    });

    test('Roublard Voleur niveau 13 : 4 emplacements', () {
      final thief = CharacterInput.fromJson(fixtureInput('thalia_n5'));
      final high = thief.copyWith(
        classLevels: [thief.classLevels.single.copyWith(level: 13)],
      );
      expect(computeSheet(high, content).attunementSlots, 4);
    });

    test('4 objets harmonisés : erreur d\'intégrité', () {
      final sheet = computeSheet(
        aldric.copyWith(
          items: [
            for (var i = 0; i < 4; i++)
              const ItemInput(itemId: cloak, quantity: 1, attuned: true),
          ],
        ),
        content,
      );
      expect(
        sheet.integrityErrors.map((e) => e.rule),
        contains(IntegrityRule.attunement),
      );
    });

    test('3 objets harmonisés : pas d\'erreur', () {
      final sheet = computeSheet(
        aldric.copyWith(
          items: [
            for (var i = 0; i < 3; i++)
              const ItemInput(itemId: cloak, quantity: 1, attuned: true),
          ],
        ),
        content,
      );
      expect(
        sheet.integrityErrors.map((e) => e.rule),
        isNot(contains(IntegrityRule.attunement)),
      );
    });
  });

  test('Aura de protection : CHA aux jets de sauvegarde (SRD)', () {
    final paladin = aldric.copyWith(
      baseScores: aldric.baseScores.copyWith(charisma: 14),
      classLevels: const [
        ClassLevelInput(classId: 'srd:class:paladin', level: 6),
      ],
      feats: const [],
      weaponMasteries: const [],
    );
    final sheet = computeSheet(paladin, content);
    // INT 8 (-1), non maîtrisé, plus CHA 14 (+2).
    expect(sheet.savingThrows['int'], 1);
  });

  group('consommables [J7]', () {
    final potion = consumableOf(content.entity('srd:item:potion-of-healing'));

    test('potion de guérison : 2d4 + 2, action Bonus', () {
      expect(potion, (dice: 2, sides: 4, bonus: 2, action: 'bonus_action'));
    });

    test('un objet ordinaire ne s\'utilise pas', () {
      expect(consumableOf(content.entity('srd:item:healers-kit')), isNull);
      expect(consumableOf(null), isNull);
    });

    test('jet entre 2 et 8', () {
      expect(consumableRollValid(potion!, 1), isFalse);
      expect(consumableRollValid(potion, 2), isTrue);
      expect(consumableRollValid(potion, 8), isTrue);
      expect(consumableRollValid(potion, 9), isFalse);
    });

    test('la fiche ne change pas tant qu\'on ne boit pas', () {
      expect(computeSheet(aldric, content).integrityErrors, isEmpty);
    });
  });

  test('monnaie : une pièce changée, les autres intactes', () {
    final after = setCoin(aldric, 'gp', 40);
    expect(after.coins['gp'], 40);
    expect(after.coins['sp'], 12);
    expect(after.coins['cp'], 30);
  });
}
