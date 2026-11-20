// Spec encounters : « Adversaire masqué aux joueurs », « Vue du combat du
// joueur » (US-36, EF-VJ-02 à 04). Valeurs de [J1].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

var _next = 0;

CombatEvent _event(CombatEventType type, [Map<String, Object?> p = const {}]) =>
    CombatEvent(
      id: 'e${(_next++).toString().padLeft(4, '0')}',
      type: type,
      payload: p,
    );

CombatEvent _pc(String id, String label, int hp, int max) =>
    _event(CombatEventType.combatantAdded, {
      'id': id,
      'kind': 'pc',
      'ref_id': id,
      'owner': 'joueur-$id',
      'label': label,
      'hp': hp,
      'hp_max': max,
      'ac': 18,
    });

CombatEvent _foe(String id, String label) =>
    _event(CombatEventType.combatantAdded, {
      'id': id,
      'kind': 'monster',
      'ref_id': 'srd:monster:bandit',
      'label': label,
      'hp': 11,
      'hp_max': 11,
      'ac': 12,
    });

void main() {
  // [J1] : round 3, tour du Chef de bande, Aldric joue dans 2 tours.
  final events = [
    _pc('thalia', 'Thalia', 33, 33),
    _foe('chef', 'Chef de bande'),
    _foe('loup', 'Loup 2'),
    _pc('aldric', 'Aldric Varenne', 41, 49),
    _pc('mira', 'Mira Solen', 10, 38),
    _foe('cache', 'Assassin caché'),
    for (final (unit, d) in [
      ('thalia', 22),
      ('chef', 18),
      ('loup', 15),
      ('aldric', 14),
      ('mira', 9),
      ('cache', 5),
    ])
      _event(CombatEventType.initiativeRolled, {
        'unit': unit,
        'dice': [d],
      }),
    _event(CombatEventType.combatStarted),
    _event(CombatEventType.tempHp, {
      'targets': ['aldric'],
      'amount': 5,
    }),
    _event(CombatEventType.combatantHidden, {
      'combatant': 'cache',
      'hidden': true,
    }),
    _event(CombatEventType.concentrationStarted, {
      'combatant': 'mira',
      'spell': 'Bénédiction',
    }),
    // Béni, posé au round 1 pour 10 rounds.
    _event(CombatEventType.conditionAdded, {
      'combatant': 'aldric',
      'instance': 'beni',
      'label': 'Béni',
      'duration': {'kind': 'rounds', 'rounds': 10},
      'concentration': 'mira',
    }),
    for (var i = 0; i < 6 * 2 + 1; i++) _event(CombatEventType.turnAdvanced),
  ];

  test('[J1] : ordre filtré, adversaires sous leur seul nom', () {
    final view = playerCombatView(projectCombat(events));
    expect(view['round'], 3);
    final order = (view['order']! as List).cast<Map<String, Object?>>();
    expect(
      [for (final o in order) o['label']],
      ['Thalia', 'Chef de bande', 'Loup 2', 'Aldric Varenne', 'Mira Solen'],
    );
    final chef = order[1];
    expect(chef, {
      'id': 'chef',
      'unit': 'chef',
      'label': 'Chef de bande',
      'kind': 'foe',
      'active': true,
    });
    expect(order[0]['health'], 'unhurt');
    expect(order[3]['health'], 'wounded');
    expect(order[4]['health'], 'badly');
    expect(turnsUntil(view, 'aldric'), 2);
  });

  test('[J1] : le détail d\'Aldric pour son téléphone', () {
    final view = playerCombatView(projectCombat(events));
    final aldric =
        (view['pcs']! as Map<String, Object?>)['aldric']!
            as Map<String, Object?>;
    expect(aldric['hp'], 41);
    expect(aldric['hp_max'], 49);
    expect(aldric['temp_hp'], 5);
    expect(aldric['reaction'], isTrue);
    expect(aldric['concentration'], isNull);
    // « Béni · de Mira · concentration · 8 rounds ».
    expect(aldric['conditions'], [
      {
        'instance': 'beni',
        'label': 'Béni',
        'levels': 1,
        'duration': 'rounds',
        'rounds': 8,
        'concentration': 'Mira Solen',
      },
    ]);
  });

  test('masqué puis rendu visible', () {
    final shown = playerCombatView(
      projectCombat([
        ...events,
        _event(CombatEventType.combatantHidden, {
          'combatant': 'cache',
          'hidden': false,
        }),
      ]),
    );
    expect([
      for (final o in shown['order']! as List) (o as Map)['label'],
    ], contains('Assassin caché'));
    expect(projectCombat(events).combatant('cache')!.hidden, isTrue);
  });

  test('aucune donnée réservée au MJ dans la vue', () {
    final view = playerCombatView(projectCombat(events));
    expect((view['pcs']! as Map).keys, {'thalia', 'aldric', 'mira'});
    expect('$view', isNot(contains('srd:monster')));
    for (final o in view['order']! as List) {
      final entry = o as Map;
      if (entry['kind'] == 'foe') {
        expect(entry.keys, {'id', 'unit', 'label', 'kind', 'active'});
      }
    }
  });

  test('test de concentration en attente et jets contre la mort', () {
    final state = projectCombat([
      ...events,
      _event(CombatEventType.concentrationStarted, {
        'combatant': 'mira',
        'spell': 'Bénédiction',
      }),
      _event(CombatEventType.damage, {
        'targets': ['mira'],
        'amount': 4,
        'type': 'srd:damage-type:slashing',
      }),
      _event(CombatEventType.damage, {
        'targets': ['thalia'],
        'amount': 40,
        'type': 'srd:damage-type:slashing',
      }),
    ]);
    final pcs = playerCombatView(state)['pcs']! as Map<String, Object?>;
    final mira = pcs['mira']! as Map<String, Object?>;
    expect(mira['concentration'], 'Bénédiction');
    expect(mira['checks'], [
      {'dc': 10, 'damage': 4},
    ]);
    final thalia = pcs['thalia']! as Map<String, Object?>;
    expect(thalia['death'], {
      'successes': 0,
      'failures': 0,
      'stable': false,
      'dead': false,
    });
  });

  group('demandes du joueur', () {
    final base = projectCombat(events);
    // Les maps se comparent en profondeur dans une liste, pas dans un record.
    List<List<Object>> apply(
      String type,
      Map<String, Object?> payload, {
      String character = 'aldric',
      CombatState? state,
    }) => [
      for (final (t, p) in requestEvents(
        state ?? base,
        id: 'q1',
        character: character,
        type: type,
        payload: payload,
      ))
        [t, p],
    ];

    test('des dégâts visent son seul PJ, avec la référence', () {
      final out = apply('damage', {
        'targets': ['mira', 'chef'],
        'amount': 7,
        'type': 'srd:damage-type:slashing',
        'knock_out': true,
      });
      expect(out, [
        [
          CombatEventType.damage,
          {
            'targets': ['aldric'],
            'amount': 7,
            'type': 'srd:damage-type:slashing',
            'request': 'q1',
          },
        ],
      ]);
      final after = projectCombat([
        ...events,
        for (final [t as CombatEventType, p as Map<String, Object?>] in out)
          _event(t, p),
      ]);
      // 5 PV temporaires d'abord, puis 2 PV.
      expect(after.combatant('aldric')!.hp, 39);
    });

    test('soins et PV temporaires', () {
      expect(apply('heal', {'amount': 3}), [
        [
          CombatEventType.heal,
          {
            'targets': ['aldric'],
            'amount': 3,
            'request': 'q1',
          },
        ],
      ]);
      expect(apply('temp_hp', {'amount': 8}), [
        [
          CombatEventType.tempHp,
          {
            'targets': ['aldric'],
            'amount': 8,
            'request': 'q1',
          },
        ],
      ]);
    });

    test('refusée : type non permis, montant invalide, PJ absent', () {
      expect(apply('combatant_removed', {'combatant': 'aldric'}), isEmpty);
      expect(apply('undo', {'event': 'e0001'}), isEmpty);
      expect(apply('damage', {'amount': 0}), isEmpty);
      expect(apply('heal', {'amount': 'x'}), isEmpty);
      expect(apply('heal', {'amount': 3}, character: 'kael'), isEmpty);
      expect(apply('inconnu', const {}), isEmpty);
    });

    test('jet contre la mort, seulement à terre et instable', () {
      expect(apply('death_save', {'outcome': 'success'}), isEmpty);
      final down = projectCombat([
        ...events,
        _event(CombatEventType.damage, {
          'targets': ['aldric'],
          'amount': 46,
          'type': 'srd:damage-type:slashing',
        }),
      ]);
      expect(apply('death_save', {'outcome': 'nat20'}, state: down), [
        [
          CombatEventType.deathSave,
          {'combatant': 'aldric', 'outcome': 'nat20', 'request': 'q1'},
        ],
      ]);
      expect(apply('death_save', {'outcome': 'x'}, state: down), isEmpty);
    });

    test("test de concentration, seulement s'il est en attente", () {
      expect(apply('concentration_check', {'success': true}), isEmpty);
      final pending = projectCombat([
        ...events,
        _event(CombatEventType.concentrationStarted, {
          'combatant': 'aldric',
          'spell': 'Bénédiction',
        }),
        _event(CombatEventType.damage, {
          'targets': ['aldric'],
          'amount': 10,
          'type': 'srd:damage-type:slashing',
        }),
      ]);
      expect(apply('concentration_check', {'success': false}, state: pending), [
        [
          CombatEventType.concentrationCheck,
          {'combatant': 'aldric', 'success': false, 'request': 'q1'},
        ],
      ]);
    });

    test('concentration commencée, finie ; fin de tour à son seul tour', () {
      expect(apply('concentration_started', {'spell': 'Bénédiction'}), [
        [
          CombatEventType.concentrationStarted,
          {'combatant': 'aldric', 'spell': 'Bénédiction', 'request': 'q1'},
        ],
      ]);
      expect(apply('concentration_started', {'spell': ''}), isEmpty);
      expect(apply('concentration_ended', const {}), isEmpty);
      final concentrating = projectCombat([
        ...events,
        _event(CombatEventType.concentrationStarted, {
          'combatant': 'aldric',
          'spell': 'Bénédiction',
        }),
      ]);
      expect(apply('concentration_ended', const {}, state: concentrating), [
        [
          CombatEventType.concentrationEnded,
          {'combatant': 'aldric', 'request': 'q1'},
        ],
      ]);
      // [J1] : c'est le tour du Chef de bande, pas d'Aldric.
      expect(apply('turn_advanced', const {}), isEmpty);
      final mine = projectCombat([
        ...events,
        _event(CombatEventType.turnAdvanced),
        _event(CombatEventType.turnAdvanced),
      ]);
      expect(mine.active, 'aldric');
      expect(apply('turn_advanced', const {}, state: mine), [
        [
          CombatEventType.turnAdvanced,
          {'request': 'q1'},
        ],
      ]);
    });
  });

  test('jet contre la mort : 1, 20, 10 ou plus (SRD)', () {
    expect(deathSaveOutcome(1), 'nat1');
    expect(deathSaveOutcome(9), 'failure');
    expect(deathSaveOutcome(10), 'success');
    expect(deathSaveOutcome(19), 'success');
    expect(deathSaveOutcome(20), 'nat20');
  });
}
