// Spec character-creation : « Assistant en 9 étapes », « Choix manquant
// bloquant et expliqué ».
import 'dart:io';
import 'dart:math';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_draft.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

MissingChoice? _missing(CreationDraft draft) => missingChoice(draft, _content);

const start = CreationDraft();

/// Jusqu'à l'étape Langues : Guerrier, Criminel, Nain.
CreationDraft _throughSpecies() => start
    .selectClass('srd:class:fighter')
    .next(_content)
    .selectBackground('srd:background:criminal')
    .next(_content)
    .selectSpecies('srd:species:dwarf', const ['M'])
    .next(_content);

CreationDraft _raise(CreationDraft draft, String code, int times) {
  var result = draft;
  for (var i = 0; i < times; i++) {
    result = result.raiseScore(code);
  }
  return result;
}

/// Les valeurs d'Aldric ([D1]) : 15 13 14 8 12 10.
CreationDraft _aldricScores(CreationDraft draft) => _raise(
  _raise(_raise(_raise(_raise(draft, 'str', 7), 'dex', 5), 'con', 6), 'wis', 4),
  'cha',
  2,
);

void main() {
  test('étape 1 : une classe à choisir', () {
    expect(_missing(start), MissingChoice.classChoice);
    expect(_missing(start.selectClass('srd:class:fighter')), isNull);
  });

  test('on ne passe à la suite qu’une étape remplie', () {
    expect(start.next(_content).step, 0);
    final draft = start.selectClass('srd:class:fighter').next(_content);
    expect((draft.step, draft.reached), (1, 1));
  });

  test('étape 2 : Historique, puis outil au choix du Soldat', () {
    final draft = start.selectClass('srd:class:fighter').next(_content);
    expect(_missing(draft), MissingChoice.background);
    final soldier = draft.selectBackground('srd:background:soldier');
    expect(_missing(soldier), MissingChoice.tool);
    expect(_missing(soldier.selectTool('srd:tool:dice-set')), isNull);
  });

  test('étape 2 : outil imposé (Criminel), rien à choisir', () {
    final draft = start
        .selectClass('srd:class:fighter')
        .next(_content)
        .selectBackground('srd:background:criminal');
    expect(_missing(draft), isNull);
  });

  test('changer d’Historique efface l’outil choisi', () {
    final draft = start
        .selectBackground('srd:background:soldier')
        .selectTool('srd:tool:dice-set')
        .selectBackground('srd:background:criminal');
    expect(draft.toolChoice, isNull);
  });

  test('retoucher le même choix ne perd pas ce qui en dépend', () {
    final soldier = start
        .selectBackground('srd:background:soldier')
        .selectTool('srd:tool:dice-set')
        .selectBackground('srd:background:soldier');
    expect(soldier.toolChoice, 'srd:tool:dice-set');
    final human = start
        .selectSpecies('srd:species:human', const ['M', 'P'])
        .selectSize('P')
        .selectSpecies('srd:species:human', const ['M', 'P']);
    expect(human.size, 'P');
  });

  test('étape 3 : espèce, puis taille si elle en propose deux', () {
    final draft = start
        .selectClass('srd:class:fighter')
        .next(_content)
        .selectBackground('srd:background:criminal')
        .next(_content);
    expect(draft.step, 2);
    expect(_missing(draft), MissingChoice.species);
    final human = draft.selectSpecies('srd:species:human', const ['M', 'P']);
    expect(human.size, isNull);
    expect(_missing(human), MissingChoice.size);
    expect(_missing(human.selectSize('P')), isNull);
  });

  test('une espèce à une seule taille la fixe d’office', () {
    final draft = start
        .selectSpecies('srd:species:human', const ['M', 'P'])
        .selectSize('P')
        .selectSpecies('srd:species:dwarf', const ['M']);
    expect(draft.size, 'M');
  });

  test('retour à une étape atteinte, pas au-delà', () {
    final draft = start
        .selectClass('srd:class:fighter')
        .next(_content)
        .selectBackground('srd:background:criminal')
        .next(_content);
    final back = draft.goTo(0, _content);
    expect(
      (back.step, back.reached, back.classId),
      (0, 2, 'srd:class:fighter'),
    );
    expect(back.goTo(5, _content).step, 0);
    expect(back.goTo(2, _content).step, 2);
    expect(back.previous().step, 0);
    expect(draft.previous().step, 1);
  });

  group('langues', () {
    final step4 = _throughSpecies();

    test('deux langues à choisir, pas une de plus', () {
      expect(_missing(step4), MissingChoice.languages);
      final one = step4.toggleLanguage('srd:language:dwarvish');
      expect(_missing(one), MissingChoice.languages);
      final two = one.toggleLanguage('srd:language:orc');
      expect(_missing(two), isNull);
      expect(two.toggleLanguage('srd:language:elvish').languages, hasLength(2));
      expect(two.toggleLanguage('srd:language:orc').languages, [
        'srd:language:dwarvish',
      ]);
    });

    test('le tirage garde le choix fait et complète sans doublon', () {
      const options = ['a', 'b', 'c', 'd'];
      final drawn = step4.toggleLanguage('b').drawLanguages(options, Random(1));
      expect(drawn.languages, hasLength(2));
      expect(drawn.languages.first, 'b');
      expect(drawn.languages.toSet(), hasLength(2));
      expect(drawn.drawLanguages(options).languages, drawn.languages);
    });
  });

  group('acquisition par points', () {
    test('départ : tout à 8, 27 points', () {
      expect(start.remainingPoints, 27);
      expect(start.scores['str'], 8);
    });

    test('bornes : ni sous 8 ni au-dessus de 15', () {
      expect(start.canLower('str'), isFalse);
      expect(start.lowerScore('str').scores['str'], 8);
      final top = _raise(start, 'str', 7);
      expect(top.scores['str'], 15);
      expect(top.canRaise('str'), isFalse);
    });

    test('le coût monte à 14 et 15 ; le budget borne la hausse', () {
      final at13 = _raise(start, 'str', 5);
      expect(at13.remainingPoints, 22);
      expect(at13.raiseScore('str').remainingPoints, 20);
      final spent = _raise(_raise(_raise(start, 'str', 7), 'dex', 7), 'con', 7);
      expect(spent.remainingPoints, 0);
      expect(spent.canRaise('wis'), isFalse);
      expect(spent.raiseScore('wis').scores['wis'], 8);
    });
  });

  group('bonus d’Historique', () {
    final step5 = _aldricScores(
      _throughSpecies()
          .toggleLanguage('srd:language:dwarvish')
          .toggleLanguage('srd:language:orc')
          .next(_content),
    );

    test('il faut dépenser les 27 points', () {
      expect(step5.step, 4);
      expect(_missing(step5.lowerScore('str')), MissingChoice.points);
    });

    test('+2 et +1 : les deux sont requis', () {
      expect(_missing(step5), MissingChoice.bonus);
      final plus2 = step5.setBonus('dex', 2);
      expect(_missing(plus2), MissingChoice.bonus);
      expect(_missing(plus2.setBonus('con', 1)), isNull);
    });

    test('un +2 posé ailleurs se déplace ; le retoucher le retire', () {
      final moved = step5.setBonus('str', 2).setBonus('dex', 2);
      expect(moved.bonuses, {'dex': 2});
      expect(moved.setBonus('dex', 2).bonuses, isEmpty);
    });

    test('+1, +1 et +1 : trois caractéristiques ; changer vide les bonus', () {
      final draft = step5.setBonus('str', 2).setDistribution('1-1-1');
      expect(draft.bonuses, isEmpty);
      final two = draft.setBonus('dex', 1).setBonus('con', 1);
      expect(_missing(two), MissingChoice.bonus);
      expect(_missing(two.setBonus('int', 1)), isNull);
    });

    test('une caractéristique non éligible est refusée', () {
      expect(eligibleAbilities(step5, _content), {'dex', 'con', 'int'});
      expect(
        _missing(step5.setBonus('wis', 2).setBonus('con', 1)),
        MissingChoice.bonusInvalid,
      );
    });

    test('changer d’Historique rend le bonus invalide et bloque le saut', () {
      final done = step5.setBonus('int', 2).setBonus('con', 1).next(_content);
      expect(done.step, 5);
      final soldier = done
          .goTo(1, _content)
          .selectBackground('srd:background:soldier')
          .selectTool('srd:tool:dice-set');
      expect(soldier.bonuses, {'int': 2, 'con': 1});
      expect(missingAt(soldier, 4, _content), MissingChoice.bonusInvalid);
      expect(soldier.goTo(5, _content).step, 1);
      expect(soldier.goTo(4, _content).step, 4);
    });
  });

  test('une étape rouverte bloque le saut vers l’avant', () {
    final draft = start
        .selectClass('srd:class:fighter')
        .next(_content)
        .selectBackground('srd:background:criminal')
        .next(_content)
        .goTo(1, _content)
        .selectBackground('srd:background:soldier');
    expect(_missing(draft), MissingChoice.tool);
    expect(draft.goTo(2, _content).step, 1);
    expect(draft.goTo(0, _content).step, 0);
  });
}
