// Spec encounters : « Dégâts massifs », « Assommer », « Soutien », « Fin
// automatique de la concentration » (US-37, EF-PV-05, 06, EF-CON-06). SRD
// 5.2.1, « Dégâts massifs », « Assommer une créature » ; valeurs de [F2a],
// [F2b], [F2c].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

var _next = 0;

CombatEvent _event(CombatEventType type, Map<String, Object?> payload) =>
    CombatEvent(
      id: 'e${(_next++).toString().padLeft(4, '0')}',
      type: type,
      payload: payload,
    );

CombatEvent _add(
  String id, {
  String kind = 'pc',
  int hp = 27,
  int? max,
  List<String> conditionImmunities = const [],
}) => _event(CombatEventType.combatantAdded, {
  'id': id,
  'kind': kind,
  'label': id,
  'hp': hp,
  'hp_max': max ?? hp,
  'condition_immunities': conditionImmunities,
});

CombatEvent _hit(String on, int amount, {bool knockOut = false}) =>
    _event(CombatEventType.damage, {
      'targets': [on],
      'amount': amount,
      'type': 'srd:damage-type:bludgeoning',
      'knock_out': ?(knockOut ? true : null),
    });

CombatEvent _heal(String on, int amount) => _event(CombatEventType.heal, {
  'targets': [on],
  'amount': amount,
});

CombatEvent _save(String on, String outcome) =>
    _event(CombatEventType.deathSave, {'combatant': on, 'outcome': outcome});

CombatEvent _pose(String on, String condition) =>
    _event(CombatEventType.conditionAdded, {
      'combatant': on,
      'instance': '$on-$condition',
      'condition': 'srd:condition:$condition',
    });

/// Mira (38 PV) bénit Aldric et Thalia.
List<CombatEvent> _blessing() => [
  _add('mira', hp: 38),
  _add('aldric', hp: 49),
  _add('thalia', hp: 33),
  _event(CombatEventType.concentrationStarted, {
    'combatant': 'mira',
    'spell': 'Bénédiction',
  }),
  for (final on in ['aldric', 'thalia'])
    _event(CombatEventType.conditionAdded, {
      'combatant': on,
      'instance': 'béni-$on',
      'label': 'Béni',
      'concentration': 'mira',
    }),
];

