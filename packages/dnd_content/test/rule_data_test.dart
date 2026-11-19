// Spec content-pack : « Tables de règles d'une entité rule » (US-24,
// EF-ACT-05). Tables du SRD 5.2.1 : « Domaines de savoir », « Tests
// d'Influence ».
import 'package:dnd_content/dnd_content.dart';
import 'package:test/test.dart';

import 'pack_fixtures.dart';

ContentEntity _rule(Map<String, Object?> data) => entity({
  'id': 'test:rule:tables',
  'type': 'rule',
  'name': 'Tables',
  'text': {'fr': 'Texte.'},
  'data': data,
});

void main() {
  test('une règle sans données reste valide', () {
    final rule = entity({
      'id': 'srd:rule:advantage',
      'type': 'rule',
      'name': 'Avantage',
      'text': {'fr': 'Texte.'},
    });
    final data = rule.data as RuleData;
    expect(data.studySkills, isEmpty);
    expect(data.influenceChecks, isEmpty);
  });

  test('tables lues et références contrôlées', () {
    final rule = _rule({
      'study_skills': {'humanoid': 'srd:skill:history'},
      'influence_checks': [
        {
          'id': 'handle',
          'ability': 'srd:ability:wis',
          'skill': 'srd:skill:animal-handling',
          'creature_types': ['beast', 'monstrosity'],
        },
      ],
    });
    final data = rule.data as RuleData;
    expect('${data.studySkills[CreatureType.humanoid]}', 'srd:skill:history');
    final handle = data.influenceChecks.single;
    expect(handle.id, 'handle');
    expect('${handle.ability}', 'srd:ability:wis');
    expect(handle.creatureTypes, [
      CreatureType.beast,
      CreatureType.monstrosity,
    ]);

    final pack = ContentPack(
      manifest: srdManifest(),
      entities: [
        ability('wis'),
        ability('int'),
        skill('history', 'srd:ability:int'),
        skill('animal-handling', 'srd:ability:wis'),
        rule,
      ],
    );
    expect(validatePack(pack), isEmpty);
  });

  test('une compétence inconnue ou du mauvais type est refusée', () {
    final pack = ContentPack(
      manifest: srdManifest(),
      entities: [
        ability('int'),
        _rule({
          'study_skills': {
            'humanoid': 'srd:skill:inexistante',
            'giant': 'srd:ability:int',
          },
        }),
      ],
    );
    final messages = [for (final i in validatePack(pack)) '$i'];
    expect(messages, contains(contains('srd:skill:inexistante')));
    expect(messages, contains(contains('type « skill » attendu')));
  });
}
