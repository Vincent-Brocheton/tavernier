// Spec character-creation : « Équipement de départ », « Détails du
// personnage », « Récapitulatif », « Enregistrement du personnage créé ».
import 'dart:convert';
import 'dart:io';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/creation/creation_draft.dart';
import 'package:game_table/creation/creation_providers.dart';
import 'package:game_table/creation/draft_input.dart';
import 'package:game_table/creation/step_layout.dart';
import 'package:game_table/creation/subchoices.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

/// Remplit chaque section avec ses premières options libres. Une section en
/// ouvre parfois une autre : on repart de la liste à chaque choix.
CreationDraft _fill(CreationDraft start) {
  var draft = start;
  while (true) {
    final sections = subchoiceSections(draft, _content);
    final section = sections.where((s) => !s.complete).firstOrNull;
    if (section == null) return draft;
    final option = section.options.firstWhere(
      (o) => o.block == null && !section.chosen.contains(o.id),
    );
    draft = draft.toggleOption(section, option.id);
  }
}

CreationDraft _complete(
  String cls,
  String background,
  String species, {
  String? feat,
}) {
  var draft = const CreationDraft()
      .selectClass(cls)
      .selectBackground(background)
      .selectSpecies(species, const ['M']);
  if (feat != null) draft = draft.selectOriginFeat(feat);
  final data = _content.entity(background)!.data as BackgroundData;
  if (data.toolChoiceCategory case final category?) {
    draft = draft.selectTool(
      '${sortedEntities(_content, 'tool').firstWhere((t) => (t.data as ToolData).category == category).id}',
    );
  }
  draft = draft
      .selectClassEquipment(0)
      .selectBackgroundEquipment(0)
      .withDetails(name: 'Test');
  final lot = (_content.entity(cls)!.data as ClassData).startingEquipment[0];
  if (lot.toolChoice.isNotEmpty) {
    draft = draft.selectEquipmentTool(
      '${sortedEntities(_content, 'tool').firstWhere((t) => lot.toolChoice.contains((t.data as ToolData).category)).id}',
    );
  }
  return _fill(draft);
}

CreationDraft _withScores(CreationDraft draft) {
  final eligible = eligibleAbilities(draft, _content).toList();
  var next = draft;
  for (final code in abilityCodes) {
    for (
      var i = 0;
      i < 7 && code != 'wis' && code != 'cha' && code != 'int';
      i++
    ) {
      next = next.raiseScore(code);
    }
  }
  return next.setBonus(eligible[0], 2).setBonus(eligible[1], 1);
}

