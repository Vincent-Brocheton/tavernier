// Spec tables : « Lancer une rencontre » (US-20, EF-INI-01, EF-INI-02).
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_data/dnd_data.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:game_table/encounters/launch.dart';

final _content = ActiveContent([
  readDndpack(File('assets/packs/srd-5.2.1-fr.dndpack').readAsBytesSync()),
]);

/// Aldric de [D1], au niveau 1.
CharacterInput _aldric() => CharacterInput.fromJson(
  (jsonDecode(
        File('../../packages/dnd_rules/test/fixtures/d1/aldric_n1.json')
            .readAsStringSync(),
      ) as Map<String, Object?>)['input']!
      as Map<String, Object?>,
);

MonsterData _monster(String slug) =>
    _content.entity('srd:monster:$slug')!.data as MonsterData;

Encounter _encounter(HpMode hpMode) => Encounter(
  id: 'e',
  tableId: 't',
  title: 'Le relais du Sel',
  status: EncounterStatus.ready,
  hpMode: hpMode,
  groups: const [
    EncounterGroup(
      id: 'vets',
      kind: 'monster',
      refId: 'srd:monster:veteran',
      quantity: 2,
      sharedInitiative: true,
    ),
    EncounterGroup(
      id: 'ogre',
      kind: 'monster',
      refId: 'srd:monster:ogre',
      quantity: 1,
      sharedInitiative: true,
    ),
    EncounterGroup(
      id: 'wolves',
      kind: 'monster',
      refId: 'srd:monster:dire-wolf',
      quantity: 2,
      sharedInitiative: false,
    ),
    EncounterGroup(
      id: 'varga',
      kind: 'npc',
      refId: 'npc-varga',
      quantity: 1,
      sharedInitiative: true,
    ),
    EncounterGroup(
      id: 'perdu',
      kind: 'monster',
      refId: 'srd:monster:introuvable',
      quantity: 1,
      sharedInitiative: true,
    ),
  ],
);

const _varga = Npc(
  id: 'npc-varga',
  tableId: 't',
  name: 'Varga la Balafrée',
  attitude: Attitude.hostile,
  hiddenInfo: [],
  monsterId: 'srd:monster:bandit-captain',
);

CombatState _launch(HpMode hpMode, {int seed = 1}) {
  final sheet = computeSheet(_aldric(), _content);
  return projectCombat([
    for (final (i, (type, payload)) in launchEvents(
      encounter: _encounter(hpMode),
      content: _content,
      npcs: const [_varga],
      party: const [(id: 'aldric', name: 'Aldric Varenne', owner: 'hugo')],
      sheets: {'aldric': (sheet: sheet, hp: 9)},
      random: Random(seed),
    ).indexed)
      CombatEvent(
        id: 'e${i.toString().padLeft(3, '0')}',
        type: type,
        payload: payload,
      ),
  ]);
}

void main() {
  test('PJ : fiche calculée, joueur, PV courants', () {
    final aldric = _launch(HpMode.average).combatant('aldric')!;
    expect(
      (aldric.kind, aldric.label, aldric.owner, aldric.hp),
      (CombatantKind.pc, 'Aldric Varenne', 'hugo', 9),
    );
    // [D1] niveau 1 : DEX 13 (+1) et Vigilant (+2, bonus de maîtrise).
    expect(aldric.bonus, 3);
    expect(aldric.initiative, isNull);
  });

  test('groupes : numérotés, initiative commune, jets automatiques', () {
    final state = _launch(HpMode.average);
    expect(
      [for (final c in state.combatants) c.label],
      [
        'Aldric Varenne',
        'Vétéran 1',
        'Vétéran 2',
        'Ogre',
        'Loup sanguinaire 1',
        'Loup sanguinaire 2',
        'Varga la Balafrée',
      ],
    );
    expect(state.members('vets'), hasLength(2));
    // Sans initiative commune, chaque loup joue seul.
    expect(state.combatant('wolves:1')!.unit, 'wolves:1');
    expect(state.combatant('wolves:2')!.unit, 'wolves:2');
    for (final c in state.combatants.skip(1)) {
      expect(c.initiative, isNotNull, reason: c.label);
    }
    final varga = state.combatant('varga:1')!;
    expect(
      (varga.kind, varga.bonus),
      (CombatantKind.npc, _monster('bandit-captain').initiative),
    );
  });

  test('PV moyens du profil, ou tirés aux dés de vie', () {
    final ogre = _monster('ogre');
    expect(_launch(HpMode.average).combatant('ogre:1')!.hp, ogre.hp);
    final rolled = _launch(HpMode.roll, seed: 7).combatant('ogre:1')!;
    final dice = DiceFormula.parse(ogre.hitDice);
    expect(
      rolled.hp,
      inInclusiveRange(
        dice.count + dice.bonus,
        dice.count * dice.sides + dice.bonus,
      ),
    );
    expect(rolled.hpMax, rolled.hp);
  });

  test('compteurs du profil : dragon noir adulte', () {
    final state = projectCombat([
      for (final (i, (type, payload)) in launchEvents(
        encounter: const Encounter(
          id: 'e',
          tableId: 't',
          title: 'Antre',
          status: EncounterStatus.ready,
          hpMode: HpMode.average,
          groups: [
            EncounterGroup(
              id: 'dragon',
              kind: 'monster',
              refId: 'srd:monster:adult-black-dragon',
              quantity: 1,
              sharedInitiative: true,
            ),
          ],
        ),
        content: _content,
        npcs: const [],
        party: const [],
        sheets: const {},
        random: Random(1),
      ).indexed)
        CombatEvent(id: 'e$i', type: type, payload: payload),
    ]);
    final dragon = state.combatant('dragon:1')!;
    expect(dragon.max('legendary_actions'), 3);
    expect(dragon.max('legendary_resistance'), 3);
    expect(dragon.max('recharge:Souffle d’acide'), 1);
  });

  test('renfort : numéroté après ses semblables', () {
    expect(
      reinforcementLabel('Loup sanguinaire', [
        'Aldric',
        'Loup sanguinaire 1',
        'Loup sanguinaire 3',
      ]),
      'Loup sanguinaire 4',
    );
    expect(reinforcementLabel('Ogre', ['Ogre']), 'Ogre 2');
    expect(reinforcementLabel('Ogre', ['Ogre mage']), 'Ogre');
    expect(reinforcementLabel('Bandit', const []), 'Bandit');
  });
}
