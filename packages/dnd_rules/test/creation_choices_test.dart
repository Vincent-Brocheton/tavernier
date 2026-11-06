// Spec character-creation : « Sous-choix de niveau 1 ».
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  final content = srdContent();
  ClassData cls(String slug) =>
      content.entity('srd:class:$slug')!.data as ClassData;

  test('Clerc : Ordre divin, options nommées', () {
    final choices = openChoices(content, levelOneFeatures(cls('cleric')));
    final order = choices.single;
    expect(order.id, 'cleric-divine-order');
    expect(order.count, 1);
    expect(
      [for (final o in order.options) o.label],
      ['Protecteur', 'Thaumaturge'],
    );
    expect(order.options.first.pick, 'Protecteur');
  });

  group('sorts de départ (tables de classe, SRD)', () {
    test('Clerc : 3 sorts mineurs, 4 préparés', () {
      expect(cantripsAtFirstLevel(cls('cleric')), 3);
      expect(preparedAtFirstLevel(cls('cleric')), 4);
    });

    test('Paladin : aucun sort mineur, 2 préparés', () {
      expect(cantripsAtFirstLevel(cls('paladin')), 0);
      expect(preparedAtFirstLevel(cls('paladin')), 2);
    });

    test('Guerrier : aucun sort', () {
      expect(cantripsAtFirstLevel(cls('fighter')), 0);
      expect(preparedAtFirstLevel(cls('fighter')), 0);
    });

    test('grimoire : 6 sorts, pour le Magicien seul', () {
      expect(spellbookSize('srd:class:wizard'), 6);
      expect(spellbookSize('srd:class:cleric'), 0);
    });

    test('Thaumaturge : un sort mineur de plus, Protecteur aucun', () {
      final order = openChoices(
        content,
        levelOneFeatures(cls('cleric')),
      ).single;
      expect(
        {for (final o in order.options) o.label: o.bonusCantrips},
        {'Protecteur': 0, 'Thaumaturge': 1},
      );
    });
  });

  test('Lignage elfique : le choix de caractéristique porte un titre', () {
    final choices = openChoices(content, ['srd:feature:elf-elven-lineage']);
    expect(choices.first.title, isNull);
    expect(choices.last.title, 'Caractéristique d’incantation');
    expect(
      [for (final o in choices.last.options) o.label],
      ['Intelligence', 'Sagesse', 'Charisme'],
    );
  });

  test('Initié à la magie : listes et caractéristiques du pack', () {
    expect(content.entity(magicInitiateFeat), isNotNull);
    for (final id in [...magicInitiateLists, ...magicInitiateAbilities]) {
      expect(content.entity(id), isNotNull, reason: id);
    }
  });

  test('Roublard : Expertise et langue, le palier du niveau 6 écarté', () {
    final choices = openChoices(content, levelOneFeatures(cls('rogue')));
    expect(
      {for (final c in choices) c.id},
      {'rogue-thieves-cant-language', 'rogue-expertise'},
    );
    final expertise = choices.singleWhere((c) => c.id == 'rogue-expertise');
    expect(expertise.count, 2);
    expect(expertise.options.first.expertise, isTrue);
    expect(expertise.options.first.pick, startsWith('srd:skill:'));
    expect(expertise.options.first.label, isNot(startsWith('srd:')));
  });

  test('Elfe : lignage nommé et compétence de Sens aiguisés', () {
    final elf = content.entity('srd:species:elf')!.data as SpeciesData;
    final choices = openChoices(content, [for (final t in elf.traits) '$t']);
    expect(
      {for (final c in choices) c.id},
      {'elven-lineage', 'elven-lineage-ability', 'keen-senses'},
    );
    expect(
      [for (final o in choices.first.options) o.label],
      ['Drow', 'Elfe sylvestre', 'Haut-elfe'],
    );
  });

  test('Ascendance draconique : options nommées par leur type de dégâts', () {
    final choice = openChoices(content, [
      'srd:feature:dragonborn-draconic-ancestry',
    ]).single;
    expect([for (final o in choice.options) o.label], contains('Feu'));
    expect(choice.options.first.pick, startsWith('srd:damage-type:'));
  });

  test('dons accordés : style pour le Guerrier, origines pour l’Humain', () {
    expect(grantedFeatCategories(content, levelOneFeatures(cls('fighter'))), [
      'fighting_style',
    ]);
    expect(
      grantedFeatCategories(content, levelOneFeatures(cls('bard'))),
      isEmpty,
    );
    final human = content.entity('srd:species:human')!.data as SpeciesData;
    expect(
      grantedFeatCategories(content, [for (final t in human.traits) '$t']),
      ['origin'],
    );
  });

  group('bottes', () {
    test('Guerrier (p. 56) : 3, toute arme', () {
      final options = masteryOptions(content, cls('fighter'));
      expect(options.slots, 3);
      expect(options.weapons, hasLength(38));
    });

    test('Barbare (p. 31) : 2, corps à corps seulement', () {
      final options = masteryOptions(content, cls('barbarian'));
      expect(options.slots, 2);
      final ids = [for (final w in options.weapons) '${w.id}'];
      expect(ids, contains('srd:weapon:greataxe'));
      expect(ids, isNot(contains('srd:weapon:longbow')));
    });

    test('Roublard : armes de guerre Finesse ou Légère seulement', () {
      final options = masteryOptions(content, cls('rogue'));
      expect(options.slots, 2);
      final ids = [for (final w in options.weapons) '${w.id}'];
      expect(ids, contains('srd:weapon:rapier'));
      expect(ids, isNot(contains('srd:weapon:longsword')));
    });

    test('Barde : aucune', () {
      expect(masteryOptions(content, cls('bard')).slots, 0);
      expect(masteryOptions(content, cls('bard')).weapons, isEmpty);
    });
  });
}
