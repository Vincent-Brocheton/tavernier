// Bestiaire du SRD (changes t-06a-format-monstre et
// t-06b-extracteur-bestiaire). Valeurs relues dans
// docs/maquettes/texte/D01-Jeu-De-Donnees.txt et le SRD 5.2.1.
import 'dart:io';
import 'dart:isolate';

import 'package:dnd_content/dnd_content.dart';
import 'package:path/path.dart' as p;
import 'package:srd_builder/src/monster_extractor.dart';
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

  test('330 profils : « Monstres de A à Z » et « Animaux »', () {
    expect(byId.values.where((e) => e.type == 'monster'), hasLength(330));
  });

  test('Dragon rouge adulte : FP 17, 18 000 PX (20 000 dans son antre), '
      '3 utilisations Légendaires (4), Souffle de feu', () {
    final dragon = monster('adult-red-dragon');
    expect(dragon.cr, '17');
    expect(dragon.xp, 18000);
    expect(dragon.xpLair, 20000);
    expect(dragon.legendaryUses, 3);
    expect(dragon.legendaryUsesLair, 4);
    final breath = dragon.actions.firstWhere((a) => a.name == 'Souffle de feu');
    expect(breath.uses!.recharge, '5-6');
    expect((breath.save!.ability, breath.save!.dc), ('dex', 21));
  });

  test('Nuée de chauves-souris : nuée de taille G de Bêtes de taille TP', () {
    final swarm = monster('swarm-of-bats');
    expect(swarm.sizes, [MonsterSize.large]);
    expect(swarm.swarmSize, MonsterSize.tiny);
    expect(swarm.creatureType, CreatureType.beast);
  });

  test('Loup-garou : Vitesse de forme', () {
    final werewolf = monster('werewolf');
    expect(werewolf.speed.walk, 30);
    expect(werewolf.speedNote, '12 m (forme de loup uniquement)');
  });

  group('contre le SRD en mise en page', () {
    final layout = File(
      p.join(_root, '..', '..', 'docs', 'srd', 'FR_SRD_CC_v5.2.1.txt'),
    ).readAsStringSync().replaceAll(RegExp(r'[ \t]+'), ' ');

    test('chaque nom de monster_slugs.tsv est dans le SRD', () {
      final slugs = readMonsterSlugs(
        File(p.join(_root, 'extract', 'monster_slugs.tsv')),
      );
      expect(slugs, hasLength(330));
      expect([
        for (final name in slugs.keys)
          if (!layout.contains(name)) name,
      ], isEmpty);
    });

    test('chaque coquille corrigée est toujours dans le SRD', () {
      expect([
        for (final typo in monsterTypos)
          if (!layout.contains(typo.wrong)) typo.wrong,
      ], isEmpty);
    });

    // Seconde lecture, indépendante du texte en ordre de lecture de
    // l'extracteur : les valeurs imprimées, en multiensembles.
    test('seconde lecture : FP et PX, PV, caractéristiques et JS, CA et '
        'Initiative', () {
      int signed(String s) => int.parse(s.replaceAll(RegExp('[−–]'), '-'));
      final abilityKeys = {
        'For': 'str',
        'Dex': 'dex',
        'Con': 'con',
        'Int': 'int',
        'Sag': 'wis',
        'Cha': 'cha',
      };
      // Le premier « Monstres de A à Z » est celui du sommaire.
      final bestiary = layout.substring(
        RegExp('Monstres de A à Z').allMatches(layout).elementAt(1).start,
      );
      final printed = <String>[
        for (final m in RegExp(
          r'FP (\S+) \((?:PX )?(\d{1,3}(?:[  ]\d{3})*)',
        ).allMatches(bestiary))
          'FP ${m[1]} ${m[2]!.replaceAll(RegExp(r'\s'), '')}',
        for (final m in RegExp(
          r'Pv (\d+) \((\d+d\d+(?: [+−–-] ?\d+)?)\)',
        ).allMatches(bestiary))
          'Pv ${m[1]} ${m[2]}',
        for (final m in RegExp(
          r'\b(For|Dex|Con|Int|Sag|Cha) (\d+) [+−–-]\d+ ([+−–-]?\d+)',
        ).allMatches(bestiary))
          '${abilityKeys[m[1]]} ${m[2]} ${signed(m[3]!)}',
        for (final m in RegExp(
          r'\bCA (\d+)\s+Initiative ([+−–-]\d+)',
        ).allMatches(bestiary))
          'CA ${m[1]} ${signed(m[2]!)}',
      ];
      final sources = <String>[
        for (final e in byId.values)
          if (e.data case final MonsterData d) ...[
            'FP ${d.cr} ${d.xp}',
            'Pv ${d.hp} ${d.hitDice}',
            for (final MapEntry(:key, :value) in d.abilities.entries)
              '$key $value ${d.savingThrows[key]}',
            'CA ${d.ac} ${d.initiative}',
          ],
      ];
      List<String> minus(List<String> a, List<String> b) {
        final rest = [...b];
        return [
          for (final x in a)
            if (!rest.remove(x)) x,
        ]..sort();
      }

      // Valeurs fautives du PDF : Archimage et Jeune dragon blanc.
      expect(minus(printed, sources), ['FP 12 8000', 'int 6 2']);
      expect(
        minus(sources, printed),
        [
          // Valeurs corrigées.
          'FP 12 8400',
          'int 6 -2',
          // Lignes « CA … Initiative » que la mise en page sépare.
          'CA 12 1',
          'CA 13 2',
          'CA 13 3',
        ]..sort(),
      );
    });
  });
}
