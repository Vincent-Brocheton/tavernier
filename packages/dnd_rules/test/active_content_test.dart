import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
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

  test('entité bannie : hors des listes, lisible, fiche inchangée', () {
    const sleep = 'srd:spell:sleep';
    final content = srdContent();
    final banned = content.withBanned({sleep});
    expect(
      content.spellList('srd:class:wizard').map((s) => '$s'),
      contains(sleep),
    );
    expect(
      banned.spellList('srd:class:wizard').map((s) => '$s'),
      isNot(contains(sleep)),
    );
    expect(banned.entities.map((e) => '${e.id}'), isNot(contains(sleep)));
    expect(banned.entity(sleep)?.name, content.entity(sleep)!.name);
    expect(banned.isBanned(sleep), isTrue);
    expect(content.isBanned(sleep), isFalse);
    expect(content.withBanned(const {}), same(content));
    // Une fiche qui a déjà le sort se calcule comme sans bannissement.
    final aldric = CharacterInput.fromJson(fixtureInput('aldric_n5'));
    expect(
      computeSheet(aldric, banned).toJson(),
      computeSheet(aldric, content).toJson(),
    );
  });
}