void main() {
  group('dégâts massifs', () {
    test('[F2a] : Brannoc, 3 PV sur 27, 30 dégâts : mort sur le coup', () {
      final state = projectCombat([_add('brannoc', hp: 3, max: 27)]);
      final brannoc = state.combatant('brannoc')!;
      final r = resolveDamage(brannoc, 30, 'srd:damage-type:bludgeoning');
      expect(instantDeath(brannoc, r), isTrue);
      final after = projectCombat([
        _add('brannoc', hp: 3, max: 27),
        _hit('brannoc', 30),
      ]).combatant('brannoc')!;
      expect(after.dead, isTrue);
      expect(after.unconscious, isFalse);
    });

    test('excédent de 26 : à 0 PV, vivant', () {
      final brannoc = projectCombat([
        _add('brannoc', hp: 3, max: 27),
        _hit('brannoc', 29),
      ]).combatant('brannoc')!;
      expect(brannoc.dead, isFalse);
      expect(brannoc.unconscious, isTrue);
    });

    test('à 0 PV, 27 dégâts : mort ; 26 : un échec', () {
      List<CombatEvent> down(int amount) => [
        _add('brannoc', hp: 3, max: 27),
        _hit('brannoc', 3),
        _hit('brannoc', amount),
      ];
      expect(projectCombat(down(27)).combatant('brannoc')!.dead, isTrue);
      final alive = projectCombat(down(26)).combatant('brannoc')!;
      expect(alive.dead, isFalse);
      expect(alive.deathFailures, 1);
    });

    test('un monstre ne meurt pas sur le coup, il est hors de combat', () {
      final wolf = projectCombat([
        _add('loup', kind: 'monster', hp: 11),
        _hit('loup', 40),
      ]).combatant('loup')!;
      expect(wolf.dead, isFalse);
      expect(wolf.outOfCombat, isTrue);
    });
  });

  group('Assommer', () {
    List<CombatEvent> varga() => [
      _add('varga', kind: 'npc', hp: 7, max: 52),
      _hit('varga', 9, knockOut: true),
    ];

    test('[F2b] : Varga, 7 PV, 9 dégâts : 1 PV, Inconsciente', () {
      final v = projectCombat(varga()).combatant('varga')!;
      expect(v.hp, 1);
      expect(v.outOfCombat, isFalse);
      expect(v.conditions.single.condition, unconsciousCondition);
      expect(v.conditions.single.knockedOut, isTrue);
    });

    test('sans chute, Assommer ne fait rien de plus', () {
      final v = projectCombat([
        _add('varga', kind: 'npc', hp: 20, max: 52),
        _hit('varga', 9, knockOut: true),
      ]).combatant('varga')!;
      expect(v.hp, 11);
      expect(v.conditions, isEmpty);
    });

    test('un soin la réveille', () {
      final v = projectCombat([...varga(), _heal('varga', 2)])
          .combatant('varga')!;
      expect(v.hp, 3);
      expect(v.conditions, isEmpty);
    });

    test('un PJ assommé ne fait pas de jets contre la mort', () {
      final b = projectCombat([
        _add('brannoc', hp: 3, max: 27),
        _hit('brannoc', 8, knockOut: true),
      ]).combatant('brannoc')!;
      expect(b.hp, 1);
      expect(b.unconscious, isFalse);
      expect(b.conditions.single.condition, unconsciousCondition);
    });
  });

  group('Soutien', () {
    test('[F2c] : Brannoc stabilisé, le moindre dégât relance les jets', () {
      final events = [
        _add('brannoc', hp: 3, max: 27),
        _hit('brannoc', 8),
        _save('brannoc', 'failure'),
        _save('brannoc', 'stabilized'),
      ];
      final stable = projectCombat(events).combatant('brannoc')!;
      expect(stable.stable, isTrue);
      expect(stable.unconscious, isTrue);
      final hit = projectCombat([...events, _hit('brannoc', 1)])
          .combatant('brannoc')!;
      expect(hit.stable, isFalse);
      expect(hit.deathFailures, 2);
    });

    test('debout : sans effet', () {
      final b = projectCombat([_add('brannoc'), _save('brannoc', 'stabilized')])
          .combatant('brannoc')!;
      expect(b.stable, isFalse);
    });
  });

  group('fin automatique de la concentration', () {
    void ended(CombatState state) {
      expect(state.combatant('mira')!.concentration, isNull);
      expect(state.combatant('aldric')!.conditions, isEmpty);
      expect(state.combatant('thalia')!.conditions, isEmpty);
    }

    test('Mira tombe à 0 PV : Bénédiction prend fin', () {
      final state = projectCombat([..._blessing(), _hit('mira', 40)]);
      ended(state);
      expect(state.combatant('mira')!.concentrationChecks, isEmpty);
    });

    test('Mira meurt sur le coup', () {
      ended(projectCombat([..._blessing(), _hit('mira', 80)]));
    });

    test('Mira assommée', () {
      final state = projectCombat([
        ..._blessing(),
        _hit('mira', 40, knockOut: true),
      ]);
      ended(state);
      expect(state.combatant('mira')!.hp, 1);
    });

    for (final condition in [
      'incapacitated',
      'unconscious',
      'paralyzed',
      'petrified',
      'stunned',
    ]) {
      test('état $condition : fin', () {
        ended(projectCombat([..._blessing(), _pose('mira', condition)]));
      });
    }

    test('état Empoisonné : la concentration continue', () {
      final state = projectCombat([..._blessing(), _pose('mira', 'poisoned')]);
      expect(state.combatant('mira')!.concentration, 'Bénédiction');
    });

    test('immunisée à Étourdi : la concentration continue', () {
      final state = projectCombat([
        _add('mira', hp: 38, conditionImmunities: ['srd:condition:stunned']),
        ..._blessing().skip(1),
        _pose('mira', 'stunned'),
      ]);
      expect(state.combatant('mira')!.concentration, 'Bénédiction');
      expect(state.combatant('aldric')!.conditions, isNotEmpty);
    });

    test('dégâts sans chute : test en attente, concentration gardée', () {
      final mira = projectCombat([..._blessing(), _hit('mira', 12)])
          .combatant('mira')!;
      expect(mira.concentration, 'Bénédiction');
      expect(mira.concentrationChecks, hasLength(1));
    });
  });

  test('Épuisement 6 en combat : mort, et fin de la concentration', () {
    final state = projectCombat([
      ..._blessing(),
      _event(CombatEventType.conditionAdded, {
        'combatant': 'mira',
        'instance': 'fatigue',
        'condition': exhaustionCondition,
        'levels': 5,
      }),
    ]);
    expect(state.combatant('mira')!.dead, isFalse);
    final dead = projectCombat([
      ..._blessing(),
      _event(CombatEventType.conditionAdded, {
        'combatant': 'mira',
        'instance': 'fatigue',
        'condition': exhaustionCondition,
        'levels': 6,
      }),
    ]);
    expect(dead.combatant('mira')!.dead, isTrue);
    expect(dead.combatant('mira')!.concentration, isNull);
  });
}
