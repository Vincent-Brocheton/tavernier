// Spec content-pack : « Type d'entité objet magique ».
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

Map<String, Object?> _staff({
  Map<String, Object?> data = const {},
  Map<String, Object?>? text = const {'fr': 'Ce bâton a 10 charges.'},
}) => {
  'id': 'srd:magic-item:staff-of-healing',
  'type': 'magic-item',
  'name': 'Bâton de guérison',
  'data': {
    'category': 'staff',
    'rarity': 'rare',
    'type_line':
        'Bâton, rare (Harmonisation requise avec un Barde, Clerc ou Druide)',
    'attunement': true,
    'attunement_by': 'un Barde, Clerc ou Druide',
    ...data,
  },
  'text': ?text,
};

void main() {
  test('objet magique lu et réécrit à l’identique', () {
    final json = _staff();
    final entity = parseEntity(json, 'magic-item/x.json').entity!;
    final data = entity.data as MagicItemData;
    expect(data.category, MagicItemCategory.staff);
    expect(data.rarity, Rarity.rare);
    expect(data.attunement, isTrue);
    expect(data.attunementBy, 'un Barde, Clerc ou Druide');
    expect(entity.toJson(), json);
  });

  test('toutes les raretés, très rare et variable comprises', () {
    for (final (value, rarity) in [
      ('common', Rarity.common),
      ('very_rare', Rarity.veryRare),
      ('artifact', Rarity.artifact),
      ('varies', Rarity.varies),
    ]) {
      final data =
          parseEntity(_staff(data: {'rarity': value}), 'x').entity!.data
              as MagicItemData;
      expect(data.rarity, rarity);
    }
  });

  test('sans harmonisation par défaut', () {
    final json = _staff();
    (json['data']! as Map<String, Object?>)
      ..remove('attunement')
      ..remove('attunement_by');
    final data = parseEntity(json, 'x').entity!.data as MagicItemData;
    expect((data.attunement, data.attunementBy), (false, null));
  });

  test('texte obligatoire', () {
    final result = parseEntity(_staff(text: null), 'x');
    expect(result.entity, isNull);
    expect(result.issues, isNotEmpty);
  });

  test('rareté ou catégorie inconnue refusée', () {
    expect(
      parseEntity(_staff(data: {'rarity': 'mythique'}), 'x').entity,
      isNull,
    );
    expect(
      parseEntity(_staff(data: {'category': 'relique'}), 'x').entity,
      isNull,
    );
  });
}
