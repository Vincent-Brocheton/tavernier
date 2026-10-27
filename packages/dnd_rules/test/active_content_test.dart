import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'support.dart';

void main() {
  test('retrouve une entité du pack SRD', () {
    final fighter = srdContent().entity('srd:class:fighter');
    expect(fighter?.data, isA<ClassData>());
  });

  test('renvoie null pour un identifiant absent', () {
    expect(srdContent().entity('srd:class:absente'), isNull);
  });

  test('une entité ajoutée par un autre pack est visible', () {
    final extra = srdPack.entities.firstWhere(
      (e) => '${e.id}' == 'srd:feat:alert',
    );
    expect(srdContent([extra]).entity('srd:feat:alert'), same(extra));
  });
}
