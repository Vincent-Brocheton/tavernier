// Spec encounters : « Échange d'initiative (Vigilant) », « Réaction des PJ »
// (US-37, EF-INI-08, 09). SRD 5.2.1, don Vigilant ; valeurs de [C3] :
// Aldric 19, Thalia 22, Mira 8.
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

var _next = 0;

CombatEvent _event(CombatEventType type, Map<String, Object?> payload) =>
    CombatEvent(
      id: 'e${(_next++).toString().padLeft(4, '0')}',
      type: type,
      payload: payload,
    );

CombatEvent _add(String id, {bool alert = false}) => _event(
  CombatEventType.combatantAdded,
  {'id': id, 'kind': 'pc', 'label': id, 'hp': 30, 'hp_max': 30, 'alert': alert},
);

CombatEvent _roll(String unit, int total) =>
    _event(CombatEventType.initiativeRolled, {
      'unit': unit,
      'dice': [total],
    });

CombatEvent _swap(String a, String b) =>
    _event(CombatEventType.initiativeSwapped, {'combatant': a, 'with': b});

List<CombatEvent> _party() => [
  _add('aldric', alert: true),
  _add('thalia', alert: true),
  _add('mira'),
  _roll('aldric', 19),
  _roll('thalia', 22),
  _roll('mira', 8),
];

int? _total(CombatState s, String id) => s.combatant(id)!.initiative?.total;

void main() {
  group('Vigilant', () {
    test('[C3] : Aldric échange son 19 avec le 8 de Mira', () {
      final state = projectCombat([..._party(), _swap('aldric', 'mira')]);
      expect(_total(state, 'aldric'), 8);
      expect(_total(state, 'mira'), 19);
      expect(state.order, ['thalia', 'mira', 'aldric']);
    });

    test('un ordre déjà choisi suit l\'échange', () {
      final state = projectCombat([
        ..._party(),
        _event(CombatEventType.orderSet, {
          'order': ['thalia', 'aldric', 'mira'],
        }),
        _swap('aldric', 'mira'),
      ]);
      expect(state.order, ['thalia', 'mira', 'aldric']);
    });

    test('impossible si l\'un des deux est Neutralisé', () {
      final state = projectCombat([
        ..._party(),
        _event(CombatEventType.conditionAdded, {
          'combatant': 'mira',
          'instance': 'étourdie',
          'condition': 'srd:condition:stunned',
        }),
        _swap('aldric', 'mira'),
      ]);
      expect(_total(state, 'aldric'), 19);
    });

    test('sans Vigilant, après le début du combat ou sans jet : rien', () {
      expect(
        _total(projectCombat([..._party(), _swap('mira', 'aldric')]), 'mira'),
        8,
      );
      expect(
        _total(
          projectCombat([
            ..._party(),
            _event(CombatEventType.combatStarted, const {}),
            _swap('aldric', 'mira'),
          ]),
          'aldric',
        ),
        19,
      );
      expect(
        _total(
          projectCombat([
            _add('aldric', alert: true),
            _add('mira'),
            _roll('aldric', 19),
            _swap('aldric', 'mira'),
          ]),
          'aldric',
        ),
        19,
      );
    });

    test('canSwapInitiative', () {
      final state = projectCombat(_party());
      expect(state.canSwapInitiative('aldric', 'mira'), isTrue);
      expect(state.canSwapInitiative('mira', 'aldric'), isFalse);
      expect(state.canSwapInitiative('aldric', 'aldric'), isFalse);
    });
  });

  test('réaction d\'un PJ : utilisée, puis rendue au début de son tour', () {
    final events = [
      ..._party(),
      _event(CombatEventType.combatStarted, const {}),
      _event(CombatEventType.counterUsed, {
        'combatant': 'aldric',
        'counter': reactionCounter,
      }),
    ];
    expect(
      projectCombat(events).combatant('aldric')!.remaining(reactionCounter),
      0,
    );
    final next = projectCombat([
      ...events,
      _event(CombatEventType.turnAdvanced, const {}),
    ]);
    expect(next.active, 'aldric');
    expect(next.combatant('aldric')!.remaining(reactionCounter), 1);
  });
}
