// Spec encounters : « États d'un combattant », « Durée d'un état », « Rappels
// de tour » (US-22, EF-CON-01 à 03). Règles du SRD 5.2.1 (« Un état n'est pas
// cumulable avec lui-même », Épuisement cumulatif) ; valeurs de [C5], [C6].
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

var _next = 0;

CombatEvent _event(CombatEventType type, [Map<String, Object?>? payload]) =>
    CombatEvent(
      id: 'e${(_next++).toString().padLeft(4, '0')}',
      type: type,
      payload: payload ?? const {},
    );

CombatEvent _add(
  String id, {
  Map<String, int> saves = const {},
  List<String> conditionImmunities = const [],
}) => _event(CombatEventType.combatantAdded, {
  'id': id,
  'kind': 'monster',
  'label': id,
  'hp': 10,
  'hp_max': 10,
  'saves': saves,
  'condition_immunities': conditionImmunities,
});

const _restrained = 'srd:condition:restrained';
const _frightened = 'srd:condition:frightened';
const _poisoned = 'srd:condition:poisoned';
const _blinded = 'srd:condition:blinded';
const _exhaustion = 'srd:condition:exhaustion';

CombatEvent _pose(
  String on,
  String instance, {
  String? condition,
  String? label,
  Map<String, Object?> duration = const {'kind': 'indefinite'},
  int? levels,
  Map<String, Object?>? recurring,
}) => _event(CombatEventType.conditionAdded, {
  'combatant': on,
  'instance': instance,
  'condition': ?condition,
  'label': ?label,
  'duration': duration,
  'levels': ?levels,
  'recurring': ?recurring,
});

CombatEvent _remove(String on, String instance, {int? levels}) => _event(
  CombatEventType.conditionRemoved,
  {'combatant': on, 'instance': instance, 'levels': ?levels},
);

CombatEvent _saved(String on, String instance, {required bool success}) =>
    _event(CombatEventType.conditionSave, {
      'combatant': on,
      'instance': instance,
      'success': success,
    });

final _start = _event(CombatEventType.combatStarted);
CombatEvent _next1() => _event(CombatEventType.turnAdvanced);
CombatEvent _undo(CombatEvent e) =>
    _event(CombatEventType.undo, {'event': e.id});

List<String> _on(List<CombatEvent> events, String id) => [
  for (final c in projectCombat(events).combatant(id)!.conditions)
    c.condition ?? c.label!,
];

