// Spec encounters : « Entrées du journal » (US-25, EF-LOG-01, 02). Valeurs
// du journal de la planche Combat-Desktop.
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

var _next = 0;

CombatEvent _event(CombatEventType type, [Map<String, Object?> p = const {}]) =>
    CombatEvent(
      id: 'e${(_next++).toString().padLeft(4, '0')}',
      type: type,
      payload: p,
    );

CombatEvent _add(String id, String label, int hp, {String kind = 'pc'}) =>
    _event(CombatEventType.combatantAdded, {
      'id': id,
      'kind': kind,
      'label': label,
      'hp': hp,
      'hp_max': hp,
    });

CombatEvent _hit(String on, int amount) => _event(CombatEventType.damage, {
  'targets': [on],
  'amount': amount,
  'type': 'srd:damage-type:piercing',
});

void main() {
  final opening = [
    _add('mira', 'Mira Solen', 38),
    _add('brannoc', 'Brannoc', 27),
    _add('loup', 'Loup 2', 11, kind: 'monster'),
    for (final (unit, d) in [('mira', 9), ('brannoc', 6), ('loup', 15)])
      _event(CombatEventType.initiativeRolled, {
        'unit': unit,
        'dice': [d],
      }),
    _event(CombatEventType.combatStarted),
  ];

  test('round, PV avant et après, chute', () {
    final hits = [_hit('mira', 16), _hit('brannoc', 22)];
    final round2 = _event(CombatEventType.turnAdvanced);
    final events = [
      ...opening,
      hits[0],
      _event(CombatEventType.turnAdvanced),
      _event(CombatEventType.turnAdvanced),
      round2,
      hits[1],
      _hit('brannoc', 8),
    ];
    final journal = combatJournal(events);
    expect(journal, hasLength(events.length));
    final mira = journal.firstWhere((j) => j.event == hits[0]);
    expect(mira.round, 1);
    expect(mira.hp['mira'], (
      before: 38,
      after: 22,
      unconscious: false,
      outOfCombat: false,
      dead: false,
    ));
    final brannoc = journal.firstWhere((j) => j.event == hits[1]);
    expect(brannoc.round, 2);
    expect(
      (brannoc.hp['brannoc']!.before, brannoc.hp['brannoc']!.after),
      (27, 5),
    );
    // Loup 2 → Brannoc : 8 perforants (5 → 0), Inconscient.
    final down = journal.last.hp['brannoc']!;
    expect((down.before, down.after, down.unconscious), (5, 0, true));
  });

  test('annulé : marqué, et l\'annulation a son entrée', () {
    final hit = _hit('loup', 13);
    final events = [
      ...opening,
      hit,
      _event(CombatEventType.undo, {'event': hit.id}),
    ];
    final journal = combatJournal(events);
    expect(journal.firstWhere((j) => j.event == hit).undone, isTrue);
    expect(journal.firstWhere((j) => j.event == hit).hp, isEmpty);
    expect(journal.last.event.type, CombatEventType.undo);
    expect(journal.last.undone, isFalse);
    expect(undoableCount(events), opening.length);
  });

  test('hors de combat et noms gardés après un retrait', () {
    final events = [
      ...opening,
      _hit('loup', 13),
      _event(CombatEventType.combatantRemoved, {'combatant': 'loup'}),
    ];
    expect(
      combatJournal(events)[events.length - 2].hp['loup']!.outOfCombat,
      isTrue,
    );
    expect(combatantLabels(events)['loup'], 'Loup 2');
  });

  test('24 actions dont une annulée : 23 annulables (EF-LOG-02)', () {
    final hits = [for (var i = 0; i < 17; i++) _hit('loup', 0)];
    final events = [
      ...opening,
      ...hits,
      _event(CombatEventType.undo, {'event': hits.last.id}),
    ];
    expect(opening.length + hits.length, 24);
    expect(undoableCount(events), 23);
  });
}
