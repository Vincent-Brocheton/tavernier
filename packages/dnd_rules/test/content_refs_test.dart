// Spec character-sheet : « Contenu figé d'une fiche » (US-30 lot c2,
// EF-PJ-14).
import 'package:dnd_content/dnd_content.dart';
import 'package:dnd_rules/dnd_rules.dart';
import 'package:test/test.dart';

import 'support.dart';

/// « Gardiens des Marches » : une sous-classe du Guerrier dont l'aptitude
/// donne [ac] à la CA avec un bouclier, et un don qui ne change pas.
ContentPack _gardiens(String version, int ac) => ContentPack(
  manifest: PackManifest(
    id: '0193a000-0000-7000-8000-000000000030',
    namespace: 'gardiens',
    name: 'Gardiens des Marches',
    version: version,
    origin: PackOrigin.imported,
    author: 'Inès',
    licence: 'CC-BY-4.0',
    locale: 'fr',
  ),
  entities: [
    for (final json in [
      {
        'id': 'gardiens:subclass:rempart',
        'type': 'subclass',
        'name': 'Gardien du rempart',
        'data': {
          'parent_class': 'srd:class:fighter',
          'features': ['gardiens:feature:rempart-vivant'],
        },
      },
      {
        'id': 'gardiens:feature:rempart-vivant',
        'type': 'feature',
        'name': 'Rempart vivant',
        'data': {'source': 'gardiens:subclass:rempart', 'level': 3},
        'effects': [
          {
            'op': 'modify_ac',
            'value': ac,
            'when': {'shield': true},
          },
        ],
        'text': {'fr': '+$ac CA avec un bouclier.'},
      },
      {
        'id': 'gardiens:feat:veilleur',
        'type': 'feat',
        'name': 'Veilleur',
        'data': {'category': 'general'},
        'text': {'fr': 'Vous montez la garde.'},
      },
    ])
      parseEntity(json, 'test').entity!,
  ],
);

void main() {
  final v1 = ActiveContent([srdPack, _gardiens('0.1.0', 1)]);
  final v2 = ActiveContent([srdPack, _gardiens('0.2.0', 2)]);
  final base = sandboxCharacter(
    v1,
    classId: 'srd:class:fighter',
    level: 3,
    subclassId: 'gardiens:subclass:rempart',
    shield: true,
  );
  final hugo = base.copyWith(
    feats: [
      ...base.feats,
      const FeatInput(
        featId: 'gardiens:feat:veilleur',
        sourceType: 'test',
        sourceRef: 'test',
      ),
    ],
  );

  test('les entités homebrew utilisées sont figées, pas le SRD', () {
    final record = contentRefsToRecord(hugo, v1, const []);
    expect(record.create.map((r) => r.entityId).toSet(), {
      'gardiens:subclass:rempart',
      'gardiens:feat:veilleur',
    });
    final rempart = record.create.firstWhere(
      (r) => r.entityId == 'gardiens:subclass:rempart',
    );
    expect(rempart.packVersion, '0.1.0');
    // L'instantané porte la sous-classe et son aptitude.
    expect(
      [for (final e in rempart.snapshot['entities']! as List) (e as Map)['id']],
      ['gardiens:subclass:rempart', 'gardiens:feature:rempart-vivant'],
    );
    expect(record.follow, isEmpty);
    expect(record.remove, isEmpty);
  });

  test('nouvelle version : la fiche garde +1 CA et voit le changement', () {
    final refs = contentRefsToRecord(hugo, v1, const []).create;
    final frozen = freezeContent(refs, v2);
    // Cotte de mailles 16 + bouclier 2 + Rempart vivant.
    expect(computeSheet(hugo, v1).armorClass.value, 19);
    expect(computeSheet(hugo, v2).armorClass.value, 20);
    expect(
      computeSheet(hugo, v2.withOverrides(frozen.frozen)).armorClass.value,
      19,
    );
    final change = frozen.changes.single;
    expect(change.entityId, 'gardiens:subclass:rempart');
    expect(change.fromVersion, '0.1.0');
    expect(change.toVersion, '0.2.0');
    expect(change.before.name, 'Gardien du rempart');

    // Le don, inchangé, suit la nouvelle version sans rien demander.
    final record = contentRefsToRecord(hugo, v2, refs);
    expect(record.follow.map((r) => r.entityId), ['gardiens:feat:veilleur']);
    expect(record.follow.single.packVersion, '0.2.0');
  });

  test('version gardée : figée, plus d’alerte ; entité quittée : retirée', () {
    final refs = [
      for (final r in contentRefsToRecord(hugo, v1, const []).create)
        if (r.entityId == 'gardiens:subclass:rempart')
          (
            entityId: r.entityId,
            packId: r.packId,
            packVersion: r.packVersion,
            snapshot: {...r.snapshot, 'kept': '0.2.0'},
          )
        else
          r,
    ];
    final frozen = freezeContent(refs, v2);
    expect(frozen.changes, isEmpty);
    expect(frozen.frozen, isNotEmpty);
    expect(freezeContent(refs, v1).frozen, isEmpty);
    expect(contentRefsToRecord(base, v1, refs).remove, [
      'gardiens:feat:veilleur',
    ]);
    expect(v1.withOverrides(const []), same(v1));
    expect(usedEntityIds(hugo), contains('srd:species:human'));
  });
}
