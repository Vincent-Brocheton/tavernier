// Spec encounters : « Dégâts », « Soins et PV temporaires », « Zéro point de
// vie », « Aperçu des dégâts » (US-21, EF-PV-01 à 04). Règles du SRD 5.2.1
// (ordre des ajustements, jets contre la mort) ; valeurs de [1b].
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
  String kind = 'monster',
  int hp = 10,
  int? hpMax,
  List<String> resistances = const [],
  List<String> vulnerabilities = const [],
  List<String> immunities = const [],
}) => _event(CombatEventType.combatantAdded, {
  'id': id,
  'kind': kind,
  'label': id,
  'hp': hp,
  'hp_max': hpMax ?? hp,
  'resistances': resistances,
  'vulnerabilities': vulnerabilities,
  'immunities': immunities,
});

CombatEvent _damage(
  List<String> targets,
  int amount, {
  String type = 'srd:damage-type:slashing',
  bool critical = false,
  bool half = false,
  bool double = false,
}) => _event(CombatEventType.damage, {
  'targets': targets,
  'amount': amount,
  'type': type,
  'critical': critical,
  'half': half,
  'double': double,
});

CombatEvent _save(String id, String outcome) =>
    _event(CombatEventType.deathSave, {'combatant': id, 'outcome': outcome});

Combatant _after(List<CombatEvent> events, String id) =>
    projectCombat(events).combatant(id)!;

