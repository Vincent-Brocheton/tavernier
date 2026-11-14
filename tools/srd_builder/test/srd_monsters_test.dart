// Monstres de [D1] (change t-06a-format-monstre). Valeurs relues dans
// docs/maquettes/texte/D01-Jeu-De-Donnees.txt et le SRD 5.2.1.
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/srd_builder.dart';
import 'package:test/test.dart';

final _root = p.normalize(
  p.join(
    p.fromUri(
      Isolate.resolvePackageUriSync(Uri.parse('package:srd_builder/'))!,
    ),
    '..',
  ),
);

void main() {
  late Map<String, ContentEntity> byId;

  setUpAll(() {
    final loaded = loadSources(Directory(p.join(_root, 'sources')));
    expect(loaded.issues, isEmpty);
    byId = {for (final e in loaded.pack!.entities) '${e.id}': e};
  });

  MonsterData monster(String slug) =>
      byId['srd:monster:$slug']!.data as MonsterData;

  test('PX de [D1] : Bandit 25, Loup 50, Loup sanguinaire 200, '
      'Chef de bande 450, Ogre 450, Vétéran 700', () {
    expect(
      {
        for (final slug in [
          'bandit',
          'wolf',
          'dire-wolf',
          'bandit-captain',
          'ogre',
          'veteran',
        ])
          byId['srd:monster:$slug']!.name: monster(slug).xp,
      },
      {
        'Bandit': 25,
        'Loup': 50,
        'Loup sanguinaire': 200,
        'Chef de bande': 450,
        'Ogre': 450,
        'Vétéran': 700,
      },
    );
  });

  test('Ogre : FP 2, Intelligence 5, Massue puis Javeline', () {
    final ogre = monster('ogre');
    expect(ogre.cr, '2');
    expect(ogre.abilities['int'], 5);
    expect(ogre.actions.map((a) => a.name), ['Massue', 'Javeline']);
    final javelin = ogre.actions.last.attack!;
    expect(javelin.kind, MonsterAttackKind.meleeOrRanged);
    expect(javelin.range, [30, 120]);
  });

  test('Chef de bande : Parade en Réaction', () {
    final parry = monster('bandit-captain').actions.last;
    expect(parry.kind, MonsterActionKind.reaction);
    expect(parry.name, 'Parade');
  });
}
