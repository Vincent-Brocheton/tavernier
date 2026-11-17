// Spec encounters : « Journal du combat », « Jet d'initiative », « Ordre
// d'initiative et égalités », « Rounds et tours », « Compteurs d'un
// combattant », « Préparation des combattants » (US-20, EF-INI-01 à 07).
// Valeurs de la planche [C3] (Le relais du Sel, séance 12).
import 'dart:math';

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
  String id,
  String label, {
  String kind = 'monster',
  String? group,
  String? owner,
  int bonus = 0,
  Map<String, int> counters = const {},
}) => _event(CombatEventType.combatantAdded, {
  'id': id,
  'kind': kind,
  'ref_id': 'ref:$id',
  'label': label,
  'group_id': ?group,
  'owner': ?owner,
  'bonus': bonus,
  'ac': 12,
  'hp': 10,
  'hp_max': 10,
  'counters': counters,
});

CombatEvent _roll(String unit, List<int> dice, int bonus, {int? dropped}) =>
    _event(CombatEventType.initiativeRolled, {
      'unit': unit,
      'dice': dice,
      'dropped': ?dropped,
      'bonus': bonus,
    });

/// Le relais du Sel ([C3]) : neuf unités et leurs jets.
List<CombatEvent> _relais() => [
  _add('aldric', 'Aldric Varenne', kind: 'pc', owner: 'hugo', bonus: 4),
  _add('mira', 'Mira Solen', kind: 'pc', owner: 'ines'),
  _add('thalia', 'Thalia', kind: 'pc', owner: 'leo', bonus: 7),
  _add('brannoc', 'Brannoc', kind: 'pc', owner: 'sam', bonus: 2),
  _add('varga', 'Varga la Balafrée', kind: 'npc', bonus: 3),
  _add('v1', 'Vétéran 1', group: 'vets', bonus: 3),
  _add('v2', 'Vétéran 2', group: 'vets', bonus: 3),
  for (var i = 1; i <= 3; i++)
    _add('l$i', 'Loup sanguinaire $i', group: 'wolves', bonus: 2),
  for (var i = 1; i <= 4; i++)
    _add('b$i', 'Bandit $i', group: 'bandits', bonus: 1),
  _add('ogre', 'Ogre', bonus: -1),
  _roll('aldric', [15], 4, dropped: 11),
  _roll('mira', [8], 0),
  _roll('thalia', [15], 7),
  _roll('brannoc', [6], 2, dropped: 14),
  _roll('varga', [14], 3),
  _roll('vets', [12], 3),
  _roll('wolves', [13], 2),
  _roll('bandits', [11], 1),
  _roll('ogre', [10], -1),
];

const _order = [
  'thalia',
  'aldric',
  'varga',
  'vets',
  'wolves',
  'bandits',
  'ogre',
  'brannoc',
  'mira',
];

