// Spec homebrew : « Arme ou armure magique », « Listes de classes d'un sort »
// (US-27 lot b).
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

ContentEntity _entity(Map<String, Object?> json) =>
    parseEntity(json, 'test').entity!;

void main() {
  final aldric = CharacterInput.fromJson(fixtureInput('aldric_n5'));

  group('armure magique', () {
    // Variante du bouclier : +1 CA, harmonisation requise.
    final shield = _entity({
      'id': 'hb:armor:warden-shield',
      'type': 'armor',
      'name': 'Bouclier du veilleur',
      'extends_id': 'srd:armor:shield',
      'data': {
        'category': 'shield',
        'base_ac': 2,
        'weight_kg': 3.0,
        'cost_cp': 1000,
        'rarity': 'uncommon',
        'attunement': true,
      },
      'effects': [
        {'op': 'modify_ac', 'value': 1},
      ],
    });
    final content = srdContent([shield]);
    CharacterInput holding({required bool attuned}) => aldric.copyWith(
      items: [
        for (final i in aldric.items)
          if (i.itemId != 'srd:armor:shield') i,
        ItemInput(
          itemId: '${shield.id}',
          quantity: 1,
          equipped: true,
          attuned: attuned,
        ),
      ],
    );

    test('harmonisée et portée : bouclier +2 et effet +1', () {
      // [D1] : 19 avec la cotte de mailles et le bouclier du SRD.
      expect(
        computeSheet(holding(attuned: true), content).armorClass.value,
        20,
      );
    });

    test('portée sans harmonisation : sans effet', () {
      expect(
        computeSheet(holding(attuned: false), content).armorClass.value,
        19,
      );
    });

    test('sans rareté, une armure ordinaire n\'applique pas ses effets', () {
      final plain = parseEntity({
        ...shield.toJson(),
        'data': {
          ...shield.data.toJson()
            ..remove('rarity')
            ..remove('attunement'),
        },
      }, 'test').entity!;
      final sheet = computeSheet(
        aldric.copyWith(
          items: [
            for (final i in aldric.items)
              if (i.itemId != 'srd:armor:shield') i,
            ItemInput(itemId: '${plain.id}', quantity: 1, equipped: true),
          ],
        ),
        srdContent([plain]),
      );
      expect(sheet.armorClass.value, 19);
    });

    test('l\'harmonisation se lit sur l\'arme et l\'armure', () {
      expect(requiresAttunement(shield.data), isTrue);
      expect(
        requiresAttunement(content.entity('srd:armor:shield')!.data),
        isFalse,
      );
      expect(
        requiresAttunement(
          content.entity('srd:magic-item:cloak-of-protection')!.data,
        ),
        isTrue,
      );
    });
  });

  group('listes de classes d\'un sort', () {
    final spell = _entity({
      'id': 'hb:spell:mist-lantern',
      'type': 'spell',
      'name': 'Lanterne de brume',
      'data': {
        'level': 1,
        'school': 'illusion',
        'casting_time': 'action',
        'ritual': false,
        'range': {'kind': 'feet', 'feet': 60},
        'components': {'verbal': true, 'somatic': true},
        'material_consumed': false,
        'duration': '1 heure',
        'concentration': false,
        'classes': ['srd:class:wizard', 'srd:class:bard'],
      },
      'text': {'fr': 'Une lueur pâle.'},
    });
    final content = srdContent([spell]);

    test('le sort entre dans la liste de ses classes, après le SRD', () {
      final wizard = content.spellList('srd:class:wizard');
      final srd =
          (content.entity('srd:class:wizard')!.data as ClassData).spellList;
      expect(wizard, [...srd, spell.id]);
      expect(content.spellList('srd:class:bard'), contains(spell.id));
    });

    test('pas dans les autres classes', () {
      expect(content.spellList('srd:class:cleric'), isNot(contains(spell.id)));
    });

    test('classe inconnue : liste vide', () {
      expect(content.spellList('hb:class:none'), isEmpty);
    });
  });
}
