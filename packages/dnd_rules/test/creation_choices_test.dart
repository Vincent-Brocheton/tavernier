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
    expect({for (final c in choices) c.id}, {'elven-lineage', 'keen-senses'});
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
