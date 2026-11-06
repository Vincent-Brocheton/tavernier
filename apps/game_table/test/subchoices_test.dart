// Spec character-creation : « Sous-choix de niveau 1 », sur le pack SRD réel.
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_draft.dart';
import 'package:game_table/creation/subchoices.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

CreationDraft _draft(String cls, String background, String species) =>
    const CreationDraft()
        .selectClass('srd:class:$cls')
        .selectBackground('srd:background:$background')
        .selectSpecies('srd:species:$species', const ['M']);

Subchoice _section(CreationDraft draft, String key) =>
    subchoiceSections(draft, _content).singleWhere((s) => s.key == key);

List<String> _blocked(Subchoice section) => [
  for (final o in section.options)
    if (o.block != null) o.label,
];

void main() {
  group('extrait d’un texte de règles', () {
    test('« cf. » ne coupe pas la phrase (Polyvalent)', () {
      expect(
        firstSentence(
          'Vous recevez le don de votre choix (cf. « Dons »). Doué est '
          'recommandé.',
        ),
        'Vous recevez le don de votre choix (cf. « Dons »).',
      );
    });

    test('s’arrête au premier paragraphe (Doué)', () {
      expect(
        firstSentence('Trois maîtrises.\nRépétable. Vous pouvez le reprendre.'),
        'Trois maîtrises.',
      );
    });

    test('saute la formule d’annonce d’un don (Vigilant)', () {
      expect(
        firstSentence(_content.entity('srd:feat:alert')!.textFr!),
        'Maîtrise de l’Initiative.',
      );
    });
  });

  test('Guerrier Soldat : compétences de l’Historique grisées', () {
    final skills = _section(
      _draft('fighter', 'soldier', 'dwarf'),
      'classSkills',
    );
    expect(skills.count, 2);
    expect(_blocked(skills), ['Athlétisme', 'Intimidation']);
  });

  test('sections selon le personnage', () {
    List<String> keys(CreationDraft draft) => [
      for (final s in subchoiceSections(draft, _content)) s.key,
    ];
    expect(keys(_draft('fighter', 'criminal', 'dwarf')), [
      'classSkills',
      'masteries',
      'fightingStyle',
    ]);
    expect(keys(_draft('bard', 'criminal', 'dwarf')), [
      'classSkills',
      'classTools',
    ]);
    expect(keys(_draft('cleric', 'sage', 'elf')), [
      'classSkills',
      'cleric-divine-order',
      'elven-lineage',
      'keen-senses',
    ]);
    expect(keys(_draft('monk', 'sage', 'human')), [
      'classSkills',
      'originFeat',
      'skillful',
    ]);
  });

  test('Goliath : un bénéfice d’Ascendance gigante parmi six', () {
    final ancestry = _section(
      _draft('monk', 'sage', 'goliath'),
      'giant-ancestry',
    );
    expect(ancestry.count, 1);
    expect(ancestry.options.map((o) => o.label), [
      'Brûlure ignée',
      'Endurance de la pierre',
      'Froid mordant',
      'Renversement des coteaux',
      'Saut des nuées',
      'Tonnerre des cieux',
    ]);
  });

  test('Barde : 3 instruments sur 10', () {
    final tools = _section(_draft('bard', 'sage', 'dwarf'), 'classTools');
    expect(tools.count, 3);
    expect(tools.options, hasLength(10));
    expect(tools.options.map((o) => o.label), contains('luth'));
  });

  test('Humain Soldat : Sauvagerie martiale déjà obtenue, non répétable', () {
    final feats = _section(_draft('monk', 'soldier', 'human'), 'originFeat');
    expect(feats.options, hasLength(4));
    expect(_blocked(feats), ['Sauvagerie martiale']);
    expect(
      feats.options.singleWhere((o) => o.block != null).block,
      OptionBlock.notRepeatable,
    );
  });

  test('Doué ouvre son choix de 3 compétences', () {
    final draft = _draft(
      'monk',
      'sage',
      'human',
    ).selectOriginFeat('srd:feat:skilled');
    expect(_section(draft, 'skilled').count, 3);
  });

  test('Roublard : Expertise sur une compétence maîtrisée seulement', () {
    final draft = _draft('rogue', 'criminal', 'dwarf');
    final expertise = _section(draft, 'rogue-expertise');
    final free = [
      for (final o in expertise.options)
        if (o.block == null) o.label,
    ];
    expect(free, unorderedEquals(['Discrétion', 'Escamotage']));
    final more = draft.toggleClassSkill('srd:skill:acrobatics', 4);
    expect(
      _blocked(_section(more, 'rogue-expertise')),
      isNot(contains('Acrobaties')),
    );
  });

  test('une maîtrise prise ailleurs ne se reprend pas', () {
    final draft = _draft(
      'monk',
      'sage',
      'human',
    ).togglePick('skillful', 'srd:skill:acrobatics', 1);
    expect(_blocked(_section(draft, 'classSkills')), contains('Acrobaties'));
  });

  test('langue du Roublard : le Commun et les langues choisies sont pris', () {
    final draft = _draft(
      'rogue',
      'criminal',
      'dwarf',
    ).toggleLanguage('srd:language:orc');
    expect(
      _blocked(_section(draft, 'rogue-thieves-cant-language')),
      containsAll(['Commun', 'Orc']),
    );
  });

  group('blocage de l’étape', () {
    CreationDraft atSubchoices(CreationDraft draft) => CreationDraft(
      step: 5,
      reached: 5,
      classId: draft.classId,
      backgroundId: draft.backgroundId,
      speciesId: draft.speciesId,
      size: draft.size,
    );

    test('Guerrier : compétences, bottes et style requis', () {
      var draft = atSubchoices(_draft('fighter', 'criminal', 'dwarf'));
      expect(missingChoice(draft, _content), MissingChoice.subchoices);
      draft = draft
          .toggleClassSkill('srd:skill:perception', 2)
          .toggleClassSkill('srd:skill:survival', 2)
          .toggleMastery('srd:weapon:longsword', 3)
          .toggleMastery('srd:weapon:javelin', 3)
          .toggleMastery('srd:weapon:battleaxe', 3);
      expect(missingChoice(draft, _content), MissingChoice.subchoices);
      expect(
        missingChoice(draft.selectFightingStyle('srd:feat:defense'), _content),
        isNull,
      );
    });

    test('pas plus que le nombre permis', () {
      final draft = atSubchoices(_draft('fighter', 'criminal', 'dwarf'))
          .toggleMastery('srd:weapon:longsword', 2)
          .toggleMastery('srd:weapon:javelin', 2)
          .toggleMastery('srd:weapon:battleaxe', 2);
      expect(draft.masteries, ['srd:weapon:longsword', 'srd:weapon:javelin']);
    });

    test('un choix unique se remplace', () {
      final draft = const CreationDraft()
          .togglePick('elven-lineage', 'Drow', 1)
          .togglePick('elven-lineage', 'Haut-elfe', 1);
      expect(draft.choices['elven-lineage'], ['Haut-elfe']);
      final skills = draft.toggleClassSkill('a', 1).toggleClassSkill('b', 1);
      expect(skills.classSkills, ['b']);
    });

    test('compétence devenue invalide : signalée, l’étape bloque', () {
      final draft = atSubchoices(_draft('fighter', 'criminal', 'dwarf'))
          .toggleClassSkill('srd:skill:athletics', 2)
          .toggleClassSkill('srd:skill:survival', 2)
          .toggleMastery('srd:weapon:longsword', 3)
          .toggleMastery('srd:weapon:javelin', 3)
          .toggleMastery('srd:weapon:battleaxe', 3)
          .selectFightingStyle('srd:feat:defense');
      expect(missingChoice(draft, _content), isNull);
      final soldier = draft.selectBackground('srd:background:soldier');
      final skills = _section(soldier, 'classSkills');
      expect(skills.invalid.single.label, 'Athlétisme');
      expect(skills.complete, isFalse);
      expect(missingChoice(soldier, _content), MissingChoice.subchoices);
    });

    test('changer de classe efface ses sous-choix', () {
      final draft = _draft('fighter', 'criminal', 'dwarf')
          .toggleClassSkill('srd:skill:perception', 2)
          .toggleMastery('srd:weapon:longsword', 3)
          .selectFightingStyle('srd:feat:defense')
          .selectClass('srd:class:bard');
      expect(draft.classSkills, isEmpty);
      expect(draft.masteries, isEmpty);
      expect(draft.fightingStyle, isNull);
    });

    test('changer d’espèce efface le don de Polyvalent', () {
      final draft = _draft('monk', 'sage', 'human')
          .selectOriginFeat('srd:feat:alert')
          .selectSpecies('srd:species:orc', const ['M']);
      expect(draft.originFeat, isNull);
    });
  });
}