void main() {
  group('états', () {
    test('[C5] : Entravé jusqu\'à réussite d\'un JS de Force DD 13', () {
      final state = projectCombat([
        _add('loup'),
        _pose(
          'loup',
          'i1',
          condition: _restrained,
          duration: {'kind': 'save', 'dc': 13, 'ability': 'str'},
        ),
      ]);
      final c = state.combatant('loup')!.conditions.single;
      expect(c.id, 'i1');
      expect(c.condition, _restrained);
      expect(c.duration.kind, DurationKind.save);
      expect((c.duration.dc, c.duration.ability), (13, 'str'));
    });

    test('effet libellé, sans état du SRD', () {
      expect(_on([_add('b'), _pose('b', 'i1', label: 'En feu')], 'b'), [
        'En feu',
      ]);
    });

    test('SRD : chaque source garde son instance ; retrait d\'une seule', () {
      final events = [
        _add('b'),
        _pose('b', 'i1', condition: _poisoned),
        _pose('b', 'i2', condition: _poisoned),
        _remove('b', 'i1'),
      ];
      expect(_on(events, 'b'), [_poisoned]);
      expect(projectCombat(events).combatant('b')!.conditions.single.id, 'i2');
    });

    test('SRD : Épuisement cumulatif, plafonné à 6, retrait de niveaux', () {
      int? level(List<CombatEvent> events) =>
          projectCombat(events).combatant('a')!.exhaustion;
      final base = [
        _add('a'),
        _pose('a', 'i1', condition: _exhaustion),
        _pose('a', 'i2', condition: _exhaustion),
      ];
      expect(level(base), 2);
      expect(projectCombat(base).combatant('a')!.conditions, hasLength(1));
      expect(level([...base, _remove('a', 'i1', levels: 1)]), 1);
      expect(level([...base, _remove('a', 'i1', levels: 2)]), 0);
      expect(_on([...base, _remove('a', 'i1', levels: 2)], 'a'), isEmpty);
      expect(
        level([...base, _pose('a', 'i3', condition: _exhaustion, levels: 5)]),
        6,
      );
    });

    test('SRD : un squelette, immunisé, n\'est pas Empoisonné', () {
      expect(
        _on([
          _add('s', conditionImmunities: [_poisoned]),
          _pose('s', 'i1', condition: _poisoned),
        ], 's'),
        isEmpty,
      );
    });

    test('retrait inconnu ou porteur absent : sans effet', () {
      final events = [
        _add('b'),
        _pose('b', 'i1', condition: _poisoned),
        _remove('b', 'autre'),
        _pose('absent', 'i2', condition: _poisoned),
        _saved('absent', 'i2', success: true),
      ];
      expect(_on(events, 'b'), [_poisoned]);
    });
  });

  group('durées', () {
    // Ordre : aldric, bandit, mira (ordre d'ajout, sans jet).
    final table = [_add('aldric'), _add('bandit'), _add('mira'), _start];

    test('2 rounds posés au tour d\'Aldric : fin au début de son tour, '
        'round 3', () {
      final events = [
        ...table,
        _pose(
          'bandit',
          'i1',
          condition: _blinded,
          duration: {'kind': 'rounds', 'rounds': 2},
        ),
      ];
      // Round 2 entier, jusqu'au tour de Mira compris.
      final round2End = [...events, for (var i = 0; i < 5; i++) _next1()];
      expect(projectCombat(round2End).round, 2);
      expect(projectCombat(round2End).active, 'mira');
      expect(_on(round2End, 'bandit'), [_blinded]);
      final round3 = [...round2End, _next1()];
      expect(projectCombat(round3).active, 'aldric');
      expect(_on(round3, 'bandit'), isEmpty);
    });

    test('posé avant le combat, 1 round : dure tout le round 1', () {
      final events = [
        _add('aldric'),
        _add('bandit'),
        _pose(
          'bandit',
          'i1',
          condition: _blinded,
          duration: {'kind': 'rounds', 'rounds': 1},
        ),
        _start,
      ];
      final endOfRound1 = [...events, _next1()];
      expect(_on(endOfRound1, 'bandit'), [_blinded]);
      // Round 2, tour du bandit (unité d'ancrage hors combat : le porteur).
      final round2 = [...endOfRound1, _next1(), _next1()];
      expect(projectCombat(round2).active, 'bandit');
      expect(_on(round2, 'bandit'), isEmpty);
    });

    test('jusqu\'à la fin du tour de Mira : fin au passage après Mira', () {
      final events = [
        ...table,
        _pose(
          'bandit',
          'i1',
          condition: _frightened,
          duration: {'kind': 'turn_end', 'combatant': 'mira'},
        ),
        _next1(),
        _next1(),
      ];
      expect(projectCombat(events).active, 'mira');
      expect(_on(events, 'bandit'), [_frightened]);
      expect(_on([...events, _next1()], 'bandit'), isEmpty);
    });

    test('fin du tour du porteur pendant son tour : ce tour-ci', () {
      final events = [
        ...table,
        _pose(
          'aldric',
          'i1',
          condition: _frightened,
          duration: {'kind': 'turn_end', 'combatant': 'aldric'},
        ),
      ];
      expect(_on(events, 'aldric'), [_frightened]);
      expect(_on([...events, _next1()], 'aldric'), isEmpty);
    });

    test('jusqu\'au début du tour d\'Aldric, posé pendant son tour : '
        'le suivant', () {
      final events = [
        ...table,
        _pose(
          'bandit',
          'i1',
          condition: _restrained,
          duration: {'kind': 'turn_start', 'combatant': 'aldric'},
        ),
        _next1(),
        _next1(),
      ];
      expect(_on(events, 'bandit'), [_restrained]);
      final next = [...events, _next1()];
      expect(projectCombat(next).active, 'aldric');
      expect(_on(next, 'bandit'), isEmpty);
    });

    test('X a quitté le combat : l\'état reste', () {
      final events = [
        ...table,
        _pose(
          'bandit',
          'i1',
          condition: _restrained,
          duration: {'kind': 'turn_end', 'combatant': 'mira'},
        ),
        _event(CombatEventType.combatantRemoved, {'combatant': 'mira'}),
        for (var i = 0; i < 4; i++) _next1(),
      ];
      expect(_on(events, 'bandit'), [_restrained]);
    });

    test('unité d\'ancrage partie : le premier tour du bon round suffit', () {
      final events = [
        ...table,
        _pose(
          'bandit',
          'i1',
          condition: _blinded,
          duration: {'kind': 'rounds', 'rounds': 1},
        ),
        _event(CombatEventType.combatantRemoved, {'combatant': 'aldric'}),
      ];
      // Le tour passe au bandit (round 1), puis Mira, puis round 2.
      expect(_on([...events, _next1()], 'bandit'), [_blinded]);
      final round2 = [...events, _next1(), _next1()];
      expect(projectCombat(round2).round, 2);
      expect(_on(round2, 'bandit'), isEmpty);
    });

    test('sauvegarde : l\'échec garde l\'état, la réussite le retire', () {
      final events = [
        _add('loup'),
        _pose(
          'loup',
          'i1',
          condition: _restrained,
          duration: {'kind': 'save', 'dc': 13, 'ability': 'str'},
        ),
        _saved('loup', 'i1', success: false),
      ];
      expect(_on(events, 'loup'), [_restrained]);
      expect(
        _on([...events, _saved('loup', 'i1', success: true)], 'loup'),
        isEmpty,
      );
    });

    test('indéfinie : reste au fil des rounds', () {
      final events = [
        ...table,
        _pose('bandit', 'i1', condition: _poisoned),
        for (var i = 0; i < 9; i++) _next1(),
      ];
      expect(_on(events, 'bandit'), [_poisoned]);
    });

    test('annuler le passage du tour rend l\'état', () {
      final passage = _next1();
      final events = [
        ...table,
        _pose(
          'aldric',
          'i1',
          condition: _frightened,
          duration: {'kind': 'turn_end', 'combatant': 'aldric'},
        ),
        passage,
      ];
      expect(_on(events, 'aldric'), isEmpty);
      expect(_on([...events, _undo(passage)], 'aldric'), [_frightened]);
    });

    test('le porteur retiré emporte ses états', () {
      final state = projectCombat([
        ...table,
        _pose('bandit', 'i1', condition: _poisoned),
        _event(CombatEventType.combatantRemoved, {'combatant': 'bandit'}),
      ]);
      expect(state.combatant('bandit'), isNull);
    });
  });

  group('rappels', () {
    test('[C6] : fin du tour du loup, sauvegarde à refaire et Effrayé '
        'qui expire', () {
      final state = projectCombat([
        _add('loup', saves: {'str': 3}),
        _add('bandit'),
        _start,
        _pose(
          'loup',
          'i1',
          condition: _restrained,
          duration: {'kind': 'save', 'dc': 13, 'ability': 'str'},
        ),
        _pose(
          'loup',
          'i2',
          condition: _frightened,
          duration: {'kind': 'turn_end', 'combatant': 'loup'},
        ),
      ]);
      final reminders = turnReminders(state, TurnPhase.end);
      expect(
        [for (final r in reminders) (r.kind, r.combatant.id, r.instance.id)],
        [
          (ReminderKind.save, 'loup', 'i1'),
          (ReminderKind.expires, 'loup', 'i2'),
        ],
      );
      expect(reminders.first.saveBonus, 3);
    });

    test('bonus de sauvegarde inconnu : null', () {
      final state = projectCombat([
        _add('loup'),
        _start,
        _pose(
          'loup',
          'i1',
          condition: _restrained,
          duration: {'kind': 'save', 'dc': 13, 'ability': 'str'},
        ),
      ]);
      expect(turnReminders(state, TurnPhase.end).single.saveBonus, isNull);
    });

    test('[1a] : début du tour du Chef de bande, Empoisonné expire à la fin '
        'de ce tour', () {
      final state = projectCombat([
        _add('aldric'),
        _add('chef'),
        _add('mira'),
        _pose(
          'chef',
          'i1',
          condition: _poisoned,
          duration: {'kind': 'turn_end', 'combatant': 'chef'},
        ),
        // Mira n'est effrayée qu'à la fin du tour du chef : rappel au chef.
        _pose(
          'mira',
          'i2',
          condition: _frightened,
          duration: {'kind': 'turn_end', 'combatant': 'chef'},
        ),
        _start,
        _next1(),
      ]);
      expect(state.active, 'chef');
      expect(
        [
          for (final r in turnReminders(state, TurnPhase.start))
            (r.kind, r.combatant.id, r.instance.id),
        ],
        [
          (ReminderKind.expires, 'chef', 'i1'),
          (ReminderKind.expires, 'mira', 'i2'),
        ],
      );
    });

    test('début de tour : états qui viennent d\'expirer', () {
      final state = projectCombat([
        _add('aldric'),
        _add('bandit'),
        _start,
        _pose(
          'bandit',
          'i1',
          condition: _restrained,
          duration: {'kind': 'turn_start', 'combatant': 'bandit'},
        ),
        _next1(),
      ]);
      expect(state.combatant('bandit')!.conditions, isEmpty);
      final r = turnReminders(state, TurnPhase.start).single;
      expect(
        (r.kind, r.combatant.id, r.instance.id),
        (ReminderKind.expired, 'bandit', 'i1'),
      );
      // Au tour suivant, le rappel n'est plus là.
      expect(
        turnReminders(
          projectCombat([
            _add('aldric'),
            _add('bandit'),
            _start,
            _next1(),
            _next1(),
          ]),
          TurnPhase.start,
        ),
        isEmpty,
      );
    });

    test('dégâts récurrents : 1d4 de feu au début du tour du bandit', () {
      final fire = {
        'dice': '1d4',
        'type': 'srd:damage-type:fire',
        'at': 'start',
      };
      final events = [
        _add('aldric'),
        _add('bandit'),
        _start,
        _pose('bandit', 'i1', label: 'En feu', recurring: fire),
        _next1(),
      ];
      final r = turnReminders(projectCombat(events), TurnPhase.start).single;
      expect(r.kind, ReminderKind.recurring);
      expect(r.instance.recurring!.dice, '1d4');
      expect(r.instance.recurring!.type, 'srd:damage-type:fire');
      expect(turnReminders(projectCombat(events), TurnPhase.end), isEmpty);
    });

    test('dégâts récurrents à la fin du tour', () {
      final state = projectCombat([
        _add('bandit'),
        _start,
        _pose(
          'bandit',
          'i1',
          label: 'Acide',
          recurring: {
            'dice': '2d4',
            'type': 'srd:damage-type:acid',
            'at': 'end',
          },
        ),
      ]);
      expect(
        turnReminders(state, TurnPhase.end).single.kind,
        ReminderKind.recurring,
      );
      expect(turnReminders(state, TurnPhase.start), isEmpty);
    });

    test('combat pas commencé : aucun rappel', () {
      final state = projectCombat([
        _add('loup'),
        _pose('loup', 'i1', condition: _poisoned),
      ]);
      expect(turnReminders(state, TurnPhase.end), isEmpty);
    });
  });
}