void main() {
  group('journal', () {
    test('JSON : aller-retour, type inconnu refusé', () {
      final e = _roll('aldric', [15], 4, dropped: 11);
      final back = CombatEvent.fromJson(e.toJson());
      expect((back.id, back.type), (e.id, e.type));
      expect(back.payload, e.payload);
      expect(e.toJson()['type'], 'initiative_rolled');
      expect(
        () => CombatEvent.fromJson({
          'id': 'x',
          'type': 'boule_de_feu',
          'payload': <String, Object?>{},
        }),
        throwsFormatException,
      );
    });

    test('projection : combattants et totaux', () {
      final state = projectCombat(_relais());
      expect(state.combatants, hasLength(15));
      final aldric = state.combatant('aldric')!;
      expect((aldric.initiative!.total, aldric.initiative!.dropped), (19, 11));
      expect(state.combatant('v2')!.initiative!.total, 15);
      expect(state.combatant('brannoc')!.initiative!.total, 8);
      expect(state.round, 0);
      expect(state.active, isNull);
    });

    test('annulation : le tour suivant annulé, puis l\'annulation annulée', () {
      final events = [
        ..._relais(),
        _event(CombatEventType.combatStarted, {}),
        _event(CombatEventType.turnAdvanced, {}),
      ];
      expect(projectCombat(events).active, 'aldric');
      final undo = _event(CombatEventType.undo, {'event': events.last.id});
      expect(projectCombat([...events, undo]).active, 'thalia');
      final redo = _event(CombatEventType.undo, {'event': undo.id});
      expect(projectCombat([...events, undo, redo]).active, 'aldric');
    });
  });

  group('initiative', () {
    test('surprise : Désavantage ; Avantage et Désavantage s\'annulent', () {
      expect(combineRollModes(), RollMode.normal);
      expect(combineRollModes(surprised: true), RollMode.disadvantage);
      expect(combineRollModes(advantage: true), RollMode.advantage);
      expect(
        combineRollModes(advantage: true, surprised: true),
        RollMode.normal,
      );
    });

    test('jet : d20 + bonus, dé écarté avec l\'Avantage', () {
      final roll = rollInitiative(4, RollMode.advantage, Random(1));
      expect(roll.dice, hasLength(1));
      expect(roll.dropped, isNotNull);
      expect(roll.dice.single, greaterThanOrEqualTo(roll.dropped!));
      expect(roll.total, roll.dice.single + 4);
      final plain = rollInitiative(-1, RollMode.normal, Random(1));
      expect(plain.dropped, isNull);
      expect(plain.total, inInclusiveRange(0, 19));
    });

    test('[C3] : ordre par défaut, total puis bonus', () {
      expect(projectCombat(_relais()).order, _order);
    });

    test('[C3] : égalité à 15 au MJ, à 8 aux joueurs de Brannoc et Mira', () {
      final ties = projectCombat(_relais()).ties;
      expect(ties, hasLength(2));
      expect((ties[0].total, ties[0].gmDecides), (15, true));
      expect(ties[0].units, ['vets', 'wolves']);
      expect((ties[1].total, ties[1].gmDecides), (8, false));
      expect(ties[1].units, ['brannoc', 'mira']);
      expect(ties[1].players, {'sam', 'ines'});
    });

    test('égalité entre un monstre et un PJ : le MJ décide', () {
      final state = projectCombat([
        _add('aldric', 'Aldric', kind: 'pc', owner: 'hugo', bonus: 4),
        _add('ogre', 'Ogre', bonus: -1),
        _roll('aldric', [6], 4),
        _roll('ogre', [11], -1),
      ]);
      expect(state.ties.single.gmDecides, isTrue);
      expect(state.ties.single.players, isEmpty);
    });

    test('ordre choisi : les loups avant les vétérans, égalités réglées', () {
      final state = projectCombat([
        ..._relais(),
        _event(CombatEventType.orderSet, {
          'order': [
            'thalia',
            'aldric',
            'varga',
            'wolves',
            'vets',
            'bandits',
            'ogre',
            'mira',
            'brannoc',
          ],
        }),
      ]);
      expect(state.order.sublist(3, 5), ['wolves', 'vets']);
      expect(state.order.last, 'brannoc');
      expect(state.ties, isEmpty);
    });

    test('unité sans jet : à la fin', () {
      final state = projectCombat([..._relais(), _add('rat', 'Rat')]);
      expect(state.order.last, 'rat');
    });
  });

  group('tours', () {
    List<CombatEvent> started() => [
      ..._relais(),
      _event(CombatEventType.combatStarted, {}),
    ];

    CombatEvent next() => _event(CombatEventType.turnAdvanced, {});

    test('round 1 sur Thalia, round 2 après neuf tours', () {
      var events = started();
      expect(
        (projectCombat(events).round, projectCombat(events).active),
        (1, 'thalia'),
      );
      events = [...events, for (var i = 0; i < 9; i++) next()];
      final state = projectCombat(events);
      expect((state.round, state.active), (2, 'thalia'));
    });

    test('réaction de Varga : utilisée jusqu\'à son tour suivant', () {
      final events = [
        ...started(),
        next(),
        _event(CombatEventType.counterUsed, {
          'combatant': 'varga',
          'counter': 'reaction',
        }),
      ];
      expect(
        projectCombat(events).combatant('varga')!.remaining('reaction'),
        0,
      );
      // Tour de Varga au round 1 : elle la retrouve.
      final atHerTurn = [...events, next()];
      expect(
        projectCombat(atHerTurn).combatant('varga')!.remaining('reaction'),
        1,
      );
    });

    test('ajout en combat : à sa place d\'initiative', () {
      final state = projectCombat([
        ...started(),
        _add('chef', 'Chef de bande', bonus: 3),
        _roll('chef', [16], 3),
      ]);
      expect(state.order.indexOf('chef'), 2);
      expect(state.active, 'thalia');
    });

    test('retrait de l\'ogre pendant son tour : tour à Brannoc', () {
      final events = [...started(), for (var i = 0; i < 6; i++) next()];
      expect(projectCombat(events).active, 'ogre');
      final state = projectCombat([
        ...events,
        _event(CombatEventType.combatantRemoved, {'combatant': 'ogre'}),
      ]);
      expect(state.active, 'brannoc');
      expect(state.order, isNot(contains('ogre')));
      expect(state.combatant('ogre'), isNull);
    });

    test('retrait d\'un membre de groupe : le groupe reste', () {
      final state = projectCombat([
        ...started(),
        _event(CombatEventType.combatantRemoved, {'combatant': 'v1'}),
      ]);
      expect(state.order, contains('vets'));
      expect(state.members('vets').map((c) => c.id), ['v2']);
    });

    test('retrait du dernier actif : round suivant', () {
      final events = [...started(), for (var i = 0; i < 8; i++) next()];
      expect(projectCombat(events).active, 'mira');
      final state = projectCombat([
        ...events,
        _event(CombatEventType.combatantRemoved, {'combatant': 'mira'}),
      ]);
      expect((state.round, state.active), (2, 'thalia'));
    });
  });

  group('compteurs', () {
    List<CombatEvent> dragon() => [
      _add(
        'dragon',
        'Dragon noir adulte',
        bonus: 2,
        counters: {
          'legendary_actions': 3,
          'legendary_resistance': 3,
          "recharge:Souffle d'acide": 1,
        },
      ),
      _add('aldric', 'Aldric', kind: 'pc', owner: 'hugo', bonus: 4),
      _roll('dragon', [20], 2),
      _roll('aldric', [1], 4),
      _event(CombatEventType.combatStarted, {}),
    ];

    CombatEvent use(String counter, [int amount = 1]) => _event(
      CombatEventType.counterUsed,
      {'combatant': 'dragon', 'counter': counter, 'amount': amount},
    );

    test('actions légendaires : 3, puis 1, rendues à son tour', () {
      final events = [...dragon(), use('legendary_actions', 2)];
      final dragonState = projectCombat(events).combatant('dragon')!;
      expect(dragonState.max('legendary_actions'), 3);
      expect(dragonState.remaining('legendary_actions'), 1);
      final nextRound = [
        ...events,
        for (var i = 0; i < 2; i++) _event(CombatEventType.turnAdvanced, {}),
      ];
      expect(
        projectCombat(nextRound)
            .combatant('dragon')!
            .remaining('legendary_actions'),
        3,
      );
    });

    test('résistance légendaire : jamais rendue, jamais sous 0', () {
      final events = [
        ...dragon(),
        use('legendary_resistance', 5),
        for (var i = 0; i < 4; i++) _event(CombatEventType.turnAdvanced, {}),
      ];
      expect(
        projectCombat(events)
            .combatant('dragon')!
            .remaining('legendary_resistance'),
        0,
      );
    });

    test('recharge 5–6 : un 5 la rend, un 4 non', () {
      expect(rechargeSucceeds('5-6', 5), isTrue);
      expect(rechargeSucceeds('5-6', 4), isFalse);
      expect(rechargeSucceeds('6', 6), isTrue);
      expect(rechargeSucceeds('6', 5), isFalse);
      final used = [...dragon(), use("recharge:Souffle d'acide")];
      expect(
        projectCombat(used)
            .combatant('dragon')!
            .remaining("recharge:Souffle d'acide"),
        0,
      );
      final restored = [
        ...used,
        _event(CombatEventType.counterRestored, {
          'combatant': 'dragon',
          'counter': "recharge:Souffle d'acide",
        }),
      ];
      expect(
        projectCombat(restored)
            .combatant('dragon')!
            .remaining("recharge:Souffle d'acide"),
        1,
      );
    });
  });

  group('préparation', () {
    test('numérotation : « Loup sanguinaire 1 » à 3, unique sans numéro', () {
      expect(numberedLabels('Loup sanguinaire', 3), [
        'Loup sanguinaire 1',
        'Loup sanguinaire 2',
        'Loup sanguinaire 3',
      ]);
      expect(numberedLabels('Ogre', 1), ['Ogre']);
    });

    test('PV tirés : « 8d8 + 16 » entre 24 et 80', () {
      for (var seed = 0; seed < 20; seed++) {
        expect(
          rollHitPoints('8d8 + 16', Random(seed)),
          inInclusiveRange(24, 80),
        );
      }
      expect(rollHitPoints('1d4 - 3', Random(0)), greaterThanOrEqualTo(1));
    });
  });
}
