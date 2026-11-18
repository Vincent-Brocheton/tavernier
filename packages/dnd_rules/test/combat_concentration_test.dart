// Spec encounters : « Concentration d'un combattant », « Test de
// concentration » (US-23, EF-CON-04, 05). Règle du SRD 5.2.1, glossaire
// « Concentration » : DD de 10 ou de la moitié des dégâts subis (arrondie à
// l'inférieur), le plus élevé, jusqu'à 30 ; valeurs de [1c].
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
  int hp = 38,
  List<String> immunities = const [],
}) => _event(CombatEventType.combatantAdded, {
  'id': id,
  'kind': 'pc',
  'label': id,
  'hp': hp,
  'hp_max': hp,
  'immunities': immunities,
});

CombatEvent _focus(String on, String spell) => _event(
  CombatEventType.concentrationStarted,
  {'combatant': on, 'spell': spell},
);

CombatEvent _end(String on) =>
    _event(CombatEventType.concentrationEnded, {'combatant': on});

CombatEvent _check(String on, {required bool success}) => _event(
  CombatEventType.concentrationCheck,
  {'combatant': on, 'success': success},
);

CombatEvent _hit(String on, int amount, [String type = 'slashing']) =>
    _event(CombatEventType.damage, {
      'targets': [on],
      'amount': amount,
      'type': type,
    });

CombatEvent _pose(String on, String instance, {String? linkedTo}) =>
    _event(CombatEventType.conditionAdded, {
      'combatant': on,
      'instance': instance,
      'label': instance,
      'concentration': ?linkedTo,
    });

/// Mira bénit Aldric et Thalia ; Aldric est aussi Empoisonné, sans lien.
List<CombatEvent> _blessing() => [
  _add('mira'),
  _add('aldric'),
  _add('thalia'),
  _focus('mira', 'Bénédiction'),
  _pose('aldric', 'béni-a', linkedTo: 'mira'),
  _pose('thalia', 'béni-t', linkedTo: 'mira'),
  _pose('aldric', 'empoisonné'),
];

List<String> _on(CombatState state, String id) => [
  for (final c in state.combatant(id)!.conditions) c.label!,
];

void main() {
  group('concentration', () {
    test('Bénédiction et ses effets liés', () {
      final state = projectCombat(_blessing());
      expect(state.combatant('mira')!.concentration, 'Bénédiction');
      expect(state.combatant('aldric')!.concentration, isNull);
      expect(_on(state, 'aldric'), ['béni-a', 'empoisonné']);
      expect(
        [for (final (c, i) in state.linkedTo('mira')) '${c.id}:${i.id}'],
        ['aldric:béni-a', 'thalia:béni-t'],
      );
      expect(state.combatant('aldric')!.conditions.first.concentration, 'mira');
    });

    test('la fin retire les effets liés, pas les autres', () {
      final state = projectCombat([..._blessing(), _end('mira')]);
      expect(state.combatant('mira')!.concentration, isNull);
      expect(_on(state, 'aldric'), ['empoisonné']);
      expect(_on(state, 'thalia'), isEmpty);
      expect(state.linkedTo('mira'), isEmpty);
    });

    test('une nouvelle concentration met fin à la précédente', () {
      final state = projectCombat([
        ..._blessing(),
        _focus('mira', 'Immobilisation de personne'),
      ]);
      expect(
        state.combatant('mira')!.concentration,
        'Immobilisation de personne',
      );
      expect(_on(state, 'thalia'), isEmpty);
    });

    test('fin sans concentration ou combattant inconnu : rien', () {
      final state = projectCombat([
        ..._blessing(),
        _end('aldric'),
        _end('personne'),
        _focus('personne', 'Lumière'),
        _check('personne', success: false),
      ]);
      expect(_on(state, 'thalia'), ['béni-t']);
    });
  });

  group('tests de concentration', () {
    test('DD : 10, la moitié des dégâts, plafond 30', () {
      expect(concentrationDc(1), 10);
      expect(concentrationDc(12), 10);
      expect(concentrationDc(21), 10);
      expect(concentrationDc(22), 11);
      expect(concentrationDc(45), 22);
      expect(concentrationDc(60), 30);
      expect(concentrationDc(70), 30);
    });

    test('[1c] : 12 dégâts, JS de Constitution DD 10 en attente', () {
      final mira = projectCombat([..._blessing(), _hit('mira', 12)])
          .combatant('mira')!;
      expect(mira.concentrationChecks, [(dc: 10, damage: 12)]);
      expect(mira.hp, 26);
    });

    test('un test par source de dégâts, dans l\'ordre', () {
      final mira = projectCombat([
        ..._blessing(),
        _hit('mira', 12),
        _hit('mira', 24),
      ]).combatant('mira')!;
      expect([for (final c in mira.concentrationChecks) c.dc], [10, 12]);
    });

    test('sans concentration ou sans dégât subi : aucun test', () {
      final state = projectCombat([
        _add('mira', immunities: ['poison']),
        _add('aldric'),
        _focus('mira', 'Bénédiction'),
        _hit('mira', 9, 'poison'),
        _hit('aldric', 9),
      ]);
      expect(state.combatant('mira')!.concentrationChecks, isEmpty);
      expect(state.combatant('aldric')!.concentrationChecks, isEmpty);
    });

    test('réussite : le test est résolu, la concentration reste', () {
      final state = projectCombat([
        ..._blessing(),
        _hit('mira', 12),
        _hit('mira', 24),
        _check('mira', success: true),
      ]);
      final mira = state.combatant('mira')!;
      expect([for (final c in mira.concentrationChecks) c.dc], [12]);
      expect(mira.concentration, 'Bénédiction');
      expect(_on(state, 'thalia'), ['béni-t']);
    });

    test('échec : fin de la concentration, des tests et des effets liés', () {
      final state = projectCombat([
        ..._blessing(),
        _hit('mira', 12),
        _hit('mira', 24),
        _check('mira', success: false),
      ]);
      final mira = state.combatant('mira')!;
      expect(mira.concentration, isNull);
      expect(mira.concentrationChecks, isEmpty);
      expect(_on(state, 'aldric'), ['empoisonné']);
      expect(_on(state, 'thalia'), isEmpty);
    });

    test('test sans attente : ignoré', () {
      final state = projectCombat([
        ..._blessing(),
        _check('mira', success: false),
      ]);
      expect(state.combatant('mira')!.concentration, 'Bénédiction');
    });
  });
}
