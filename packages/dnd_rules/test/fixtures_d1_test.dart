// Cohérence interne des fixtures [D1] (T-03, cahier §12.1).
//
// Ces tests ne passent pas par le moteur : ils vérifient que les valeurs
// écrites à la main sont cohérentes entre elles (coût de l'acquisition par
// points, base + Historique + améliorations = valeur finale, totaux de PX).
// Les tables de référence ci-dessous sont recopiées du SRD 5.2.1 français.
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';

import 'package:test/test.dart';

/// SRD p. 22, « Coût des valeurs de caractéristique ».
const _pointBuyCost = {8: 0, 9: 1, 10: 2, 11: 3, 12: 4, 13: 5, 14: 7, 15: 9};

/// SRD p. 87, « Valeurs de caractéristique » de chaque Historique.
const _backgroundAbilities = {
  'srd:background:acolyte': {'int', 'wis', 'cha'},
  'srd:background:criminal': {'dex', 'con', 'int'},
  'srd:background:sage': {'con', 'int', 'wis'},
  'srd:background:soldier': {'str', 'dex', 'con'},
};

/// SRD p. 22, « Valeurs et modificateurs de caractéristique ».
const _modifierByScore = {
  8: -1, 9: -1, 10: 0, 11: 0, 12: 1, 13: 1, 14: 2, 15: 2, //
  16: 3, 17: 3, 18: 4, 19: 4, 20: 5,
};

const _abilities = ['str', 'dex', 'con', 'int', 'wis', 'cha'];

// Résolu depuis le package, pour que les tests tournent quel que soit le
// répertoire courant (racine du dépôt, IDE, melos).
final _dir = Directory.fromUri(
  Isolate.resolvePackageUriSync(Uri.parse('package:dnd_rules/'))!
      .resolve('../test/fixtures/d1/'),
);

Map<String, Object?> _load(String name) =>
    jsonDecode(File('${_dir.path}/$name.json').readAsStringSync())
        as Map<String, Object?>;

Map<String, Object?> _map(Object? value) => value! as Map<String, Object?>;

List<Object?> _list(Object? value) => value! as List<Object?>;

/// Applique `input_changes` d'une fixture qui en étend une autre.
Map<String, Object?> _resolvedInput(Map<String, Object?> fixture) {
  final parent = fixture['extends'] as String?;
  if (parent == null) return _map(fixture['input']);
  final input = {..._map(_load(parent)['input'])};
  // `<clé>_added` complète la liste du parent, toute autre clé la remplace.
  _map(fixture['input_changes']).forEach((key, value) {
    if (key.endsWith('_added')) {
      final base = key.substring(0, key.length - '_added'.length);
      input[base] = [..._list(input[base]), ..._list(value)];
    } else {
      input[key] = value;
    }
  });
  return input;
}

/// Base + bonus d'Historique + choix des dons qui augmentent une valeur.
Map<String, int> _finalScores(Map<String, Object?> input) {
  final base = _map(input['base_scores']);
  final bonuses = _map(_map(input['background_choice'])['bonuses']);
  final scores = {for (final a in _abilities) a: base[a]! as int};
  bonuses.forEach((a, v) => scores[a] = scores[a]! + (v! as int));
  for (final feat in _list(input['feats']).map(_map)) {
    if (feat['feat_id'] != 'srd:feat:ability-score-improvement') continue;
    _map(feat['choices'])
        .forEach((a, v) => scores[a] = scores[a]! + (v! as int));
  }
  return scores;
}

