// Spec encounters : « Résumé de fin de rencontre » (US-25, EF-LOG-03).
// Valeurs de [D1] (rencontres de la séance 12) et de [C11].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

var _next = 0;

CombatEvent _event(CombatEventType type, [Map<String, Object?> p = const {}]) =>
    CombatEvent(
      id: 'e${(_next++).toString().padLeft(4, '0')}',
      type: type,
      payload: p,
    );

CombatEvent _add(String id, String kind, String ref, int hp) => _event(
  CombatEventType.combatantAdded,
  {'id': id, 'kind': kind, 'ref_id': ref, 'label': id, 'hp': hp, 'hp_max': hp},
);

CombatEvent _hit(String on, int amount, {bool knockOut = false}) =>
    _event(CombatEventType.damage, {
      'targets': [on],
      'amount': amount,
      'type': 'srd:damage-type:slashing',
      'knock_out': ?(knockOut ? true : null),
    });

const _xp = {
  'srd:monster:bandit': 25,
  'srd:monster:dire-wolf': 200,
  'srd:monster:bandit-captain': 450,
  'srd:monster:ogre': 450,
  'srd:monster:veteran': 700,
};

int _xpOf(Combatant c) => _xp[c.refId] ?? 0;

/// Avance de [rounds] rounds une rencontre de [units] unités.
List<CombatEvent> _rounds(int units, int rounds) => [
  for (var i = 0; i < units * rounds; i++) _event(CombatEventType.turnAdvanced),
];

void main() {
  test('[D1] Le relais du Sel : 3 000 PX, 750 par PJ', () {
    final foes = [
      _add('varga', 'npc', 'srd:monster:bandit-captain', 52),
      for (var i = 1; i <= 2; i++)
        _add('veteran$i', 'monster', 'srd:monster:veteran', 58),
      _add('ogre', 'monster', 'srd:monster:ogre', 59),
      for (var i = 1; i <= 3; i++)
        _add('dire$i', 'monster', 'srd:monster:dire-wolf', 37),
      for (var i = 1; i <= 4; i++)
        _add('bandit$i', 'monster', 'srd:monster:bandit', 11),
    ];
    final summary = summarizeEncounter([
      for (final pc in ['aldric', 'mira', 'thalia', 'brannoc'])
        _add(pc, 'pc', pc, 30),
      ...foes,
    ], xpOf: _xpOf);
    expect(summary.xpTotal, 3000);
    expect(summary.foes, 11);
    expect(summary.pcs, hasLength(4));
    expect(summary.xpShare, 750);
  });

  test('[D1] Embuscade : Varga retirée en fuite ne compte pas', () {
    final summary = summarizeEncounter([
      _add('aldric', 'pc', 'aldric', 30),
      for (var i = 1; i <= 4; i++)
        _add('bandit$i', 'monster', 'srd:monster:bandit', 11),
      _add('varga', 'npc', 'srd:monster:bandit-captain', 52),
      _event(CombatEventType.combatantRemoved, {'combatant': 'varga'}),
    ], xpOf: _xpOf);
    expect(summary.xpTotal, 100);
  });

  test('[C11] : chutes, rounds, Varga assommée, Brannoc stabilisé', () {
    final events = [
      _add('brannoc', 'pc', 'brannoc', 27),
      _add('ogre', 'monster', 'srd:monster:ogre', 59),
      _add('varga', 'npc', 'srd:monster:bandit-captain', 52),
      for (final unit in ['brannoc', 'ogre', 'varga'])
        _event(CombatEventType.initiativeRolled, {
          'unit': unit,
          'dice': [10],
        }),
      _event(CombatEventType.combatStarted),
      ..._rounds(3, 1),
      _hit('brannoc', 30),
      _event(CombatEventType.deathSave, {
        'combatant': 'brannoc',
        'outcome': 'stabilized',
      }),
      ..._rounds(3, 2),
      _hit('ogre', 59),
      ..._rounds(3, 1),
      _hit('varga', 60, knockOut: true),
      _event(CombatEventType.study, {'actor': 'brannoc', 'target': 'varga'}),
    ];
    final summary = summarizeEncounter(events, xpOf: _xpOf);
    expect(summary.rounds, 5);
    expect(
      [for (final f in summary.fallen) (f.id, f.round, f.knockedOut)],
      [('ogre', 4, false), ('varga', 5, true)],
    );
    final brannoc = summary.downedPcs.single;
    expect((brannoc.id, brannoc.round, brannoc.stable), ('brannoc', 2, true));
    expect(
      [for (final m in summary.moments) m.event.type],
      [CombatEventType.study],
    );
    expect(summary.awarded, isNull);
  });

  test('PX retenus à la clôture', () {
    final summary = summarizeEncounter([
      _add('aldric', 'pc', 'aldric', 30),
      _add('ogre', 'monster', 'srd:monster:ogre', 59),
      _event(CombatEventType.encounterFinished, {
        'rounds': 2,
        'xp': {'aldric': 400},
      }),
    ], xpOf: _xpOf);
    expect(summary.awarded, {'aldric': 400});
    expect(summary.xpTotal, 450);
  });
}