void main() {
  group('dégâts', () {
    test('[1b] : Mira, 22 sur 38, 12 dégâts tranchants : 10', () {
      final mira = _after([
        _add('mira', kind: 'pc', hp: 22, hpMax: 38),
        _damage(['mira'], 12),
      ], 'mira');
      expect((mira.hp, mira.hpMax), (10, 38));
    });

    test('SRD : Résistance (arrondie à l\'inférieur) puis Vulnérabilité', () {
      final c = _after([
        _add(
          'c',
          hp: 50,
          resistances: ['srd:damage-type:fire'],
          vulnerabilities: ['srd:damage-type:fire'],
        ),
        _damage(['c'], 23, type: 'srd:damage-type:fire'),
      ], 'c');
      expect(c.hp, 50 - 22);
    });

    test('Immunité : aucun dégât', () {
      final dragon = _after([
        _add('dragon', hp: 195, immunities: ['srd:damage-type:acid']),
        _damage(['dragon'], 30, type: 'srd:damage-type:acid'),
      ], 'dragon');
      expect(dragon.hp, 195);
    });

    test('corrections manuelles : « Résistance ½ », « Vulnérabilité ×2 »', () {
      expect(
        _after([
          _add('a', hp: 40),
          _damage(['a'], 13, half: true),
        ], 'a').hp,
        34,
      );
      expect(
        _after([
          _add('a', hp: 40),
          _damage(['a'], 13, double: true),
        ], 'a').hp,
        14,
      );
      // Résistance du profil et correction ½ ne se cumulent pas.
      expect(
        _after([
          _add('a', hp: 40, resistances: ['srd:damage-type:slashing']),
          _damage(['a'], 13, half: true),
        ], 'a').hp,
        34,
      );
    });

    test('PV temporaires consommés d\'abord', () {
      final aldric = _after([
        _add('aldric', kind: 'pc', hp: 41, hpMax: 49),
        _event(CombatEventType.tempHp, {
          'targets': ['aldric'],
          'amount': 5,
        }),
        _damage(['aldric'], 8),
      ], 'aldric');
      expect((aldric.tempHp, aldric.hp), (0, 38));
    });

    test('plusieurs cibles : chacune perd ses PV', () {
      final events = [
        _add('l1', hp: 37),
        _add('l2', hp: 20),
        _damage(['l1', 'l2'], 10, type: 'srd:damage-type:fire'),
      ];
      expect((_after(events, 'l1').hp, _after(events, 'l2').hp), (27, 10));
    });

    test('combattant sans PV connus : rien ne change', () {
      final events = [
        _event(CombatEventType.combatantAdded, {
          'id': 'x',
          'kind': 'pc',
          'label': 'X',
        }),
        _damage(['x'], 10),
      ];
      expect(_after(events, 'x').hp, isNull);
    });

    test('aperçu : 12 dégâts, de 22 à 10, sans rien écrire', () {
      final mira = projectCombat([_add('mira', kind: 'pc', hp: 22, hpMax: 38)])
          .combatant('mira')!;
      final preview = resolveDamage(mira, 12, 'srd:damage-type:slashing');
      expect((preview.taken, preview.hpBefore, preview.hpAfter), (12, 22, 10));
      expect(mira.hp, 22);
    });
  });

  group('soins et PV temporaires', () {
    test('soin plafonné au maximum', () {
      final mira = _after([
        _add('mira', kind: 'pc', hp: 10, hpMax: 38),
        _event(CombatEventType.heal, {
          'targets': ['mira'],
          'amount': 40,
        }),
      ], 'mira');
      expect(mira.hp, 38);
    });

    test('PV temporaires : le plus élevé gardé, ou remplacés', () {
      CombatEvent temp(int amount, {bool replace = false}) =>
          _event(CombatEventType.tempHp, {
            'targets': ['aldric'],
            'amount': amount,
            'replace': replace,
          });
      final events = [_add('aldric', kind: 'pc', hp: 41), temp(5), temp(3)];
      expect(_after(events, 'aldric').tempHp, 5);
      expect(_after([...events, temp(8)], 'aldric').tempHp, 8);
      expect(_after([...events, temp(2, replace: true)], 'aldric').tempHp, 2);
    });
  });

  group('zéro point de vie', () {
    List<CombatEvent> fallen() => [
      _add('mira', kind: 'pc', hp: 10, hpMax: 38),
      _damage(['mira'], 15),
    ];

    test('Mira tombe : 0 PV, Inconsciente, compteurs à zéro', () {
      final mira = _after(fallen(), 'mira');
      expect(
        (mira.hp, mira.unconscious, mira.deathSuccesses, mira.deathFailures),
        (0, true, 0, 0),
      );
      expect(mira.dead, isFalse);
    });

    test('dégât à 0 PV : un échec ; coup critique : deux, puis la mort', () {
      final events = [
        ...fallen(),
        _damage(['mira'], 3),
      ];
      expect(_after(events, 'mira').deathFailures, 1);
      final dead = _after([
        ...events,
        _damage(['mira'], 3, critical: true),
      ], 'mira');
      expect(
        (dead.deathFailures, dead.dead, dead.unconscious),
        (3, true, false),
      );
    });

    test('trois réussites : stabilisée, toujours Inconsciente', () {
      final mira = _after([
        ...fallen(),
        _save('mira', 'success'),
        _save('mira', 'failure'),
        _save('mira', 'success'),
        _save('mira', 'success'),
      ], 'mira');
      expect(
        (mira.stable, mira.unconscious, mira.deathFailures),
        (true, true, 1),
      );
      // Stabilisée, elle ne lance plus de jet.
      final after = _after([
        ...fallen(),
        for (var i = 0; i < 3; i++) _save('mira', 'success'),
        _save('mira', 'failure'),
      ], 'mira');
      expect(after.deathFailures, 0);
    });

    test('stabilisée puis blessée : les jets reprennent', () {
      final mira = _after([
        ...fallen(),
        for (var i = 0; i < 3; i++) _save('mira', 'success'),
        _damage(['mira'], 2),
      ], 'mira');
      expect((mira.stable, mira.deathFailures), (false, 1));
    });

    test('1 naturel : deux échecs ; trois échecs : morte', () {
      final events = [...fallen(), _save('mira', 'nat1')];
      expect(_after(events, 'mira').deathFailures, 2);
      expect(
        _after([...events, _save('mira', 'failure')], 'mira').dead,
        isTrue,
      );
    });

    test('20 naturel : 1 PV, consciente, compteurs remis à zéro', () {
      final mira = _after([
        ...fallen(),
        _save('mira', 'failure'),
        _save('mira', 'nat20'),
      ], 'mira');
      expect((mira.hp, mira.unconscious, mira.deathFailures), (1, false, 0));
    });

    test('soin à 0 PV : relevée, compteurs remis à zéro ; un mort non', () {
      final healed = _after([
        ...fallen(),
        _save('mira', 'failure'),
        _event(CombatEventType.heal, {
          'targets': ['mira'],
          'amount': 5,
        }),
      ], 'mira');
      expect(
        (healed.hp, healed.unconscious, healed.deathFailures),
        (5, false, 0),
      );
      final dead = _after([
        ...fallen(),
        for (var i = 0; i < 3; i++) _save('mira', 'failure'),
        _event(CombatEventType.heal, {
          'targets': ['mira'],
          'amount': 5,
        }),
      ], 'mira');
      expect((dead.dead, dead.hp), (true, 0));
    });

    test('monstre à 0 PV : hors de combat, toujours dans l\'ordre', () {
      final state = projectCombat([
        _add('loup', hp: 11),
        _event(CombatEventType.initiativeRolled, {
          'unit': 'loup',
          'dice': [10],
          'bonus': 2,
        }),
        _damage(['loup'], 20),
      ]);
      final loup = state.combatant('loup')!;
      expect((loup.hp, loup.outOfCombat, loup.unconscious), (0, true, false));
      expect(state.order, ['loup']);
    });

    test('jet contre la mort d\'un PJ debout : ignoré', () {
      final mira = _after([
        _add('mira', kind: 'pc', hp: 10),
        _save('mira', 'failure'),
      ], 'mira');
      expect(mira.deathFailures, 0);
    });
  });
}