void main() {
  const characters = [
    'aldric_n1',
    'aldric_n5',
    'mira_n5',
    'thalia_n5',
    'brannoc_n5',
    'kael_n3',
  ];

  for (final name in characters) {
    group(name, () {
      final fixture = _load(name);
      final input = _resolvedInput(fixture);
      final expected = _map(fixture['expected']);
      final base = _map(input['base_scores']);

      test("la répartition d'Historique respecte les règles 2024", () {
        final choice = _map(input['background_choice']);
        final bonuses = _map(choice['bonuses'])
            .map((k, v) => MapEntry(k, v! as int));
        final eligible = _backgroundAbilities[input['background_id']]!;
        expect(eligible, containsAll(bonuses.keys));
        final values = bonuses.values.toList()..sort();
        switch (choice['distribution']) {
          case '2-1':
            expect(values, [1, 2]);
          case '1-1-1':
            expect(values, [1, 1, 1]);
          default:
            fail('distribution inconnue : ${choice['distribution']}');
        }
      });

      if (base['method'] == 'point_buy') {
        test("l'acquisition par points coûte 27 points", () {
          final cost = _abilities
              .map((a) => _pointBuyCost[base[a]! as int]!)
              .reduce((a, b) => a + b);
          expect(cost, 27);
          expect(expected['point_buy_cost'] ?? 27, 27);
        });
      }

      if (base['method'] == 'random') {
        test('les valeurs réparties sont exactement les jets', () {
          final assigned = _abilities.map((a) => base[a]! as int).toList()
            ..sort();
          final rolls = _list(base['rolls']).cast<int>().toList()..sort();
          expect(assigned, rolls);
        });
      }

      test('base + Historique + améliorations = valeurs attendues', () {
        final scores = _finalScores(input);
        final abilities = _map(expected['abilities']);
        for (final a in _abilities) {
          final entry = _map(abilities[a]);
          expect(entry['score'], scores[a], reason: a);
          expect(entry['score']! as int, lessThanOrEqualTo(20), reason: a);
          expect(entry['modifier'], _modifierByScore[scores[a]], reason: a);
        }
      });

      final sources = expected['sources'] as Map<String, Object?>?;
      if (sources != null) {
        test('chaque décomposition retombe sur sa valeur', () {
          int total(String key) =>
              _list(sources[key])
                  .map((s) => _map(s)['value']! as int)
                  .reduce((a, b) => a + b);
          final abilities = _map(expected['abilities']);
          for (final key in sources.keys) {
            final value = switch (key) {
              'initiative' => _map(expected['initiative'])['bonus'],
              final a when _abilities.contains(a) => _map(
                abilities[a],
              )['score'],
              _ => expected[key],
            };
            expect(total(key), value, reason: key);
          }
        });
      }
    });
  }

  group('rencontres', () {
    final data = _load('encounters');
    final xp = _map(data['monster_xp']).map((k, v) => MapEntry(k, v! as int));
    final budgets = _map(data['budgets_for_4_pcs']);

    for (final encounter in _list(data['encounters']).map(_map)) {
      test('${encounter['name']} : total des PX', () {
        final monsters = _map(encounter['monsters']);
        final sum = monsters.entries
            .map((e) => xp[e.key]! * (e.value! as int))
            .reduce((a, b) => a + b);
        expect(sum, encounter['xp']);
        if (encounter['xp_per_pc'] != null) {
          expect((encounter['xp_per_pc']! as int) * 4, encounter['xp']);
        }
      });

      final difficulty = encounter['difficulty'] as String?;
      if (difficulty != null) {
        test('${encounter['name']} : difficulté $difficulty', () {
          final budget = _map(budgets['${encounter['party_level']}'])
              .map((k, v) => MapEntry(k, v! as int));
          final total = encounter['xp']! as int;
          switch (difficulty) {
            case 'below_low':
              expect(total, lessThan(budget['low']!));
            case 'low':
              expect(total, lessThanOrEqualTo(budget['low']!));
            case 'moderate':
              expect(total, greaterThan(budget['low']!));
              expect(total, lessThanOrEqualTo(budget['moderate']!));
            default:
              fail('difficulté inconnue : $difficulty');
          }
        });
      }
    }

    test("PX d'Aldric : cumul des PX par PJ des séances 11 et 12", () {
      final track = _list(_map(data['xp_track'])['aldric']).map(_map).toList();
      int earned(int session) =>
          _list(data['encounters'])
              .map(_map)
              .where((e) => e['session'] == session)
              .map((e) => (e['xp_per_pc'] ?? 0) as int)
              .reduce((a, b) => a + b);

      expect(track.map((t) => t['xp']), [6500, 6650, 7475]);
      expect(6500 + earned(11), 6650);
      expect(6650 + earned(12), 7475);
    });
  });
}
