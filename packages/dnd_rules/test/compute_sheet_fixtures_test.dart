// Critère de sortie M0 (cahier §3) : chaque fixture [D1] `active` est
// recalculée par computeSheet() et reproduit exactement ses valeurs
// attendues. Les autres attendent le moteur ou le contenu de M1.
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

const _characterFixtures = [
  'aldric_n1',
  'aldric_n5',
  'mira_n5',
  'thalia_n5',
  'brannoc_n5',
  'kael_n3',
];

/// Compare sans tenir compte de l'ordre des listes : l'ordre des attaques,
/// ressources ou maîtrises n'est pas une valeur de la fiche.
Matcher _same(Object? expected) => switch (expected) {
  final List<Object?> list => unorderedMatches([
    for (final e in list) _same(e),
  ]),
  final Map<String, Object?> map => allOf([
    for (final MapEntry(:key, :value) in map.entries)
      containsPair(key, _same(value)),
    hasLength(map.length),
  ]),
  _ => equals(expected),
};

void main() {
  for (final name in _characterFixtures) {
    final data = fixture(name);
    final status = data['status']! as String;
    final expected = data['expected']! as Map<String, Object?>;

    group(name, () {
      late Map<String, Object?> sheet;
      setUpAll(() {
        sheet = computeSheet(
          CharacterInput.fromJson(fixtureInput(name)),
          srdContent(),
        ).toJson();
      });

      for (final MapEntry(:key, :value) in expected.entries) {
        test(
          key,
          () => expect(
            sheet[key],
            // `sources` ne donne qu'un échantillon des décompositions.
            key == 'sources'
                ? allOf([
                    for (final e in (value! as Map<String, Object?>).entries)
                      containsPair(e.key, _same(e.value)),
                  ])
                : _same(value),
            reason: '$name.$key',
          ),
          skip: status == 'active' ? false : 'fixture $status',
        );
      }
    }, skip: status == 'active' ? false : 'fixture $status');
  }
}
