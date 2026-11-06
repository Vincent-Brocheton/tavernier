// Spec character-creation : « Sous-choix de niveau 1 », sur le pack SRD réel.
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_draft.dart';
import 'package:game_table/creation/step_layout.dart';
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
      'spells-cantrips',
      'spells-prepared',
    ]);
    expect(keys(_draft('cleric', 'soldier', 'elf')), [
      'classSkills',
      'cleric-divine-order',
      'elven-lineage',
      'elven-lineage-ability',
      'keen-senses',
      'spells-cantrips',
      'spells-prepared',
    ]);
    expect(keys(_draft('monk', 'soldier', 'human')), [
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

  test('toute combinaison a assez d’options libres', () {
    final feats = [
      null,
      for (final feat in sortedEntities(_content, 'feat'))
        if ((feat.data as FeatData).category == FeatCategory.origin)
          '${feat.id}',
    ];
    for (final cls in sortedEntities(_content, 'class')) {
      for (final background in sortedEntities(_content, 'background')) {
        for (final species in sortedEntities(_content, 'species')) {
          for (final feat in feats) {
            var draft = const CreationDraft()
                .selectClass('${cls.id}')
                .selectBackground('${background.id}')
                .selectSpecies('${species.id}', const ['M']);
            if (feat != null) draft = draft.selectOriginFeat(feat);
            for (final section in subchoiceSections(draft, _content)) {
              final free = section.options.where((o) => o.block == null);
              expect(
                free.length,
                greaterThanOrEqualTo(section.count),
                reason: '${draft.classId} ${draft.speciesId} ${section.key}',
              );
            }
          }
        }
      }
    }
  });

  group('sorts de départ', () {
    test('Clerc : 3 sorts mineurs et 4 préparés de sa liste', () {
      final draft = _draft('cleric', 'soldier', 'dwarf');
      final cantrips = _section(draft, cantripsKey);
      expect(cantrips.count, 3);
      expect(
        cantrips.options.map((o) => o.label),
        containsAll(['Assistance', 'Flamme sacrée']),
      );
      final prepared = _section(draft, preparedKey);
      expect(prepared.count, 4);
      expect(prepared.options.map((o) => o.label), contains('Bénédiction'));
      expect(
        prepared.options.map((o) => o.label),
        isNot(contains('Flamme sacrée')),
      );
    });

    test('un sort choisi ne se reprend pas dans une autre section', () {
      final draft = _draft(
        'cleric',
        'acolyte',
        'dwarf',
      ).togglePick(cantripsKey, 'srd:spell:guidance', 3);
      final initiate = _section(draft, 'magic-initiate-background-cantrips');
      expect(_blocked(initiate), ['Assistance']);
      expect(initiate.options.first.block, OptionBlock.spellKnown);
      final other = draft.togglePick(
        'magic-initiate-background-cantrips',
        'srd:spell:mending',
        2,
      );
      expect(_blocked(_section(other, cantripsKey)), contains('Réparation'));
    });

    test('un sort d’espèce ne se reprend pas', () {
      expect(
        _blocked(
          _section(_draft('cleric', 'soldier', 'tiefling'), cantripsKey),
        ),
        ['Thaumaturgie'],
      );
    });

    test('un sort du lignage retenu ne se reprend pas', () {
      final draft = _draft(
        'wizard',
        'soldier',
        'elf',
      ).togglePick('elven-lineage', 'Haut-elfe', 1);
      expect(_blocked(_section(draft, cantripsKey)), ['Prestidigitation']);
    });

    test('un sort accordé par la classe ne se prépare pas (Rôdeur)', () {
      expect(
        _blocked(_section(_draft('ranger', 'soldier', 'dwarf'), preparedKey)),
        ['Marque du chasseur'],
      );
    });

    test('devenu connu par un autre choix : à refaire', () {
      final draft = _draft('wizard', 'soldier', 'elf')
          .togglePick(cantripsKey, 'srd:spell:prestidigitation', 3)
          .togglePick('elven-lineage', 'Haut-elfe', 1);
      final cantrips = _section(draft, cantripsKey);
      expect(cantrips.invalid.single.label, 'Prestidigitation');
      expect(cantrips.complete, isFalse);
    });

    test('Magicien : grimoire et sorts préparés ne se bloquent pas', () {
      var draft = _draft('wizard', 'soldier', 'dwarf');
      final six = [
        for (final o in _section(draft, spellbookKey).options.take(6)) o.id,
      ];
      for (final id in six) {
        draft = draft.toggleSpellbook(id, 6);
      }
      draft = draft.togglePick(preparedKey, six.first, 4);
      expect(_blocked(_section(draft, spellbookKey)), isEmpty);
      expect(_blocked(_section(draft, preparedKey)), isEmpty);
    });

    test('Thaumaturge : un sort mineur de plus', () {
      final draft = _draft(
        'cleric',
        'soldier',
        'dwarf',
      ).togglePick('cleric-divine-order', 'Thaumaturge', 1);
      expect(_section(draft, cantripsKey).count, 4);
    });

    test('trop de sorts mineurs après l’Ordre divin : section incomplète', () {
      var draft = _draft(
        'cleric',
        'soldier',
        'dwarf',
      ).togglePick('cleric-divine-order', 'Thaumaturge', 1);
      for (final id in ['a', 'b', 'c', 'd']) {
        draft = draft.togglePick(cantripsKey, id, 4);
      }
      draft = draft.togglePick('cleric-divine-order', 'Protecteur', 1);
      expect(_section(draft, cantripsKey).complete, isFalse);
    });

    test('Paladin : pas de sorts mineurs', () {
      final draft = _draft('paladin', 'soldier', 'dwarf');
      expect(_section(draft, preparedKey).count, 2);
      expect(
        subchoiceSections(draft, _content).map((s) => s.key),
        isNot(contains(cantripsKey)),
      );
    });

    test('Magicien : le grimoire d’abord, puis 4 sorts parmi les 6', () {
      var draft = _draft('wizard', 'soldier', 'dwarf');
      final book = _section(draft, spellbookKey);
      expect(book.count, 6);
      expect(
        subchoiceSections(draft, _content).map((s) => s.key),
        isNot(contains(preparedKey)),
      );
      final six = [for (final o in book.options.take(6)) o.id];
      for (final id in six) {
        draft = draft.toggleSpellbook(id, 6);
      }
      final prepared = _section(draft, preparedKey);
      expect(prepared.count, 4);
      expect(prepared.options.map((o) => o.id), six);
    });

    test('un sort retiré du grimoire n’est plus préparé', () {
      final draft = _draft('wizard', 'soldier', 'dwarf')
          .toggleSpellbook('a', 6)
          .toggleSpellbook('b', 6)
          .togglePick(preparedKey, 'a', 4)
          .togglePick(preparedKey, 'b', 4)
          .toggleSpellbook('a', 6);
      expect(draft.choices[preparedKey], ['b']);
    });

    test('changer de classe efface les sorts de classe', () {
      final draft = _draft('cleric', 'soldier', 'dwarf')
          .togglePick(cantripsKey, 'srd:spell:guidance', 3)
          .togglePick('elven-lineage', 'Drow', 1)
          .selectClass('srd:class:bard');
      expect(draft.choices.keys, ['elven-lineage']);
    });
  });

  group('Initié à la magie', () {
    final place = InitiatePlace.species;

    test('Acolyte : liste imposée, sorts du Clerc', () {
      final draft = _draft('monk', 'acolyte', 'dwarf');
      final keys = subchoiceSections(draft, _content).map((s) => s.key);
      expect(keys, isNot(contains('magic-initiate-background-list')));
      final cantrips = _section(draft, 'magic-initiate-background-cantrips');
      expect(cantrips.count, 2);
      expect(cantrips.listId, 'srd:class:cleric');
      expect(cantrips.options.map((o) => o.label), contains('Assistance'));
      expect(_section(draft, 'magic-initiate-background-spell').count, 1);
      expect(
        _section(
          draft,
          'magic-initiate-background-ability',
        ).options.map((o) => o.label),
        ['Intelligence', 'Sagesse', 'Charisme'],
      );
    });

    test('Polyvalent : la liste d’abord, puis les sorts', () {
      var draft = _draft(
        'monk',
        'soldier',
        'human',
      ).selectOriginFeat(magicInitiateFeat);
      final lists = _section(draft, initiateKey(place, 'list'));
      expect(lists.options.map((o) => o.label), [
        'Clerc',
        'Druide',
        'Magicien',
      ]);
      final keys = subchoiceSections(draft, _content).map((s) => s.key);
      expect(keys, isNot(contains(initiateKey(place, 'cantrips'))));
      draft = draft.selectInitiateList(place, 'srd:class:druid');
      expect(
        _section(draft, initiateKey(place, 'cantrips')).listId,
        'srd:class:druid',
      );
    });

    test('Humain Acolyte : la liste du Clerc est grisée', () {
      final draft = _draft(
        'monk',
        'acolyte',
        'human',
      ).selectOriginFeat(magicInitiateFeat);
      final lists = _section(draft, initiateKey(place, 'list'));
      expect(_blocked(lists), ['Clerc']);
      expect(lists.options.first.block, OptionBlock.sameList);
    });

    test('une autre liste efface les sorts, pas la caractéristique', () {
      final draft = _draft('monk', 'soldier', 'human')
          .selectOriginFeat(magicInitiateFeat)
          .selectInitiateList(place, 'srd:class:druid')
          .togglePick(initiateKey(place, 'ability'), 'x', 1)
          .togglePick(initiateKey(place, 'cantrips'), 'y', 2)
          .selectInitiateList(place, 'srd:class:wizard');
      expect(draft.choices[initiateKey(place, 'cantrips')], isEmpty);
      expect(draft.choices[initiateKey(place, 'ability')], ['x']);
    });

    test('la même liste garde les sorts', () {
      final draft = _draft('monk', 'soldier', 'human')
          .selectInitiateList(place, 'srd:class:druid')
          .togglePick(initiateKey(place, 'cantrips'), 'y', 2)
          .selectInitiateList(place, 'srd:class:druid');
      expect(draft.choices[initiateKey(place, 'cantrips')], ['y']);
    });

    test('changer d’Historique efface les sorts de son don', () {
      final key = initiateKey(InitiatePlace.background, 'cantrips');
      final draft = _draft(
        'monk',
        'acolyte',
        'dwarf',
      ).togglePick(key, 'y', 2).selectBackground('srd:background:sage');
      expect(draft.choices, isEmpty);
    });

    test('changer de don ou d’espèce efface les sorts de Polyvalent', () {
      final draft = _draft('monk', 'soldier', 'human')
          .selectOriginFeat(magicInitiateFeat)
          .togglePick(initiateKey(place, 'ability'), 'x', 1);
      expect(draft.selectOriginFeat('srd:feat:alert').choices, isEmpty);
      expect(
        draft.selectSpecies('srd:species:orc', const ['M']).choices,
        isEmpty,
      );
    });
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
