// Spec character-creation : « Assistant en 9 étapes », « Choix manquant
// bloquant et expliqué ».
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_draft.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

MissingChoice? _missing(CreationDraft draft) => missingChoice(draft, _content);

void main() {
  const start = CreationDraft();

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