void main() {
  test('toute combinaison : aucune erreur d’intégrité', () {
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
            if (feat != null && '${species.id}' != 'srd:species:human') {
              continue;
            }
            final draft = _withScores(
              _complete(
                '${cls.id}',
                '${background.id}',
                '${species.id}',
                feat: feat,
              ),
            );
            final reason = '${cls.id} ${background.id} ${species.id} $feat';
            expect(
              subchoiceSections(draft, _content).every((s) => s.complete),
              isTrue,
              reason: reason,
            );
            final languages = draft
                .toggleLanguage('srd:language:orc')
                .toggleLanguage('srd:language:elvish');
            final input = toCharacterInput(languages, _content);
            expect(
              computeSheet(
                input,
                _content,
              ).integrityErrors.map((e) => e.message),
              isEmpty,
              reason: reason,
            );
          }
        }
      }
    }
  });

  test('génération aléatoire : méthode et jets enregistrés, sans erreur', () {
    final draft = const CreationDraft()
        .selectClass('srd:class:fighter')
        .selectBackground('srd:background:soldier')
        .selectTool('srd:tool:dice-set')
        .selectSpecies('srd:species:human', const ['M', 'S'])
        .selectSize('M')
        .toggleLanguage('srd:language:dwarvish')
        .toggleLanguage('srd:language:orc')
        .selectOriginFeat('srd:feat:alert')
        .selectFightingStyle('srd:feat:defense')
        .toggleClassSkill('srd:skill:perception', 2)
        .toggleClassSkill('srd:skill:survival', 2)
        .toggleMastery('srd:weapon:longsword', 3)
        .toggleMastery('srd:weapon:javelin', 3)
        .toggleMastery('srd:weapon:battleaxe', 3)
        .togglePick('skillful', 'srd:skill:insight', 1)
        .selectClassEquipment(0)
        .selectBackgroundEquipment(0)
        .withDetails(name: 'Aldric Varenne')
        .withMethod(ScoreMethod.random)
        .withRolls([16, 9, 13, 11, 7, 14])
        .setBonus('str', 2)
        .setBonus('con', 1);
    final input = toCharacterInput(draft, _content);
    expect(input.baseScores.method, ScoreMethod.random);
    expect(input.baseScores.rolls, [16, 9, 13, 11, 7, 14]);
    expect(input.baseScores.strength, 16);
    expect(computeSheet(input, _content).integrityErrors, isEmpty);
  });

  test('Aldric : les valeurs de la fixture [D1]', () {
    final fixture = jsonDecode(
      File('../../packages/dnd_rules/test/fixtures/d1/aldric_n1.json')
          .readAsStringSync(),
    ) as Map<String, Object?>;
    final expected = fixture['expected']! as Map<String, Object?>;
    var draft = const CreationDraft()
        .selectClass('srd:class:fighter')
        .selectBackground('srd:background:soldier')
        .selectTool('srd:tool:dice-set')
        .selectSpecies('srd:species:human', const ['M', 'S'])
        .selectSize('M')
        .toggleLanguage('srd:language:dwarvish')
        .toggleLanguage('srd:language:orc')
        .selectOriginFeat('srd:feat:alert')
        .selectFightingStyle('srd:feat:defense')
        .toggleClassSkill('srd:skill:perception', 2)
        .toggleClassSkill('srd:skill:survival', 2)
        .toggleMastery('srd:weapon:longsword', 3)
        .toggleMastery('srd:weapon:javelin', 3)
        .toggleMastery('srd:weapon:battleaxe', 3)
        .togglePick('skillful', 'srd:skill:insight', 1)
        .selectClassEquipment(0)
        .selectBackgroundEquipment(0)
        .withDetails(name: 'Aldric Varenne');
    const scores = {'str': 15, 'dex': 13, 'con': 14, 'wis': 12, 'cha': 10};
    for (final MapEntry(key: code, value: score) in scores.entries) {
      for (var i = 8; i < score; i++) {
        draft = draft.raiseScore(code);
      }
    }
    draft = draft.setBonus('str', 2).setBonus('con', 1);

    final input = toCharacterInput(draft, _content);
    final sheet = computeSheet(input, _content);
    expect(sheet.integrityErrors, isEmpty);
    expect(sheet.hitPointsMax.value, expected['hit_points_max']);
    expect(sheet.passivePerception, expected['passive_perception']);
    expect(sheet.pointBuyCost, 27);
    expect(input.coins, {'gp': 18});
    // Lots A, comme sur [P6] : cotte de mailles + Défense.
    expect(sheet.armorClass.value, 17);
    expect(masteriesWithoutWeapon(input), [
      'srd:weapon:longsword',
      'srd:weapon:battleaxe',
    ]);
    expect(input.items.first.equipped, isTrue);
  });

  group('sélections', () {
    test('une sélection d’une section fermée n’est pas enregistrée', () {
      final draft = _withScores(
        _complete(
          'srd:class:rogue',
          'srd:background:soldier',
          'srd:species:dwarf',
        ).selectClass('srd:class:fighter'),
      );
      final filled = _fill(draft).selectClassEquipment(0);
      final input = toCharacterInput(filled, _content);
      expect(input.choices.keys, isNot(contains('rogue-expertise')));
    });

    test('Doué : ses compétences vont dans le don', () {
      final input = toCharacterInput(
        _complete(
          'srd:class:monk',
          'srd:background:soldier',
          'srd:species:human',
          feat: 'srd:feat:skilled',
        ),
        _content,
      );
      final feat = input.feats.firstWhere(
        (f) => f.featId == 'srd:feat:skilled',
      );
      expect(feat.sourceType, 'species');
      expect(feat.choices!['skilled'], hasLength(3));
      expect(input.choices.keys, isNot(contains('skilled')));
    });

    test('Initié à la magie : format des fixtures', () {
      final input = toCharacterInput(
        _complete(
          'srd:class:monk',
          'srd:background:acolyte',
          'srd:species:dwarf',
        ),
        _content,
      );
      final choices = input.feats.single.choices!;
      expect(choices['spell_list'], 'srd:class:cleric');
      expect(choices['ability'], 'int');
      expect(choices['cantrips'], hasLength(2));
      expect(choices['level_1_spell'], startsWith('srd:spell:'));
    });

    test('Magicien : grimoire et sorts préparés', () {
      final spells = toCharacterInput(
        _complete(
          'srd:class:wizard',
          'srd:background:soldier',
          'srd:species:dwarf',
        ),
        _content,
      ).spells;
      expect(spells.cantrips, hasLength(3));
      expect(spells.spellbook, hasLength(6));
      expect(spells.prepared, hasLength(4));
      expect(spells.spellbook, containsAll(spells.prepared));
    });

    test('Barde : instruments de classe et outil du lot', () {
      final input = toCharacterInput(
        _complete(
          'srd:class:bard',
          'srd:background:soldier',
          'srd:species:dwarf',
        ),
        _content,
      );
      expect(input.choices[classToolsKey], hasLength(3));
      expect(
        input.items.where((i) => i.itemId.startsWith('srd:tool:')),
        isNotEmpty,
      );
    });

    test('un champ vide devient null, le nom perd ses espaces', () {
      final input = toCharacterInput(
        _complete(
          'srd:class:rogue',
          'srd:background:soldier',
          'srd:species:dwarf',
        ).withDetails(name: '  Mira  ', appearance: '   '),
        _content,
      );
      expect(input.name, 'Mira');
      expect(input.appearance, isNull);
    });

    test('l’or de l’Historique remplace son lot', () {
      final input = toCharacterInput(
        _complete(
          'srd:class:fighter',
          'srd:background:soldier',
          'srd:species:dwarf',
        ).selectBackgroundEquipment(1),
        _content,
      );
      expect(input.coins, {'gp': 54});
      expect(
        input.items.map((i) => i.itemId),
        isNot(contains('srd:weapon:spear')),
      );
    });
  });

  group('enregistrement', () {
    late TavernierDatabase database;
    late CharacterStore store;
    late ProviderContainer container;
    late CreationNotifier notifier;
    final draft = _withScores(
      _complete(
        'srd:class:fighter',
        'srd:background:soldier',
        'srd:species:dwarf',
      ),
    );

    setUp(() {
      database = TavernierDatabase(NativeDatabase.memory());
      store = CharacterStore(database);
      container = ProviderContainer(
        overrides: [
          characterStoreProvider.overrideWith((ref) => store),
          databaseProvider.overrideWithValue(database),
        ],
      );
      addTearDown(container.dispose);
      addTearDown(database.close);
      final subscription = container.listen(creationProvider, (_, _) {});
      addTearDown(subscription.close);
      notifier = container.read(creationProvider.notifier)
        ..update((_) => draft);
    });

    test('deux appuis : un seul personnage', () async {
      final results = await Future.wait([
        notifier.save(_content),
        notifier.save(_content),
      ]);
      expect(results, [true, true]);
      expect(await store.list(), hasLength(1));
    });

    test('fiche de table : rattachée, emplacement rempli', () async {
      final tables = TableStore(database);
      final tableId = await tables.create(
        gmUserId: 'mj',
        settings: const TableSettings(name: 'Brumeval'),
        packs: const [],
      );
      final slotId = await tables.createSlot(tableId, 'hugo');
      notifier.update(
        (d) => d.forTable(
          TableConstraint(
            tableId: tableId,
            slotId: slotId,
            method: ScoreMethod.pointBuy,
            startingLevel: 1,
          ),
        ),
      );
      expect(await notifier.save(_content), isTrue);
      final [slot] = await tables.watchSlots(tableId).first;
      expect(slot.characterId, isNotNull);
      expect(slot.status, 'draft');
      final row = await database
          .customSelect('SELECT table_id FROM character')
          .getSingle();
      expect(row.read<String>('table_id'), tableId);
    });

    test('réessayer ne crée pas de doublon', () async {
      await notifier.save(_content);
      await notifier.save(_content);
      expect(await store.list(), hasLength(1));
    });

    test('échec d’écriture : `false`, brouillon conservé', () async {
      await database.customStatement('DROP TABLE character_item');
      expect(await notifier.save(_content), isFalse);
      expect(container.read(creationProvider), same(draft));
    });
  });

  group('compétences du Récapitulatif', () {
    test('la clé d’une compétence à tiret se retrouve dans la fiche', () {
      final input = toCharacterInput(
        _withScores(
          _complete(
            'srd:class:rogue',
            'srd:background:criminal',
            'srd:species:dwarf',
          ),
        ),
        _content,
      );
      final sheet = computeSheet(input, _content);
      final hand = _content.entity('srd:skill:sleight-of-hand')!;
      expect(sheet.skillProficiencies, contains(skillKey(hand)));
    });
  });

  group('blocage des étapes', () {
    test('équipement : lot de classe, puis Historique, puis outil', () {
      final bard = const CreationDraft().selectClass('srd:class:bard');
      expect(missingAt(bard, 6, _content), MissingChoice.classEquipment);
      final lot = bard.selectClassEquipment(0);
      expect(missingAt(lot, 6, _content), MissingChoice.backgroundEquipment);
      final both = lot.selectBackgroundEquipment(1);
      expect(missingAt(both, 6, _content), MissingChoice.equipmentTool);
      final tool = both.selectEquipmentTool('srd:tool:lute');
      expect(missingAt(tool, 6, _content), isNull);
    });

    test('un lot sans outil efface l’outil', () {
      final draft = const CreationDraft()
          .selectClass('srd:class:bard')
          .selectClassEquipment(0)
          .selectEquipmentTool('srd:tool:lute')
          .selectClassEquipment(1);
      expect(draft.equipmentTool, isNull);
    });

    test('changer de classe efface le lot et l’outil', () {
      final draft = const CreationDraft()
          .selectClass('srd:class:bard')
          .selectClassEquipment(0)
          .selectEquipmentTool('srd:tool:lute')
          .selectClass('srd:class:monk');
      expect(draft.classEquipment, isNull);
      expect(draft.equipmentTool, isNull);
    });

    test('changer d’Historique efface son lot', () {
      final draft = const CreationDraft()
          .selectBackground('srd:background:sage')
          .selectBackgroundEquipment(0)
          .selectBackground('srd:background:soldier');
      expect(draft.backgroundEquipment, isNull);
    });

    test('nom vide ou fait d’espaces : bloqué', () {
      const draft = CreationDraft();
      expect(missingAt(draft, 7, _content), MissingChoice.name);
      expect(
        missingAt(draft.withDetails(name: '   '), 7, _content),
        MissingChoice.name,
      );
      expect(missingAt(draft.withDetails(name: 'Mira'), 7, _content), isNull);
    });
  });
}
